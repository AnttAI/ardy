# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Interactive-demo GUI: Visualize tab (split from create_gui)."""

from ..common import *  # noqa: F401,F403


class GuiVisualizeMixin:
    def _build_visualize_tab(self, client, client_id, tab_group, g, timeline, default_prompt):
        with tab_group.add_tab("Visualize", viser.Icon.EYE):
            g.gui_viz_skinned_mesh_checkbox = client.gui.add_checkbox("Show Mesh", initial_value=True)
            g.gui_viz_skinned_mesh_opacity_slider = client.gui.add_slider(
                "Mesh Opacity", min=0.0, max=1.0, step=0.01, initial_value=1.0
            )
            g.gui_viz_skeleton_checkbox = client.gui.add_checkbox("Show Skeleton", initial_value=False)
            g.gui_viz_foot_contacts_checkbox = client.gui.add_checkbox(
                "Show Foot Contacts",
                initial_value=False,
                hint="Color foot joints purple when predicted to be in contact with the ground",
            )
            g.gui_viz_foot_contacts_checkbox.visible = g.gui_viz_skeleton_checkbox.value
            g.gui_viz_ref_motion_checkbox = client.gui.add_checkbox(
                "Show Reference Motion",
                initial_value=False,
                hint="Show loaded reference motion as a red mesh character",
            )
            g.gui_viz_soma_mesh_checkbox = client.gui.add_checkbox(
                "Show SOMA Mesh",
                initial_value=False,
                hint="Show the generated motion after Core-to-SOMA mapping, before T3 retargeting",
            )
            g.gui_viz_soma_mesh_offset = client.gui.add_vector3(
                "SOMA Offset",
                initial_value=(0.8, 0.0, 0.0),
                step=0.05,
                hint="World-space offset for the SOMA debug mesh",
            )
            g.gui_viz_t3_robot_checkbox = client.gui.add_checkbox(
                "Show Live T3",
                initial_value=False,
                hint="Retarget the generated motion to a T3 robot in this scene",
            )
            g.gui_viz_t3_soma_retarget_checkbox = client.gui.add_checkbox(
                "Use Soma T3 Retarget",
                initial_value=True,
                hint="Use embedded Soma BVH/Newton packet retargeting for T3 upper body",
            )
            g.gui_viz_t3_retarget_now_button = client.gui.add_button(
                "Reset Soma T3",
                hint="Clear streamed Soma T3 rows and retarget again",
            )
            g.gui_viz_t3_retarget_status = client.gui.add_text(
                "Soma T3 Status",
                initial_value="idle",
                disabled=True,
            )
            g.gui_viz_t3_packet_size = client.gui.add_number(
                "Soma Packet Frames",
                initial_value=10,
                min=1,
                max=200,
                step=1,
                hint="Number of generated frames to send per accurate SOMA/Newton retarget packet",
            )
            g.gui_viz_t3_offset = client.gui.add_vector3(
                "T3 Offset",
                initial_value=(0.0, 0.0, 0.0),
                step=0.05,
                hint="World-space offset for the T3 robot",
            )
            g.gui_viz_t3_yaw_offset = client.gui.add_slider(
                "T3 Yaw Offset",
                min=-180.0,
                max=180.0,
                step=1.0,
                initial_value=-90.0,
                hint="URDF forward-axis correction for the fast preview; exact Soma CSV playback uses its saved yaw",
            )
            with client.gui.add_folder("Send T3 to Real Hardware", expand_by_default=True):
                g.gui_t3_hardware_payload_md = client.gui.add_markdown(
                    "Generate motion, enable Soma T3 retargeting, then inspect the outgoing frame here."
                )
                g.gui_t3_hardware_enable_checkbox = client.gui.add_checkbox(
                    "Enable Real T3 Hardware",
                    initial_value=False,
                    hint="Off means the stream process runs in dry-run mode.",
                )
                g.gui_t3_hardware_send_checkbox = client.gui.add_checkbox(
                    "Send to connected stream",
                    initial_value=False,
                    hint="Off only previews the exact payload. Turn on to publish through the hardware bridge.",
                )
                g.gui_t3_hardware_rpm_scale = client.gui.add_number(
                    "Base RPM Scale",
                    initial_value=float(os.environ.get("ARDY_T3_RPM_SCALE", "1.0")),
                    min=0.01,
                    max=10.0,
                    step=0.05,
                )
                g.gui_t3_hardware_max_abs_rpm = client.gui.add_number(
                    "Base Command Max RPM",
                    initial_value=float(os.environ.get("ARDY_T3_MAX_ABS_RPM", "90.0")),
                    min=1.0,
                    max=300.0,
                    step=1.0,
                    hint="Pair-preserving limit applied before publishing /base/cmd_wheel_rpm.",
                )
                g.gui_t3_hardware_linear_scale = client.gui.add_number(
                    "Base Linear Scale",
                    initial_value=float(os.environ.get("ARDY_T3_LINEAR_SCALE", "1.0")),
                    min=0.01,
                    max=3.0,
                    step=0.01,
                    hint="Multiply straight/base forward velocity before converting to wheel RPM.",
                )
                g.gui_t3_hardware_backward_scale = client.gui.add_number(
                    "Base Backward Scale",
                    initial_value=float(os.environ.get("ARDY_T3_BACKWARD_SCALE", "1.0")),
                    min=0.01,
                    max=3.0,
                    step=0.01,
                    hint="Extra multiplier applied only when commanded base forward velocity is negative.",
                )
                g.gui_t3_hardware_yaw_scale = client.gui.add_number(
                    "Base Yaw Scale",
                    initial_value=float(os.environ.get("ARDY_T3_YAW_SCALE", "1.14")),
                    min=0.01,
                    max=3.0,
                    step=0.01,
                    hint="Multiply turning/yaw rate before converting to wheel RPM.",
                )
                g.gui_t3_hardware_rack_yaw_scale = client.gui.add_number(
                    "Rack Yaw Scale",
                    initial_value=float(os.environ.get("ARDY_T3_RACK_YAW_SCALE", "0.95")),
                    min=0.01,
                    max=3.0,
                    step=0.01,
                    hint="Extra yaw multiplier only for planned rack-route base commands.",
                )
                g.gui_t3_hardware_base_lead_frames = client.gui.add_number(
                    "Base Lead Frames",
                    initial_value=int(os.environ.get("ARDY_T3_BASE_LEAD_FRAMES", "0")),
                    min=0,
                    max=30,
                    step=1,
                    hint="Send base RPM from a future frame while upper body stays on the current frame.",
                )
                g.gui_t3_hardware_lift_step_frames = client.gui.add_number(
                    "CSV Lift Step Frames",
                    initial_value=int(os.environ.get("ARDY_T3_LIFT_STEP_FRAMES", "10")),
                    min=1,
                    max=300,
                    step=1,
                    hint="For CSV playback only: publish lift height on row 0, N, 2N, ...",
                )
                base_mapping_options = (
                    "Direct ROS [left, right]",
                    "Kimodo/Tara [right, -left]",
                    "Swap only [right, left]",
                    "Invert both [-left, -right]",
                )
                base_mapping_initial = os.environ.get("ARDY_T3_BASE_MAPPING_LABEL", base_mapping_options[0])
                if base_mapping_initial not in base_mapping_options:
                    base_mapping_initial = base_mapping_options[0]
                g.gui_t3_hardware_base_mapping = client.gui.add_dropdown(
                    "Base ROS Mapping",
                    options=base_mapping_options,
                    initial_value=base_mapping_initial,
                    hint="Choose how simulation wheel RPM is mapped before publishing /base/cmd_wheel_rpm.",
                )
                g.gui_t3_hardware_csv_path = client.gui.add_text(
                    "T3 CSV Path",
                    initial_value=os.environ.get("ARDY_T3_CSV_PATH", ""),
                    hint="CSV with T3 base, lift, and upper-body columns to stream directly to hardware.",
                )
                g.gui_t3_hardware_csv_segment = client.gui.add_number(
                    "T3 CSV Segment",
                    initial_value=int(os.environ.get("ARDY_T3_CSV_SEGMENT", "0")),
                    min=0,
                    max=100,
                    step=1,
                    hint="Which continuous motion segment to play when one CSV contains multiple recorded runs.",
                )
                g.gui_t3_hardware_csv_fps = client.gui.add_number(
                    "T3 CSV FPS",
                    initial_value=float(os.environ.get("ARDY_T3_CSV_FPS", "0.0")),
                    min=0.0,
                    max=200.0,
                    step=0.1,
                    hint="0 uses effective_send_fps/playback_speed from the CSV.",
                )
                g.gui_t3_hardware_base_button = client.gui.add_button("Play Base", color="blue")
                g.gui_t3_hardware_robot_button = client.gui.add_button("Play Robot", color="green")
                g.gui_t3_hardware_both_button = client.gui.add_button("Play Both", color="green")
                g.gui_t3_hardware_lift_button = client.gui.add_button("Play Lift", color="blue")
                g.gui_t3_hardware_base_lift_button = client.gui.add_button("Play Base + Lift", color="blue")
                g.gui_t3_hardware_robot_lift_button = client.gui.add_button("Play Robot + Lift", color="green")
                g.gui_t3_hardware_full_button = client.gui.add_button("Play Full T3", color="green")
                g.gui_t3_hardware_csv_robot_button = client.gui.add_button("Play CSV Robot", color="green")
                g.gui_t3_hardware_csv_full_button = client.gui.add_button("Play CSV Full T3", color="blue")
                g.gui_t3_hardware_stop_base_button = client.gui.add_button("Stop Base", color="orange")
                g.gui_t3_hardware_stop_robot_button = client.gui.add_button("Stop Robot", color="orange")
                g.gui_t3_hardware_stop_lift_button = client.gui.add_button("Stop Lift", color="orange")
                g.gui_t3_hardware_stop_both_button = client.gui.add_button("Stop Both", color="red")
                g.gui_t3_hardware_disconnect_button = client.gui.add_button("Disconnect T3 Stream", color="red")

                @g.gui_t3_hardware_base_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=True, robot=False, lift=False)

                @g.gui_t3_hardware_robot_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=False, robot=True, lift=False)

                @g.gui_t3_hardware_both_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=True, robot=True, lift=False)

                @g.gui_t3_hardware_lift_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=False, robot=False, lift=True)

                @g.gui_t3_hardware_base_lift_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=True, robot=False, lift=True)

                @g.gui_t3_hardware_robot_lift_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=False, robot=True, lift=True)

                @g.gui_t3_hardware_full_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_stream(event, client_id, base=True, robot=True, lift=True)

                @g.gui_t3_hardware_csv_robot_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_csv_stream(event, client_id, mode="robot")

                @g.gui_t3_hardware_csv_full_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._start_t3_hardware_csv_stream(event, client_id, mode="full")

                @g.gui_t3_hardware_stop_base_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._stop_t3_hardware_stream(event, client_id, base=True, robot=False, lift=False)

                @g.gui_t3_hardware_stop_robot_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._stop_t3_hardware_stream(event, client_id, base=False, robot=True, lift=False)

                @g.gui_t3_hardware_stop_lift_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._stop_t3_hardware_stream(event, client_id, base=False, robot=False, lift=True)

                @g.gui_t3_hardware_stop_both_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._stop_t3_hardware_stream(event, client_id, base=True, robot=True, lift=True)

                @g.gui_t3_hardware_disconnect_button.on_click
                def _(_: viser.GuiEvent) -> None:
                    self._disconnect_t3_hardware(client_id)

            @g.gui_viz_t3_robot_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                use_soma_t3 = bool(g.gui_viz_t3_soma_retarget_checkbox.value)
                show_csv_player = session.t3_csv_player is not None and not use_soma_t3
                if session.t3_live_retargeter is not None:
                    session.t3_live_retargeter.set_visible(g.gui_viz_t3_robot_checkbox.value and not show_csv_player)
                if session.t3_csv_player is not None:
                    session.t3_csv_player.set_visible(g.gui_viz_t3_robot_checkbox.value and show_csv_player)
                if g.gui_viz_t3_robot_checkbox.value and use_soma_t3:
                    self.request_soma_t3_retarget(client_id, force=True, start_frame=0)

            @g.gui_viz_t3_soma_retarget_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                if session.t3_csv_player is not None:
                    session.t3_csv_player.set_visible(False)
                    if g.gui_viz_t3_soma_retarget_checkbox.value:
                        session.t3_csv_player.clear()
                        session.t3_csv_player = None
                        session.t3_csv_player_generation = -1
                if g.gui_viz_t3_soma_retarget_checkbox.value:
                    self.request_soma_t3_retarget(client_id, force=True, start_frame=0)

            @g.gui_viz_t3_retarget_now_button.on_click
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                if session.t3_live_retargeter is not None:
                    session.t3_live_retargeter.clear()
                    session.t3_live_retargeter = None
                if session.t3_csv_player is not None:
                    session.t3_csv_player.clear()
                    session.t3_csv_player = None
                session.t3_csv_player_generation = -1
                with session.t3_retarget_lock:
                    session.t3_stream_rows = []
                    session.t3_retarget_packet_ranges = []
                    session.t3_retarget_packet_end_frames = []
                    session.t3_retarget_csv_end_frame = -1
                    session.t3_retarget_ready_generation = -1
                self.request_soma_t3_retarget(client_id, force=True, start_frame=0)

            @g.gui_viz_t3_packet_size.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                packet_size = max(1, int(g.gui_viz_t3_packet_size.value))
                session.t3_stream_packet_size = packet_size
                with session.t3_retarget_lock:
                    session.t3_stream_rows = []
                    session.t3_retarget_packet_ranges = []
                    session.t3_retarget_packet_end_frames = []
                    session.t3_retarget_csv_end_frame = -1
                    session.t3_retarget_ready_generation = -1
                    session.t3_retarget_pending_after_current = False
                    session.t3_retarget_pending_start_frame = None
                if g.gui_viz_t3_robot_checkbox.value and g.gui_viz_t3_soma_retarget_checkbox.value:
                    self.request_soma_t3_retarget(client_id, force=True, start_frame=0)

            @g.gui_viz_ref_motion_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                show = g.gui_viz_ref_motion_checkbox.value
                if session.ref_character is not None:
                    session.ref_character.set_skinned_mesh_visibility(show)
                    if session.ref_character.skeleton_mesh is not None:
                        session.ref_character.skeleton_mesh.set_visibility(False)
                elif show and session.ref_joints_pos is not None:
                    # Create reference character on first toggle
                    self._create_ref_character(client_id)

            @g.gui_viz_soma_mesh_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                show = g.gui_viz_soma_mesh_checkbox.value
                if session.soma_debug_character is not None:
                    session.soma_debug_character.set_skinned_mesh_visibility(show)
                    if session.soma_debug_character.skeleton_mesh is not None:
                        session.soma_debug_character.skeleton_mesh.set_visibility(False)

            g.gui_viz_hand_orientations_checkbox = client.gui.add_checkbox(
                "Show Hand+Foot Orientations",
                initial_value=False,
                hint="Show rotation axes for hand/wrist and foot joints in both EE constraints and generated motion",
            )
            g.gui_viz_hide_distant_constraints_checkbox = client.gui.add_checkbox(
                "Hide Distant Future Constraints",
                initial_value=False,
                hint="Hide constraints beyond future_crop + generate_horizon frames from current frame",
            )
            g.gui_viz_auto_camera_checkbox = client.gui.add_checkbox("Auto Camera Follow", initial_value=False)
            g.gui_viz_camera_type_dropdown = client.gui.add_dropdown(
                "Camera Type",
                options=["Over-the-shoulder", "Front-facing"],
                initial_value="Front-facing",
            )
            g.gui_show_timeline_checkbox = client.gui.add_checkbox(
                "Show Timeline",
                initial_value=True,
                hint="Show/hide the timeline strip at the bottom of the viewer",
            )
            g.gui_show_start_direction_checkbox = client.gui.add_checkbox(
                "Show Starting Direction",
                initial_value=True,
                hint="Show a blue marker at the initial position and facing direction",
            )
            g.gui_show_timeline_arrow_keys_checkbox = client.gui.add_checkbox(
                "Show Timeline Arrow Keys", initial_value=False
            )
            g.gui_arrow_key_position_dropdown = client.gui.add_dropdown(
                "Arrow Key Position",
                options=["bottom_center", "top_center"],
                initial_value="bottom_center",
            )

            # Camera controls
            client.gui.add_markdown("**Camera Control**")
            g.gui_viz_camera_fov_slider = client.gui.add_slider(
                "FOV (degrees)",
                min=20.0,
                max=120.0,
                step=1.0,
                initial_value=50.0,
                hint="Field of view in degrees",
            )
            g.gui_viz_camera_position = client.gui.add_vector3(
                "Position",
                initial_value=(0.0, 2.0, 5.0),
                step=0.1,
                hint="Camera position in world space",
            )
            g.gui_viz_camera_look_at = client.gui.add_vector3(
                "Look at",
                initial_value=(0.0, 1.0, 0.0),
                step=0.1,
                hint="Point the camera is looking at",
            )
            g.gui_viz_camera_up = client.gui.add_vector3(
                "Up direction",
                initial_value=(0.0, 1.0, 0.0),
                step=0.01,
                hint="Camera up direction vector",
            )
            g.gui_capture_camera_button = client.gui.add_button(
                "Capture Current Camera",
                hint="Capture the current camera view to the controls above",
            )
            g.gui_apply_camera_button = client.gui.add_button(
                "Apply Camera Settings",
                hint="Apply the camera settings from the controls above",
            )

            g.gui_camera_file_path = client.gui.add_text(
                "Camera File",
                initial_value=".cache/camera_params.json",
                hint="Path to save/load camera parameters",
            )
            g.gui_save_camera_button = client.gui.add_button(
                "Save Camera Parameters", hint="Save current camera parameters to file"
            )
            g.gui_load_camera_button = client.gui.add_button(
                "Load Camera Parameters", hint="Load camera parameters from file"
            )

            g.gui_dark_mode_checkbox = client.gui.add_checkbox("Dark Mode", initial_value=False)
            # Hidden from the sidebar: it still drives the theme, but the
            # toggle itself renders in the titlebar (see configure_theme).
            g.gui_dark_mode_checkbox.visible = False

            @g.gui_show_timeline_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                client = session.client
                # Same degrade-gracefully guard as gui/orchestrator.py:24-48 —
                # older viser builds without timeline support won't have this.
                if hasattr(client, "timeline"):
                    client.timeline.set_visible(g.gui_show_timeline_checkbox.value)
                else:
                    print("Timeline not available, cannot toggle visibility")

            @g.gui_show_start_direction_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                self._update_start_direction_marker(client_id)

            @g.gui_show_timeline_arrow_keys_checkbox.on_update
            def _(event: viser.GuiEvent) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                client = session.client
                show_timeline_arrow_keys = g.gui_show_timeline_arrow_keys_checkbox.value
                arrow_key_position = g.gui_arrow_key_position_dropdown.value
                client.timeline.configure_arrow_key_overlay(
                    enabled=show_timeline_arrow_keys, position=arrow_key_position
                )

            @g.gui_arrow_key_position_dropdown.on_update
            def _(event: viser.GuiEvent) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                client = session.client
                show_timeline_arrow_keys = g.gui_show_timeline_arrow_keys_checkbox.value
                arrow_key_position = g.gui_arrow_key_position_dropdown.value
                client.timeline.configure_arrow_key_overlay(
                    enabled=show_timeline_arrow_keys, position=arrow_key_position
                )

            @g.gui_viz_camera_fov_slider.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                fov_degrees = g.gui_viz_camera_fov_slider.value
                session.client.camera.fov = np.radians(fov_degrees)
                print(f"[Camera] FOV set to {fov_degrees}°")

            @g.gui_viz_camera_position.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                position = g.gui_viz_camera_position.value
                session.client.camera.position = np.array(position, dtype=np.float64)
                print(f"[Camera] Position set to {position}")

            @g.gui_viz_camera_look_at.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                look_at = g.gui_viz_camera_look_at.value
                session.client.camera.look_at = np.array(look_at, dtype=np.float64)
                print(f"[Camera] Look at set to {look_at}")

            @g.gui_viz_camera_up.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                up = g.gui_viz_camera_up.value
                session.client.camera.up_direction = np.array(up, dtype=np.float64)
                print(f"[Camera] Up direction set to {up}")

            @g.gui_capture_camera_button.on_click
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                camera = session.client.camera
                # Capture current camera state to GUI
                g.gui_viz_camera_fov_slider.value = float(np.degrees(camera.fov))
                g.gui_viz_camera_position.value = tuple(float(x) for x in camera.position)
                g.gui_viz_camera_look_at.value = tuple(float(x) for x in camera.look_at)
                g.gui_viz_camera_up.value = tuple(float(x) for x in camera.up_direction)
                print("[Camera] Captured current camera state")
                session.client.add_notification(
                    title="Camera captured",
                    body="Current camera view saved to controls",
                    auto_close_seconds=2.0,
                    color="green",
                )

            @g.gui_apply_camera_button.on_click
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                # Apply all camera settings
                fov_degrees = g.gui_viz_camera_fov_slider.value
                position = g.gui_viz_camera_position.value
                look_at = g.gui_viz_camera_look_at.value
                up = g.gui_viz_camera_up.value

                session.client.camera.fov = np.radians(fov_degrees)
                session.client.camera.position = np.array(position, dtype=np.float64)
                session.client.camera.look_at = np.array(look_at, dtype=np.float64)
                session.client.camera.up_direction = np.array(up, dtype=np.float64)

                print(f"[Camera] Applied settings - FOV: {fov_degrees}°, Pos: {position}, Look at: {look_at}, Up: {up}")
                session.client.add_notification(
                    title="Camera applied",
                    body="Camera settings applied to view",
                    auto_close_seconds=2.0,
                    color="green",
                )

            @g.gui_save_camera_button.on_click
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                filepath = g.gui_camera_file_path.value

                # Get current camera parameters from GUI controls
                camera_params = {
                    "fov_degrees": float(g.gui_viz_camera_fov_slider.value),
                    "position": list(g.gui_viz_camera_position.value),
                    "look_at": list(g.gui_viz_camera_look_at.value),
                    "up": list(g.gui_viz_camera_up.value),
                }

                try:
                    # Create directory if it doesn't exist
                    import os

                    os.makedirs(os.path.dirname(filepath), exist_ok=True)

                    # Save to JSON file
                    with open(filepath, "w") as f:
                        json.dump(camera_params, f, indent=2)

                    print(f"[Camera] Saved camera parameters to {filepath}")
                    session.client.add_notification(
                        title="Camera saved",
                        body=f"Parameters saved to {filepath}",
                        auto_close_seconds=3.0,
                        color="green",
                    )
                except Exception as e:
                    print(f"[Camera] Error saving camera parameters: {e}")
                    session.client.add_notification(
                        title="Save failed",
                        body=f"Error: {str(e)}",
                        auto_close_seconds=5.0,
                        color="red",
                    )

            @g.gui_load_camera_button.on_click
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                filepath = g.gui_camera_file_path.value

                try:
                    # Load from JSON file
                    with open(filepath, "r") as f:
                        camera_params = json.load(f)

                    # Update GUI controls
                    g.gui_viz_camera_fov_slider.value = float(camera_params["fov_degrees"])
                    g.gui_viz_camera_position.value = tuple(camera_params["position"])
                    g.gui_viz_camera_look_at.value = tuple(camera_params["look_at"])
                    g.gui_viz_camera_up.value = tuple(camera_params["up"])

                    # Apply to camera
                    session.client.camera.fov = np.radians(camera_params["fov_degrees"])
                    session.client.camera.position = np.array(camera_params["position"], dtype=np.float64)
                    session.client.camera.look_at = np.array(camera_params["look_at"], dtype=np.float64)
                    session.client.camera.up_direction = np.array(camera_params["up"], dtype=np.float64)

                    print(f"[Camera] Loaded camera parameters from {filepath}")
                    session.client.add_notification(
                        title="Camera loaded",
                        body=f"Parameters loaded from {filepath}",
                        auto_close_seconds=3.0,
                        color="green",
                    )
                except FileNotFoundError:
                    print(f"[Camera] File not found: {filepath}")
                    session.client.add_notification(
                        title="Load failed",
                        body=f"File not found: {filepath}",
                        auto_close_seconds=5.0,
                        color="red",
                    )
                except Exception as e:
                    print(f"[Camera] Error loading camera parameters: {e}")
                    session.client.add_notification(
                        title="Load failed",
                        body=f"Error: {str(e)}",
                        auto_close_seconds=5.0,
                        color="red",
                    )

            @g.gui_dark_mode_checkbox.on_update
            def _(_) -> None:
                self.configure_theme(
                    client,
                    dark_mode=g.gui_dark_mode_checkbox.value,
                    dark_mode_checkbox_uuid=g.gui_dark_mode_checkbox.uuid,
                )
                if self.client_active(client_id):
                    session = self.client_sessions[client_id]
                    with session.characters_lock:
                        for character in session.characters.values():
                            character.change_theme(g.gui_dark_mode_checkbox.value)

            @g.gui_viz_skeleton_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                g.gui_viz_foot_contacts_checkbox.visible = g.gui_viz_skeleton_checkbox.value
                if not g.gui_viz_skeleton_checkbox.value:
                    g.gui_viz_foot_contacts_checkbox.value = False
                with session.characters_lock:
                    for character in session.characters.values():
                        character.set_skeleton_visibility(g.gui_viz_skeleton_checkbox.value)

            @g.gui_viz_foot_contacts_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                with session.characters_lock:
                    for character in session.characters.values():
                        character.set_show_foot_contacts(g.gui_viz_foot_contacts_checkbox.value)
                if session.frame_idx >= 0:
                    self.set_frame(client_id, session.frame_idx)

            @g.gui_viz_hand_orientations_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]

                if g.gui_viz_hand_orientations_checkbox.value:
                    # Create hand gizmos for all characters
                    self.create_hand_gizmos(client_id)
                    # Update them to current frame
                    if session.frame_idx >= 0:
                        self.update_hand_gizmos(client_id, session.frame_idx)
                else:
                    # Hide hand gizmos
                    self.set_hand_gizmos_visibility(client_id, False)

                # Update EE constraint rotation axes visibility
                if "End-Effectors" in session.constraints:
                    ee_constraint = session.constraints["End-Effectors"]
                    for constraint_frame_idx in ee_constraint.scene_elements.keys():
                        # Only update visibility if the constraint is already visible
                        visibility = constraint_frame_idx >= session.frame_idx if session.frame_idx >= 0 else True
                        ee_constraint.set_keyframe_visibility(
                            constraint_frame_idx,
                            visibility,
                            show_rotation_axes=g.gui_viz_hand_orientations_checkbox.value,
                        )

            @g.gui_viz_hide_distant_constraints_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                # Trigger a frame update to refresh constraint visibility
                if session.frame_idx >= 0:
                    self.set_frame(client_id, session.frame_idx)

            @g.gui_viz_auto_camera_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                # Reset camera state when toggling to allow smooth start
                session.camera_position = None
                session.camera_look_at = None
                session.camera_forward_direction = None
                session.camera_position_buffer.clear()
                session.camera_last_update_frame = -1
                if g.gui_viz_auto_camera_checkbox.value:
                    # Immediately update camera when enabled
                    self.update_camera_follow(client_id, session.frame_idx)

            @g.gui_viz_camera_type_dropdown.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                # Reset camera smoothing when changing camera type
                session.camera_position = None
                session.camera_look_at = None
                session.camera_forward_direction = None
                session.camera_position_buffer.clear()
                if g.gui_viz_auto_camera_checkbox.value:
                    # Immediately update camera with new type
                    self.update_camera_follow(client_id, session.frame_idx)

            @g.gui_viz_skinned_mesh_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                with session.characters_lock:
                    for character in session.characters.values():
                        character.set_skinned_mesh_visibility(g.gui_viz_skinned_mesh_checkbox.value)

            @g.gui_viz_skinned_mesh_opacity_slider.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                with session.characters_lock:
                    for character in session.characters.values():
                        character.set_skinned_mesh_opacity(g.gui_viz_skinned_mesh_opacity_slider.value)

        #
        # Model tab
        #
