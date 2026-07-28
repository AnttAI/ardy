# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Part of InteractiveTimelineDemo (split for readability)."""

from .common import *  # noqa: F401,F403


class PlaybackMixin:
    def run_client_playback(self, client_id: int):
        """Playback loop for a specific client."""
        print(f"Starting playback loop for client {client_id}")

        elapsed_history = []

        while True:
            # Check if client is still active and should continue
            if not self.client_active(client_id):
                print(f"Client {client_id} no longer active, stopping playback loop")
                break

            session = self.client_sessions[client_id]
            if session.stop_playback:
                print(f"Stop signal received for client {client_id}")
                break

            last_update_time = time.time()

            # Update frame if playing
            if session.playing:
                playback_end_frame = session.max_frame_idx
                if not session.realtime_mode and session.task_end_frame_idx is not None:
                    playback_end_frame = min(playback_end_frame, session.task_end_frame_idx)

                waiting_for_task_generation = (
                    not session.realtime_mode
                    and session.task_end_frame_idx is not None
                    and (session.task_generation_pending or session.max_frame_idx < session.task_end_frame_idx)
                    and session.frame_idx >= session.max_frame_idx
                )

                if waiting_for_task_generation:
                    if not session.replan_lock.locked():
                        threading.Thread(
                            target=self.on_replan_trigger,
                            args=(client_id,),
                            kwargs={"skip_if_busy": True},
                            daemon=True,
                        ).start()
                elif session.frame_idx >= playback_end_frame:
                    if session.play_once or not session.realtime_mode:
                        if session.task_generation_pending:
                            if not session.replan_lock.locked():
                                threading.Thread(
                                    target=self.on_replan_trigger,
                                    args=(client_id,),
                                    kwargs={"skip_if_busy": True},
                                    daemon=True,
                                ).start()
                        else:
                            session.playing = False
                            session.play_once = False
                            session.frame_idx = playback_end_frame
                            self.set_frame(client_id, session.frame_idx)
                            session.gui_elements.gui_play_pause_button.label = "Play"
                            session.gui_elements.gui_next_frame_button.disabled = (
                                session.frame_idx >= session.max_frame_idx
                            )
                            session.gui_elements.gui_prev_frame_button.disabled = session.frame_idx <= 0
                            if session.task_end_frame_idx is not None:
                                session.client.add_notification(
                                    title="Task motion complete",
                                    body=f"Reached frame {session.task_end_frame_idx}.",
                                    auto_close_seconds=3.0,
                                    color="green",
                                )
                    else:
                        if not session.replan_lock.locked():
                            threading.Thread(
                                target=self.on_replan_trigger,
                                args=(client_id,),
                                kwargs={"skip_if_busy": True},
                                daemon=True,
                            ).start()
                        self.set_frame(client_id, playback_end_frame)
                elif session.frame_idx < session.max_frame_idx:
                    session.frame_idx += 1
                    self.set_frame(client_id, session.frame_idx)

            # Sleep to maintain target FPS (using model's native FPS)
            time_remaining = max(0, 1.0 / session.model_fps - (time.time() - last_update_time))
            time.sleep(time_remaining)

            # Track moving average of actual fps
            elapsed = time.time() - last_update_time
            elapsed_history.append(elapsed)
            if len(elapsed_history) > 10:
                elapsed_history.pop(0)

            if self.client_active(client_id):
                session.gui_elements.gui_actual_fps.value = 1.0 / (sum(elapsed_history) / len(elapsed_history))

        print(f"Playback loop ended for client {client_id}")

    def run(self):
        """Main dummy loop to keep server alive."""
        print("Main server loop started")
        try:
            while True:
                time.sleep(1.0)
        except KeyboardInterrupt:
            print("Server shutting down...")
            # Signal all playback threads to stop
            for session in self.client_sessions.values():
                session.stop_playback = True

    def set_frame(self, client_id: int, frame_idx: int, trigger_by_gui_timeline: bool = False):
        """Set the current frame for a client."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        session.frame_idx = frame_idx
        # Update the Viser timeline GUI if not triggered by it
        if not trigger_by_gui_timeline and hasattr(client, "timeline"):
            try:
                client.timeline.set_current_frame(frame_idx)
                # Set a rolling window: 20 frames before + 200 frames after current frame
                window_start = max(0, frame_idx - TIMELINE_WINDOW_BEFORE)
                window_end = frame_idx + TIMELINE_WINDOW_AFTER
                client.timeline.set_frame_range(start_frame=window_start, end_frame=window_end)
            except (AttributeError, Exception) as e:
                print(f"Could not update timeline frame: {e}")

        session.cur_time = frame_idx / session.model_fps
        session.gui_elements.gui_current_time.value = session.cur_time
        session.gui_elements.gui_frame_idx_input.value = frame_idx
        self._check_task_target_reached(client_id)

        # Check if approaching end of timeline
        thresh = session.gui_elements.gui_replan_trigger_thresh.value
        enable_auto_replan = session.gui_elements.gui_enable_auto_replan_checkbox.value
        if (
            session.realtime_mode
            and not trigger_by_gui_timeline
            and enable_auto_replan
            and session.max_frame_idx - frame_idx <= thresh
        ):
            # Cheap pre-check to avoid spawning a thread while a replan runs;
            # skip_if_busy makes the trigger drop atomically if another thread
            # won the race between this check and the lock acquisition.
            if not session.replan_lock.locked():
                threading.Thread(
                    target=self.on_replan_trigger,
                    args=(client_id,),
                    kwargs={"skip_if_busy": True},
                    daemon=True,
                ).start()

        # Update constraint visibility - show constraints that have been reached (frame_idx <= current frame)
        show_hand_orientations = session.gui_elements.gui_viz_hand_orientations_checkbox.value
        hide_distant_constraints = session.gui_elements.gui_viz_hide_distant_constraints_checkbox.value

        # Calculate max visible future frame if hiding distant constraints
        max_future_frame = float("inf")
        if hide_distant_constraints:
            future_crop = session.gui_elements.gui_future_crop_length.value
            gen_horizon = session.gen_horizon_len
            max_future_frame = frame_idx + future_crop + gen_horizon

        for track_name, constraint in session.constraints.items():
            for constraint_frame_idx in constraint.scene_elements.keys():
                # Basic visibility: constraint is in the future (not yet reached)
                visibility = constraint_frame_idx >= frame_idx

                # Additionally hide if too far in the future
                if hide_distant_constraints and constraint_frame_idx > max_future_frame:
                    visibility = False

                # Pass show_rotation_axes parameter for End-Effectors constraints
                if track_name == "End-Effectors":
                    constraint.set_keyframe_visibility(
                        constraint_frame_idx,
                        visibility,
                        show_rotation_axes=show_hand_orientations,
                    )
                else:
                    constraint.set_keyframe_visibility(constraint_frame_idx, visibility)
            # Update interval labels visibility once per constraint track
            if track_name == "2D Root":
                constraint.set_interval_labels_visibility(frame_idx)

        # Update character poses and get root position for target velocity arrow
        # Note: Each character has its own actual velocity arrow (blue) shown on their skeleton
        # We also have ONE shared target velocity arrow (orange) for the entire session
        root_pos_for_target = None
        with session.characters_lock:
            if frame_idx >= 0 and frame_idx <= session.max_frame_idx:
                for character_idx, character in enumerate(session.characters.values()):
                    # Get actual root velocity for this frame (pass as tensor)
                    root_velocity = None
                    if session.root_velocities is not None:
                        root_velocity = session.root_velocities[character_idx, frame_idx]

                    foot_contacts = (
                        session.foot_contacts[character_idx, frame_idx] > 0.5
                        if session.foot_contacts is not None
                        else None
                    )
                    character.set_pose(
                        session.joints_pos[character_idx, frame_idx],
                        session.joints_rot[character_idx, frame_idx],
                        foot_contacts=foot_contacts,
                        root_velocity=root_velocity,
                    )

                    # Store root position from first character for target velocity visualization
                    if character_idx == 0 and root_pos_for_target is None:
                        root_pos_for_target = character.skeleton_mesh.cur_joints_pos[character.skeleton.root_idx]

                    if (
                        character_idx == 0
                        and getattr(session.gui_elements, "gui_viz_soma_mesh_checkbox", None) is not None
                        and session.gui_elements.gui_viz_soma_mesh_checkbox.value
                    ):
                        try:
                            if session.soma_live_mapper is None:
                                from ardy.retarget_to_t3.soma_debug import SomaLivePoseMapper

                                session.soma_live_mapper = SomaLivePoseMapper(character.skeleton)
                            soma_joints_pos, soma_joints_rot = session.soma_live_mapper.map_frame(
                                session.joints_pos[character_idx, frame_idx],
                                session.joints_rot[character_idx, frame_idx],
                            )
                            if session.soma_debug_character is None:
                                session.soma_debug_character = Character(
                                    "soma_debug",
                                    session.client,
                                    session.soma_live_mapper.soma_skeleton,
                                    create_skeleton_mesh=False,
                                    create_skinned_mesh=True,
                                    visible_skinned_mesh=True,
                                    skinned_mesh_opacity=0.55,
                                    show_foot_contacts=False,
                                    dark_mode=False,
                                    mesh_mode="soma_skin",
                                )
                                if session.soma_debug_character.skinned_mesh is not None:
                                    session.soma_debug_character.skinned_mesh.color = (210, 245, 80)
                            soma_offset = torch.as_tensor(
                                session.gui_elements.gui_viz_soma_mesh_offset.value,
                                dtype=soma_joints_pos.dtype,
                            )
                            session.soma_debug_character.set_pose(
                                soma_joints_pos + soma_offset,
                                soma_joints_rot,
                            )
                        except Exception as e:
                            self._set_soma_t3_status(client_id, "SOMA live mesh failed")
                            print(f"[SOMA Debug] Failed to update live SOMA mesh: {e}")
                            import traceback

                            traceback.print_exc()
                            session.gui_elements.gui_viz_soma_mesh_checkbox.value = False
                            continue

                    if character_idx == 0 and session.gui_elements.gui_viz_t3_robot_checkbox.value:
                        use_soma_t3 = (
                            getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
                            and session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
                        )
                        if (
                            use_soma_t3
                            and session.t3_retarget_csv_path is not None
                            and session.t3_retarget_ready_generation > session.t3_csv_player_generation
                        ):
                            try:
                                from ardy.retarget_to_t3 import T3CsvPlaybackRobot

                                if session.t3_csv_player is not None:
                                    session.t3_csv_player.clear()
                                session.t3_csv_player = T3CsvPlaybackRobot(
                                    self.server,
                                    session.t3_retarget_csv_path,
                                    root_node_name=f"/t3_csv_client_{client_id}",
                                )
                                session.t3_csv_player_generation = session.t3_retarget_ready_generation
                                if session.t3_live_retargeter is not None:
                                    session.t3_live_retargeter.set_visible(False)
                            except Exception as e:
                                self._set_soma_t3_status(client_id, "csv load failed")
                                print(f"[T3 Live] Failed to load Soma T3 CSV player: {e}")
                                import traceback

                                traceback.print_exc()
                        csv_covers_frame = (
                            session.t3_csv_player is not None
                            and session.t3_csv_player.has_frame(frame_idx)
                        )
                        if (
                            use_soma_t3
                            and session.t3_csv_player is not None
                            and frame_idx >= session.t3_csv_player.num_frames - max(2, int(session.model_fps))
                        ):
                            self.request_soma_t3_retarget(client_id)
                        if use_soma_t3 and csv_covers_frame:
                            self._set_soma_t3_status(client_id, f"Soma upper body + ARDY base frame {frame_idx}/{session.t3_csv_player.num_frames - 1}")
                            if session.t3_csv_player is not None:
                                session.t3_csv_player.set_visible(False)
                            if session.t3_live_retargeter is None:
                                try:
                                    from ardy.retarget_to_t3 import T3LiveRetargeter

                                    session.t3_live_retargeter = T3LiveRetargeter(
                                        self.server,
                                        character.skeleton,
                                    )
                                except Exception as e:
                                    session.gui_elements.gui_viz_t3_robot_checkbox.value = False
                                    print(f"[T3 Live] Failed to create T3 robot: {e}")
                                    import traceback

                                    traceback.print_exc()
                                    continue
                            session.t3_live_retargeter.set_visible(True)
                            session.t3_live_retargeter.update_with_soma_upper_body_csv(
                                session.joints_pos[character_idx, frame_idx],
                                session.joints_rot[character_idx, frame_idx],
                                session.t3_csv_player.rows[frame_idx],
                                fps=session.model_fps,
                                offset=session.gui_elements.gui_viz_t3_offset.value,
                                yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                root_velocity=root_velocity,
                            )
                        else:
                            if use_soma_t3:
                                if session.t3_csv_player is not None and not csv_covers_frame:
                                    self._set_soma_t3_status(
                                        client_id,
                                        f"waiting for frame {frame_idx} (ready through {session.t3_csv_player.num_frames - 1})",
                                    )
                                elif session.t3_csv_player is None:
                                    self._set_soma_t3_status(client_id, "waiting for exact Soma T3 CSV")
                                self.request_soma_t3_retarget(client_id)
                                if session.t3_csv_player is not None:
                                    session.t3_csv_player.set_visible(False)
                                if session.t3_live_retargeter is None:
                                    try:
                                        from ardy.retarget_to_t3 import T3LiveRetargeter

                                        session.t3_live_retargeter = T3LiveRetargeter(
                                            self.server,
                                            character.skeleton,
                                        )
                                    except Exception as e:
                                        session.gui_elements.gui_viz_t3_robot_checkbox.value = False
                                        print(f"[T3 Live] Failed to create T3 robot: {e}")
                                        import traceback

                                        traceback.print_exc()
                                        continue
                                session.t3_live_retargeter.set_visible(True)
                                session.t3_live_retargeter.update_base_lift_stiff_upper(
                                    session.joints_pos[character_idx, frame_idx],
                                    session.joints_rot[character_idx, frame_idx],
                                    fps=session.model_fps,
                                    offset=session.gui_elements.gui_viz_t3_offset.value,
                                    yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                    root_velocity=root_velocity,
                                )
                                continue
                            if session.t3_csv_player is not None:
                                session.t3_csv_player.set_visible(False)
                            if session.t3_live_retargeter is None:
                                try:
                                    from ardy.retarget_to_t3 import T3LiveRetargeter

                                    session.t3_live_retargeter = T3LiveRetargeter(
                                        self.server,
                                        character.skeleton,
                                    )
                                except Exception as e:
                                    session.gui_elements.gui_viz_t3_robot_checkbox.value = False
                                    print(f"[T3 Live] Failed to create T3 robot: {e}")
                                    import traceback

                                    traceback.print_exc()
                                    continue
                            session.t3_live_retargeter.set_visible(True)
                            session.t3_live_retargeter.update(
                                session.joints_pos[character_idx, frame_idx],
                                session.joints_rot[character_idx, frame_idx],
                                fps=session.model_fps,
                                offset=session.gui_elements.gui_viz_t3_offset.value,
                                yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                root_velocity=root_velocity,
                            )

        # Update reference motion character
        if (
            session.ref_character is not None
            and session.ref_joints_pos is not None
            and session.gui_elements.gui_viz_ref_motion_checkbox.value
        ):
            ref_frame = min(frame_idx, session.ref_joints_pos.shape[0] - 1)
            if ref_frame >= 0:
                session.ref_character.set_pose(
                    session.ref_joints_pos[ref_frame],
                    session.ref_joints_rot[ref_frame],
                )

        # Update hand gizmos if enabled
        if session.gui_elements.gui_viz_hand_orientations_checkbox.value:
            if not session.hand_gizmos:
                self.create_hand_gizmos(client_id)
            self.update_hand_gizmos(client_id, frame_idx)
        elif session.hand_gizmos:
            # Hide hand gizmos if checkbox is off
            self.set_hand_gizmos_visibility(client_id, False)

        # Update target velocity arrow visualization (orange, user-specified target)
        if session.target_velocity_arrow is not None:
            gui_elements = session.gui_elements
            # Show target velocity arrow if enabled and we have a valid root position
            if gui_elements.gui_use_target_velocity_checkbox.value and root_pos_for_target is not None:
                # Get target velocity from GUI (x, z)
                target_vel_xz = gui_elements.gui_target_root_velocity.value
                target_velocity = np.array([target_vel_xz[0], 0.0, target_vel_xz[1]])

                # Update target velocity arrow
                session.target_velocity_arrow.update(
                    root_velocity=target_velocity,
                    root_pos=root_pos_for_target,
                    visible=True,
                )

                # Predict future root positions and update 2D root constraints
                if frame_idx % TARGET_VELOCITY_UPDATE_INTERVAL == 0:
                    self._update_root_constraints_from_target_velocity(client_id, frame_idx, target_velocity)
            else:
                # Hide target velocity arrow if disabled or no character available
                session.target_velocity_arrow.set_visibility(False)

        # Update camera
        if session.gui_elements.gui_viz_auto_camera_checkbox.value:
            self.update_camera_follow(client_id, frame_idx)

    def _check_task_target_reached(self, client_id: int):
        """Report once when the generated root reaches the loaded BVH task target."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]

        if (
            session.task_reached_reported
            or session.task_generation_pending
            or session.task_end_frame_idx is None
            or session.joints_pos is None
            or session.ref_joints_pos is None
            or session.frame_idx < session.task_end_frame_idx
            or session.frame_idx < 0
        ):
            return

        frame_idx = min(session.frame_idx, session.joints_pos.shape[1] - 1)
        target_frame = min(session.task_end_frame_idx, session.ref_joints_pos.shape[0] - 1)
        root_idx = 0

        current_root_xz = session.joints_pos[0, frame_idx, root_idx, [0, 2]]
        target_root_xz = session.ref_joints_pos[target_frame, root_idx, [0, 2]].to(current_root_xz)
        distance = torch.linalg.norm(current_root_xz - target_root_xz)

        speed = torch.tensor(0.0, device=current_root_xz.device)
        if session.root_velocities is not None and frame_idx < session.root_velocities.shape[1]:
            speed = torch.linalg.norm(session.root_velocities[0, frame_idx, [0, 2]])

        distance_m = float(distance.detach().cpu())
        speed_mps = float(speed.detach().cpu())
        if distance_m > 0.15 or speed_mps > 0.05:
            return

        session.task_reached_reported = True
        message = (
            f"[Task Target] Reached target at frame {frame_idx} "
            f"(target_frame={session.task_end_frame_idx}, distance={distance_m:.3f} m, speed={speed_mps:.3f} m/s)"
        )
        print(message)
        session.client.add_notification(
            title="Task target reached",
            body=f"Frame {frame_idx}, distance {distance_m:.3f} m.",
            auto_close_seconds=5.0,
            color="green",
        )
