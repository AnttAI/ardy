# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Part of InteractiveTimelineDemo (split for readability)."""

from .common import *  # noqa: F401,F403
from .window_budget import compute_window_num_frames


class GenerationMixin:
    def _project_rotations_to_so3(self, rot_mats: torch.Tensor) -> torch.Tensor:
        """Project averaged 3x3 matrices back to valid rotations."""
        u, _, vh = torch.linalg.svd(rot_mats)
        projected = u @ vh
        det = torch.linalg.det(projected)
        if (det < 0).any():
            u = u.clone()
            u[det < 0, :, -1] *= -1.0
            projected = u @ vh
        return projected

    def _smooth_rotation_sequence(self, rotations: torch.Tensor, window: int = 5) -> torch.Tensor:
        """Smooth a [B, T, J, 3, 3] rotation sequence with a centered moving average."""
        if rotations.shape[1] < 3 or window <= 1:
            return rotations
        window = min(int(window), int(rotations.shape[1]))
        if window % 2 == 0:
            window -= 1
        if window <= 1:
            return rotations

        half = window // 2
        first = rotations[:, :1].expand(-1, half, -1, -1, -1)
        last = rotations[:, -1:].expand(-1, half, -1, -1, -1)
        padded = torch.cat([first, rotations, last], dim=1)
        smoothed = torch.empty_like(rotations)
        for frame_idx in range(rotations.shape[1]):
            avg = padded[:, frame_idx : frame_idx + window].mean(dim=1)
            smoothed[:, frame_idx] = self._project_rotations_to_so3(avg.reshape(-1, 3, 3)).reshape_as(avg)
        return smoothed

    def _straighten_rack_route_arrival_pose(self, session: ClientSession) -> bool:
        """Make the rack-route end pose upright while keeping the generated stop point."""
        if (
            session.motion_rep is None
            or session.joints_pos is None
            or session.joints_rot is None
            or session.task_end_frame_idx is None
            or session.t3_base_route_positions is None
            or session.t3_base_route_headings is None
        ):
            return False

        end_idx = int(session.task_end_frame_idx)
        if end_idx < 0 or end_idx >= int(session.joints_pos.shape[1]):
            return False

        skeleton = session.motion_rep.skeleton
        root_idx = skeleton.root_idx
        fps = max(float(session.model_fps), 1.0)
        blend_frames = max(4, int(round(0.45 * fps)))
        start_idx = max(0, end_idx - blend_frames + 1)

        with session.motion_tensor_lock:
            joints_pos = session.joints_pos.clone()
            joints_rot = session.joints_rot.clone()
            num_samples = int(joints_pos.shape[0])
            seq_len = int(joints_pos.shape[1])

            route_headings = np.asarray(session.t3_base_route_headings, dtype=np.float32)
            target_heading = float(route_headings[-1]) if len(route_headings) > 0 else 0.0

            for sample_idx in range(num_samples):
                straight_positions_np, straight_rotations_np = self._straight_back_pose_from_motion(
                    skeleton,
                    joints_pos[sample_idx, end_idx].detach().cpu().numpy(),
                    joints_rot[sample_idx, end_idx].detach().cpu().numpy(),
                    target_heading,
                )
                straight_positions = torch.as_tensor(
                    straight_positions_np,
                    device=joints_pos.device,
                    dtype=joints_pos.dtype,
                )
                straight_rotations = torch.as_tensor(
                    straight_rotations_np,
                    device=joints_rot.device,
                    dtype=joints_rot.dtype,
                )

                for frame_idx in range(start_idx, end_idx + 1):
                    alpha = (frame_idx - start_idx) / max(float(end_idx - start_idx), 1.0)
                    alpha = alpha * alpha * (3.0 - 2.0 * alpha)
                    joints_pos[sample_idx, frame_idx] = (
                        (1.0 - alpha) * joints_pos[sample_idx, frame_idx]
                        + alpha * straight_positions
                    )
                    blended_rot = (
                        (1.0 - alpha) * joints_rot[sample_idx, frame_idx]
                        + alpha * straight_rotations
                    )
                    joints_rot[sample_idx, frame_idx] = self._project_rotations_to_so3(
                        blended_rot.reshape(-1, 3, 3)
                    ).reshape_as(blended_rot)

                joints_pos[sample_idx, end_idx] = straight_positions
                joints_rot[sample_idx, end_idx] = straight_rotations

            local_rot_mats = skeleton.global_rots_to_local_rots(joints_rot.reshape(-1, skeleton.nbjoints, 3, 3))
            local_rot_mats = local_rot_mats.reshape(num_samples, seq_len, skeleton.nbjoints, 3, 3)
            root_positions = joints_pos[:, :, root_idx]
            joints_pos, root_positions = ground_motion_to_floor(
                skeleton,
                joints_pos,
                root_positions,
            )
            joints_rot, joints_pos, _ = skeleton.fk(local_rot_mats, root_positions)
            joints_pos, root_positions = ground_motion_to_floor(
                skeleton,
                joints_pos,
                root_positions,
            )
            motion_tensor_unnormalized = session.motion_rep(
                local_joint_rots=local_rot_mats,
                root_positions=root_positions,
                to_normalize=False,
            )
            session.joints_pos = joints_pos
            session.joints_rot = joints_rot
            session.motion_tensor = session.motion_rep.normalize(motion_tensor_unnormalized)
            if session.foot_contacts is not None:
                session.foot_contacts = motion_tensor_unnormalized[:, :, session.motion_rep.slice_dict["foot_contacts"]]
            if session.root_velocities is not None:
                velocities = motion_tensor_unnormalized[:, :, session.motion_rep.slice_dict["velocities"]]
                session.root_velocities = velocities.reshape(
                    num_samples,
                    seq_len,
                    skeleton.nbjoints,
                    3,
                )[:, :, root_idx, :]
                session.root_velocities[:, start_idx : end_idx + 1] = 0.0

        return True

    def _hand_only_active_joint_indices(self, session: ClientSession) -> list[int]:
        skeleton = session.motion_rep.skeleton
        ee_constraint = session.constraints.get("End-Effectors") if session.constraints else None
        if ee_constraint is None or not ee_constraint.keyframes:
            return []

        active_sides = set()
        for keyframe in ee_constraint.keyframes.values():
            for joint_name in keyframe.get("joint_names", []):
                joint_name = str(joint_name)
                is_arm_joint = any(part in joint_name for part in ("Shoulder", "Arm", "ForeArm", "Hand"))
                if not is_arm_joint:
                    continue
                if joint_name.startswith("Left"):
                    active_sides.add("Left")
                elif joint_name.startswith("Right"):
                    active_sides.add("Right")

        moving_names = []
        for side in sorted(active_sides):
            moving_names.extend(
                [
                    f"{side}Shoulder",
                    f"{side}Arm",
                    f"{side}ForeArm",
                    f"{side}Hand",
                ]
            )
            moving_names.extend(
                skeleton.left_hand_joint_names if side == "Left" else skeleton.right_hand_joint_names
            )

        return sorted({skeleton.bone_index[name] for name in moving_names if name in skeleton.bone_index})

    def _apply_hand_only_motion_filter(
        self,
        session: ClientSession,
        samples: torch.Tensor,
        samples_unnormalized: torch.Tensor,
        joints_pos: torch.Tensor,
        joints_rot: torch.Tensor,
        foot_contacts: torch.Tensor | None,
        local_rot_mats: torch.Tensor,
        root_positions: torch.Tensor,
        history_length: int,
    ):
        """Freeze root/body and smooth moving arm chains for hand-only pick motions."""
        enabled = (
            getattr(session.gui_elements, "gui_constraint_hand_only_motion_checkbox", None) is not None
            and session.gui_elements.gui_constraint_hand_only_motion_checkbox.value
        )
        if not enabled:
            return samples, samples_unnormalized, joints_pos, joints_rot, foot_contacts, local_rot_mats, root_positions

        moving_indices = self._hand_only_active_joint_indices(session)
        if not moving_indices:
            return samples, samples_unnormalized, joints_pos, joints_rot, foot_contacts, local_rot_mats, root_positions

        start = int(history_length)
        if start >= local_rot_mats.shape[1]:
            return samples, samples_unnormalized, joints_pos, joints_rot, foot_contacts, local_rot_mats, root_positions

        anchor_idx = max(0, start - 1)
        filtered_local = local_rot_mats.clone()
        filtered_root = root_positions.clone()

        all_indices = set(range(session.motion_rep.skeleton.nbjoints))
        frozen_indices = sorted(all_indices - set(moving_indices))
        if frozen_indices:
            filtered_local[:, start:, frozen_indices] = filtered_local[:, anchor_idx : anchor_idx + 1, frozen_indices]
        filtered_root[:, start:] = filtered_root[:, anchor_idx : anchor_idx + 1]

        arm_rots = filtered_local[:, start:, moving_indices]
        filtered_local[:, start:, moving_indices] = self._smooth_rotation_sequence(arm_rots, window=7)

        filtered_global_rot, filtered_pos, _ = session.motion_rep.skeleton.fk(filtered_local, filtered_root)
        filtered_unnorm = session.motion_rep(
            local_joint_rots=filtered_local,
            root_positions=filtered_root,
            to_normalize=False,
        )
        filtered_norm = session.motion_rep.normalize(filtered_unnorm)
        filtered_contacts = (
            filtered_unnorm[:, :, session.motion_rep.slice_dict["foot_contacts"]]
            if foot_contacts is not None
            else foot_contacts
        )
        return (
            filtered_norm,
            filtered_unnorm,
            filtered_pos,
            filtered_global_rot,
            filtered_contacts,
            filtered_local,
            filtered_root,
        )

    def restart(self, client_id: int, *, preserve_t3_base_route: bool = False):
        """Restart the demo for a client."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        playing = session.playing
        session.playing = False
        if not preserve_t3_base_route:
            session.t3_base_route_positions = None
            session.t3_base_route_headings = None
        self.clear_motions(client_id)
        session.max_frame_idx = -1
        session.frame_idx = 0

        # Reset camera state for smooth transitions
        session.camera_position = None
        session.camera_look_at = None
        session.camera_forward_direction = None
        session.camera_position_buffer.clear()
        session.camera_last_update_frame = -1

        # Clear all timeline prompts and add current active prompt from frame 0 to infinity
        self.clear_timeline_prompts(client_id)

        client = session.client
        if session.timeline_data is not None and hasattr(client, "timeline"):
            # Add current active prompt from frame 0 to infinity
            prompt_uuid_list = session.timeline_data.get("prompt_uuid_list", [])
            current_prompt = session.gui_elements.gui_prompt_text.value
            try:
                new_uuid = client.timeline.add_prompt(
                    text=current_prompt,
                    start_frame=0,
                    end_frame=INFINITE_FRAME_IDX,
                    color=self.get_prompt_color(0),
                )
                prompt_uuid_list.append(new_uuid)
                session.timeline_data["prompt_counter"] = 1  # Reset counter
                print(f"Added prompt for restart: '{current_prompt}' (frames 0-∞)")
            except (AttributeError, Exception) as e:
                print(f"Error adding prompt: {e}")

        self._generate_step(client_id)

        session.playing = playing
        self.set_frame(client_id, 0)

    def restart_from_now(self, client_id: int):
        """Restart generation from the current frame, clearing all motions after it."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        if session.model is None:
            print(f"Model not loaded for client {client_id}!")
            return

        current_frame = session.frame_idx
        if current_frame < 0:
            # No motion yet, fall back to normal restart
            self.restart(client_id)
            return

        playing = session.playing
        session.playing = False

        # Crop motion data to current frame (keep frames 0..current_frame)
        keep_end = current_frame + 1
        with session.motion_tensor_lock:
            if session.motion_tensor is not None:
                session.motion_tensor = session.motion_tensor[:, :keep_end]
            if session.joints_pos is not None:
                session.joints_pos = session.joints_pos[:, :keep_end]
            if session.joints_rot is not None:
                session.joints_rot = session.joints_rot[:, :keep_end]
            if session.foot_contacts is not None:
                session.foot_contacts = session.foot_contacts[:, :keep_end]
            if session.root_velocities is not None:
                session.root_velocities = session.root_velocities[:, :keep_end]

        session.max_frame_idx = current_frame
        session.gui_elements.gui_frame_idx_input.max = current_frame

        # Clear timeline text prompts that start after the current frame,
        # and extend the active prompt (the one covering current_frame) to infinity
        client = session.client
        if session.timeline_data is not None and hasattr(client, "timeline"):
            prompt_uuid_list = session.timeline_data.get("prompt_uuid_list", [])
            kept_uuids = []
            active_uuid = None
            for prompt_uuid in prompt_uuid_list:
                try:
                    prompt = client.timeline._prompts.get(prompt_uuid)
                    if prompt is None:
                        continue
                    if prompt.start_frame > current_frame:
                        # Prompt starts after current frame — remove it
                        client.timeline.remove_prompt(prompt_uuid)
                        print(f"[Restart From Now] Removed future prompt '{prompt.text}' (start={prompt.start_frame})")
                    else:
                        kept_uuids.append(prompt_uuid)
                        # Track the last prompt that covers current_frame
                        if prompt.start_frame <= current_frame:
                            active_uuid = prompt_uuid
                except Exception as e:
                    print(f"[Restart From Now] Error processing prompt: {e}")

            # Extend the active prompt to infinity so generation continues with it
            if active_uuid is not None:
                try:
                    client.timeline.update_prompt(active_uuid, end_frame=INFINITE_FRAME_IDX)
                    active_prompt = client.timeline._prompts.get(active_uuid)
                    if active_prompt:
                        print(f"[Restart From Now] Extended prompt '{active_prompt.text}' to infinity")
                except Exception as e:
                    print(f"[Restart From Now] Error extending prompt: {e}")

            session.timeline_data["prompt_uuid_list"] = kept_uuids
            session.timeline_data["prompt_counter"] = len(kept_uuids)

        print(f"[Restart From Now] Cleared motion after frame {current_frame}, triggering generation")

        self._generate_step(client_id)

        session.playing = playing

    def on_replan_trigger(self, client_id: int, skip_if_busy: bool = False):
        """Called when approaching end of timeline or when prompt changes.

        With skip_if_busy=True the trigger is dropped when a replan is already running, instead of
        queuing behind it. Used by the per-frame auto-replan check, which would otherwise pile up
        redundant generations (it re-fires on the next frame anyway).
        """
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        if skip_if_busy:
            if not session.replan_lock.acquire(blocking=False):
                return
            try:
                self._generate_step(client_id)
            finally:
                session.replan_lock.release()
        else:
            with session.replan_lock:
                self._generate_step(client_id)

    def _get_history_motion(self, session: ClientSession):
        """Get history motion for autoregressive generation."""
        frame_idx = session.frame_idx
        replan_buffer_size = session.gui_elements.gui_replan_buffer_size.value
        history_crop_length = session.gui_elements.gui_history_crop_length.value
        motion_tensor = session.motion_tensor

        cur_motion_len = motion_tensor.shape[1] if motion_tensor is not None else 0
        history_end_idx = min(cur_motion_len - 1, frame_idx + replan_buffer_size)
        if (
            cur_motion_len >= session.num_frames_per_token
        ):  # if there are history frames, ensure history end idx is at least num_frames_per_token - 1
            history_end_idx = max(history_end_idx, session.num_frames_per_token - 1)
        history_length = min(history_end_idx + 1, history_crop_length)
        history_length = history_length // session.num_frames_per_token * session.num_frames_per_token
        history_start_idx = max(0, history_end_idx - history_length + 1)

        history_motion_tensor = None
        if motion_tensor is not None and history_start_idx <= history_end_idx:
            history_motion_tensor = motion_tensor[:, history_start_idx : history_end_idx + 1]

        return history_motion_tensor, history_start_idx, history_end_idx, history_length

    def _generate_step(self, client_id: int):
        """One autoregressive generation step."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        if session.model is None:
            print(f"Model not loaded for client {client_id}!")
            return

        start_time = time.time()

        history_motion_tensor, history_start_idx, history_end_idx, history_length = self._get_history_motion(session)
        print(
            f"Generate with frame idx {session.frame_idx}, history start: {history_start_idx}, end: {history_end_idx}, length: {history_length}"
        )

        num_samples = session.gui_elements.gui_num_samples.value
        text_feat = session.text_embedding.repeat(num_samples, 1, 1)
        text_pad_mask = torch.ones(text_feat.shape[0], text_feat.shape[1], device=self.device, dtype=torch.bool)

        motion_mask = None
        observed_motion = None

        # Check if we have timeline constraints (including waypoints)
        constraint_idx_list = [c.get_constraint_info()["frame_idx"] for c in session.constraints.values()]
        # merge all constraint indices into a single list
        all_constraint_indices = [idx for sublist in constraint_idx_list for idx in sublist]
        max_task_idx = session.task_end_frame_idx if not session.realtime_mode else None
        max_required_idx = None
        if all_constraint_indices:
            max_required_idx = max(all_constraint_indices)
        if max_task_idx is not None:
            max_required_idx = max(max_required_idx, max_task_idx) if max_required_idx is not None else max_task_idx

        has_valid_timeline_constraints = max_required_idx is not None and max_required_idx > history_end_idx

        # number of frames of the visible sequence to the model
        num_frames = compute_window_num_frames(
            history_length=history_length,
            gen_horizon_len=session.gen_horizon_len,
            num_frames_per_token=session.num_frames_per_token,
            max_window_len=session.max_window_len,
            history_start_idx=history_start_idx,
            max_constraint_idx=(max_required_idx if has_valid_timeline_constraints else None),
            future_crop_length=(
                session.max_window_len
                if max_task_idx is not None
                else session.gui_elements.gui_future_crop_length.value
            ),
        )

        # Process timeline constraints
        if has_valid_timeline_constraints:
            motion_mask, observed_motion = self.compute_constraint_mask(
                session,
                num_samples,
                num_frames=num_frames + history_start_idx,
                history_end_idx=history_end_idx,
            )

            if motion_mask is not None and observed_motion is not None:
                motion_mask = motion_mask[:, history_start_idx:]
                observed_motion = observed_motion[:, history_start_idx:]
                motion_mask[:, :history_length] = 0.0  # disable history frames constraints
                observed_motion[:, :history_length] = 0.0

        # if motion_mask is not None and observed_motion is not None:
        #     print(f"motion mask non zero: {(motion_mask != 0.0).sum()}, observed motion non zero: {(observed_motion != 0.0).sum()}")
        #     # motion_mask_by_dim = motion_mask.any(dim=(0, 1))
        #     # print(f"Nonzero dimensions: {motion_mask_by_dim.nonzero()}")
        #     observed_motion_by_dim = observed_motion.any(dim=(0, 1))
        #     print(f"Observed motion nonzero dimensions: {observed_motion_by_dim.nonzero().squeeze()}")

        print(f"Num frames: {num_frames}")

        if history_motion_tensor is None:
            num_samples = session.gui_elements.gui_num_samples.value
            init_global_translation = (
                torch.from_numpy(session.init_global_translation)
                .to(dtype=torch.float32, device=self.device)
                .unsqueeze(0)
                .repeat(num_samples, 1)
            )
            init_first_heading_angle = (
                torch.ones(num_samples, dtype=torch.float32, device=self.device) * session.init_first_heading_angle
            )
        else:
            init_global_translation = None
            init_first_heading_angle = None

        # Generate motion
        samples = session.model.autoregressive_step(
            num_frames=num_frames,
            num_denoising_steps=session.gui_elements.gui_diffusion_steps_slider.value,
            motion_mask=motion_mask,
            observed_motion=observed_motion,
            cfg_weight=(
                session.gui_elements.gui_cfg_text_weight.value,
                session.gui_elements.gui_cfg_constraint_weight.value,
            ),
            texts=None,
            text_feat=text_feat,
            text_pad_mask=text_pad_mask,
            init_history_sequence=history_motion_tensor,
            init_global_translation=init_global_translation,
            init_first_heading_angle=init_first_heading_angle,
        )

        # Convert to joints
        samples_unnormalized = session.motion_rep.unnormalize(samples)
        pred_joints_output = session.motion_rep.inverse(
            samples_unnormalized,
            is_normalized=False,
        )

        joints_pos = pred_joints_output["posed_joints"]
        joints_rot = pred_joints_output["global_rot_mats"]
        foot_contacts = pred_joints_output.get("foot_contacts")
        local_rot_mats = pred_joints_output["local_rot_mats"]
        root_positions = pred_joints_output["root_positions"]

        # Apply post-processing if enabled
        if session.gui_elements.gui_enable_postprocess_checkbox.value:
            postprocess_start_time = time.time()

            # Get constraints in the generation horizon
            model_constraints = self.compute_model_constraints_lst(
                session,
                num_frames=session.gen_horizon_len + history_length + history_start_idx,
                history_end_idx=history_end_idx,
            )

            #  check if the model_constraints is not empty
            if len(model_constraints) > 0:
                # Get local rotations and root positions from pred_joints_output
                # subtract history_end_idx from the model_constraints frame indices
                for constraint in model_constraints:
                    constraint.frame_indices = constraint.frame_indices - history_start_idx - history_length

                # Apply post-processing to generation horizon frames
                corrected_output = post_process_motion(
                    local_rot_mats[:, history_length:],
                    root_positions[:, history_length:],
                    foot_contacts[:, history_length:],
                    session.motion_rep.skeleton,
                    constraint_lst=model_constraints if model_constraints else None,
                    contact_threshold=session.gui_elements.gui_postprocess_contact_threshold.value,
                    root_margin=session.gui_elements.gui_postprocess_root_margin.value,
                )

                # calculate corrected motion_tensor, joints_pos, joints_rot, foot_contacts
                joints_pos[:, history_length:] = corrected_output["posed_joints"]
                joints_rot[:, history_length:] = corrected_output["global_rot_mats"]
                local_rot_mats[:, history_length:] = corrected_output["local_rot_mats"]
                root_positions[:, history_length:] = corrected_output["root_positions"]
                corrected_tensor_unnormalized = session.motion_rep(
                    local_joint_rots=corrected_output["local_rot_mats"],
                    root_positions=corrected_output["root_positions"],
                    to_normalize=False,
                )
                corrected_tensor_normalized = session.motion_rep.normalize(corrected_tensor_unnormalized)
                samples_unnormalized[:, history_length:] = corrected_tensor_unnormalized
                samples[:, history_length:] = corrected_tensor_normalized
                foot_contacts[:, history_length:] = corrected_tensor_unnormalized[
                    :, :, session.motion_rep.slice_dict["foot_contacts"]
                ]

            postprocess_end_time = time.time()
            print(
                f"[PostProcess] Motion correction applied in {postprocess_end_time - postprocess_start_time:.4f} seconds"
            )

        (
            samples,
            samples_unnormalized,
            joints_pos,
            joints_rot,
            foot_contacts,
            local_rot_mats,
            root_positions,
        ) = self._apply_hand_only_motion_filter(
            session,
            samples,
            samples_unnormalized,
            joints_pos,
            joints_rot,
            foot_contacts,
            local_rot_mats,
            root_positions,
            history_length,
        )

        joints_pos, root_positions = ground_motion_to_floor(
            session.motion_rep.skeleton,
            joints_pos,
            root_positions,
        )
        grounded_tensor_unnormalized = session.motion_rep(
            local_joint_rots=local_rot_mats,
            root_positions=root_positions,
            to_normalize=False,
        )
        samples_unnormalized = grounded_tensor_unnormalized
        samples = session.motion_rep.normalize(grounded_tensor_unnormalized)
        if foot_contacts is not None:
            foot_contacts = grounded_tensor_unnormalized[:, :, session.motion_rep.slice_dict["foot_contacts"]]

        # Extract root velocities from motion representation
        joint_velocities = samples_unnormalized[:, :, session.motion_rep.slice_dict["velocities"]]
        sequence_len = samples_unnormalized.shape[1]
        joint_velocities = joint_velocities.reshape(
            num_samples,
            sequence_len,
            session.motion_rep.skeleton.nbjoints,
            3,
        )
        root_velocities = joint_velocities[:, :, session.motion_rep.skeleton.root_idx, :]

        # Update motion data
        with session.motion_tensor_lock:
            if session.motion_tensor is None:
                session.motion_tensor = samples.clone()
                session.joints_pos = joints_pos.clone()
                session.joints_rot = joints_rot.clone()
                session.foot_contacts = foot_contacts.clone()
                session.root_velocities = root_velocities.clone()
                for i in range(num_samples):
                    self.add_character(client_id, session.motion_rep.skeleton, i)
            else:
                session.motion_tensor = torch.cat(
                    [
                        session.motion_tensor[:, : history_end_idx + 1],
                        samples[:, history_length:],
                    ],
                    dim=1,
                )
                session.joints_pos = torch.cat(
                    [
                        session.joints_pos[:, : history_end_idx + 1],
                        joints_pos[:, history_length:],
                    ],
                    dim=1,
                )
                session.joints_rot = torch.cat(
                    [
                        session.joints_rot[:, : history_end_idx + 1],
                        joints_rot[:, history_length:],
                    ],
                    dim=1,
                )
                session.foot_contacts = torch.cat(
                    [
                        session.foot_contacts[:, : history_end_idx + 1],
                        foot_contacts[:, history_length:],
                    ],
                    dim=1,
                )
                session.root_velocities = torch.cat(
                    [
                        session.root_velocities[:, : history_end_idx + 1],
                        root_velocities[:, history_length:],
                    ],
                    dim=1,
                )

            # Update timeline
            session.max_frame_idx = session.motion_tensor.shape[1] - 1
            if (
                session.task_generation_pending
                and session.task_end_frame_idx is not None
                and session.max_frame_idx >= session.task_end_frame_idx
            ):
                session.task_generation_pending = False

        if self._straighten_rack_route_arrival_pose(session):
            print(f"[Rack Route] Straightened arrival pose at frame {session.task_end_frame_idx}")

        # Update frame index input max value
        session.gui_elements.gui_frame_idx_input.max = session.max_frame_idx
        if (
            getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
            and session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
            and session.gui_elements.gui_viz_t3_robot_checkbox.value
        ):
            session.t3_live_soma77_local_rot_mats = None
            session.t3_live_root_positions = None
            self.request_soma_t3_retarget(client_id, start_frame=0)

        end_time = time.time()
        print(f"Generate step time: {end_time - start_time} seconds")
