# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Part of InteractiveTimelineDemo (split for readability)."""

from .common import *  # noqa: F401,F403
from .retarget_viewer import RetargetViewerPose, SomaT3RetargetViewer


class PlaybackMixin:
    def play_files_in_retarget_viewer(self, client_id: int, mode: str) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        gui = session.gui_elements
        try:
            mode = mode.lower()
            if mode not in {"csv", "bvh", "both"}:
                raise ValueError(f"Unsupported file playback mode: {mode}")
            session.playing = False
            session.play_once = False
            if getattr(gui, "gui_play_pause_button", None) is not None:
                gui.gui_play_pause_button.label = "Play"
            session.retarget_debug_websocket_enabled = True
            if getattr(gui, "gui_viz_newton_websocket_checkbox", None) is not None:
                gui.gui_viz_newton_websocket_checkbox.value = True
            session.retarget_debug_viewer_visible = True
            gui.gui_viz_retarget_viewer_button.label = "Disconnect RTX"
            gui.gui_viz_retarget_viewer_status.value = "connecting websocket"
            if (
                session.retarget_debug_viewer is not None
                and not session.retarget_debug_websocket_enabled
                and getattr(session.retarget_debug_viewer, "viewer_backend", "gl") != "rtx"
            ):
                session.retarget_debug_viewer.clear()
                session.retarget_debug_viewer = None
            if session.retarget_debug_viewer is None:
                character = session.characters.get(0) or next(iter(session.characters.values()), None)
                if session.soma_live_mapper is None and character is not None:
                    from ardy.retarget_to_t3.soma_debug import SomaLivePoseMapper

                    session.soma_live_mapper = SomaLivePoseMapper(character.skeleton)
                if character is None:
                    soma_skeleton = SOMASkeleton77(load=True)
                    core_skeleton = soma_skeleton
                else:
                    soma_skeleton = session.soma_live_mapper.soma_skeleton
                    core_skeleton = character.skeleton
                session.retarget_debug_viewer = SomaT3RetargetViewer(
                    session.client,
                    client_id,
                    core_skeleton,
                    soma_skeleton,
                    viewer_backend="rtx" if not session.retarget_debug_websocket_enabled else session.retarget_debug_viewer_backend,
                    background_usd=session.retarget_debug_background_usd,
                    camera_preset=session.retarget_debug_camera_preset,
                    rtx_environment=session.retarget_debug_rtx_environment,
                    newton_pythonpath=session.retarget_debug_newton_pythonpath,
                    viewer_python=session.retarget_debug_viewer_python,
                    websocket_enabled=session.retarget_debug_websocket_enabled,
                    websocket_url=session.retarget_debug_websocket_url,
                )
            status = session.retarget_debug_viewer.play_files(
                bvh_path=gui.gui_viz_file_bvh_path.value,
                csv_path=gui.gui_viz_file_csv_path.value,
                mode=mode,
            )
            gui.gui_viz_file_viewer_status.value = status
            if "failed" in status or "not available" in status or "Set the" in status:
                raise RuntimeError(status)
            session.client.add_notification(
                title=f"RTX {mode.upper()} playback started",
                body=(
                    "Streaming into the independent RTX viewer websocket."
                    if session.retarget_debug_websocket_enabled
                    else "Streaming into the existing RTX viewer window."
                ),
                auto_close_seconds=3.0,
                color="green",
            )
        except Exception as exc:
            gui.gui_viz_file_viewer_status.value = str(exc)
            session.client.add_notification(
                title="RTX file playback failed",
                body=str(exc),
                auto_close_seconds=6.0,
                color="red",
            )

    def toggle_retarget_debug_viewer(self, client_id: int) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        gui = session.gui_elements
        session.retarget_debug_websocket_enabled = True
        if getattr(gui, "gui_viz_newton_websocket_checkbox", None) is not None:
            gui.gui_viz_newton_websocket_checkbox.value = True
        opening = not bool(session.retarget_debug_viewer_visible)
        session.retarget_debug_viewer_visible = opening
        if opening:
            session.retarget_debug_disconnect_reported = False
        gui.gui_viz_retarget_viewer_button.label = "Disconnect RTX" if opening else "Connect RTX"
        gui.gui_viz_retarget_viewer_status.value = "connecting websocket" if opening else "disconnected"

        if not opening:
            if session.retarget_debug_viewer is not None:
                session.retarget_debug_viewer.set_visible(False)
            return

        if hasattr(self, "warm_live_soma_t3_solver"):
            self.warm_live_soma_t3_solver(client_id)
        self.set_frame(client_id, session.frame_idx)
        if session.retarget_debug_viewer is not None:
            gui.gui_viz_retarget_viewer_status.value = "connecting websocket"
        session.client.add_notification(
            title="Newton RTX connected",
            body="Streaming to the independently launched Newton RTX viewer.",
            auto_close_seconds=3.0,
            color="blue",
        )

    def _update_retarget_debug_viewer(
        self,
        client_id: int,
        character,
        frame_idx: int,
        soma_joints_pos,
        soma_joints_rot,
        effective_fps: float,
        root_velocity,
        t3_state_row=None,
    ) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        if not session.retarget_debug_viewer_visible or soma_joints_pos is None or soma_joints_rot is None:
            return

        if session.retarget_debug_viewer is None:
            if session.soma_live_mapper is None:
                return
            session.retarget_debug_viewer = SomaT3RetargetViewer(
                session.client,
                client_id,
                character.skeleton,
                session.soma_live_mapper.soma_skeleton,
                viewer_backend=session.retarget_debug_viewer_backend,
                background_usd=session.retarget_debug_background_usd,
                camera_preset=session.retarget_debug_camera_preset,
                rtx_environment=session.retarget_debug_rtx_environment,
                newton_pythonpath=session.retarget_debug_newton_pythonpath,
                viewer_python=session.retarget_debug_viewer_python,
                websocket_enabled=session.retarget_debug_websocket_enabled,
                websocket_url=session.retarget_debug_websocket_url,
            )
            session.retarget_debug_viewer.open()
            session.client.add_notification(
                title="Newton viewer ready",
                body=(
                    "Live SOMA/Newton frames are streaming to the independent Newton websocket viewer."
                    if session.retarget_debug_websocket_enabled
                    else "Live SOMA/Newton frames are streaming to the Newton mesh viewer."
                ),
                auto_close_seconds=3.0,
                color="green",
            )

        live_row = None
        if t3_state_row is None and hasattr(self, "solve_live_soma_mesh_t3_frame"):
            live_row = self.solve_live_soma_mesh_t3_frame(
                client_id,
                frame_idx,
                soma_joints_pos,
                soma_joints_rot,
                session.soma_live_mapper.soma_skeleton,
            )
        status = session.retarget_debug_viewer.update(
            RetargetViewerPose(
                soma_joints_pos=soma_joints_pos,
                soma_joints_rot=soma_joints_rot,
                core_joints_pos=session.joints_pos[0, frame_idx],
                core_joints_rot=session.joints_rot[0, frame_idx],
                t3_row=live_row,
                t3_state_row=t3_state_row,
                root_velocity=root_velocity,
                soma_offset=session.gui_elements.gui_viz_soma_mesh_offset.value,
                fps=effective_fps,
                frame_idx=frame_idx,
                accurate_ready_until=frame_idx if live_row is not None else -1,
            )
        )
        if session.retarget_debug_websocket_enabled:
            status_lower = str(status).lower()
            connected = (
                "websocket connected" in status_lower
                or status_lower.startswith("live newton frame")
                or status_lower.startswith("warming live")
            )
            disconnected = (
                "websocket disconnected" in status_lower
                or "websocket unavailable" in status_lower
                or "websocket connect failed" in status_lower
                or "websocket not available" in status_lower
            )
            if connected:
                session.retarget_debug_disconnect_reported = False
                if session.retarget_debug_viewer_visible:
                    session.gui_elements.gui_viz_retarget_viewer_button.label = "Disconnect RTX"
            elif disconnected:
                session.retarget_debug_viewer_visible = False
                session.gui_elements.gui_viz_retarget_viewer_button.label = "Connect RTX"
                if not session.retarget_debug_disconnect_reported:
                    session.client.add_notification(
                        title="Newton RTX disconnected",
                        body=str(status),
                        auto_close_seconds=6.0,
                        color="red",
                    )
                    session.retarget_debug_disconnect_reported = True
        session.gui_elements.gui_viz_retarget_viewer_status.value = status

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
            if (
                getattr(session, "retarget_debug_viewer", None) is not None
                and getattr(session.gui_elements, "gui_viz_file_viewer_status", None) is not None
            ):
                status = getattr(session.retarget_debug_viewer, "file_playback_status", "")
                if status and status != "idle":
                    session.gui_elements.gui_viz_file_viewer_status.value = status
            if session.stop_playback:
                print(f"Stop signal received for client {client_id}")
                break

            last_update_time = time.time()

            # Update frame if playing
            if session.playing:
                if getattr(session, "t3_hardware_clock_active", False):
                    time.sleep(0.02)
                    last_update_time = time.time()
                    continue
                accurate_soma_waiting = False
                playback_end_frame = session.max_frame_idx
                if not session.realtime_mode and session.task_end_frame_idx is not None:
                    playback_end_frame = min(playback_end_frame, session.task_end_frame_idx)

                use_accurate_soma_t3 = (
                    getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
                    and session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
                    and session.gui_elements.gui_viz_t3_robot_checkbox.value
                )
                if use_accurate_soma_t3:
                    next_frame = min(session.frame_idx + 1, playback_end_frame)
                    csv_ready_until = (
                        max(len(session.t3_stream_rows) - 1, int(session.t3_retarget_csv_end_frame))
                        if hasattr(session, "t3_stream_rows")
                        else int(session.t3_retarget_csv_end_frame)
                    )
                    if next_frame > csv_ready_until:
                        self.request_soma_t3_retarget(client_id, start_frame=0)
                        self._set_soma_t3_status(
                            client_id,
                            f"waiting for accurate Soma T3 frame {next_frame}; ready to {csv_ready_until}",
                        )
                        accurate_soma_waiting = True

                waiting_for_task_generation = (
                    not session.realtime_mode
                    and session.task_end_frame_idx is not None
                    and (session.task_generation_pending or session.max_frame_idx < session.task_end_frame_idx)
                    and session.frame_idx >= session.max_frame_idx
                )

                if accurate_soma_waiting:
                    pass
                elif waiting_for_task_generation:
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
                            self._pause_t3_hardware_motion(client_id)
                            session.gui_elements.gui_play_pause_button.label = "Play"
                            session.gui_elements.gui_next_frame_button.disabled = (
                                session.frame_idx >= session.max_frame_idx
                            )
                            session.gui_elements.gui_prev_frame_button.disabled = session.frame_idx <= 0
                            followup_started = False
                            if hasattr(self, "_apply_pending_say_hi_after_task"):
                                followup_started = self._apply_pending_say_hi_after_task(client_id)
                            if session.task_end_frame_idx is not None and not followup_started:
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

            # Sleep to maintain the shared playback clock. Slowing this clock
            # keeps mesh, T3 preview, and hardware frame streaming synchronized.
            playback_speed = max(float(getattr(session, "playback_speed", 1.0)), 0.05)
            effective_fps = max(float(session.model_fps) * playback_speed, 1e-6)
            time_remaining = max(0, 1.0 / effective_fps - (time.time() - last_update_time))
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

        playback_speed = max(float(getattr(session, "playback_speed", 1.0)), 0.05)
        effective_fps = max(float(session.model_fps) * playback_speed, 1e-6)
        session.cur_time = frame_idx / effective_fps
        session.gui_elements.gui_current_time.value = session.cur_time
        session.gui_elements.gui_frame_idx_input.value = frame_idx
        self._check_task_target_reached(client_id)

        # Check if approaching end of timeline
        thresh = session.gui_elements.gui_replan_trigger_thresh.value
        if (
            getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
            and session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
            and session.gui_elements.gui_viz_t3_robot_checkbox.value
        ):
            thresh = max(int(thresh), int(session.gen_horizon_len))
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
                    playback_speed = max(float(getattr(session, "playback_speed", 1.0)), 0.05)
                    effective_fps = max(float(session.model_fps) * playback_speed, 1e-6)
                    display_root_velocity = None if root_velocity is None else root_velocity * playback_speed

                    foot_contacts = (
                        session.foot_contacts[character_idx, frame_idx] > 0.5
                        if session.foot_contacts is not None
                        else None
                    )
                    character.set_pose(
                        session.joints_pos[character_idx, frame_idx],
                        session.joints_rot[character_idx, frame_idx],
                        foot_contacts=foot_contacts,
                        root_velocity=display_root_velocity,
                    )

                    # Store root position from first character for target velocity visualization
                    if character_idx == 0 and root_pos_for_target is None:
                        root_pos_for_target = character.skeleton_mesh.cur_joints_pos[character.skeleton.root_idx]

                    soma_joints_pos = None
                    soma_joints_rot = None
                    if (
                        character_idx == 0
                        and (
                            (
                                getattr(session.gui_elements, "gui_viz_soma_mesh_checkbox", None) is not None
                                and session.gui_elements.gui_viz_soma_mesh_checkbox.value
                            )
                            or (
                                getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
                                and session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
                                and session.gui_elements.gui_viz_t3_robot_checkbox.value
                            )
                            or session.retarget_debug_viewer_visible
                        )
                    ):
                        try:
                            if session.soma_live_mapper is None:
                                from ardy.retarget_to_t3.soma_debug import SomaLivePoseMapper

                                session.soma_live_mapper = SomaLivePoseMapper(character.skeleton)
                            soma_joints_pos, soma_joints_rot = session.soma_live_mapper.map_frame(
                                session.joints_pos[character_idx, frame_idx],
                                session.joints_rot[character_idx, frame_idx],
                            )
                            show_soma_mesh = (
                                getattr(session.gui_elements, "gui_viz_soma_mesh_checkbox", None) is not None
                                and session.gui_elements.gui_viz_soma_mesh_checkbox.value
                            )
                            if show_soma_mesh and session.soma_debug_character is None:
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
                            if show_soma_mesh and session.soma_debug_character is not None:
                                soma_offset = torch.as_tensor(
                                    session.gui_elements.gui_viz_soma_mesh_offset.value,
                                    dtype=soma_joints_pos.dtype,
                                )
                                session.soma_debug_character.set_pose(
                                    soma_joints_pos + soma_offset,
                                    soma_joints_rot,
                                )
                            if not session.gui_elements.gui_viz_t3_robot_checkbox.value:
                                self._update_retarget_debug_viewer(
                                    client_id,
                                    character,
                                    frame_idx,
                                    soma_joints_pos,
                                    soma_joints_rot,
                                    effective_fps,
                                    display_root_velocity,
                                )
                        except Exception as e:
                            self._set_soma_t3_status(client_id, "SOMA live mesh failed")
                            print(f"[SOMA Debug] Failed to update live SOMA mesh: {e}")
                            import traceback

                            traceback.print_exc()
                            if getattr(session.gui_elements, "gui_viz_soma_mesh_checkbox", None) is not None:
                                session.gui_elements.gui_viz_soma_mesh_checkbox.value = False
                            continue

                    if character_idx == 0 and session.gui_elements.gui_viz_t3_robot_checkbox.value:
                        if (
                            getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
                            and not session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
                            and session.t3_csv_player is not None
                        ):
                            if session.t3_live_retargeter is not None:
                                session.t3_live_retargeter.set_visible(False)
                            session.t3_csv_player.set_visible(True)
                            if session.t3_csv_player.has_frame(frame_idx):
                                session.t3_csv_player.update(
                                    frame_idx,
                                    offset=session.gui_elements.gui_viz_t3_offset.value,
                                    yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                )
                            continue
                        use_soma_t3 = (
                            getattr(session.gui_elements, "gui_viz_t3_soma_retarget_checkbox", None) is not None
                            and session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value
                        )
                        if use_soma_t3:
                            stream_row = (
                                session.t3_stream_rows[frame_idx]
                                if 0 <= frame_idx < len(session.t3_stream_rows) and session.t3_stream_rows[frame_idx]
                                else None
                            )
                            retarget_csv_player_ready = (
                                session.t3_csv_player is not None
                                and session.t3_retarget_ready_generation >= 0
                                and session.t3_csv_player_generation == session.t3_retarget_ready_generation
                            )
                            if (
                                stream_row is None
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
                                    session.t3_csv_player.set_visible(False)
                                    retarget_csv_player_ready = True
                                except Exception as e:
                                    self._set_soma_t3_status(client_id, "csv load failed")
                                    print(f"[T3 Live] Failed to load Soma T3 CSV player: {e}")
                                    import traceback

                                    traceback.print_exc()
                            csv_covers_frame = (
                                stream_row is not None
                                or retarget_csv_player_ready
                                and session.t3_csv_player is not None
                                and session.t3_csv_player.has_frame(frame_idx)
                            )
                            if not csv_covers_frame:
                                self.request_soma_t3_retarget(client_id, start_frame=0)
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
                            if csv_covers_frame:
                                self._set_soma_t3_status(client_id, f"accurate Soma T3 frame {frame_idx}")
                                t3_row = stream_row if stream_row is not None else session.t3_csv_player.rows[frame_idx]
                                session.t3_live_retargeter.update_with_soma_upper_body_csv(
                                    session.joints_pos[character_idx, frame_idx],
                                    session.joints_rot[character_idx, frame_idx],
                                    t3_row,
                                    fps=effective_fps,
                                    offset=session.gui_elements.gui_viz_t3_offset.value,
                                    yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                    root_velocity=display_root_velocity,
                                )
                                self._update_retarget_debug_viewer(
                                    client_id,
                                    character,
                                    frame_idx,
                                    soma_joints_pos,
                                    soma_joints_rot,
                                    effective_fps,
                                    display_root_velocity,
                                    t3_state_row=session.t3_live_retargeter.newton_state_row(),
                                )
                            else:
                                ready_until = (
                                    max(len(session.t3_stream_rows) - 1, int(session.t3_retarget_csv_end_frame))
                                    if hasattr(session, "t3_stream_rows")
                                    else int(session.t3_retarget_csv_end_frame)
                                )
                                if soma_joints_pos is not None and soma_joints_rot is not None:
                                    session.t3_live_retargeter.update_with_soma_mesh_ik(
                                        session.joints_pos[character_idx, frame_idx],
                                        session.joints_rot[character_idx, frame_idx],
                                        soma_joints_pos,
                                        soma_joints_rot,
                                        session.soma_live_mapper.soma_skeleton,
                                        fps=effective_fps,
                                        offset=session.gui_elements.gui_viz_t3_offset.value,
                                        yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                        root_velocity=display_root_velocity,
                                    )
                                else:
                                    session.t3_live_retargeter.update(
                                        session.joints_pos[character_idx, frame_idx],
                                        session.joints_rot[character_idx, frame_idx],
                                        fps=effective_fps,
                                        offset=session.gui_elements.gui_viz_t3_offset.value,
                                        yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                                        root_velocity=display_root_velocity,
                                    )
                                self._set_soma_t3_status(
                                    client_id,
                                    f"previewing mesh IK for frame {frame_idx}; accurate ready to {ready_until}",
                                )
                                self._update_retarget_debug_viewer(
                                    client_id,
                                    character,
                                    frame_idx,
                                    soma_joints_pos,
                                    soma_joints_rot,
                                    effective_fps,
                                    display_root_velocity,
                                    t3_state_row=session.t3_live_retargeter.newton_state_row(),
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
                            fps=effective_fps,
                            offset=session.gui_elements.gui_viz_t3_offset.value,
                            yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                            root_velocity=display_root_velocity,
                        )
                        self._update_retarget_debug_viewer(
                            client_id,
                            character,
                            frame_idx,
                            soma_joints_pos,
                            soma_joints_rot,
                            effective_fps,
                            display_root_velocity,
                            t3_state_row=session.t3_live_retargeter.newton_state_row(),
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

        if hasattr(self, "_sync_t3_hardware_frame"):
            self._sync_t3_hardware_frame(client_id, frame_idx)

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
