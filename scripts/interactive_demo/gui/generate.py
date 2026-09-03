# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Interactive-demo GUI: Generate tab (split from create_gui)."""

import re

from ardy.retail_rack_route import normalize_rack_name, rack_shelf_object_position

from ..common import *  # noqa: F401,F403
from ..environments import DEFAULT_ENVIRONMENT_LABEL


class GuiGenerateMixin:
    def _set_rack_route_visible(self, g, environment_label: str) -> None:
        """Show rack-route motion controls only for the retail-store environment."""
        visible = environment_label == DEFAULT_ENVIRONMENT_LABEL
        rack_route_folder = getattr(g, "gui_rack_route_folder", None)
        if rack_route_folder is not None:
            try:
                rack_route_folder.visible = visible
            except AttributeError:
                pass
        for handle_name in (
            "gui_source_rack_route_dropdown",
            "gui_rack_route_dropdown",
            "gui_apply_rack_route_button",
            "gui_return_rack_route_button",
            "gui_rack_to_rack_route_button",
            "gui_rack_pick_shelf_dropdown",
            "gui_rack_pick_object_dropdown",
            "gui_rack_pick_button",
            "gui_kimodo_pick_status_md",
            "gui_kimodo_pick_command_text",
            "gui_kimodo_pick_apply_command_button",
            "gui_kimodo_pick_configure_button",
            "gui_kimodo_pick_run_button",
            "gui_kimodo_pick_enabled_checkbox",
            "gui_kimodo_pick_spacebar_checkbox",
            "gui_kimodo_pick_go_rack_button",
            "gui_kimodo_pick_confirm_button",
            "gui_kimodo_pick_sample_button",
        ):
            handle = getattr(g, handle_name, None)
            if handle is not None:
                handle.visible = visible

    def _parse_kimodo_pick_command(self, command: str, g) -> tuple[str, int, int, str]:
        """Parse commands like 'pick item on rack1 shelf 4 object 2'."""
        text = command.strip().lower().replace("-", " ")
        rack_match = re.search(r"\brack\s*_?\s*([1-4])\b", text)
        shelf_match = re.search(r"\bshelf\s*([1-5])\b", text)
        object_match = re.search(r"\b(?:object|item|slot|product)\s*([1-3])\b", text)
        hand_match = re.search(r"\b(left|right)\s*hand\b|\bhand\s*(left|right)\b", text)

        if rack_match is None or shelf_match is None:
            raise ValueError("Command needs a rack and shelf, for example: pick item on rack1 shelf 4 object 2")

        rack_name = normalize_rack_name(f"rack_{rack_match.group(1)}")
        shelf_number = int(shelf_match.group(1))
        object_index = int(object_match.group(1)) if object_match else int(g.gui_rack_pick_object_dropdown.value)
        hand_side = "right"
        if hand_match is not None:
            hand_side = next(group for group in hand_match.groups() if group is not None)
        return rack_name, shelf_number, object_index, hand_side

    def _update_kimodo_pick_target_marker(
        self,
        client_id: int,
        rack_name: str,
        shelf_number: int,
        object_index: int,
    ) -> None:
        """Highlight the currently selected pick target in the Viser scene."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        handles = getattr(session, "kimodo_pick_target_handles", [])
        for handle in handles:
            try:
                handle.remove()
            except Exception:
                pass

        position = np.asarray(
            rack_shelf_object_position(rack_name, shelf_number, object_index),
            dtype=np.float64,
        )
        marker_root = f"/kimodo_pick_target/{rack_name}/shelf_{shelf_number}/object_{object_index}"
        session.kimodo_pick_target_handles = [
            session.client.scene.add_box(
                f"{marker_root}/marker",
                dimensions=(0.11, 0.11, 0.11),
                color=(255, 220, 40),
                position=position,
            ),
            session.client.scene.add_label(
                f"{marker_root}/label",
                text=f"{rack_name} S{shelf_number} O{object_index}",
                position=position + np.array([0.0, 0.16, 0.0], dtype=np.float64),
                anchor="center-center",
            ),
        ]

    def _configure_kimodo_pick_workflow(
        self,
        g,
        client_id: int | None = None,
        *,
        rack_name: str | None = None,
        shelf_number: int | None = None,
        object_index: int | None = None,
        hand_side: str = "right",
    ) -> None:
        """Set the GUI to the Kimodo rack-pick BVH hands-only preset."""
        rack_name = normalize_rack_name(rack_name or str(g.gui_rack_route_dropdown.value))
        shelf_number = int(shelf_number if shelf_number is not None else g.gui_rack_pick_shelf_dropdown.value)
        object_index = int(object_index if object_index is not None else g.gui_rack_pick_object_dropdown.value)

        g.gui_rack_route_dropdown.value = rack_name
        g.gui_rack_pick_shelf_dropdown.value = str(shelf_number)
        g.gui_rack_pick_object_dropdown.value = str(object_index)
        g.gui_motion_file_path.value = KIMODO_PICK_MOTION_FILE_PATH
        g.gui_constraint_frame_indices.value = KIMODO_PICK_CONSTRAINT_FRAMES
        g.gui_constraint_fullbody_checkbox.value = False
        g.gui_constraint_hands_checkbox.value = True
        g.gui_constraint_forearm_orientation_checkbox.value = False
        g.gui_constraint_hand_only_motion_checkbox.value = True
        g.gui_constraint_feet_checkbox.value = False
        g.gui_constraint_hands_feet_checkbox.value = False
        g.gui_constraint_2d_waypoints_checkbox.value = False
        g.gui_constraint_2d_trajectory_checkbox.value = False
        g.gui_continue_from_current_checkbox.value = False
        # Deterministic Constraint Frames override random sampling, so Max
        # Keyframes can remain whatever the user already has.
        g.gui_kimodo_pick_status_md.content = (
            f"**Kimodo rack pick:** target `{rack_name}` shelf `{shelf_number}` object `{object_index}`. "
            f"Hand `{hand_side}`. Press `Run Pick Command` or Space."
        )
        if client_id is not None:
            self._update_kimodo_pick_target_marker(client_id, rack_name, shelf_number, object_index)

    def _wait_for_route_generation(self, client_id: int, timeout_s: float = 120.0) -> bool:
        """Wait until the route task has enough generated frames for the final rack pose."""
        start_time = time.time()
        while time.time() - start_time < timeout_s:
            if not self.client_active(client_id):
                return False
            session = self.client_sessions[client_id]
            target = session.task_end_frame_idx
            if target is None:
                return session.max_frame_idx >= 0
            if not session.task_generation_pending and session.max_frame_idx >= target:
                self.set_frame(client_id, target)
                return True
            if not session.replan_lock.locked():
                self.on_replan_trigger(client_id, skip_if_busy=True)
            time.sleep(0.05)
        return False

    def _start_task_playback(self, client_id: int) -> None:
        """Start non-realtime task playback and keep the playback buttons in sync."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        session.realtime_mode = False
        session.playing = True
        session.play_once = True
        session.gui_elements.gui_realtime_mode_checkbox.value = False
        session.gui_elements.gui_play_pause_button.label = "Pause"
        session.gui_elements.gui_next_frame_button.disabled = True
        session.gui_elements.gui_prev_frame_button.disabled = True

    def _wait_for_route_playback(self, client_id: int, timeout_s: float = 180.0) -> bool:
        """Wait until route playback reaches the final rack pose."""
        start_time = time.time()
        while time.time() - start_time < timeout_s:
            if not self.client_active(client_id):
                return False
            session = self.client_sessions[client_id]
            target = session.task_end_frame_idx
            if target is None:
                return session.max_frame_idx >= 0
            if session.frame_idx >= target and not session.task_generation_pending and session.max_frame_idx >= target:
                session.playing = False
                session.play_once = False
                session.gui_elements.gui_play_pause_button.label = "Play"
                return True
            if (
                session.frame_idx >= session.max_frame_idx
                and session.task_generation_pending
                and not session.replan_lock.locked()
            ):
                self.on_replan_trigger(client_id, skip_if_busy=True)
            time.sleep(0.1)
        return False

    def _run_kimodo_pick_command_workflow(self, client_id: int) -> None:
        """Parse the command, generate the rack route, then pick from the route's final pose."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client
        g = session.gui_elements
        if getattr(g.gui_kimodo_pick_run_button, "disabled", False):
            return

        try:
            rack_name, shelf_number, object_index, hand_side = self._parse_kimodo_pick_command(
                str(g.gui_kimodo_pick_command_text.value),
                g,
            )
        except Exception as e:
            client.add_notification(
                title="Could not parse pick command",
                body=str(e),
                color="red",
                auto_close_seconds=5.0,
            )
            return

        self._configure_kimodo_pick_workflow(
            g,
            client_id,
            rack_name=rack_name,
            shelf_number=shelf_number,
            object_index=object_index,
            hand_side=hand_side,
        )
        g.gui_kimodo_pick_run_button.disabled = True
        g.gui_kimodo_pick_status_md.content = (
            f"**Kimodo rack pick:** running `{rack_name}` shelf `{shelf_number}` object `{object_index}` "
            f"with `{hand_side}` hand. Generating route first..."
        )
        progress = client.add_notification(
            title="Kimodo Pick Command",
            body=f"Going to {rack_name}, shelf {shelf_number}, object {object_index}.",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            self.apply_rack_route(client_id, rack_name)
            progress.body = "Playing route to the rack..."
            self._start_task_playback(client_id)
            client.flush()
            if not self._wait_for_route_playback(client_id):
                raise RuntimeError("Timed out waiting for rack route playback to reach the final pose.")

            session = self.client_sessions[client_id]
            route_final_frame = session.task_end_frame_idx if session.task_end_frame_idx is not None else session.max_frame_idx
            self.set_frame(client_id, min(route_final_frame, session.max_frame_idx))
            progress.body = "Applying BVH hand-only constraints from the final rack pose..."
            client.flush()
            self._sample_kimodo_pick_constraints(
                client_id,
                continue_from_current=True,
                hand_side=hand_side,
            )
            self._start_task_playback(client_id)

            g.gui_kimodo_pick_status_md.content = (
                f"**Kimodo rack pick:** BVH constraints applied from the last `{rack_name}` pose for shelf "
                f"`{shelf_number}` object `{object_index}` using `{hand_side}` hand."
            )
            progress.title = "Kimodo pick complete"
            progress.body = "Route played, then the BVH hand pick was applied automatically."
            progress.color = "green"
        except Exception as e:
            g.gui_kimodo_pick_status_md.content = f"**Kimodo rack pick failed:** {e}"
            progress.title = "Kimodo pick failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            g.gui_kimodo_pick_run_button.disabled = False
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 7.0

    def _sample_kimodo_pick_constraints(
        self,
        client_id: int,
        *,
        continue_from_current: bool = False,
        hand_side: str = "right",
    ) -> None:
        """Load the configured BVH and add hand-only constraints to the Viser timeline."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client
        g = session.gui_elements

        self._configure_kimodo_pick_workflow(
            g,
            client_id,
            rack_name=str(g.gui_rack_route_dropdown.value),
            shelf_number=int(g.gui_rack_pick_shelf_dropdown.value),
            object_index=int(g.gui_rack_pick_object_dropdown.value),
            hand_side=hand_side,
        )

        if session.motion_rep is None:
            client.add_notification(
                title="No model loaded",
                body="Please load a model first.",
                color="red",
                auto_close_seconds=4.0,
            )
            return

        file_path = g.gui_motion_file_path.value.strip()
        if not os.path.exists(file_path):
            client.add_notification(
                title="Pick BVH not found",
                body=file_path,
                color="red",
                auto_close_seconds=5.0,
            )
            return

        progress = client.add_notification(
            title="Kimodo BVH Pick",
            body="Loading BVH and sampling hand constraints...",
            loading=True,
            with_close_button=False,
        )
        client.flush()

        try:
            seq_data = self.load_motion_from_file(file_path, session, crop_10s=False)
            constraint_type = "Right Hand" if hand_side == "right" else "Left Hand"
            self.load_sequence(
                client_id,
                seq_data,
                constraint_types=[constraint_type],
                continue_from_current=continue_from_current,
                update_text=bool(seq_data.get("text")),
            )
            g.gui_viz_ref_motion_checkbox.value = True
            if session.ref_joints_pos is not None:
                self._create_ref_character(client_id)

            g.gui_kimodo_pick_status_md.content = (
                f"**Kimodo rack pick:** `{g.gui_rack_route_dropdown.value}` shelf "
                f"`{g.gui_rack_pick_shelf_dropdown.value}` object `{g.gui_rack_pick_object_dropdown.value}`. "
                "BVH hand constraints sampled on frames "
                f"`{KIMODO_PICK_CONSTRAINT_FRAMES}`. Only `{constraint_type}` and `Hand Only Motion` are enabled."
            )
            progress.title = "Kimodo pick ready"
            progress.body = "Hands-only BVH constraints are visible in Viser. Generate or play the motion."
            progress.color = "green"
        except Exception as e:
            progress.title = "Kimodo pick failed"
            progress.body = str(e)
            progress.color = "red"
            raise
        finally:
            progress.loading = False
            progress.with_close_button = True
            progress.auto_close_seconds = 6.0

    def _build_generate_tab(self, client, client_id, tab_group, g, timeline, default_prompt):
        with tab_group.add_tab("Generate", viser.Icon.WALK):
            g.gui_restart_button = client.gui.add_button("Restart", color="orange")
            g.gui_restart_from_now_button = client.gui.add_button(
                "Restart From Now",
                icon=viser.Icon.PLAYER_SKIP_FORWARD,
                color="green",
            )

            g.gui_clear_all_constraints_button = client.gui.add_button("Clear All Constraints", color="red")

            @g.gui_clear_all_constraints_button.on_click
            def _(event: viser.GuiEvent) -> None:
                self.clear_constraints(event.client.client_id)

            # Initial Body Transform folder
            with client.gui.add_folder("Initial Body Transform", expand_by_default=False):
                g.gui_show_transform_gizmo_checkbox = client.gui.add_checkbox(
                    "Show Transform Gizmo",
                    initial_value=False,
                    hint="Show/hide the transform control gizmo for initial body pose",
                )
                g.gui_reset_transform_button = client.gui.add_button("Reset Transform")

                @g.gui_show_transform_gizmo_checkbox.on_update
                def _(_) -> None:
                    if not self.client_active(client_id):
                        return
                    session = self.client_sessions[client_id]
                    if session.transform_gizmo is not None:
                        session.transform_gizmo.visible = g.gui_show_transform_gizmo_checkbox.value

                @g.gui_reset_transform_button.on_click
                def _(_) -> None:
                    if not self.client_active(client_id):
                        return
                    session = self.client_sessions[client_id]

                    # Reset to origin and zero heading. Must stay a numpy array:
                    # the fresh-generation path feeds it to torch.from_numpy.
                    session.init_global_translation = np.zeros(3, dtype=np.float32)
                    session.init_first_heading_angle = 0.0

                    # Update gizmo position
                    if session.transform_gizmo is not None:
                        session.transform_gizmo.position = (0.0, 0.0, 0.0)
                        session.transform_gizmo.wxyz = viser.transforms.SO3.from_y_radians(0.0).wxyz

                    self._update_start_direction_marker(client_id)

                    client.add_notification(
                        title="Transform Reset",
                        body="Initial body transform reset to origin",
                        auto_close_seconds=2.0,
                    )

            # Constraints and Keyframe loading from file
            with client.gui.add_folder("Constraints", expand_by_default=False):
                # Motion file path for constraint loading
                default_motion_path = (
                    "datasets/bones-seed/g1/csv/230306/jog_ff_loop_180_R_001__A244.csv"
                    if "g1" in DEFAULT_MODEL_DIR
                    else "datasets/bones-seed/soma_uniform/bvh/230306/jog_ff_loop_180_R_001__A244.bvh"
                )
                g.gui_motion_file_path = client.gui.add_text(
                    "Motion File Path",
                    initial_value=default_motion_path,
                    hint="Path to BVH (soma) or CSV (g1) motion file for constraint sampling",
                )
                g.gui_random_motion_button = client.gui.add_button(
                    "Random Motion File",
                    hint="Pick a random motion file from datasets/bones-seed/",
                )

                @g.gui_random_motion_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    # Match the skeleton family of the *currently loaded* model.
                    # G1 models use the CSV subset, others use the BVH subset.
                    # Fall back to DEFAULT_MODEL_DIR if no model is loaded yet.
                    is_g1 = "g1" in DEFAULT_MODEL_DIR
                    session = self.client_sessions.get(client_id)
                    if session is not None and session.motion_rep is not None:
                        is_g1 = is_g1_skeleton(session.motion_rep.skeleton)
                    skeleton_key = "g1" if is_g1 else "soma"
                    candidates = self._bones_seed_paths_by_skeleton.get(skeleton_key, [])

                    if not candidates:
                        if event.client:
                            event.client.add_notification(
                                title="No motion files available",
                                body=("Metadata CSV missing or empty — see startup logs."),
                                color="red",
                                auto_close_seconds=3.0,
                            )
                        return

                    picked = random.choice(candidates)
                    g.gui_motion_file_path.value = picked
                    if event.client:
                        event.client.add_notification(
                            title="Random Motion File",
                            body=os.path.basename(picked),
                            color="blue",
                            auto_close_seconds=2.0,
                        )

                g.gui_crop_motion_checkbox = client.gui.add_checkbox(
                    "Crop to 10s",
                    initial_value=True,
                    hint="Randomly crop loaded motion to 10 seconds",
                )

                # Constraint type checkboxes
                g.gui_constraint_fullbody_checkbox = client.gui.add_checkbox("Full Body", initial_value=True)
                g.gui_constraint_hands_checkbox = client.gui.add_checkbox("Hands", initial_value=False)
                g.gui_constraint_forearm_orientation_checkbox = client.gui.add_checkbox(
                    "Forearm Orientation",
                    initial_value=False,
                    hint="When sampling hand constraints, also constrain matching forearm rotations.",
                )
                g.gui_constraint_hand_only_motion_checkbox = client.gui.add_checkbox(
                    "Hand Only Motion",
                    initial_value=True,
                    hint="Freeze root/body/feet after generation so only constrained arm chains move.",
                )
                g.gui_constraint_feet_checkbox = client.gui.add_checkbox("Feet", initial_value=False)
                g.gui_constraint_hands_feet_checkbox = client.gui.add_checkbox("Hands and Feet", initial_value=False)
                g.gui_constraint_2d_waypoints_checkbox = client.gui.add_checkbox(
                    "2D Root Waypoints", initial_value=False
                )
                g.gui_constraint_2d_trajectory_checkbox = client.gui.add_checkbox(
                    "2D Root Trajectory", initial_value=False
                )

                g.gui_max_keyframe_num = client.gui.add_number(
                    "Max Keyframes",
                    initial_value=1,
                    min=1,
                    max=20,
                    step=1,
                    hint="Maximum number of keyframes to sample from sequence",
                )
                g.gui_min_keyframe_gap = client.gui.add_number(
                    "Min Keyframe Gap",
                    initial_value=30,
                    min=0,
                    max=120,
                    step=1,
                    hint="Minimum frame gap for automatically sampled constraints.",
                )
                g.gui_motion_stretch = client.gui.add_number(
                    "Motion Stretch",
                    initial_value=1.0,
                    min=1.0,
                    max=5.0,
                    step=0.25,
                    hint="Automatically computed from Max Keyframes and Min Keyframe Gap.",
                )
                g.gui_motion_stretch.disabled = True
                g.gui_constraint_frame_indices = client.gui.add_text(
                    "Constraint Frames",
                    initial_value="",
                    hint=(
                        "Optional deterministic BVH frames, e.g. 0,38,52,64,84,end "
                        "or a Kimodo pick_constraints JSON path."
                    ),
                )

                g.gui_continue_from_current_checkbox = client.gui.add_checkbox(
                    "Continue from Current Frame",
                    initial_value=False,
                    hint="If enabled, transform loaded sequence to continue from current position and heading",
                )

                def update_motion_stretch_preview() -> None:
                    source_frames = 0
                    file_path = g.gui_motion_file_path.value.strip()
                    resolved_file_path = (
                        file_path
                        if os.path.isabs(file_path)
                        else os.path.join(REPO_ROOT, file_path)
                    )
                    try:
                        if file_path and os.path.exists(resolved_file_path):
                            ext = os.path.splitext(resolved_file_path)[1].lower()
                            if ext == ".bvh":
                                with open(resolved_file_path, "r", encoding="utf-8", errors="ignore") as f:
                                    for line in f:
                                        stripped = line.strip()
                                        if stripped.startswith("Frames:"):
                                            source_frames = int(stripped.split(":", 1)[1].strip())
                                            break
                            elif ext == ".csv":
                                with open(resolved_file_path, "r", encoding="utf-8", errors="ignore") as f:
                                    source_frames = max(0, sum(1 for _ in f) - 1)
                    except Exception:
                        source_frames = 0

                    if source_frames <= 1:
                        g.gui_motion_stretch.value = 1.0
                        return

                    if g.gui_crop_motion_checkbox.value and session.motion_rep is not None:
                        source_frames = min(source_frames, int(10.0 * session.motion_rep.fps))

                    max_keyframes = int(g.gui_max_keyframe_num.value)
                    min_gap = int(g.gui_min_keyframe_gap.value)
                    if max_keyframes <= 1 or min_gap <= 0:
                        g.gui_motion_stretch.value = 1.0
                        return

                    fps = float(session.motion_rep.fps) if session.motion_rep is not None else 20.0
                    reach_in_frames = round(2 * fps) if g.gui_continue_from_current_checkbox.value else 0
                    required_frames = reach_in_frames + (max_keyframes - 1) * min_gap + 1
                    stretch = max(1.0, (required_frames - 1) / (source_frames - 1))
                    g.gui_motion_stretch.value = min(float(g.gui_motion_stretch.max), round(stretch, 2))

                @g.gui_max_keyframe_num.on_update
                def _(_) -> None:
                    update_motion_stretch_preview()

                @g.gui_min_keyframe_gap.on_update
                def _(_) -> None:
                    update_motion_stretch_preview()

                @g.gui_continue_from_current_checkbox.on_update
                def _(_) -> None:
                    update_motion_stretch_preview()

                @g.gui_crop_motion_checkbox.on_update
                def _(_) -> None:
                    update_motion_stretch_preview()

                @g.gui_motion_file_path.on_update
                def _(_) -> None:
                    update_motion_stretch_preview()

                update_motion_stretch_preview()

                g.gui_load_seq_button = client.gui.add_button("Sample Constraints", color="green")

                @g.gui_load_seq_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    if not self.client_active(client_id):
                        return
                    session = self.client_sessions[client_id]

                    if session.motion_rep is None:
                        if event.client:
                            event.client.add_notification(
                                title="No model loaded",
                                body="Please load a model first.",
                                color="red",
                            )
                        return

                    file_path = g.gui_motion_file_path.value.strip()
                    if not skeleton_supports_constraint_sampling(session.motion_rep.skeleton) and not file_path.lower().endswith(
                        ".bvh"
                    ):
                        if event.client:
                            event.client.add_notification(
                                title="No dataset for this skeleton",
                                body=(
                                    "The Core skeleton has no companion dataset for "
                                    "constraint sampling. Load a G1 model to use "
                                    "this feature."
                                ),
                                color="orange",
                                auto_close_seconds=4.0,
                            )
                        return

                    # Load motion from file path
                    if not file_path:
                        if event.client:
                            event.client.add_notification(
                                title="No file path",
                                body="Please enter a motion file path.",
                                color="red",
                            )
                        return

                    if not os.path.exists(file_path):
                        if event.client:
                            event.client.add_notification(
                                title="File not found",
                                body=f"Motion file not found: {file_path}",
                                color="red",
                            )
                        return

                    t_start = time.time()

                    try:
                        seq_data = self.load_motion_from_file(
                            file_path, session, crop_10s=g.gui_crop_motion_checkbox.value
                        )
                    except Exception as e:
                        if event.client:
                            event.client.add_notification(
                                title="Error loading motion",
                                body=f"Failed to load motion: {str(e)}",
                                color="red",
                            )
                        import traceback

                        traceback.print_exc()
                        return

                    # Collect selected constraint types
                    constraint_types = []
                    if g.gui_constraint_fullbody_checkbox.value:
                        constraint_types.append("Full Body")
                    if g.gui_constraint_hands_checkbox.value:
                        constraint_types.append("Hands")
                    if g.gui_constraint_feet_checkbox.value:
                        constraint_types.append("Feet")
                    if g.gui_constraint_hands_feet_checkbox.value:
                        constraint_types.append("Hands and Feet")
                    if g.gui_constraint_2d_waypoints_checkbox.value:
                        constraint_types.append("2D Root Waypoints")
                    if g.gui_constraint_2d_trajectory_checkbox.value:
                        constraint_types.append("2D Root Trajectory")

                    if len(constraint_types) == 0:
                        if event.client:
                            event.client.add_notification(
                                title="No constraint types selected",
                                body="Please select at least one constraint type.",
                                color="red",
                            )
                        return

                    continue_from_current = g.gui_continue_from_current_checkbox.value
                    try:
                        self.load_sequence(
                            client_id,
                            seq_data,
                            constraint_types=constraint_types,
                            continue_from_current=continue_from_current,
                            update_text=bool(seq_data.get("text")),
                        )
                    except Exception as e:
                        if event.client:
                            event.client.add_notification(
                                title="Error sampling constraints",
                                body=str(e),
                                color="red",
                            )
                        import traceback

                        traceback.print_exc()
                        return

                    elapsed = time.time() - t_start
                    if event.client:
                        mode_str = "continued from" if continue_from_current else "loaded"
                        constraint_str = ", ".join(constraint_types)
                        event.client.add_notification(
                            title="Constraints Sampled",
                            body=f"{mode_str.title()} from {os.path.basename(file_path)} with {constraint_str} ({elapsed:.2f}s)",
                            auto_close_seconds=3.0,
                            color="green",
                        )

            # Waypoint controls
            with client.gui.add_folder("Rack Route", expand_by_default=True) as rack_route_folder:
                g.gui_rack_route_folder = rack_route_folder
                g.gui_source_rack_route_dropdown = client.gui.add_dropdown(
                    "Source Rack",
                    options=("rack_1", "rack_2", "rack_3", "rack_4"),
                    initial_value="rack_1",
                    hint="Start rack for rack-to-rack motion",
                )
                g.gui_rack_route_dropdown = client.gui.add_dropdown(
                    "Target Rack",
                    options=("rack_1", "rack_2", "rack_3", "rack_4"),
                    initial_value="rack_2",
                    hint="Generate a constraints-only origin-to-rack route for the mesh human",
                )
                g.gui_apply_rack_route_button = client.gui.add_button(
                    "Go To Rack",
                    color="green",
                )
                g.gui_return_rack_route_button = client.gui.add_button(
                    "Return To Origin",
                    color="blue",
                )
                g.gui_rack_to_rack_route_button = client.gui.add_button(
                    "Rack To Rack",
                    color="orange",
                )
                g.gui_rack_pick_shelf_dropdown = client.gui.add_dropdown(
                    "Pick Shelf",
                    options=("1", "2", "3", "4", "5"),
                    initial_value="4",
                    hint="Shelf number on the target rack",
                )
                g.gui_rack_pick_object_dropdown = client.gui.add_dropdown(
                    "Pick Object",
                    options=("1", "2", "3"),
                    initial_value="2",
                    hint="Object slot on the selected shelf",
                )
                g.gui_rack_pick_button = client.gui.add_button(
                    "Pick Item",
                    color="blue",
                )

                @g.gui_apply_rack_route_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    threading.Thread(
                        target=self.apply_rack_route,
                        args=(
                            client_id,
                            str(g.gui_rack_route_dropdown.value),
                        ),
                        daemon=True,
                    ).start()

                @g.gui_return_rack_route_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    threading.Thread(
                        target=self.apply_rack_route,
                        args=(
                            client_id,
                            str(g.gui_rack_route_dropdown.value),
                        ),
                        kwargs={"return_to_origin": True},
                        daemon=True,
                    ).start()

                @g.gui_rack_to_rack_route_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    threading.Thread(
                        target=self.apply_rack_route,
                        args=(
                            client_id,
                            str(g.gui_rack_route_dropdown.value),
                        ),
                        kwargs={
                            "source_rack_name": str(g.gui_source_rack_route_dropdown.value),
                        },
                        daemon=True,
                    ).start()

                @g.gui_rack_pick_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    threading.Thread(
                        target=self.apply_rack_pick,
                        args=(
                            client_id,
                            str(g.gui_rack_route_dropdown.value),
                            int(g.gui_rack_pick_shelf_dropdown.value),
                            int(g.gui_rack_pick_object_dropdown.value),
                        ),
                        daemon=True,
                    ).start()

            with client.gui.add_folder("Kimodo Rack Pick Workflow", expand_by_default=True):
                g.gui_kimodo_pick_status_md = client.gui.add_markdown(
                    "**Kimodo rack pick:** type a command, then run it. The program routes to the rack and applies a shelf-aware hand-only pick from the final rack pose."
                )
                g.gui_kimodo_pick_command_text = client.gui.add_text(
                    "Pick Command",
                    initial_value="pick item on rack1 shelf 4 object 2",
                    hint="Examples: pick item on rack1 shelf 4, pick item from rack_3 shelf 2 object 1",
                )
                g.gui_kimodo_pick_apply_command_button = client.gui.add_button(
                    "Use Pick Command",
                    color="blue",
                )
                g.gui_kimodo_pick_configure_button = client.gui.add_button(
                    "Load BVH Pick Settings",
                    color="blue",
                )
                g.gui_kimodo_pick_run_button = client.gui.add_button(
                    "Run Pick Command",
                    color="green",
                )
                g.gui_kimodo_pick_enabled_checkbox = client.gui.add_checkbox(
                    "Enable Kimodo Workflow",
                    initial_value=False,
                    hint="When off, Kimodo workflow shortcuts are disabled and normal controls keep Space playback.",
                )
                g.gui_kimodo_pick_spacebar_checkbox = client.gui.add_checkbox(
                    "Space Runs Pick Command",
                    initial_value=False,
                    hint="Only works when Enable Kimodo Workflow is also on.",
                )
                g.gui_kimodo_pick_go_rack_button = client.gui.add_button(
                    "Manual 1 Go To Rack",
                    color="green",
                )
                g.gui_kimodo_pick_confirm_button = client.gui.add_button(
                    "Manual 2 Confirm Rack Reached",
                    color="orange",
                )
                g.gui_kimodo_pick_sample_button = client.gui.add_button(
                    "Manual 3 Sample BVH Pick",
                    color="green",
                    disabled=True,
                )

                @g.gui_kimodo_pick_apply_command_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    try:
                        rack_name, shelf_number, object_index, hand_side = self._parse_kimodo_pick_command(
                            str(g.gui_kimodo_pick_command_text.value),
                            g,
                        )
                        self._configure_kimodo_pick_workflow(
                            g,
                            client_id,
                            rack_name=rack_name,
                            shelf_number=shelf_number,
                            object_index=object_index,
                            hand_side=hand_side,
                        )
                    except Exception as e:
                        if event.client:
                            event.client.add_notification(
                                title="Could not parse pick command",
                                body=str(e),
                                color="red",
                                auto_close_seconds=5.0,
                            )
                        return

                    if event.client:
                        event.client.add_notification(
                            title="Pick command loaded",
                            body=f"{rack_name} shelf {shelf_number} object {object_index}, {hand_side} hand",
                            color="green",
                            auto_close_seconds=3.0,
                        )

                @g.gui_kimodo_pick_configure_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._configure_kimodo_pick_workflow(g, client_id)
                    if event.client:
                        event.client.add_notification(
                            title="Kimodo pick settings loaded",
                            body=(
                                f"{g.gui_rack_route_dropdown.value} shelf {g.gui_rack_pick_shelf_dropdown.value} "
                                f"object {g.gui_rack_pick_object_dropdown.value}"
                            ),
                            color="green",
                            auto_close_seconds=3.0,
                        )

                @g.gui_kimodo_pick_run_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    threading.Thread(
                        target=self._run_kimodo_pick_command_workflow,
                        args=(client_id,),
                        daemon=True,
                    ).start()

                @g.gui_kimodo_pick_go_rack_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self._configure_kimodo_pick_workflow(g, client_id)
                    g.gui_kimodo_pick_sample_button.disabled = True
                    g.gui_kimodo_pick_status_md.content = (
                        f"**Kimodo rack pick:** generating route to `{g.gui_rack_route_dropdown.value}`. "
                        "When it finishes visually, click `2 Confirm Rack Reached`."
                    )
                    threading.Thread(
                        target=self.apply_rack_route,
                        args=(client_id, str(g.gui_rack_route_dropdown.value)),
                        daemon=True,
                    ).start()

                @g.gui_kimodo_pick_confirm_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    g.gui_kimodo_pick_sample_button.disabled = False
                    g.gui_kimodo_pick_status_md.content = (
                        "**Kimodo rack pick:** rack position confirmed. "
                        "Click `3 Sample BVH Pick` to visualize the hands-only BVH constraints."
                    )
                    if event.client:
                        event.client.add_notification(
                            title="Rack confirmed",
                            body="BVH pick sampling is enabled.",
                            color="green",
                            auto_close_seconds=2.0,
                        )

                @g.gui_kimodo_pick_sample_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    threading.Thread(
                        target=self._sample_kimodo_pick_constraints,
                        args=(client_id,),
                        daemon=True,
                    ).start()

            with client.gui.add_folder("Waypoint", expand_by_default=False):
                g.gui_waypoint_mode_checkbox = client.gui.add_checkbox("Enable Waypoint Mode", initial_value=False)
                g.gui_dense_root_checkbox = client.gui.add_checkbox("Use Dense Root", initial_value=False)
                g.gui_waypoint_interval = client.gui.add_number(
                    "Waypoint Interval", initial_value=60, min=1, max=300, step=1
                )
                g.gui_one_meter_root_distance_cm = client.gui.add_number(
                    "Root Distance cm",
                    initial_value=100.0,
                    min=1.0,
                    max=500.0,
                    step=1.0,
                )
                g.gui_one_meter_root_duration_s = client.gui.add_number(
                    "Root Duration s",
                    initial_value=2.0,
                    min=0.5,
                    max=20.0,
                    step=0.1,
                )
                g.gui_one_meter_root_button = client.gui.add_button("Constrain Root Forward", color="blue")
                g.gui_one_meter_root_back_button = client.gui.add_button("Constrain Root Backward", color="orange")
                g.gui_root_turn_degrees = client.gui.add_number(
                    "Root Turn deg",
                    initial_value=90.0,
                    min=1.0,
                    max=360.0,
                    step=1.0,
                )
                g.gui_root_turn_duration_s = client.gui.add_number(
                    "Root Turn Duration s",
                    initial_value=2.0,
                    min=0.5,
                    max=20.0,
                    step=0.1,
                )
                g.gui_root_turn_left_button = client.gui.add_button("Constrain Turn Left", color="purple")
                g.gui_root_turn_right_button = client.gui.add_button("Constrain Turn Right", color="purple")
                g.gui_forward_left_forward_first_cm = client.gui.add_number(
                    "FLF First Forward cm",
                    initial_value=270.0,
                    min=1.0,
                    max=1000.0,
                    step=1.0,
                )
                g.gui_forward_left_forward_turn_degrees = client.gui.add_number(
                    "FLF Left Turn deg",
                    initial_value=90.0,
                    min=1.0,
                    max=360.0,
                    step=1.0,
                )
                g.gui_forward_left_forward_second_cm = client.gui.add_number(
                    "FLF Second Forward cm",
                    initial_value=500.0,
                    min=1.0,
                    max=1000.0,
                    step=1.0,
                )
                g.gui_forward_left_forward_button = client.gui.add_button(
                    "Constrain Forward Left Forward",
                    color="green",
                )

                @g.gui_one_meter_root_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self.apply_root_distance_constraint(
                        event.client.client_id,
                        float(g.gui_one_meter_root_distance_cm.value) / 100.0,
                        float(g.gui_one_meter_root_duration_s.value),
                    )

                @g.gui_one_meter_root_back_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self.apply_root_distance_constraint(
                        event.client.client_id,
                        float(g.gui_one_meter_root_distance_cm.value) / 100.0,
                        float(g.gui_one_meter_root_duration_s.value),
                        backward=True,
                    )

                @g.gui_root_turn_left_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self.apply_root_rotation_constraint(
                        event.client.client_id,
                        float(g.gui_root_turn_degrees.value),
                        float(g.gui_root_turn_duration_s.value),
                    )

                @g.gui_root_turn_right_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self.apply_root_rotation_constraint(
                        event.client.client_id,
                        float(g.gui_root_turn_degrees.value),
                        float(g.gui_root_turn_duration_s.value),
                        clockwise=True,
                    )

                @g.gui_forward_left_forward_button.on_click
                def _(event: viser.GuiEvent) -> None:
                    self.apply_forward_left_forward_constraint(
                        event.client.client_id,
                        float(g.gui_forward_left_forward_first_cm.value) / 100.0,
                        float(g.gui_forward_left_forward_turn_degrees.value),
                        float(g.gui_forward_left_forward_second_cm.value) / 100.0,
                    )

            with client.gui.add_folder("Target Velocity", expand_by_default=False):
                # Target root velocity control
                g.gui_use_target_velocity_checkbox = client.gui.add_checkbox("Use Target Velocity", initial_value=False)
                g.gui_target_root_velocity = client.gui.add_vector2(
                    "Target Root Velocity (xz)",
                    initial_value=(0.0, 0.0),
                    min=(-5.0, -5.0),
                    max=(5.0, 5.0),
                    step=0.001,
                    hint="Target 2D root velocity in XZ plane (forward/backward, left/right)",
                    disabled=True,  # Initially disabled until checkbox is checked
                )
                g.gui_use_target_heading_checkbox = client.gui.add_checkbox(
                    "Use Target Heading",
                    initial_value=False,
                    hint="If enabled, calculate root heading from target velocity direction",
                )

                # Flag to prevent infinite loop when loading velocity
                _loading_target_velocity = [False]

                @g.gui_target_root_velocity.on_update
                def _(_) -> None:
                    # Update target velocity arrow when value changes
                    # Skip if we're currently loading the velocity to avoid loop
                    if _loading_target_velocity[0]:
                        return
                    if not self.client_active(client.client_id):
                        return
                    session = self.client_sessions[client.client_id]
                    if session.target_velocity_arrow is not None and g.gui_use_target_velocity_checkbox.value:
                        # Trigger a frame update to refresh the arrow
                        self.set_frame(client.client_id, session.frame_idx)

                @g.gui_use_target_velocity_checkbox.on_update
                def _(_) -> None:
                    # Enable/disable target velocity input based on checkbox
                    g.gui_target_root_velocity.disabled = not g.gui_use_target_velocity_checkbox.value
                    # Update target velocity arrow visibility
                    if not self.client_active(client.client_id):
                        return
                    session = self.client_sessions[client.client_id]

                    # Target velocity and waypoint/dense-root are conflicting
                    # modes; turning on target velocity must disable the others
                    # (each set triggers its own on_update to keep state and
                    # visuals in sync — e.g. hides the click plane).
                    if g.gui_use_target_velocity_checkbox.value:
                        if g.gui_waypoint_mode_checkbox.value:
                            g.gui_waypoint_mode_checkbox.value = False
                        if g.gui_dense_root_checkbox.value:
                            g.gui_dense_root_checkbox.value = False

                    # Keep the timeline arrow-key overlay in sync, like the "t"
                    # shortcut does: driving the checkbox runs its on_update,
                    # which calls configure_arrow_key_overlay.
                    if g.gui_show_timeline_arrow_keys_checkbox.value != g.gui_use_target_velocity_checkbox.value:
                        g.gui_show_timeline_arrow_keys_checkbox.value = g.gui_use_target_velocity_checkbox.value

                    if g.gui_use_target_velocity_checkbox.value:
                        # When enabled, load current frame's root velocity
                        if (
                            session.root_velocities is not None
                            and session.frame_idx >= 0
                            and session.frame_idx < session.root_velocities.shape[1]
                        ):
                            # Get root velocity for first character at current frame
                            root_vel = session.root_velocities[0, session.frame_idx].cpu().numpy()
                            # Set flag to prevent the on_update callback from triggering
                            _loading_target_velocity[0] = True
                            g.gui_target_root_velocity.value = (
                                float(root_vel[0]),
                                float(root_vel[2]),
                            )
                            _loading_target_velocity[0] = False

                    if session.target_velocity_arrow is not None:
                        if not g.gui_use_target_velocity_checkbox.value:
                            # Hide arrow when disabled
                            session.target_velocity_arrow.set_visibility(False)
                        else:
                            # Trigger a frame update to show the arrow if enabled
                            self.set_frame(client.client_id, session.frame_idx)

            with client.gui.add_folder("Post Process", expand_by_default=False):
                g.gui_enable_postprocess_checkbox = client.gui.add_checkbox(
                    "Enable Post-Processing",
                    initial_value=False,
                    hint="Apply motion correction to reduce foot skating and improve quality",
                )
                g.gui_postprocess_root_margin = client.gui.add_slider(
                    "Root Margin",
                    min=0.0,
                    max=0.2,
                    step=0.01,
                    initial_value=0.04,
                    hint="Margin for root position correction (default: 0.04)",
                )
                g.gui_postprocess_contact_threshold = client.gui.add_slider(
                    "Contact Threshold",
                    min=0.0,
                    max=1.0,
                    step=0.05,
                    initial_value=0.5,
                    hint="Threshold for foot contact detection (default: 0.5)",
                )

            @g.gui_restart_button.on_click
            def _(event: viser.GuiEvent) -> None:
                self.restart(client_id)
                if event.client:
                    event.client.add_notification(
                        title="Restarted",
                        body="Scene has been reset.",
                        auto_close_seconds=2.0,
                        color="blue",
                    )

            @g.gui_restart_from_now_button.on_click
            def _(event: viser.GuiEvent) -> None:
                self.restart_from_now(client_id)
                if event.client:
                    event.client.add_notification(
                        title="Restarted From Now",
                        body=f"Cleared motion after frame {self.client_sessions[client_id].frame_idx} and triggered generation.",
                        auto_close_seconds=2.0,
                        color="blue",
                    )

            @g.gui_waypoint_mode_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                session.waypoint_mode = g.gui_waypoint_mode_checkbox.value
                # Toggle click plane visibility (clicks only register while visible)
                if session.click_plane is not None:
                    session.click_plane.visible = session.waypoint_mode

            @g.gui_dense_root_checkbox.on_update
            def _(_) -> None:
                if not self.client_active(client_id):
                    return
                session = self.client_sessions[client_id]
                session.constraints["2D Root"].set_dense_path(g.gui_dense_root_checkbox.value)
                session.constraints["2D Root"].set_smooth_path(g.gui_dense_root_checkbox.value)

        #
        # Visualization tab
        #
