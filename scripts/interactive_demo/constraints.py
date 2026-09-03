# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Part of InteractiveTimelineDemo (split for readability)."""

import math

from .common import *  # noqa: F401,F403

# End-effector joint -> constraint-type key in ardy.constraints.TYPE_TO_CLASS
# (generation regroups End-Effector keyframes by these keys).
EE_JOINT_TO_TYPE = {
    "LeftHand": "left-hand",
    "RightHand": "right-hand",
    "LeftFoot": "left-foot",
    "RightFoot": "right-foot",
}


class ConstraintsMixin:
    def _load_cached_say_hi_motion(self, session):
        """Load the cached say-hi BVH parse and return normalized motion features."""
        skeleton_name = type(session.motion_rep.skeleton).__name__
        patterns = [
            os.path.join(REPO_ROOT, ".cache", "motion", f"say hi_{skeleton_name}_*.pt"),
            os.path.join(REPO_ROOT, "datasets", "bones-seed", "cache", f"say hi_{skeleton_name}_*.pt"),
        ]
        cache_paths = []
        for pattern in patterns:
            cache_paths.extend(sorted(glob.glob(pattern)))
        if not cache_paths:
            return None, None

        cached = torch.load(cache_paths[0], weights_only=True)
        if "local_rot_mats" not in cached or "root_trans" not in cached:
            return None, cache_paths[0]

        motion_rep = session.motion_rep
        device = (
            next(iter(motion_rep.skeleton.buffers())).device
            if list(motion_rep.skeleton.buffers())
            else self.device
        )
        local_rot_mats = cached["local_rot_mats"].to(device=device, dtype=torch.float32).unsqueeze(0)
        root_trans = cached["root_trans"].to(device=device, dtype=torch.float32).unsqueeze(0)
        feats = motion_rep(local_rot_mats, root_trans, to_normalize=False)
        rotated = motion_rep.rotate_to(feats, torch.tensor(0.0, device=device))
        root_pos = rotated[:, :, motion_rep.slice_dict["root_pos"]]
        first_2d = root_pos[:, 0, [0, 2]].clone()
        canonical = motion_rep.translate_2d(rotated, -first_2d)
        return motion_rep.normalize(canonical).squeeze(0), cache_paths[0]

    def _add_say_hi_constraints_from_cache(
        self,
        client_id: int,
        start_frame: int,
        root_position: np.ndarray,
        heading: float,
    ) -> tuple[int, int]:
        """Append selected say-hi full-body BVH keyframes after a route."""
        session = self.client_sessions[client_id]
        motion, cache_path = self._load_cached_say_hi_motion(session)
        if motion is None:
            print("[Forward Left Forward] No cached say-hi motion found for this skeleton.")
            return start_frame, 0

        motion_rep = session.motion_rep
        motion_unnorm = motion_rep.unnormalize(motion.unsqueeze(0))
        motion_rotated = motion_rep.rotate_to(motion_unnorm, torch.tensor(float(heading), device=motion.device))
        target_2d = torch.tensor(
            [[float(root_position[0]), float(root_position[2])]],
            device=motion.device,
            dtype=torch.float32,
        )
        motion_transformed = motion_rep.translate_2d_to(motion_rotated, target_2d)
        motion_normalized = motion_rep.normalize(motion_transformed).squeeze(0)

        inverse_output = motion_rep.inverse(motion_normalized, is_normalized=True)
        joints_pos = inverse_output["posed_joints"]
        joints_rot = inverse_output["global_rot_mats"]
        motion_len = int(motion_normalized.shape[0])
        if motion_len <= 0:
            return start_frame, 0

        selected = sorted(
            set(
                max(0, min(motion_len - 1, int(round((motion_len - 1) * ratio))))
                for ratio in (0.0, 0.25, 0.5, 0.75, 1.0)
            )
        )
        fullbody_constraint = session.constraints.get("Full-Body")
        if fullbody_constraint is None:
            return start_frame, 0

        timeline_added = 0
        for seq_idx in selected:
            frame_idx = start_frame + seq_idx
            constraint_id = f"say_hi_fullbody_{frame_idx}"
            fullbody_constraint.add_keyframe(
                keyframe_id=constraint_id,
                frame_idx=frame_idx,
                joints_pos=joints_pos[seq_idx],
                joints_rot=joints_rot[seq_idx],
                exists_ok=True,
            )
            self.add_keyframe_to_timeline(client_id, "Full-Body", frame_idx, constraint_id)
            timeline_added += 1

        if session.gui_elements.gui_viz_ref_motion_checkbox.value:
            prefix_pos = session.ref_joints_pos
            prefix_rot = session.ref_joints_rot
            if prefix_pos is None or prefix_pos.shape[0] < start_frame:
                pad_pos = joints_pos[:1].repeat(start_frame, 1, 1)
                pad_rot = joints_rot[:1].repeat(start_frame, 1, 1, 1)
                prefix_pos = pad_pos
                prefix_rot = pad_rot
            else:
                prefix_pos = prefix_pos[:start_frame]
                prefix_rot = prefix_rot[:start_frame]
            session.ref_joints_pos = torch.cat([prefix_pos.to(joints_pos), joints_pos], dim=0)
            session.ref_joints_rot = torch.cat([prefix_rot.to(joints_rot), joints_rot], dim=0)
            self._create_ref_character(client_id)

        print(f"[Forward Left Forward] Added say-hi constraints from {cache_path}: frames {selected}")
        return start_frame + motion_len - 1, timeline_added

    def _apply_pending_say_hi_after_task(self, client_id: int) -> bool:
        """Install the say-hi BVH constraints after an FLF route has completed."""
        if not self.client_active(client_id):
            return False
        session = self.client_sessions[client_id]
        if not session.pending_say_hi_after_task:
            return False
        if session.pending_say_hi_root_position is None or session.pending_say_hi_heading is None:
            session.pending_say_hi_after_task = False
            return False

        route_end_frame = int(session.task_end_frame_idx if session.task_end_frame_idx is not None else session.frame_idx)
        session.pending_say_hi_after_task = False

        if not os.path.exists(SAY_HI_MOTION_FILE_PATH):
            session.client.add_notification(
                title="Say Hi skipped",
                body=f"BVH not found: {SAY_HI_MOTION_FILE_PATH}",
                color="orange",
                auto_close_seconds=4.0,
            )
            return False

        if session.max_frame_idx >= 0:
            self.set_frame(client_id, min(route_end_frame, session.max_frame_idx))

        g = session.gui_elements
        g.gui_motion_file_path.value = SAY_HI_MOTION_FILE_PATH
        crop_10s = True
        if getattr(g, "gui_crop_motion_checkbox", None) is not None:
            g.gui_crop_motion_checkbox.value = crop_10s
        g.gui_constraint_fullbody_checkbox.value = False
        g.gui_constraint_hands_checkbox.value = True
        g.gui_constraint_forearm_orientation_checkbox.value = False
        g.gui_constraint_hand_only_motion_checkbox.value = True
        g.gui_constraint_feet_checkbox.value = False
        g.gui_constraint_hands_feet_checkbox.value = False
        g.gui_constraint_2d_waypoints_checkbox.value = True
        g.gui_constraint_2d_trajectory_checkbox.value = False
        g.gui_continue_from_current_checkbox.value = True
        g.gui_max_keyframe_num.value = 11
        if getattr(g, "gui_min_keyframe_gap", None) is not None:
            g.gui_min_keyframe_gap.value = round(1.5 * session.motion_rep.fps)
        if getattr(g, "gui_motion_stretch", None) is not None:
            g.gui_motion_stretch.value = 1.0
        g.gui_constraint_frame_indices.value = ""

        try:
            seq_data = self.load_motion_from_file(SAY_HI_MOTION_FILE_PATH, session, crop_10s=crop_10s)
            self.load_sequence(
                client_id,
                seq_data,
                constraint_types=[
                    "Hands",
                    "2D Root Waypoints",
                ],
                continue_from_current=True,
                update_text=bool(seq_data.get("text")),
            )
            session.play_once = True
            session.playing = True
            session.gui_elements.gui_play_pause_button.label = "Pause"
            session.client.add_notification(
                title="Say Hi BVH started",
                body=f"Cropped to 10s, sparse hand/root constraints, continuing after frame {route_end_frame}.",
                color="green",
                auto_close_seconds=3.0,
            )
            return True
        except Exception as e:
            session.client.add_notification(
                title="Say Hi failed",
                body=str(e),
                color="red",
                auto_close_seconds=5.0,
            )
            raise

    def remove_keyframe_from_timeline(
        self,
        client_id: int,
        constraint_type: str,
        frame_idx: int,
        constraint_id: str,
        joint_name: str = None,
    ):
        """Remove a keyframe from the timeline GUI if it exists.

        Args:
            constraint_type: Type of constraint (e.g., "2D Root", "End-Effectors")
            frame_idx: Frame index where the keyframe exists
            constraint_id: ID of the keyframe to remove
            joint_name: For End-Effectors, specify the joint
        """
        if not self.client_active(client_id):
            return False

        session = self.client_sessions[client_id]
        client = session.client

        # Check if timeline is available
        if not hasattr(client, "timeline") or session.timeline_data is None:
            return False

        # Check if timeline tracks are properly initialized
        tracks_ids = session.timeline_data.get("tracks_ids", {})
        if not tracks_ids:
            # Timeline not properly initialized (probably not supported in this viser version)
            return False

        # Get the track ID for the constraint type
        track_name = constraint_type
        if constraint_type == "End-Effectors":
            if joint_name:
                track_name = joint_name.replace("Hand", " Hand").replace("Foot", " Foot")
            else:
                return False

        if track_name not in tracks_ids:
            return False

        track_id = tracks_ids[track_name]

        # Try to remove keyframe from timeline
        try:
            if hasattr(client.timeline, "remove_keyframe"):
                # Check if keyframe is in tracking dict and get its timeline UUID
                if constraint_id not in session.timeline_data["keyframes"]:
                    return False

                # Get the timeline UUID that was returned when we added this keyframe
                keyframe_data = session.timeline_data["keyframes"][constraint_id]
                timeline_uuid = keyframe_data.get("timeline_uuid")

                if not timeline_uuid:
                    return False

                # The viser timeline API takes the UUID returned by add_keyframe
                client.timeline.remove_keyframe(timeline_uuid)

                # Remove from tracking data
                with session.timeline_data["keyframe_update_lock"]:
                    del session.timeline_data["keyframes"][constraint_id]
                return True
            else:
                return False
        except Exception as e:
            return False

    def add_keyframe_to_timeline(
        self,
        client_id: int,
        constraint_type: str,
        frame_idx: int,
        constraint_id: str,
        joint_name: str = None,
    ):
        """Attempt to add a keyframe to the timeline GUI if the API supports it.

        Falls back gracefully if not supported.

        Args:
            joint_name: For End-Effectors, specify the joint (e.g., "LeftHand", "RightFoot")
        """
        if not self.client_active(client_id):
            return False

        session = self.client_sessions[client_id]
        client = session.client

        # Check if timeline is available
        if not hasattr(client, "timeline"):
            print(f"[Timeline] Warning: Client {client_id} has no timeline attribute")
            return False

        if session.timeline_data is None:
            print(f"[Timeline] Warning: Client {client_id} has no timeline_data")
            return False

        # Check if timeline tracks are properly initialized
        tracks_ids = session.timeline_data.get("tracks_ids", {})
        if not tracks_ids:
            # Timeline not properly initialized (probably not supported in this viser version)
            print(f"[Timeline] Warning: No tracks_ids found in timeline_data")
            return False

        # Get the track ID for the constraint type
        track_name = constraint_type
        if constraint_type == "End-Effectors":
            # For end-effectors, map joint name to track name
            if joint_name:
                # Convert joint names like "LeftHand" to "Left Hand"
                track_name = joint_name.replace("Hand", " Hand").replace("Foot", " Foot")
            else:
                # Can't determine which specific track without joint name
                print(f"[Timeline] Warning: End-Effectors constraint without joint_name")
                return False

        if track_name not in tracks_ids:
            print(f"[Timeline] Warning: Track '{track_name}' not found in tracks_ids: {list(tracks_ids.keys())}")
            return False

        track_id = tracks_ids[track_name]

        # Try to add keyframe to timeline (if the API supports it)
        try:
            # Check if the timeline has an add_keyframe method
            if hasattr(client.timeline, "add_keyframe"):
                # Check if this keyframe already exists in timeline_data
                if constraint_id in session.timeline_data["keyframes"]:
                    existing = session.timeline_data["keyframes"][constraint_id]
                    print(
                        f"[Timeline] Keyframe '{constraint_id}' already exists at frame {existing['frame']}, skipping"
                    )
                    return True  # Return true since the keyframe is already there

                # add_keyframe returns a UUID that we need to store for later removal
                print(
                    f"[Timeline] Attempting to add keyframe: track_id={track_id}, frame={frame_idx}, constraint_id={constraint_id}"
                )
                timeline_uuid = client.timeline.add_keyframe(track_id, frame_idx)
                print(f"[Timeline] Successfully added keyframe, received UUID: {timeline_uuid}")

                # Track it in timeline_data - store both the UUID and other metadata
                with session.timeline_data["keyframe_update_lock"]:
                    session.timeline_data["keyframes"][constraint_id] = {
                        "frame": frame_idx,
                        "track_id": track_id,
                        "timeline_uuid": timeline_uuid,  # Store the UUID returned by viser
                    }
                print(f"[Timeline] ✓ Added keyframe: track='{track_name}', frame={frame_idx}, id={constraint_id}")
                return True
            else:
                print(f"[Timeline] Warning: add_keyframe method not available on client.timeline")
                return False
        except (AttributeError, Exception) as e:
            # API not available or failed - that's okay, constraints still work
            print(f"[Timeline] ✗ Failed to add keyframe: {type(e).__name__}: {e}")
            import traceback

            traceback.print_exc()
            return False

    def add_interval_to_timeline(
        self,
        client_id: int,
        constraint_type: str,
        start_frame_idx: int,
        end_frame_idx: int,
        constraint_id: str,
    ):
        """Attempt to add an interval to the timeline GUI if the API supports it.

        Falls back gracefully if not supported.
        """
        if not self.client_active(client_id):
            return False

        session = self.client_sessions[client_id]
        client = session.client

        # Check if timeline is available
        if not hasattr(client, "timeline") or session.timeline_data is None:
            return False

        # Check if timeline tracks are properly initialized
        tracks_ids = session.timeline_data.get("tracks_ids", {})
        if not tracks_ids:
            # Timeline not properly initialized (probably not supported in this viser version)
            return False

        # Get the track ID for the constraint type
        track_name = constraint_type
        if constraint_type == "End-Effectors":
            # For end-effectors, we can't determine which specific track without more info
            # So we skip timeline GUI integration for now
            print(f"Warning: Intervals not supported for End-Effectors in timeline")
            return False

        if track_name not in tracks_ids:
            print(f"Warning: Track '{track_name}' not found in tracks_ids: {list(tracks_ids.keys())}")
            return False

        track_id = tracks_ids[track_name]
        print(
            f"Adding interval to timeline: track='{track_name}', frames={start_frame_idx}-{end_frame_idx}, id={constraint_id}"
        )

        # Try to add interval to timeline (if the API supports it)
        try:
            # Check if the timeline has an add_interval method
            if hasattr(client.timeline, "add_interval"):
                client.timeline.add_interval(track_id, start_frame_idx, end_frame_idx, constraint_id)
                # Track it in timeline_data
                with session.timeline_data["keyframe_update_lock"]:
                    session.timeline_data["intervals"][constraint_id] = {
                        "track_id": track_id,
                        "start_frame_idx": start_frame_idx,
                        "end_frame_idx": end_frame_idx,
                    }
                return True
        except (AttributeError, Exception) as e:
            # API not available or failed - that's okay, constraints still work
            print(f"Timeline GUI interval integration not available: {e}")
            return False

        return False

    def add_waypoint(self, client_id: int, x: float, z: float):
        """Add a waypoint for a client using the 2D Root constraint system."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        interval = session.gui_elements.gui_waypoint_interval.value
        target_frame = max(0, session.frame_idx) + interval
        constraint = session.constraints["2D Root"]

        # If dense mode is enabled, first add a waypoint at the current frame
        if session.gui_elements.gui_dense_root_checkbox.value:
            current_frame = session.frame_idx
            if current_frame >= 0 and current_frame <= session.max_frame_idx:
                # Get current root position from motion data
                current_root_pos = session.joints_pos[0, current_frame, 0, :].clone()
                # Zero out the y component for 2D constraint
                current_root_pos[1] = 0.0

                # Add waypoint at current frame
                # Generate a unique waypoint ID using timestamp to avoid conflicts
                import time

                current_waypoint_id = f"waypoint_{current_frame}_{int(time.time() * 1000000) % 1000000}"
                constraint.add_keyframe(
                    keyframe_id=current_waypoint_id,
                    frame_idx=current_frame,
                    root_pos=current_root_pos,
                    viz_label=True,
                    exists_ok=True,
                    update_path=False,
                )

                # Add to timeline GUI
                success = self.add_keyframe_to_timeline(client_id, "2D Root", current_frame, current_waypoint_id)
                if not success:
                    print(
                        f"[Warning] Failed to add current waypoint to timeline GUI, but constraint was added successfully"
                    )

                print(
                    f"Added current position waypoint at frame {current_frame}: ({current_root_pos[0]:.2f}, {current_root_pos[2]:.2f})"
                )

        # Add the clicked waypoint to the 2D Root constraint track
        # Generate a unique waypoint ID using timestamp to avoid conflicts
        import time

        waypoint_id = f"waypoint_{target_frame}_{int(time.time() * 1000000) % 1000000}"
        root_pos = torch.tensor([x, 0.0, z], dtype=torch.float32)

        constraint.add_keyframe(
            keyframe_id=waypoint_id,
            frame_idx=target_frame,
            root_pos=root_pos,
            viz_label=True,
            exists_ok=True,
            update_path=False,
        )

        # Try to add to timeline GUI
        success = self.add_keyframe_to_timeline(client_id, "2D Root", target_frame, waypoint_id)
        if not success:
            print(f"[Warning] Failed to add waypoint to timeline GUI, but constraint was added successfully")

        # Update the path visualization if dense_path is enabled
        if constraint.dense_path and constraint.line_segments is not None:
            try:
                constraint.update_line_segments()
            except Exception as e:
                print(f"[Warning] Failed to update line segments: {e}")

        print(f"Added target waypoint: ({x:.2f}, {z:.2f}) at frame {target_frame}")

        threading.Thread(target=self.on_replan_trigger, args=(client_id,), daemon=True).start()

    def apply_root_distance_constraint(
        self,
        client_id: int,
        distance_m: float = 1.0,
        duration_s: float = 4.0,
        *,
        backward: bool = False,
    ):
        """Constrain the generated root to travel a fixed distance forward."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        if "2D Root" not in session.constraints:
            client.add_notification(
                title="No 2D Root Track",
                body="The active model does not provide root path constraints.",
                color="red",
                auto_close_seconds=4.0,
            )
            return

        progress = client.add_notification(
            title="Root Distance Constraint",
            body="Installing dense straight root path...",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            distance_m = max(0.01, float(distance_m))
            duration_s = max(0.5, float(duration_s))
            total_frames = max(2, int(round(duration_s * float(session.model_fps))) + 1)
            end_frame = total_frames - 1

            start = (
                np.asarray(session.init_global_translation, dtype=np.float32).copy()
                if session.init_global_translation is not None
                else np.zeros(3, dtype=np.float32)
            )
            start[1] = 0.0
            heading = float(session.init_first_heading_angle or 0.0)
            forward = np.array([math.sin(heading), 0.0, math.cos(heading)], dtype=np.float32)
            direction = -1.0 if backward else 1.0
            end = start + forward * distance_m * direction
            end[1] = 0.0

            session.playing = False
            session.play_once = False
            session.realtime_mode = False
            session.gui_elements.gui_play_pause_button.label = "Play"
            session.gui_elements.gui_realtime_mode_checkbox.value = False
            session.gui_elements.gui_next_frame_button.disabled = False
            session.gui_elements.gui_prev_frame_button.disabled = True
            session.gui_elements.gui_enable_auto_replan_checkbox.value = False
            session.gui_elements.gui_enable_auto_replan_checkbox.disabled = True

            session.init_global_translation = start.astype(np.float32)
            session.init_first_heading_angle = heading
            session.t3_base_route_positions = None
            session.t3_base_route_headings = None
            if session.transform_gizmo is not None:
                session.transform_gizmo.position = tuple(session.init_global_translation.tolist())
                session.transform_gizmo.wxyz = viser.transforms.SO3.from_y_radians(heading).wxyz
            self._update_start_direction_marker(client_id)

            with session.timeline_data["keyframe_update_lock"]:
                for constraint in list(session.constraints.values()):
                    constraint.clear()
                if hasattr(client, "timeline"):
                    client.timeline.clear_keyframes()
                    client.timeline.clear_intervals()
                session.timeline_data["keyframes"].clear()
                session.timeline_data["intervals"].clear()

            root_constraint = session.constraints["2D Root"]
            root_constraint.set_smooth_path(False)
            root_constraint.set_dense_path(False)

            waypoint_interval = max(1, int(round(float(session.model_fps) * 0.25)))
            waypoint_indices = sorted(set([0, end_frame, *range(0, total_frames, waypoint_interval)]))
            for frame_idx in waypoint_indices:
                alpha = frame_idx / max(float(end_frame), 1.0)
                position = start + (end - start) * alpha
                root_constraint.add_keyframe(
                    keyframe_id=(
                        f"root_distance_{'back' if backward else 'forward'}_"
                        f"{int(round(distance_m * 100.0))}cm_{frame_idx}"
                    ),
                    frame_idx=frame_idx,
                    root_pos=torch.tensor(position, dtype=torch.float32),
                    global_root_heading=heading,
                    viz_label=frame_idx in {0, end_frame},
                    exists_ok=True,
                    update_path=False,
                    add_annulus=frame_idx in {0, end_frame},
                )

            root_constraint.set_dense_path(True)
            root_constraint.update_line_segments()
            self.add_interval_to_timeline(client_id, "2D Root", 0, end_frame, f"root_distance_{end_frame}")

            if hasattr(client, "timeline"):
                client.timeline.set_frame_range(
                    start_frame=0,
                    end_frame=max(total_frames + TIMELINE_WINDOW_BEFORE, TIMELINE_WINDOW_AFTER),
                )

            session.task_end_frame_idx = end_frame
            session.task_generation_pending = True
            session.task_reached_reported = False
            session.ref_joints_pos = None
            session.ref_joints_rot = None
            if session.ref_character is not None:
                session.ref_character.clear()
                session.ref_character = None

            text_feat, _ = session.model.text_encoder([RACK_ROUTE_WALKING_PROMPT])
            session.text_embedding = text_feat.to(self.device)
            session.gui_elements.gui_prompt_text.value = RACK_ROUTE_WALKING_PROMPT
            session.gui_elements.gui_active_prompt_label.content = (
                f"**Active Prompt:** {RACK_ROUTE_WALKING_PROMPT} + "
                f"{distance_m * 100.0:.0f} cm {'backward' if backward else 'forward'} root constraint"
            )

            progress.body = f"Generating {distance_m * 100.0:.0f} cm {'backward' if backward else 'forward'} root motion..."
            client.flush()
            self.restart(client_id)
            self.set_frame(client_id, 0)

            progress.title = "Root Distance Applied"
            progress.body = (
                f"Root constrained to {distance_m * 100.0:.0f} cm "
                f"{'backward' if backward else 'forward'} over {total_frames / float(session.model_fps):.1f}s "
                f"with {len(waypoint_indices)} dense waypoints."
            )
            progress.color = "green"
        except Exception as e:
            progress.title = "Root Distance Failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 6.0

    def apply_root_rotation_constraint(
        self,
        client_id: int,
        degrees: float = 90.0,
        duration_s: float = 2.0,
        *,
        clockwise: bool = False,
    ):
        """Constrain the generated root to rotate in place by a fixed angle."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        if "2D Root" not in session.constraints:
            client.add_notification(
                title="No 2D Root Track",
                body="The active model does not provide root path constraints.",
                color="red",
                auto_close_seconds=4.0,
            )
            return

        progress = client.add_notification(
            title="Root Rotation Constraint",
            body="Installing dense in-place turn...",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            degrees = max(1.0, min(abs(float(degrees)), 360.0))
            duration_s = max(0.5, float(duration_s))
            total_frames = max(2, int(round(duration_s * float(session.model_fps))) + 1)
            end_frame = total_frames - 1

            start = (
                np.asarray(session.init_global_translation, dtype=np.float32).copy()
                if session.init_global_translation is not None
                else np.zeros(3, dtype=np.float32)
            )
            start[1] = 0.0
            start_heading = float(session.init_first_heading_angle or 0.0)
            sign = -1.0 if clockwise else 1.0
            end_heading = start_heading + math.radians(degrees) * sign

            session.playing = False
            session.play_once = False
            session.realtime_mode = False
            session.gui_elements.gui_play_pause_button.label = "Play"
            session.gui_elements.gui_realtime_mode_checkbox.value = False
            session.gui_elements.gui_next_frame_button.disabled = False
            session.gui_elements.gui_prev_frame_button.disabled = True
            session.gui_elements.gui_enable_auto_replan_checkbox.value = False
            session.gui_elements.gui_enable_auto_replan_checkbox.disabled = True

            session.init_global_translation = start.astype(np.float32)
            session.init_first_heading_angle = start_heading
            session.t3_base_route_positions = None
            session.t3_base_route_headings = None
            if session.transform_gizmo is not None:
                session.transform_gizmo.position = tuple(session.init_global_translation.tolist())
                session.transform_gizmo.wxyz = viser.transforms.SO3.from_y_radians(start_heading).wxyz
            self._update_start_direction_marker(client_id)

            with session.timeline_data["keyframe_update_lock"]:
                for constraint in list(session.constraints.values()):
                    constraint.clear()
                if hasattr(client, "timeline"):
                    client.timeline.clear_keyframes()
                    client.timeline.clear_intervals()
                session.timeline_data["keyframes"].clear()
                session.timeline_data["intervals"].clear()

            root_constraint = session.constraints["2D Root"]
            root_constraint.set_smooth_path(False)
            root_constraint.set_dense_path(False)

            waypoint_interval = max(1, int(round(float(session.model_fps) * 0.15)))
            waypoint_indices = sorted(set([0, end_frame, *range(0, total_frames, waypoint_interval)]))
            for frame_idx in waypoint_indices:
                alpha = frame_idx / max(float(end_frame), 1.0)
                heading = start_heading + (end_heading - start_heading) * alpha
                root_constraint.add_keyframe(
                    keyframe_id=f"root_turn_{int(round(degrees))}deg_{'cw' if clockwise else 'ccw'}_{frame_idx}",
                    frame_idx=frame_idx,
                    root_pos=torch.tensor(start, dtype=torch.float32),
                    global_root_heading=float(heading),
                    viz_label=frame_idx in {0, end_frame},
                    exists_ok=True,
                    update_path=False,
                    add_annulus=frame_idx in {0, end_frame},
                )

            root_constraint.set_dense_path(True)
            root_constraint.update_line_segments()
            self.add_interval_to_timeline(client_id, "2D Root", 0, end_frame, f"root_turn_{end_frame}")

            if hasattr(client, "timeline"):
                client.timeline.set_frame_range(
                    start_frame=0,
                    end_frame=max(total_frames + TIMELINE_WINDOW_BEFORE, TIMELINE_WINDOW_AFTER),
                )

            session.task_end_frame_idx = end_frame
            session.task_generation_pending = True
            session.task_reached_reported = False
            session.ref_joints_pos = None
            session.ref_joints_rot = None
            if session.ref_character is not None:
                session.ref_character.clear()
                session.ref_character = None

            prompt = "A person turns in place."
            text_feat, _ = session.model.text_encoder([prompt])
            session.text_embedding = text_feat.to(self.device)
            session.gui_elements.gui_prompt_text.value = prompt
            session.gui_elements.gui_active_prompt_label.content = (
                f"**Active Prompt:** {prompt} + {degrees:.0f} deg "
                f"{'clockwise' if clockwise else 'counterclockwise'} root constraint"
            )

            progress.body = f"Generating {degrees:.0f} deg in-place root turn..."
            client.flush()
            self.restart(client_id)
            self.set_frame(client_id, 0)

            progress.title = "Root Rotation Applied"
            progress.body = (
                f"Root constrained to turn {degrees:.0f} deg "
                f"{'clockwise' if clockwise else 'counterclockwise'} over "
                f"{total_frames / float(session.model_fps):.1f}s with {len(waypoint_indices)} dense heading waypoints."
            )
            progress.color = "green"
        except Exception as e:
            progress.title = "Root Rotation Failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 6.0

    def apply_forward_left_forward_constraint(
        self,
        client_id: int,
        first_distance_m: float = 2.5,
        turn_degrees: float = 90.0,
        second_distance_m: float = 2.0,
    ):
        """Constrain the root to go forward, turn left, then continue forward."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        if "2D Root" not in session.constraints:
            client.add_notification(
                title="No 2D Root Track",
                body="The active model does not provide root path constraints.",
                color="red",
                auto_close_seconds=4.0,
            )
            return

        progress = client.add_notification(
            title="Forward Left Forward Constraint",
            body="Installing rack-style straight-turn-straight root path...",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            first_distance_m = max(0.01, float(first_distance_m))
            second_distance_m = max(0.01, float(second_distance_m))
            turn_degrees = max(1.0, min(abs(float(turn_degrees)), 360.0))

            fps = float(session.model_fps)
            walk_speed_m_s = 0.60
            turn_seconds_per_90 = 0.75
            first_frames = max(2, int(round(first_distance_m / walk_speed_m_s * fps)))
            turn_frames = max(2, int(round(turn_seconds_per_90 * fps * turn_degrees / 90.0)))
            second_frames = max(2, int(round(second_distance_m / walk_speed_m_s * fps)))
            route_end_frame = first_frames + turn_frames + second_frames
            total_frames = route_end_frame + 1
            end_frame = route_end_frame

            start = (
                np.asarray(session.init_global_translation, dtype=np.float32).copy()
                if session.init_global_translation is not None
                else np.zeros(3, dtype=np.float32)
            )
            start[1] = 0.0
            start_heading = float(session.init_first_heading_angle or 0.0)
            end_heading = start_heading + math.radians(turn_degrees)

            start_forward = np.array([math.sin(start_heading), 0.0, math.cos(start_heading)], dtype=np.float32)
            end_forward = np.array([math.sin(end_heading), 0.0, math.cos(end_heading)], dtype=np.float32)
            turn_position = start + start_forward * first_distance_m
            turn_position[1] = 0.0
            end_position = turn_position + end_forward * second_distance_m
            end_position[1] = 0.0

            session.playing = False
            session.play_once = False
            session.realtime_mode = False
            session.gui_elements.gui_play_pause_button.label = "Play"
            session.gui_elements.gui_realtime_mode_checkbox.value = False
            session.gui_elements.gui_next_frame_button.disabled = False
            session.gui_elements.gui_prev_frame_button.disabled = True
            session.gui_elements.gui_enable_auto_replan_checkbox.value = False
            session.gui_elements.gui_enable_auto_replan_checkbox.disabled = True

            session.init_global_translation = start.astype(np.float32)
            session.init_first_heading_angle = start_heading
            session.t3_base_route_positions = None
            session.t3_base_route_headings = None
            if session.transform_gizmo is not None:
                session.transform_gizmo.position = tuple(session.init_global_translation.tolist())
                session.transform_gizmo.wxyz = viser.transforms.SO3.from_y_radians(start_heading).wxyz
            self._update_start_direction_marker(client_id)

            with session.timeline_data["keyframe_update_lock"]:
                for constraint in list(session.constraints.values()):
                    constraint.clear()
                if hasattr(client, "timeline"):
                    client.timeline.clear_keyframes()
                    client.timeline.clear_intervals()
                session.timeline_data["keyframes"].clear()
                session.timeline_data["intervals"].clear()

            root_constraint = session.constraints["2D Root"]
            root_constraint.set_smooth_path(False)
            root_constraint.set_dense_path(False)

            first_end_frame = first_frames
            turn_end_frame = first_frames + turn_frames
            waypoint_indices = (0, first_end_frame, turn_end_frame, route_end_frame)
            for frame_idx in waypoint_indices:
                if frame_idx <= first_end_frame:
                    alpha = frame_idx / max(float(first_end_frame), 1.0)
                    position = start + (turn_position - start) * alpha
                    heading = start_heading
                elif frame_idx <= turn_end_frame:
                    alpha = (frame_idx - first_end_frame) / max(float(turn_frames), 1.0)
                    heading = start_heading + (end_heading - start_heading) * alpha
                    position = turn_position
                else:
                    alpha = (frame_idx - turn_end_frame) / max(float(second_frames), 1.0)
                    position = turn_position + (end_position - turn_position) * alpha
                    heading = end_heading

                root_constraint.add_keyframe(
                    keyframe_id=f"root_forward_left_forward_{frame_idx}",
                    frame_idx=frame_idx,
                    root_pos=torch.tensor(position, dtype=torch.float32),
                    global_root_heading=float(heading),
                    viz_label=frame_idx in {0, first_end_frame, turn_end_frame, end_frame},
                    exists_ok=True,
                    update_path=False,
                    add_annulus=frame_idx in {0, first_end_frame, turn_end_frame, end_frame},
                )

            session.ref_joints_pos = None
            session.ref_joints_rot = None
            if session.ref_character is not None:
                session.ref_character.clear()
                session.ref_character = None
            session.pending_say_hi_after_task = True
            session.pending_say_hi_root_position = end_position.astype(np.float32)
            session.pending_say_hi_heading = float(end_heading)

            root_constraint.set_dense_path(True)
            root_constraint.update_line_segments()
            self.add_interval_to_timeline(client_id, "2D Root", 0, route_end_frame, "root_forward_left_forward")

            if hasattr(client, "timeline"):
                client.timeline.set_frame_range(
                    start_frame=0,
                    end_frame=max(route_end_frame + TIMELINE_WINDOW_BEFORE, TIMELINE_WINDOW_AFTER),
                )

            session.task_end_frame_idx = route_end_frame
            session.task_generation_pending = True
            session.task_reached_reported = False

            prompt = RACK_ROUTE_WALKING_PROMPT
            text_feat, _ = session.model.text_encoder([prompt])
            session.text_embedding = text_feat.to(self.device)
            session.gui_elements.gui_prompt_text.value = prompt
            session.gui_elements.gui_active_prompt_label.content = (
                f"**Active Prompt:** {prompt} + {first_distance_m * 100.0:.0f} cm forward, "
                f"{turn_degrees:.0f} deg left, {second_distance_m * 100.0:.0f} cm forward"
            )

            progress.body = "Generating rack-style straight-left-straight motion..."
            client.flush()
            self.restart(client_id)
            self.set_frame(client_id, 0)

            progress.title = "Forward Left Forward Applied"
            progress.body = (
                f"{first_distance_m * 100.0:.0f} cm forward, {turn_degrees:.0f} deg left, "
                f"{second_distance_m * 100.0:.0f} cm forward over {(route_end_frame + 1) / fps:.1f}s "
                f"with {len(waypoint_indices)} route waypoints. Say-hi BVH will start after completion."
            )
            progress.color = "green"
        except Exception as e:
            progress.title = "Forward Left Forward Failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 6.0

    def apply_rack_route(
        self,
        client_id: int,
        rack_name: str,
        return_to_origin: bool = False,
        source_rack_name: str | None = None,
    ):
        """Apply a dense rack route and regenerate the visible human motion."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        if session.model is None or session.motion_rep is None:
            client.add_notification(
                title="No model loaded",
                body="Please wait for the model to finish loading.",
                color="red",
                auto_close_seconds=3.0,
            )
            return

        fps = float(session.model_fps)
        try:
            if source_rack_name is not None:
                total_frames = rack_to_rack_auto_frame_count(source_rack_name, rack_name, fps=fps)
                route = plan_rack_to_rack_route(
                    source_rack_name,
                    rack_name,
                    total_frames=total_frames,
                    fps=fps,
                )
            elif return_to_origin:
                total_frames = rack_return_auto_frame_count(rack_name, fps=fps)
                route = plan_rack_return_route(rack_name, total_frames=total_frames, fps=fps)
            else:
                total_frames = rack_route_auto_frame_count(rack_name, fps=fps)
                route = plan_rack_route(rack_name, total_frames=total_frames, fps=fps)
        except Exception as e:
            client.add_notification(
                title="Rack route failed",
                body=str(e),
                color="red",
                auto_close_seconds=5.0,
            )
            return

        route_label = "rack-to-rack route" if source_rack_name is not None else "return route" if return_to_origin else "route"
        progress = client.add_notification(
            title=f"{route.rack_name.replace('_', ' ').title()} {route_label}",
            body="Encoding cached walking motion guidance...",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            session.playing = False
            session.play_once = False
            session.realtime_mode = False
            session.gui_elements.gui_play_pause_button.label = "Play"
            session.gui_elements.gui_realtime_mode_checkbox.value = False
            session.gui_elements.gui_next_frame_button.disabled = False
            session.gui_elements.gui_prev_frame_button.disabled = True
            session.gui_elements.gui_enable_auto_replan_checkbox.value = False
            session.gui_elements.gui_enable_auto_replan_checkbox.disabled = True

            # Outbound starts at origin. Return starts at the selected rack's
            # approach pose and heading, then turns in place before walking.
            session.init_global_translation = np.asarray(route.positions[0], dtype=np.float32)
            session.init_first_heading_angle = float(route.headings[0])
            session.t3_base_route_positions = np.asarray(route.positions, dtype=np.float32)
            session.t3_base_route_headings = np.asarray(route.headings, dtype=np.float32)
            if session.transform_gizmo is not None:
                session.transform_gizmo.position = tuple(session.init_global_translation.tolist())
                session.transform_gizmo.wxyz = viser.transforms.SO3.from_y_radians(
                    session.init_first_heading_angle
                ).wxyz
            self._update_start_direction_marker(client_id)

            # Clear existing constraints and timeline markers before installing
            # the route. This keeps "go to rack N" deterministic every time.
            with session.timeline_data["keyframe_update_lock"]:
                for constraint in list(session.constraints.values()):
                    constraint.clear()
                if hasattr(client, "timeline"):
                    client.timeline.clear_keyframes()
                    client.timeline.clear_intervals()
                session.timeline_data["keyframes"].clear()
                session.timeline_data["intervals"].clear()

            root_constraint = session.constraints.get("2D Root")
            if root_constraint is None:
                raise RuntimeError("The active model does not provide a 2D Root constraint track.")

            root_constraint.set_smooth_path(False)
            root_constraint.set_dense_path(False)
            positions = np.asarray(route.positions, dtype=np.float32)
            for frame_idx in route.waypoint_indices:
                position = positions[frame_idx]
                heading = route.headings[frame_idx]
                root_constraint.add_keyframe(
                    keyframe_id=(
                        f"rack_{'to_rack' if source_rack_name is not None else 'return' if return_to_origin else 'outbound'}"
                        f"_{route.rack_name}_{frame_idx}"
                    ),
                    frame_idx=frame_idx,
                    root_pos=position,
                    global_root_heading=float(heading),
                    viz_label=True,
                    update_path=False,
                    exists_ok=True,
                    add_annulus=True,
                )
            root_constraint.set_dense_path(True)
            root_constraint.update_line_segments()
            self.add_interval_to_timeline(
                client_id,
                "2D Root",
                0,
                total_frames - 1,
                f"rack_{'to_rack' if source_rack_name is not None else 'return' if return_to_origin else 'outbound'}_{route.rack_name}",
            )

            if hasattr(client, "timeline"):
                client.timeline.set_frame_range(
                    start_frame=0,
                    end_frame=max(total_frames + TIMELINE_WINDOW_BEFORE, TIMELINE_WINDOW_AFTER),
                )

            session.task_end_frame_idx = total_frames - 1
            session.task_generation_pending = True
            session.task_reached_reported = False
            session.ref_joints_pos = None
            session.ref_joints_rot = None
            if session.ref_character is not None:
                session.ref_character.clear()
                session.ref_character = None

            # Use the cached walking embedding for natural gait while sparse
            # root/heading waypoints decide the route and final facing.
            text_feat, _ = session.model.text_encoder([RACK_ROUTE_WALKING_PROMPT])
            session.text_embedding = text_feat.to(self.device)
            session.gui_elements.gui_prompt_text.value = RACK_ROUTE_WALKING_PROMPT
            session.gui_elements.gui_active_prompt_label.content = (
                f"**Active Prompt:** {RACK_ROUTE_WALKING_PROMPT} + rack constraints"
            )

            progress.body = "Generating origin-to-rack motion..."
            client.flush()
            self.restart(client_id, preserve_t3_base_route=True)
            self.set_frame(client_id, 0)

            progress.title = f"{route.rack_name.replace('_', ' ').title()} {route_label} applied"
            progress.body = (
                f"Stop point X {route.positions[-1][0]:.2f}, Z {route.positions[-1][2]:.2f}; "
                f"heading {np.rad2deg(route.final_heading):.1f} deg; "
                f"{total_frames / fps:.1f}s auto duration; turns {route.turn_degrees}; "
                f"{len(route.waypoint_indices)} visible Root2D waypoints; "
                "no planned backwalk over 0.20 m."
            )
            progress.color = "green"
        except Exception as e:
            progress.title = "Rack route failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 6.0

    def _smooth_pick_path(
        self,
        total_frames: int,
        waypoints: list[tuple[int, np.ndarray]],
    ) -> np.ndarray:
        """Smoothstep interpolation through hand waypoints."""
        ordered = sorted((int(frame), np.asarray(point, dtype=np.float32)) for frame, point in waypoints)
        path = np.empty((total_frames, 3), dtype=np.float32)
        for (start_frame, start), (end_frame, end) in zip(ordered[:-1], ordered[1:]):
            span = max(1, end_frame - start_frame)
            for frame in range(start_frame, end_frame + 1):
                alpha = (frame - start_frame) / span
                alpha = alpha * alpha * (3.0 - 2.0 * alpha)
                path[frame] = start + alpha * (end - start)
        return path

    def _rotation_between_vectors(self, source: np.ndarray, target: np.ndarray) -> np.ndarray:
        source = np.asarray(source, dtype=np.float64)
        target = np.asarray(target, dtype=np.float64)
        source /= max(float(np.linalg.norm(source)), 1e-9)
        target /= max(float(np.linalg.norm(target)), 1e-9)
        cross = np.cross(source, target)
        dot = float(np.clip(np.dot(source, target), -1.0, 1.0))
        sine = float(np.linalg.norm(cross))
        if sine < 1e-8:
            if dot > 0.0:
                return np.eye(3, dtype=np.float64)
            seed = np.array([1.0, 0.0, 0.0], dtype=np.float64)
            if abs(source[0]) > 0.8:
                seed = np.array([0.0, 1.0, 0.0], dtype=np.float64)
            axis = np.cross(source, seed)
            axis /= max(float(np.linalg.norm(axis)), 1e-9)
            return 2.0 * np.outer(axis, axis) - np.eye(3, dtype=np.float64)
        axis = cross / sine
        skew = np.array(
            [[0.0, -axis[2], axis[1]], [axis[2], 0.0, -axis[0]], [-axis[1], axis[0], 0.0]],
            dtype=np.float64,
        )
        return np.eye(3, dtype=np.float64) + sine * skew + (1.0 - dot) * (skew @ skew)

    def _arm_chain_indices(self, skeleton, side: str) -> tuple[int, int, int, list[int]]:
        names = skeleton.bone_order_names
        if side == "right":
            candidates = [
                ("RightArm", "RightForeArm", "RightHand", skeleton.right_hand_joint_names),
                (
                    "right_shoulder_yaw_skel",
                    "right_elbow_skel",
                    "right_wrist_yaw_skel",
                    skeleton.right_hand_joint_names,
                ),
            ]
        else:
            candidates = [
                ("LeftArm", "LeftForeArm", "LeftHand", skeleton.left_hand_joint_names),
                (
                    "left_shoulder_yaw_skel",
                    "left_elbow_skel",
                    "left_wrist_yaw_skel",
                    skeleton.left_hand_joint_names,
                ),
            ]
        for shoulder_name, elbow_name, wrist_name, hand_names in candidates:
            if shoulder_name in names and elbow_name in names and wrist_name in names:
                return (
                    names.index(shoulder_name),
                    names.index(elbow_name),
                    names.index(wrist_name),
                    [names.index(name) for name in hand_names if name in names],
                )
        raise RuntimeError(f"Could not find a {side} arm chain for skeleton {getattr(skeleton, 'name', 'unknown')}.")

    def _upright_standing_pose_at(
        self,
        skeleton,
        root_xz: np.ndarray,
        heading: float,
    ) -> tuple[np.ndarray, np.ndarray]:
        """Build a clean upright standing pose with relaxed arms by the sides."""
        neutral = skeleton.neutral_joints.detach().cpu().numpy().astype(np.float64).copy()
        neutral[:, 1] -= float(neutral[:, 1].min())
        root_idx = skeleton.root_idx

        def chain_from_to(start_idx: int, end_idx: int) -> list[int]:
            chain = [end_idx]
            current = end_idx
            while current != start_idx:
                parent = int(skeleton.joint_parents[current].item())
                if parent < 0:
                    return []
                chain.append(parent)
                current = parent
            return list(reversed(chain))

        for side in ("left", "right"):
            try:
                shoulder_idx, _elbow_idx, wrist_idx, hand_indices = self._arm_chain_indices(skeleton, side)
            except RuntimeError:
                continue

            chain = chain_from_to(shoulder_idx, wrist_idx)
            if len(chain) < 2:
                continue

            segment_lengths = [
                float(np.linalg.norm(neutral[b] - neutral[a]))
                for a, b in zip(chain[:-1], chain[1:])
            ]
            chain_length = sum(segment_lengths)
            if chain_length <= 1e-6:
                continue

            shoulder = neutral[shoulder_idx].copy()
            lateral_sign = 1.0 if shoulder[0] >= neutral[root_idx, 0] else -1.0
            cumulative = 0.0
            for idx, segment_length in zip(chain[1:], segment_lengths):
                cumulative += segment_length
                ratio = cumulative / chain_length
                neutral[idx] = shoulder + np.array(
                    [
                        lateral_sign * 0.10 * ratio,
                        -0.92 * chain_length * ratio,
                        0.06 * ratio + 0.04 * math.sin(math.pi * ratio),
                    ],
                    dtype=np.float64,
                )

            wrist_delta = neutral[wrist_idx] - (skeleton.neutral_joints[wrist_idx].detach().cpu().numpy())
            for hand_idx in hand_indices:
                if hand_idx != wrist_idx:
                    neutral[hand_idx] = skeleton.neutral_joints[hand_idx].detach().cpu().numpy() + wrist_delta

        neutral[:, 1] -= float(neutral[:, 1].min())
        root_local = neutral[root_idx].copy()
        root_world = root_local.copy()
        root_world[0] = float(root_xz[0])
        root_world[2] = float(root_xz[1])

        yaw = float(heading)
        cos_yaw = math.cos(yaw)
        sin_yaw = math.sin(yaw)
        yaw_rot = np.array(
            [
                [cos_yaw, 0.0, sin_yaw],
                [0.0, 1.0, 0.0],
                [-sin_yaw, 0.0, cos_yaw],
            ],
            dtype=np.float64,
        )
        offsets = neutral - root_local
        positions = root_world[None, :] + np.einsum("ij,nj->ni", yaw_rot, offsets)
        rotations = np.repeat(yaw_rot[None, :, :], skeleton.nbjoints, axis=0)
        return positions.astype(np.float32), rotations.astype(np.float32)

    def _straight_back_pose_from_motion(
        self,
        skeleton,
        positions: np.ndarray,
        rotations: np.ndarray,
        heading: float,
    ) -> tuple[np.ndarray, np.ndarray]:
        """Straighten the torso/head while preserving generated limb poses."""
        names = skeleton.bone_order_names
        root_idx = skeleton.root_idx
        cleaned_rotations = np.asarray(rotations, dtype=np.float64).copy()

        yaw = float(heading)
        cos_yaw = math.cos(yaw)
        sin_yaw = math.sin(yaw)
        yaw_rot = np.array(
            [
                [cos_yaw, 0.0, sin_yaw],
                [0.0, 1.0, 0.0],
                [-sin_yaw, 0.0, cos_yaw],
            ],
            dtype=np.float64,
        )

        back_names = {
            "Hips",
            "Spine",
            "Spine1",
            "Spine2",
            "Spine3",
            "Chest",
            "Neck",
            "Neck1",
            "Neck2",
            "Head",
            "HeadEnd",
        }
        for name in back_names:
            if name in names:
                cleaned_rotations[names.index(name)] = yaw_rot

        device = skeleton.neutral_joints.device
        dtype = skeleton.neutral_joints.dtype
        global_rot_tensor = torch.as_tensor(cleaned_rotations, device=device, dtype=dtype)
        local_rot_tensor = skeleton.global_rots_to_local_rots(global_rot_tensor)
        root_position = torch.as_tensor(
            np.asarray(positions, dtype=np.float64)[root_idx],
            device=device,
            dtype=dtype,
        )[None]
        solved_global, solved_positions, _ = skeleton.fk(local_rot_tensor[None], root_position)
        grounded_positions, grounded_root = ground_motion_to_floor(
            skeleton,
            solved_positions[None],
            root_position[None],
        )
        solved_global, solved_positions, _ = skeleton.fk(local_rot_tensor[None], grounded_root[0])
        return (
            solved_positions[0].detach().cpu().numpy().astype(np.float32),
            solved_global[0].detach().cpu().numpy().astype(np.float32),
        )

    def _lock_pick_motion_to_standing_arm_only(
        self,
        session,
        base_positions: np.ndarray,
        base_rotations: np.ndarray,
        hand_path: np.ndarray,
        side: str,
        target_palm_normals: np.ndarray | None = None,
        palm_normal_local: np.ndarray | None = None,
        target_hand_rotations: np.ndarray | None = None,
        grasp_frame: int | None = None,
        lift_frame: int | None = None,
        chest_frame: int | None = None,
        object_position: np.ndarray | None = None,
        correction_start_frame: int | None = None,
        correction_attempts: int = 2,
    ) -> float | None:
        """Freeze the whole body and solve only the selected arm to the pick path."""
        if session.joints_pos is None or session.joints_rot is None:
            return None
        skeleton = session.motion_rep.skeleton
        generated_frames = int(session.joints_pos.shape[1])
        if generated_frames > len(hand_path):
            tail = np.repeat(np.asarray(hand_path[-1], dtype=np.float32)[None, :], generated_frames - len(hand_path), axis=0)
            hand_path = np.concatenate([np.asarray(hand_path, dtype=np.float32), tail], axis=0)
        total_frames = min(generated_frames, int(len(hand_path)))
        if total_frames <= 0:
            return None

        shoulder_idx, elbow_idx, wrist_idx, hand_indices = self._arm_chain_indices(skeleton, side)
        hand_label = "Left" if side == "left" else "Right"
        middle_name = (
            f"{hand_label}HandMiddleEnd"
            if f"{hand_label}HandMiddleEnd" in skeleton.bone_order_names
            else (
                skeleton.left_hand_joint_names[-1]
                if side == "left"
                else skeleton.right_hand_joint_names[-1]
            )
        )
        middle_idx = skeleton.bone_order_names.index(middle_name) if middle_name in skeleton.bone_order_names else wrist_idx
        positions = np.repeat(np.asarray(base_positions, dtype=np.float64)[None, ...], total_frames, axis=0)
        global_rotations = np.repeat(np.asarray(base_rotations, dtype=np.float64)[None, ...], total_frames, axis=0)
        base_upper = positions[0, elbow_idx] - positions[0, shoulder_idx]
        base_lower = positions[0, wrist_idx] - positions[0, elbow_idx]
        upper_len = float(np.linalg.norm(base_upper))
        lower_len = float(np.linalg.norm(base_lower))
        base_bend = base_upper - np.dot(base_upper, base_lower) * base_lower / max(float(np.dot(base_lower, base_lower)), 1e-9)
        if np.linalg.norm(base_bend) < 1e-6:
            base_bend = np.array([0.0, -1.0, 0.0], dtype=np.float64)

        for frame in range(total_frames):
            shoulder = positions[frame, shoulder_idx]
            elbow = positions[frame, elbow_idx]
            wrist = positions[frame, wrist_idx]
            target = np.asarray(hand_path[frame], dtype=np.float64)
            shoulder_to_target = target - shoulder
            distance = float(np.linalg.norm(shoulder_to_target))
            if upper_len < 1e-6 or lower_len < 1e-6 or distance < 1e-6:
                continue
            distance = min(distance, upper_len + lower_len - 1e-4)
            distance = max(distance, abs(upper_len - lower_len) + 1e-4)
            direction = shoulder_to_target / max(float(np.linalg.norm(shoulder_to_target)), 1e-9)
            along = (upper_len**2 - lower_len**2 + distance**2) / (2.0 * distance)
            height = np.sqrt(max(upper_len**2 - along**2, 0.0))
            bend = base_bend - np.dot(base_bend, direction) * direction
            if np.linalg.norm(bend) < 1e-6:
                bend = elbow - (shoulder + np.dot(elbow - shoulder, direction) * direction)
            if np.linalg.norm(bend) < 1e-6:
                bend = np.cross(direction, np.array([0.0, 1.0, 0.0], dtype=np.float64))
            if np.linalg.norm(bend) < 1e-6:
                bend = np.cross(direction, np.array([1.0, 0.0, 0.0], dtype=np.float64))
            bend /= max(float(np.linalg.norm(bend)), 1e-9)

            solved_elbow = shoulder + along * direction + height * bend
            solved_wrist = shoulder + distance * direction
            upper_delta = self._rotation_between_vectors(elbow - shoulder, solved_elbow - shoulder)
            lower_delta = self._rotation_between_vectors(wrist - elbow, solved_wrist - solved_elbow)
            global_rotations[frame, shoulder_idx] = upper_delta @ global_rotations[frame, shoulder_idx]
            global_rotations[frame, elbow_idx] = lower_delta @ global_rotations[frame, elbow_idx]
            for hand_idx in hand_indices:
                global_rotations[frame, hand_idx] = lower_delta @ global_rotations[frame, hand_idx]
            if target_palm_normals is not None and palm_normal_local is not None:
                forearm_axis = solved_wrist - solved_elbow
                forearm_axis /= max(float(np.linalg.norm(forearm_axis)), 1e-9)
                desired_palm = np.asarray(target_palm_normals[frame], dtype=np.float64)
                desired_palm = desired_palm - np.dot(desired_palm, forearm_axis) * forearm_axis
                current_palm = global_rotations[frame, wrist_idx] @ np.asarray(palm_normal_local, dtype=np.float64)
                current_palm = current_palm - np.dot(current_palm, forearm_axis) * forearm_axis
                if np.linalg.norm(desired_palm) >= 1e-6 and np.linalg.norm(current_palm) >= 1e-6:
                    desired_palm /= max(float(np.linalg.norm(desired_palm)), 1e-9)
                    current_palm /= max(float(np.linalg.norm(current_palm)), 1e-9)
                    roll_delta = self._rotation_between_vectors(current_palm, desired_palm)
                    global_rotations[frame, elbow_idx] = roll_delta @ global_rotations[frame, elbow_idx]
                    for hand_idx in hand_indices:
                        global_rotations[frame, hand_idx] = roll_delta @ global_rotations[frame, hand_idx]
            if target_hand_rotations is not None:
                desired_wrist = np.asarray(target_hand_rotations[frame], dtype=np.float64)
                if np.all(np.isfinite(desired_wrist)):
                    wrist_delta = desired_wrist @ global_rotations[frame, wrist_idx].T
                    for hand_idx in hand_indices:
                        global_rotations[frame, hand_idx] = wrist_delta @ global_rotations[frame, hand_idx]

        device = session.joints_pos.device
        dtype = session.joints_pos.dtype
        global_rot_tensor = torch.as_tensor(global_rotations, device=device, dtype=dtype)
        local_rot_tensor = skeleton.global_rots_to_local_rots(global_rot_tensor)
        root_positions = torch.as_tensor(
            np.repeat(base_positions[skeleton.root_idx][None, :], total_frames, axis=0),
            device=device,
            dtype=dtype,
        )
        solved_global, solved_positions, _ = skeleton.fk(local_rot_tensor, root_positions)
        with session.motion_tensor_lock:
            num_samples = int(session.joints_pos.shape[0])
            session.joints_pos[:, :total_frames] = solved_positions[None].expand(num_samples, -1, -1, -1)
            session.joints_rot[:, :total_frames] = solved_global[None].expand(num_samples, -1, -1, -1, -1)
            if session.root_velocities is not None:
                session.root_velocities[:, :total_frames] = 0.0

        final_error = None
        if grasp_frame is not None and object_position is not None:
            grasp_idx = max(0, min(int(grasp_frame), total_frames - 1))
            correction_start = (
                max(0, min(int(correction_start_frame), grasp_idx))
                if correction_start_frame is not None
                else 0
            )
            correction_lift = (
                max(grasp_idx, min(int(lift_frame), total_frames - 1))
                if lift_frame is not None
                else grasp_idx
            )
            correction_chest = (
                max(correction_lift + 1, min(int(chest_frame), total_frames - 1))
                if chest_frame is not None
                else min(total_frames - 1, correction_lift + max(1, grasp_idx - correction_start))
            )
            solved_np = solved_positions.detach().cpu().numpy()
            palm_at_grasp = 0.35 * solved_np[grasp_idx, wrist_idx] + 0.65 * solved_np[grasp_idx, middle_idx]
            target_object = np.asarray(object_position, dtype=np.float64)
            palm_correction = target_object - palm_at_grasp
            final_error = float(np.linalg.norm(palm_correction))
            if correction_attempts > 0 and final_error > 0.005:
                corrected_path = np.asarray(hand_path, dtype=np.float32).copy()
                for frame in range(correction_start, total_frames):
                    if frame <= grasp_idx:
                        alpha = (frame - correction_start) / max(float(grasp_idx - correction_start), 1.0)
                    elif frame <= correction_lift:
                        alpha = 1.0
                    elif frame < correction_chest:
                        alpha = 1.0 - (frame - correction_lift) / max(float(correction_chest - correction_lift), 1.0)
                    else:
                        alpha = 0.0
                    alpha = max(0.0, min(1.0, alpha))
                    alpha = alpha * alpha * (3.0 - 2.0 * alpha)
                    corrected_path[frame] += (palm_correction * alpha).astype(np.float32)
                return self._lock_pick_motion_to_standing_arm_only(
                    session,
                    base_positions,
                    base_rotations,
                    corrected_path,
                    side,
                    target_palm_normals=target_palm_normals,
                    palm_normal_local=palm_normal_local,
                    target_hand_rotations=target_hand_rotations,
                    grasp_frame=grasp_frame,
                    lift_frame=lift_frame,
                    chest_frame=chest_frame,
                    object_position=object_position,
                    correction_start_frame=correction_start_frame,
                    correction_attempts=correction_attempts - 1,
                )
        return final_error

    def apply_rack_pick(
        self,
        client_id: int,
        rack_name: str,
        shelf_number: int,
        object_index: int,
        hand_side: str | None = None,
    ):
        """Apply a constraints-only rack item pick from the current rack pose."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        if session.model is None or session.motion_rep is None:
            client.add_notification(
                title="No model loaded",
                body="Please wait for the model to finish loading.",
                color="red",
                auto_close_seconds=3.0,
            )
            return
        if session.joints_pos is None or session.joints_rot is None or session.max_frame_idx < 0:
            client.add_notification(
                title="Generate rack pose first",
                body="Use Go To Rack or Rack To Rack, then Pick Item.",
                color="orange",
                auto_close_seconds=5.0,
            )
            return

        fps = float(session.model_fps)
        try:
            total_frames = rack_pick_auto_frame_count(
                rack_name,
                shelf_number,
                object_index,
                fps=fps,
            )
            pick = plan_rack_pick(
                rack_name,
                shelf_number,
                object_index,
                total_frames=total_frames,
                fps=fps,
                hand_side=hand_side,
            )
        except Exception as e:
            client.add_notification(
                title="Rack pick failed",
                body=str(e),
                color="red",
                auto_close_seconds=5.0,
            )
            return

        if not session.rack_pick_lock.acquire(blocking=False):
            client.add_notification(
                title="Rack pick already running",
                body="Wait for the current pick motion to finish before starting another one.",
                color="yellow",
                auto_close_seconds=3.0,
            )
            return

        progress = client.add_notification(
            title=f"Pick item from {pick.rack_name.replace('_', ' ').title()}",
            body="Building hand and root constraints...",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            motion_last_frame = int(session.joints_pos.shape[1] - 1)
            route_end_frame = (
                int(session.task_end_frame_idx)
                if session.task_end_frame_idx is not None
                else session.max_frame_idx
            )
            base_frame_idx = min(max(0, route_end_frame), motion_last_frame, session.max_frame_idx)
            generated_positions = session.joints_pos[0, base_frame_idx].detach().cpu().numpy().astype(np.float32).copy()
            generated_rotations = session.joints_rot[0, base_frame_idx].detach().cpu().numpy().astype(np.float32).copy()
            skeleton = session.motion_rep.skeleton
            names = skeleton.bone_order_names
            root_idx = skeleton.root_idx

            approach = np.asarray(pick.approach_position, dtype=np.float32)
            current_root = generated_positions[root_idx]
            rack_distance = float(np.linalg.norm(current_root[[0, 2]] - approach[[0, 2]]))
            if rack_distance > 0.70:
                raise RuntimeError(
                    f"The current human is {rack_distance:.2f} m from the selected rack approach pose. "
                    "Generate the rack route first or select the rack where the human is standing."
                )
            generated_heading = float(
                math.atan2(generated_rotations[root_idx, 0, 2], generated_rotations[root_idx, 2, 2])
            )
            upright_positions, upright_rotations = self._straight_back_pose_from_motion(
                skeleton,
                generated_positions,
                generated_rotations,
                generated_heading,
            )
            base_positions_t = torch.as_tensor(upright_positions, dtype=torch.float32)[None, None]
            grounded_base_positions, _ = ground_motion_to_floor(
                skeleton,
                base_positions_t,
            )
            base_positions = grounded_base_positions[0, 0].cpu().numpy().astype(np.float32)
            base_rotations = upright_rotations.astype(np.float32)
            session.t3_base_route_positions = None
            session.t3_base_route_headings = None

            session.playing = False
            session.play_once = False
            session.realtime_mode = False
            session.gui_elements.gui_play_pause_button.label = "Play"
            session.gui_elements.gui_realtime_mode_checkbox.value = False
            session.gui_elements.gui_next_frame_button.disabled = False
            session.gui_elements.gui_prev_frame_button.disabled = True
            session.gui_elements.gui_enable_auto_replan_checkbox.value = False
            session.gui_elements.gui_enable_auto_replan_checkbox.disabled = True

            init_root = base_positions[root_idx].copy()
            init_root[1] = 0.0
            session.init_global_translation = init_root.astype(np.float32)
            session.init_first_heading_angle = generated_heading
            if session.transform_gizmo is not None:
                session.transform_gizmo.position = tuple(session.init_global_translation.tolist())
                session.transform_gizmo.wxyz = viser.transforms.SO3.from_y_radians(
                    session.init_first_heading_angle
                ).wxyz
            self._update_start_direction_marker(client_id)

            with session.timeline_data["keyframe_update_lock"]:
                for constraint in list(session.constraints.values()):
                    constraint.clear()
                if hasattr(client, "timeline"):
                    client.timeline.clear_keyframes()
                    client.timeline.clear_intervals()
                session.timeline_data["keyframes"].clear()
                session.timeline_data["intervals"].clear()

            stationary_root = np.repeat(init_root[None, :], total_frames, axis=0)
            stationary_root[:, 1] = 0.0

            hand_label = "Left" if pick.hand_side == "left" else "Right"
            hand_joint_names = (
                skeleton.left_hand_joint_names
                if pick.hand_side == "left"
                else skeleton.right_hand_joint_names
            )
            hand_indices = [names.index(name) for name in hand_joint_names]
            hand_root_idx = hand_indices[0]
            middle_name = (
                f"{hand_label}HandMiddleEnd"
                if f"{hand_label}HandMiddleEnd" in names
                else hand_joint_names[-1]
            )
            middle_idx = names.index(middle_name)
            wrist_start = base_positions[hand_root_idx]
            middle_start = base_positions[middle_idx]
            palm_from_wrist = (0.35 * wrist_start + 0.65 * middle_start) - wrist_start
            thumb_name = f"{hand_label}HandThumb1"
            thumb_idx = names.index(thumb_name) if thumb_name in names else None
            base_finger_direction = middle_start - wrist_start
            if thumb_idx is not None:
                base_thumb_direction = base_positions[thumb_idx] - wrist_start
                base_palm_normal_world = (
                    np.cross(base_finger_direction, base_thumb_direction)
                    if pick.hand_side == "left"
                    else np.cross(base_thumb_direction, base_finger_direction)
                )
            else:
                base_palm_normal_world = base_rotations[hand_root_idx][:, 1]
            if float(np.linalg.norm(base_palm_normal_world)) < 1e-6:
                base_palm_normal_world = base_rotations[hand_root_idx][:, 1]
            base_palm_normal_world = base_palm_normal_world / max(
                float(np.linalg.norm(base_palm_normal_world)),
                1e-9,
            )
            if float(np.dot(base_palm_normal_world, np.array([0.0, 1.0, 0.0]))) < 0.0:
                base_palm_normal_world = -base_palm_normal_world

            first_frame, pregrasp_frame, grasp_frame, lift_frame, chest_frame = pick.frame_indices
            diagonal_approach_frame = min(
                max(pregrasp_frame + 1, int(round((pregrasp_frame + grasp_frame) * 0.5))),
                grasp_frame - 1,
            )
            last_frame = total_frames - 1
            outward_normal = np.asarray(rack_outward_normal(pick.rack_name), dtype=np.float32)
            right_lateral = base_positions[names.index("RightShoulder")] - base_positions[names.index("LeftShoulder")]
            right_lateral[1] = 0.0
            right_lateral = right_lateral / max(float(np.linalg.norm(right_lateral)), 1e-9)
            active_lateral = right_lateral if pick.hand_side == "right" else -right_lateral
            object_position = np.asarray(pick.object_position, dtype=np.float32)

            grasp_clearance = 0.02
            pregrasp_clearance = 0.14
            diagonal_clearance = 0.07
            lateral_clearance = 0.12
            grasp_palm_target = object_position + grasp_clearance * outward_normal + np.array(
                [0.0, -0.01, 0.0],
                dtype=np.float32,
            )
            pregrasp_palm_target = (
                object_position
                + pregrasp_clearance * outward_normal
                + lateral_clearance * active_lateral
                + np.array([0.0, 0.05, 0.0], dtype=np.float32)
            )
            diagonal_palm_target = (
                object_position
                + diagonal_clearance * outward_normal
                + 0.5 * lateral_clearance * active_lateral
                + np.array([0.0, 0.025, 0.0], dtype=np.float32)
            )
            lift_palm_target = grasp_palm_target + np.array([0.0, 0.07, 0.0], dtype=np.float32)
            chest_joint_name = "Chest" if "Chest" in names else "Spine3" if "Spine3" in names else names[root_idx]
            chest_base = base_positions[names.index(chest_joint_name)]
            shoulder_mid = 0.5 * (
                base_positions[names.index("RightShoulder")]
                + base_positions[names.index("LeftShoulder")]
            )
            chest_hold_y = max(float(chest_base[1] - 0.06), float(shoulder_mid[1] - 0.22), 0.95)
            chest_target = (
                chest_base
                - 0.24 * outward_normal
                + 0.18 * active_lateral
                + np.array([0.0, chest_hold_y - float(chest_base[1]), 0.0], dtype=np.float32)
            )
            pregrasp_target = pregrasp_palm_target
            grasp_target = grasp_palm_target
            diagonal_target = diagonal_palm_target
            lift_target = lift_palm_target
            chest_wrist_target = chest_target

            rack_center = np.asarray(RACK_MAP_POSITIONS[pick.rack_name], dtype=np.float32)
            minimum_front_clearance = float(RACK_WIDTH_M / 2.0 + 0.045)
            min_grasp_clearance = float(RACK_WIDTH_M / 2.0 - 0.055)
            path_adjustment_cm = 0.0
            approach_waypoint_clearance = float(
                min(
                    np.dot(pregrasp_target - rack_center, outward_normal),
                    np.dot(diagonal_target - rack_center, outward_normal),
                )
            )
            if approach_waypoint_clearance < minimum_front_clearance:
                outward_shift = minimum_front_clearance - approach_waypoint_clearance + 0.01
                pregrasp_target = pregrasp_target + outward_shift * outward_normal
                diagonal_target = diagonal_target + outward_shift * outward_normal
                path_adjustment_cm = max(path_adjustment_cm, outward_shift * 100.0)

            grasp_waypoint_clearance = float(
                min(
                    np.dot(grasp_target - rack_center, outward_normal),
                    np.dot(lift_target - rack_center, outward_normal),
                )
            )
            if grasp_waypoint_clearance < min_grasp_clearance:
                outward_shift = min_grasp_clearance - grasp_waypoint_clearance + 0.005
                grasp_target = grasp_target + outward_shift * outward_normal
                lift_target = lift_target + outward_shift * outward_normal
                path_adjustment_cm = max(path_adjustment_cm, outward_shift * 100.0)

            hand_path = self._smooth_pick_path(
                total_frames,
                [
                    (first_frame, wrist_start),
                    (pregrasp_frame, pregrasp_target),
                    (diagonal_approach_frame, diagonal_target),
                    (grasp_frame, grasp_target),
                    (lift_frame, lift_target),
                    (chest_frame, chest_wrist_target),
                    (last_frame, chest_wrist_target),
                ],
            )
            front_clearance = (hand_path - rack_center[None, :]) @ outward_normal
            approach_clearance_value = float(front_clearance[pregrasp_frame : diagonal_approach_frame + 1].min())
            actual_grasp_clearance = float(front_clearance[grasp_frame : lift_frame + 1].min())

            target_palm_normals = self._smooth_pick_path(
                total_frames,
                [
                    (first_frame, base_palm_normal_world.astype(np.float32)),
                    (pregrasp_frame, base_palm_normal_world.astype(np.float32)),
                    (diagonal_approach_frame, base_palm_normal_world.astype(np.float32)),
                    (grasp_frame, base_palm_normal_world.astype(np.float32)),
                    (lift_frame, base_palm_normal_world.astype(np.float32)),
                    (chest_frame, base_palm_normal_world.astype(np.float32)),
                    (last_frame, base_palm_normal_world.astype(np.float32)),
                ],
            )
            target_palm_normals = target_palm_normals / np.maximum(
                np.linalg.norm(target_palm_normals, axis=1, keepdims=True),
                1e-9,
            )
            palm_normal_local = base_rotations[hand_root_idx].T @ base_palm_normal_world
            if hasattr(client, "timeline"):
                client.timeline.set_frame_range(
                    start_frame=0,
                    end_frame=max(total_frames + TIMELINE_WINDOW_BEFORE, TIMELINE_WINDOW_AFTER),
                )

            session.task_end_frame_idx = total_frames - 1
            session.task_generation_pending = True
            session.task_reached_reported = False
            session.ref_joints_pos = None
            session.ref_joints_rot = None
            if session.ref_character is not None:
                session.ref_character.clear()
                session.ref_character = None

            session.gui_elements.gui_prompt_text.value = RACK_PICK_CALM_PROMPT
            session.gui_elements.gui_active_prompt_label.content = (
                f"**Active Prompt:** {RACK_PICK_CALM_PROMPT} + procedural pick"
            )

            progress.body = f"Applying procedural pick from Go To Rack end frame {base_frame_idx}..."
            client.flush()
            with session.motion_tensor_lock:
                device = session.joints_pos.device
                dtype = session.joints_pos.dtype
                num_samples = int(session.joints_pos.shape[0])
                session.joints_pos = torch.as_tensor(base_positions, device=device, dtype=dtype)[None, None].repeat(
                    num_samples,
                    total_frames,
                    1,
                    1,
                )
                session.joints_rot = torch.as_tensor(base_rotations, device=device, dtype=dtype)[None, None].repeat(
                    num_samples,
                    total_frames,
                    1,
                    1,
                    1,
                )
                if session.foot_contacts is not None:
                    foot_frame = min(base_frame_idx, session.foot_contacts.shape[1] - 1)
                    session.foot_contacts = session.foot_contacts[:, foot_frame : foot_frame + 1].repeat(
                        1,
                        total_frames,
                        1,
                    )
                if session.root_velocities is not None:
                    session.root_velocities = torch.zeros(
                        (num_samples, total_frames, 3),
                        device=device,
                        dtype=dtype,
                    )
                if session.motion_tensor is not None:
                    session.motion_tensor = torch.zeros(
                        (num_samples, total_frames, session.motion_tensor.shape[-1]),
                        device=session.motion_tensor.device,
                        dtype=session.motion_tensor.dtype,
                    )
                session.max_frame_idx = total_frames - 1
                session.task_generation_pending = False
            session.gui_elements.gui_frame_idx_input.max = session.max_frame_idx
            palm_error = self._lock_pick_motion_to_standing_arm_only(
                session,
                base_positions,
                base_rotations,
                hand_path,
                pick.hand_side,
                target_palm_normals=target_palm_normals,
                palm_normal_local=palm_normal_local,
                grasp_frame=grasp_frame,
                lift_frame=lift_frame,
                chest_frame=chest_frame,
                object_position=np.asarray(pick.object_position, dtype=np.float32),
                correction_start_frame=pregrasp_frame,
            )
            self.set_frame(client_id, 0)

            progress.title = "Rack pick applied"
            palm_error_text = (
                f" Palm grasp error {palm_error * 100.0:.1f} cm."
                if palm_error is not None
                else ""
            )
            path_adjustment_text = (
                f" Auto clearance adjusted {path_adjustment_cm:.1f} cm."
                if path_adjustment_cm > 0.0
                else ""
            )
            progress.body = (
                f"{pick.hand_side.title()} hand: shelf {pick.shelf_number}, object {pick.object_index}; "
                f"started from Go To Rack end frame {base_frame_idx}; "
                f"pregrasp frame {pregrasp_frame}, diagonal approach {diagonal_approach_frame}, "
                f"grasp {grasp_frame}, lift {lift_frame}, "
                f"hold from {chest_frame}; {total_frames / fps:.1f}s auto duration. "
                "Path uses pregrasp 14 cm out, diagonal 7 cm out, grasp 2 cm out, lift 7 cm. "
                f"Clearance: approach {approach_clearance_value:.3f} m, grasp {actual_grasp_clearance:.3f} m. "
                "Body, hips, waist, head, and feet are locked to the standing rack pose. "
                f"{path_adjustment_text}"
                f"{palm_error_text}"
            )
            progress.color = "green"
        except Exception as e:
            progress.title = "Rack pick failed"
            progress.body = str(e)
            progress.color = "red"
            print(f"[Rack Pick] Failed: {e}")
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 7.0
            session.rack_pick_lock.release()

    def load_root_constraints(self, client_id: int, filepath: str = "root_constraints.json"):
        """Load root constraints from a JSON file."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        try:
            with open(filepath, "r") as f:
                data = json.load(f)

            # Clear existing 2D root constraints
            constraint = session.constraints["2D Root"]
            constraint.clear()

            data_type = data.get("type", "keyframes")  # Default to keyframes for backward compatibility

            if data_type == "dense_trajectory":
                # Load dense trajectory as interval
                trajectory = data.get("trajectory", {})
                if len(trajectory) == 0:
                    print("No trajectory data found")
                    return

                frame_indices = sorted([int(k) for k in trajectory.keys()])
                start_frame = frame_indices[0]
                end_frame = frame_indices[-1]

                # Collect all root positions
                root_positions = []
                for frame_idx in frame_indices:
                    pos_data = trajectory[str(frame_idx)]
                    root_pos = torch.tensor(pos_data, dtype=torch.float32)
                    root_positions.append(root_pos)

                root_pos_tensor = torch.stack(root_positions)

                # Add as interval
                interval_id = f"loaded_trajectory_{start_frame}_{end_frame}"
                constraint.add_interval(
                    interval_id=interval_id,
                    start_frame_idx=start_frame,
                    end_frame_idx=end_frame,
                    root_pos=root_pos_tensor,
                    add_annulus=False,
                )

                # Add to timeline GUI
                self.add_interval_to_timeline(client_id, "2D Root", start_frame, end_frame, interval_id)

                print(
                    f"Loaded dense trajectory with {len(frame_indices)} frames from {filepath} (frames {start_frame}-{end_frame})"
                )
            else:
                # Load keyframes
                keyframes = data.get("keyframes", {})
                for frame_idx, pos_data in keyframes.items():
                    frame_idx = int(frame_idx)
                    root_pos = torch.tensor(pos_data, dtype=torch.float32)
                    keyframe_id = f"loaded_waypoint_{frame_idx}"

                    constraint.add_keyframe(
                        keyframe_id=keyframe_id,
                        frame_idx=frame_idx,
                        root_pos=root_pos,
                        viz_label=True,
                        exists_ok=True,
                    )

                    # Add to timeline GUI
                    self.add_keyframe_to_timeline(client_id, "2D Root", frame_idx, keyframe_id)

                print(f"Loaded {len(keyframes)} root keyframes from {filepath}")

        except FileNotFoundError:
            print(f"File {filepath} not found")
        except Exception as e:
            print(f"Error loading root constraints: {e}")

    def save_root_constraints(self, client_id: int, filepath: str = "root_constraints.json"):
        """Save root constraints to a JSON file."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        constraint = session.constraints["2D Root"]

        # Check if dense path is enabled
        if constraint.dense_path and len(constraint.keyframes) > 0:
            # Export dense interpolated trajectory
            constraint_info = constraint.get_constraint_info()
            frame_indices = constraint_info["frame_idx"]
            root_positions = constraint_info["root_pos"]

            data = {"type": "dense_trajectory", "trajectory": {}}

            for i, frame_idx in enumerate(frame_indices):
                pos = root_positions[i]
                # root positions may be numpy arrays or tensors; normalize to a list.
                data["trajectory"][str(frame_idx)] = (
                    pos.detach().cpu().tolist() if isinstance(pos, torch.Tensor) else np.asarray(pos).tolist()
                )

            print(f"Saved dense trajectory with {len(frame_indices)} frames to {filepath}")
        else:
            # Export keyframes only
            data = {"type": "keyframes", "keyframes": {}}

            for frame_idx, root_pos in constraint.keyframes.items():
                # keyframes may hold numpy arrays (viz track) or tensors; normalize to a list.
                data["keyframes"][str(frame_idx)] = (
                    root_pos.detach().cpu().tolist()
                    if isinstance(root_pos, torch.Tensor)
                    else np.asarray(root_pos).tolist()
                )

            print(f"Saved {len(data['keyframes'])} root keyframes to {filepath}")

        # Save to file
        try:
            with open(filepath, "w") as f:
                json.dump(data, f, indent=2)
        except Exception as e:
            print(f"Error saving root constraints: {e}")

    def add_constraint_callback(
        self,
        client_id: int,
        constraint_id: str,
        constraint_type: str,
        frame_range: tuple[int, int],
        joint_names: list[str] = None,
        verbose: bool = True,
    ):
        """Add a constraint to the session."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        # Need to have at least one motion/character to add constraints
        with session.characters_lock:
            if len(session.characters) == 0:
                print("No characters available to add constraints!")
                return

            # Get motion data from first character
            character = list(session.characters.values())[0]

        end_effector_type = None
        if constraint_type == "End-Effectors":
            if joint_names is None or len(joint_names) == 0:
                print("No EE constraints selected! Couldn't add constraint.")
                return
            # Derive the type keys before appending Hips, which has no type of its own
            end_effector_type = {EE_JOINT_TO_TYPE[name] for name in joint_names if name in EE_JOINT_TO_TYPE}
            # Always include Hips for smoothed root
            joint_names = list(set(joint_names + ["Hips"]))

        is_interval = frame_range[1] != frame_range[0]
        start_frame_idx = int(frame_range[0])
        end_frame_idx = int(frame_range[1])

        # Validate interval
        if start_frame_idx < 0 or end_frame_idx < 0:
            print("Invalid interval! Couldn't add constraint.")
            return
        if end_frame_idx < start_frame_idx:
            print("Invalid interval! Couldn't add constraint.")
            return
        if session.joints_pos is None or session.joints_rot is None:
            print("No generated motion available to add constraint!")
            return
        motion_last_frame = int(session.joints_pos.shape[1] - 1)
        if start_frame_idx > motion_last_frame:
            print(
                f"Constraint frame {start_frame_idx} is outside the current motion "
                f"(last frame {motion_last_frame}). Couldn't add constraint."
            )
            if verbose:
                session.client.add_notification(
                    title="Constraint outside motion",
                    body=f"Frame {start_frame_idx} is past the current motion end frame {motion_last_frame}.",
                    auto_close_seconds=4.0,
                    color="orange",
                )
            return
        if end_frame_idx > motion_last_frame:
            print(
                f"Clamping constraint interval end from {end_frame_idx} to "
                f"current motion end {motion_last_frame}."
            )
            end_frame_idx = motion_last_frame
            is_interval = end_frame_idx != start_frame_idx

        # Collect constraint data
        if is_interval:
            constraint_kwargs = {
                "interval_id": constraint_id,
                "start_frame_idx": start_frame_idx,
                "end_frame_idx": end_frame_idx,
            }
        else:
            constraint_kwargs = {
                "keyframe_id": constraint_id,
                "frame_idx": start_frame_idx,
            }

        # Get joints data from current motion
        if constraint_type in ["Full-Body", "End-Effectors"]:
            if is_interval:
                joints_pos = session.joints_pos[0, start_frame_idx : end_frame_idx + 1]
                joints_rot = session.joints_rot[0, start_frame_idx : end_frame_idx + 1]
            else:
                joints_pos = session.joints_pos[0, start_frame_idx]
                joints_rot = session.joints_rot[0, start_frame_idx]

            constraint_kwargs["joints_pos"] = joints_pos
            constraint_kwargs["joints_rot"] = joints_rot
            if constraint_type == "End-Effectors":
                constraint_kwargs["joint_names"] = joint_names
                constraint_kwargs["end_effector_type"] = end_effector_type

        elif constraint_type == "2D Root":
            # Clone (slices are views into session.joints_pos) and drop the marker
            # to the ground: the 2D root viz expects y = 0, not pelvis height.
            if is_interval:
                root_pos = session.joints_pos[0, start_frame_idx : end_frame_idx + 1, 0, :].clone()
                root_pos[:, 1] = 0.0
            else:
                root_pos = session.joints_pos[0, start_frame_idx, 0, :].clone()
                root_pos[1] = 0.0
            constraint_kwargs["root_pos"] = root_pos

        # Add the constraint
        constraint = session.constraints[constraint_type]
        if is_interval:
            constraint.add_interval(**constraint_kwargs)
        else:
            constraint.add_keyframe(**constraint_kwargs)

        if verbose:
            session.client.add_notification(
                title="Constraint added",
                body="",
                auto_close_seconds=5.0,
                color="blue",
            )

    def remove_constraint_callback(
        self,
        client_id: int,
        constraint_id: str,
        constraint_type: str,
        frame_range: tuple[int, int],
        verbose: bool = True,
    ):
        """Remove a constraint from the session."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        is_interval = frame_range[1] != frame_range[0]
        start_frame_idx = int(frame_range[0])
        end_frame_idx = int(frame_range[1])

        constraint = session.constraints[constraint_type]
        if is_interval:
            constraint.remove_interval(constraint_id, start_frame_idx, end_frame_idx)
        else:
            constraint.remove_keyframe(constraint_id, start_frame_idx)

        if verbose:
            session.client.add_notification(
                title="Constraint removed",
                body="",
                auto_close_seconds=5.0,
                color="blue",
            )

    def clear_constraints(self, client_id: int):
        """Clear all constraints for a client."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client
        with session.timeline_data["keyframe_update_lock"]:
            for constraint in list(session.constraints.values()):
                constraint.clear()
            if hasattr(client, "timeline"):
                client.timeline.clear_keyframes()
                client.timeline.clear_intervals()

        # The reference motion is the ghost of a sampled constraint sequence, so
        # it belongs to the constraints — clear it alongside them.
        if session.ref_character is not None:
            session.ref_character.clear()
            session.ref_character = None
        session.ref_joints_pos = None
        session.ref_joints_rot = None
        session.task_end_frame_idx = None
        session.task_generation_pending = False
        session.task_reached_reported = False
        session.pending_say_hi_after_task = False
        session.pending_say_hi_root_position = None
        session.pending_say_hi_heading = None
        session.t3_base_route_positions = None
        session.t3_base_route_headings = None

        client.add_notification(
            title="Constraints cleared",
            body="All constraints have been removed.",
            auto_close_seconds=2.0,
            color="blue",
        )

    def clear_timeline_prompts(self, client_id: int):
        """Clear all text prompts from timeline."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        if session.timeline_data is not None and hasattr(client, "timeline"):
            prompt_uuid_list = session.timeline_data.get("prompt_uuid_list", [])
            for prompt_uuid in prompt_uuid_list:
                try:
                    client.timeline.remove_prompt(prompt_uuid)
                    print(f"Removed prompt '{prompt_uuid}' from timeline")
                except (AttributeError, Exception) as e:
                    print(f"Error removing prompt: {e}")

            # Clear the prompt list
            prompt_uuid_list.clear()
