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

            # Use the cached walking embedding for natural gait while the
            # dense root/heading constraints decide the route and final facing.
            text_feat, _ = session.model.text_encoder([RACK_ROUTE_WALKING_PROMPT])
            session.text_embedding = text_feat.to(self.device)
            session.gui_elements.gui_prompt_text.value = RACK_ROUTE_WALKING_PROMPT
            session.gui_elements.gui_active_prompt_label.content = (
                f"**Active Prompt:** {RACK_ROUTE_WALKING_PROMPT} + rack constraints"
            )

            progress.body = "Generating origin-to-rack motion..."
            client.flush()
            self.restart(client_id)
            self.set_frame(client_id, 0)

            progress.title = f"{route.rack_name.replace('_', ' ').title()} {route_label} applied"
            progress.body = (
                f"Stop point X {route.positions[-1][0]:.2f}, Z {route.positions[-1][2]:.2f}; "
                f"heading {np.rad2deg(route.final_heading):.1f} deg; "
                f"{total_frames / fps:.1f}s auto duration; turns {route.turn_degrees}; "
                f"{len(route.waypoint_indices)} visible Root2D waypoints; no planned backwalk over 0.20 m."
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
        """Build a clean upright standing pose from the skeleton neutral pose."""
        neutral = skeleton.neutral_joints.detach().cpu().numpy().astype(np.float64).copy()
        neutral[:, 1] -= float(neutral[:, 1].min())
        root_idx = skeleton.root_idx
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
    ) -> None:
        """Freeze the whole body and solve only the selected arm to the pick path."""
        if session.joints_pos is None or session.joints_rot is None:
            return
        skeleton = session.motion_rep.skeleton
        generated_frames = int(session.joints_pos.shape[1])
        if generated_frames > len(hand_path):
            tail = np.repeat(np.asarray(hand_path[-1], dtype=np.float32)[None, :], generated_frames - len(hand_path), axis=0)
            hand_path = np.concatenate([np.asarray(hand_path, dtype=np.float32), tail], axis=0)
        total_frames = min(generated_frames, int(len(hand_path)))
        if total_frames <= 0:
            return

        shoulder_idx, elbow_idx, wrist_idx, hand_indices = self._arm_chain_indices(skeleton, side)
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

    def apply_rack_pick(
        self,
        client_id: int,
        rack_name: str,
        shelf_number: int,
        object_index: int,
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
            )
        except Exception as e:
            client.add_notification(
                title="Rack pick failed",
                body=str(e),
                color="red",
                auto_close_seconds=5.0,
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
            base_frame_idx = min(max(0, session.frame_idx), session.max_frame_idx)
            if base_frame_idx < session.max_frame_idx:
                base_frame_idx = session.max_frame_idx
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
            base_positions = generated_positions
            base_rotations = generated_rotations

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
            session.init_first_heading_angle = float(pick.rack_facing_heading)
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
            diagonal_frame = min(max(pregrasp_frame + 1, int(round((pregrasp_frame + grasp_frame) * 0.5))), grasp_frame - 1)
            last_frame = total_frames - 1
            pregrasp_target = np.asarray(pick.pregrasp_position, dtype=np.float32) - palm_from_wrist
            grasp_target = np.asarray(pick.grasp_position, dtype=np.float32) - palm_from_wrist
            diagonal_target = 0.55 * pregrasp_target + 0.45 * grasp_target
            diagonal_target[1] += 0.03
            hand_path = self._smooth_pick_path(
                total_frames,
                [
                    (first_frame, wrist_start),
                    (pregrasp_frame, pregrasp_target),
                    (diagonal_frame, diagonal_target),
                    (grasp_frame, grasp_target),
                    (lift_frame, np.asarray(pick.lift_position, dtype=np.float32) - palm_from_wrist),
                    (chest_frame, np.asarray(pick.chest_hold_position, dtype=np.float32) - palm_from_wrist),
                    (last_frame, np.asarray(pick.chest_hold_position, dtype=np.float32) - palm_from_wrist),
                ],
            )
            # For this hand rig the computed palm normal points out of the back
            # side of the hand, so aim it upward to make the visible palm face
            # the ground.
            desired_palm_normal_world = np.array([0.0, 1.0, 0.0], dtype=np.float32)
            target_palm_normals = self._smooth_pick_path(
                total_frames,
                [
                    (first_frame, base_palm_normal_world.astype(np.float32)),
                    (pregrasp_frame, desired_palm_normal_world),
                    (diagonal_frame, desired_palm_normal_world),
                    (grasp_frame, desired_palm_normal_world),
                    (lift_frame, desired_palm_normal_world),
                    (chest_frame, desired_palm_normal_world),
                    (last_frame, desired_palm_normal_world),
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

            progress.body = "Applying procedural pick from the previous rack frame..."
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
            self._lock_pick_motion_to_standing_arm_only(
                session,
                base_positions,
                base_rotations,
                hand_path,
                pick.hand_side,
                target_palm_normals=target_palm_normals,
                palm_normal_local=palm_normal_local,
            )
            self.set_frame(client_id, 0)

            progress.title = "Rack pick applied"
            progress.body = (
                f"{pick.hand_side.title()} hand: shelf {pick.shelf_number}, object {pick.object_index}; "
                f"pregrasp frame {pregrasp_frame}, diagonal {diagonal_frame}, grasp {grasp_frame}, lift {lift_frame}, "
                f"hold from {chest_frame}; {total_frames / fps:.1f}s auto duration. "
                "Body, hips, waist, head, and feet are locked to the standing rack pose."
            )
            progress.color = "green"
        except Exception as e:
            progress.title = "Rack pick failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 7.0

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
