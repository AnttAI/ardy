"""Wire generated T3 data to the real-hardware bridge."""

from __future__ import annotations

import csv
import json
import time
from pathlib import Path

from ..common import *  # noqa: F401,F403


class T3HardwareMixin:
    _T3_BASE_MAPPING_KEYS = {
        "Direct ROS [left, right]": "direct",
        "Kimodo/Tara [right, -left]": "kimodo_tara",
        "Swap only [right, left]": "swap",
        "Invert both [-left, -right]": "invert_both",
    }
    _T3_HARDWARE_MIN_BUFFER_FRAMES = 120

    def _ensure_t3_hardware_log_path(self, session) -> Path:
        if session.t3_hardware_log_path is None:
            log_dir = Path(REPO_ROOT) / "outputs" / "t3_hardware_logs"
            log_dir.mkdir(parents=True, exist_ok=True)
            stamp = time.strftime("%Y%m%d_%H%M%S")
            stem = f"client_{session.client.client_id}_{stamp}"
            session.t3_hardware_log_path = str(log_dir / f"{stem}.jsonl")
            session.t3_hardware_csv_log_path = str(log_dir / f"{stem}.csv")
        return Path(session.t3_hardware_log_path)

    def _ensure_t3_hardware_csv_log_path(self, session) -> Path:
        self._ensure_t3_hardware_log_path(session)
        return Path(session.t3_hardware_csv_log_path)

    def _append_t3_hardware_log(
        self,
        session,
        payload,
        stream_payload: dict[str, object] | None,
        *,
        sent_to_stream: bool,
        dry_run: bool,
    ) -> None:
        log_path = self._ensure_t3_hardware_log_path(session)
        csv_log_path = self._ensure_t3_hardware_csv_log_path(session)
        stream_payload = stream_payload if stream_payload is not None else payload.to_stream_payload()
        wall_time_s = time.time()
        previous_wall_time_s = session.t3_hardware_last_log_wall_time_s
        previous_frame_idx = session.t3_hardware_last_log_frame_idx
        send_dt_s = (
            ""
            if previous_wall_time_s is None
            else max(0.0, float(wall_time_s) - float(previous_wall_time_s))
        )
        session.t3_hardware_last_log_wall_time_s = wall_time_s
        session.t3_hardware_last_log_frame_idx = int(payload.frame_index)
        frame_delta = "" if previous_frame_idx is None else int(payload.frame_index) - int(previous_frame_idx)
        measured_send_fps = "" if send_dt_s == "" or send_dt_s <= 0.0 else 1.0 / send_dt_s
        playback_speed = max(float(getattr(session, "playback_speed", 1.0)), 0.05)
        native_fps = float(getattr(session, "model_fps", 30.0))
        effective_send_fps = native_fps * playback_speed
        record = {
            "wall_time_s": wall_time_s,
            "frame_index": int(payload.frame_index),
            "mode": payload.mode,
            "sent_to_stream": bool(sent_to_stream),
            "dry_run": bool(dry_run),
            "sent_to_real_hardware": bool(sent_to_stream) and not bool(dry_run),
            "native_fps": native_fps,
            "playback_speed": playback_speed,
            "effective_send_fps": effective_send_fps,
            "send_dt_s": send_dt_s,
            "measured_send_fps": measured_send_fps,
            "frame_delta": frame_delta,
            "stream_payload": stream_payload,
            "base_debug": payload.base_debug,
        }
        with log_path.open("a", encoding="utf-8") as f:
            f.write(json.dumps(record, separators=(",", ":")) + "\n")
        fieldnames = [
            "wall_time_s",
            "Frame",
            "frame_index",
            "mode",
            "sent_to_stream",
            "dry_run",
            "sent_to_real_hardware",
            "csv_segment_index",
            "native_fps",
            "playback_speed",
            "effective_send_fps",
            "send_dt_s",
            "measured_send_fps",
            "frame_delta",
            "base_frame_index",
            "base_frame_lead",
            "root_translateX",
            "root_translateY",
            "root_translateZ",
            "root_rotateX",
            "root_rotateY",
            "root_rotateZ",
            *[f"right_joint{i}_dof" for i in range(1, 8)],
            "right_gripper_joint1_dof",
            "right_gripper_joint2_dof",
            *[f"left_joint{i}_dof" for i in range(1, 8)],
            "left_gripper_joint1_dof",
            "left_gripper_joint2_dof",
            "telescopic_lift_joint_dof",
            "lift_hardware_frame",
            "lift_value_source_frame",
            "lift_hardware_value_cm",
            "time_s",
            "root_x_m",
            "root_y_m",
            "root_z_m",
            "root_yaw_rad",
            "root_yaw_deg",
            "step_ground_distance_m",
            "distance_from_start_m",
            "forward_velocity_m_s",
            "yaw_rate_rad_s",
            "left_wheel_rad_s",
            "right_wheel_rad_s",
            "base_mapping",
            "base_linear_scale",
            "base_backward_scale",
            "base_yaw_scale",
            "base_rack_yaw_scale",
            "base_effective_yaw_scale",
            "base_max_abs_rpm",
            "base_rpm_limit_scale",
            "left_motor_rpm",
            "right_motor_rpm",
        ]
        base_rpm = stream_payload.get("base_wheel_rpm") or ["", ""]
        base_debug = payload.base_debug or {}
        t3_row = payload.t3_row or {}
        frame_value = t3_row.get("Frame", record["frame_index"])
        lift_hardware_value = "" if payload.lift is None else payload.lift
        row = {
            "wall_time_s": record["wall_time_s"],
            "frame_index": record["frame_index"],
            "mode": record["mode"],
            "sent_to_stream": record["sent_to_stream"],
            "dry_run": record["dry_run"],
            "sent_to_real_hardware": record["sent_to_real_hardware"],
            "native_fps": record["native_fps"],
            "playback_speed": record["playback_speed"],
            "effective_send_fps": record["effective_send_fps"],
            "send_dt_s": record["send_dt_s"],
            "measured_send_fps": record["measured_send_fps"],
            "frame_delta": record["frame_delta"],
            "csv_segment_index": base_debug.get("csv_segment_index", ""),
            "base_frame_index": base_debug.get("base_frame_index", ""),
            "base_frame_lead": base_debug.get("base_frame_lead", ""),
            "Frame": frame_value,
            "root_translateX": t3_row.get("root_translateX", ""),
            "root_translateY": t3_row.get("root_translateY", ""),
            "root_translateZ": t3_row.get("root_translateZ", ""),
            "root_rotateX": t3_row.get("root_rotateX", ""),
            "root_rotateY": t3_row.get("root_rotateY", ""),
            "root_rotateZ": t3_row.get("root_rotateZ", ""),
            "right_gripper_joint1_dof": t3_row.get("right_gripper_joint1_dof", ""),
            "right_gripper_joint2_dof": t3_row.get("right_gripper_joint2_dof", ""),
            "left_gripper_joint1_dof": t3_row.get("left_gripper_joint1_dof", ""),
            "left_gripper_joint2_dof": t3_row.get("left_gripper_joint2_dof", ""),
            "telescopic_lift_joint_dof": lift_hardware_value or t3_row.get("telescopic_lift_joint_dof", ""),
            "lift_hardware_frame": "" if payload.lift is None else payload.lift_frame_index,
            "lift_value_source_frame": "" if payload.lift is None else payload.lift_value_frame_index,
            "lift_hardware_value_cm": lift_hardware_value,
            "time_s": base_debug.get("time_s", t3_row.get("time_s", "")),
            "root_x_m": base_debug.get("root_x_m", t3_row.get("root_x_m", "")),
            "root_y_m": base_debug.get("root_y_m", t3_row.get("root_y_m", "")),
            "root_z_m": base_debug.get("root_z_m", t3_row.get("root_z_m", "")),
            "root_yaw_rad": base_debug.get("root_yaw_rad", t3_row.get("root_yaw_rad", "")),
            "root_yaw_deg": base_debug.get("root_yaw_deg", t3_row.get("root_yaw_deg", "")),
            "step_ground_distance_m": base_debug.get("step_ground_distance_m", t3_row.get("step_ground_distance_m", "")),
            "distance_from_start_m": base_debug.get("distance_from_start_m", t3_row.get("distance_from_start_m", "")),
            "forward_velocity_m_s": base_debug.get("forward_velocity_m_s", t3_row.get("forward_velocity_m_s", "")),
            "yaw_rate_rad_s": base_debug.get("yaw_rate_rad_s", t3_row.get("yaw_rate_rad_s", "")),
            "left_wheel_rad_s": base_debug.get("left_wheel_rad_s", t3_row.get("left_wheel_rad_s", "")),
            "right_wheel_rad_s": base_debug.get("right_wheel_rad_s", t3_row.get("right_wheel_rad_s", "")),
            "base_mapping": base_debug.get("base_mapping", ""),
            "base_linear_scale": base_debug.get("base_linear_scale", ""),
            "base_backward_scale": base_debug.get("base_backward_scale", ""),
            "base_yaw_scale": base_debug.get("base_yaw_scale", ""),
            "base_rack_yaw_scale": base_debug.get("base_rack_yaw_scale", ""),
            "base_effective_yaw_scale": base_debug.get("base_effective_yaw_scale", ""),
            "base_max_abs_rpm": base_debug.get("base_max_abs_rpm", ""),
            "base_rpm_limit_scale": base_debug.get("base_rpm_limit_scale", ""),
            "left_motor_rpm": base_rpm[0],
            "right_motor_rpm": base_rpm[1],
        }
        for idx in range(1, 8):
            row[f"right_joint{idx}_dof"] = t3_row.get(f"right_joint{idx}_dof", "")
            row[f"left_joint{idx}_dof"] = t3_row.get(f"left_joint{idx}_dof", "")
        write_header = not csv_log_path.exists()
        with csv_log_path.open("a", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            if write_header:
                writer.writeheader()
            writer.writerow({column: row.get(column, "") for column in fieldnames})

    def _ensure_t3_hardware_bridge(
        self,
        session,
        *,
        dry_run: bool,
        require_arms: bool,
        require_base: bool,
        require_lift: bool,
    ):
        from ardy.t3_hardware import T3HardwareBridge

        if session.t3_hardware_bridge is None:
            session.t3_hardware_bridge = T3HardwareBridge()
        bridge = session.t3_hardware_bridge
        bridge_needs_restart = (
            bridge.dry_run != dry_run
            or bridge.require_arms != require_arms
            or bridge.require_base != require_base
            or bridge.require_lift != require_lift
        )
        if bridge_needs_restart and bridge.is_connected():
            bridge.disconnect()
        bridge.dry_run = dry_run
        bridge.require_arms = require_arms
        bridge.require_base = require_base
        bridge.require_lift = require_lift
        if not bridge.is_connected():
            bridge.connect()
            bridge.wait_until_ready(timeout=10.0)
        return bridge

    def _restart_t3_hardware_bridge(
        self,
        session,
        *,
        dry_run: bool,
        require_arms: bool,
        require_base: bool,
        require_lift: bool,
    ):
        from ardy.t3_hardware import T3HardwareBridge

        if session.t3_hardware_bridge is not None:
            session.t3_hardware_bridge.disconnect()
        session.t3_hardware_bridge = T3HardwareBridge(
            dry_run=dry_run,
            require_arms=require_arms,
            require_base=require_base,
            require_lift=require_lift,
        )
        session.t3_hardware_bridge.connect()
        session.t3_hardware_bridge.wait_until_ready(timeout=10.0)
        return session.t3_hardware_bridge

    def _current_t3_row(self, session, frame_idx: int) -> dict[str, float] | None:
        if 0 <= frame_idx < len(session.t3_stream_rows) and session.t3_stream_rows[frame_idx]:
            return session.t3_stream_rows[frame_idx]
        if session.t3_csv_player is not None and session.t3_csv_player.has_frame(frame_idx):
            return session.t3_csv_player.rows[frame_idx]
        return None

    def _hardware_mode(self, session) -> str | None:
        if session.t3_hardware_stream_base and session.t3_hardware_stream_robot and session.t3_hardware_stream_lift:
            return "full"
        if session.t3_hardware_stream_base and session.t3_hardware_stream_lift:
            return "base_lift"
        if session.t3_hardware_stream_robot and session.t3_hardware_stream_lift:
            return "robot_lift"
        if session.t3_hardware_stream_base and session.t3_hardware_stream_robot:
            return "both"
        if session.t3_hardware_stream_base:
            return "base"
        if session.t3_hardware_stream_robot:
            return "robot"
        if session.t3_hardware_stream_lift:
            return "lift"
        return None

    def _mode_requires_arms(self, mode: str) -> bool:
        return mode in {"robot", "both", "robot_lift", "full"}

    def _mode_requires_base(self, mode: str) -> bool:
        return mode in {"base", "both", "base_lift", "full"}

    def _mode_streams_lift(self, mode: str) -> bool:
        return mode in {"lift", "base_lift", "robot_lift", "full"}

    def _mode_requires_lift_subscriber(self, mode: str) -> bool:
        return self._mode_streams_lift(mode) and os.environ.get("ARDY_T3_REQUIRE_LIFT_SUBSCRIBER", "0") == "1"

    def _lift_step_frames(self, session) -> int:
        return max(1, int(getattr(session.gui_elements, "gui_t3_hardware_lift_step_frames").value))

    def _should_emit_lift(self, session, mode: str, frame_idx: int) -> bool:
        if not self._mode_streams_lift(mode):
            return False
        return int(frame_idx) % self._lift_step_frames(session) == 0

    def _playback_end_frame(self, session) -> int:
        playback_end_frame = int(session.max_frame_idx)
        if not session.realtime_mode and session.task_end_frame_idx is not None:
            playback_end_frame = min(playback_end_frame, int(session.task_end_frame_idx))
        return playback_end_frame

    def _next_t3_lift_target_frame(self, session, frame_idx: int) -> int | None:
        last_target = int(getattr(session, "t3_hardware_last_lift_target_frame", -1))
        frame_idx = int(frame_idx)
        playback_end_frame = self._playback_end_frame(session)
        with session.t3_retarget_lock:
            packet_ranges = list(getattr(session, "t3_retarget_packet_ranges", []))
            ready_end = int(getattr(session, "t3_retarget_csv_end_frame", -1))
        if not packet_ranges:
            return None
        for start_frame, end_frame in sorted((int(start), int(end)) for start, end in packet_ranges):
            if frame_idx != start_frame:
                continue
            target_frame = min(end_frame, ready_end, playback_end_frame)
            if target_frame >= frame_idx and target_frame > last_target:
                return target_frame
            return None
        return None

    def _consume_t3_lift_target_frame(self, session, frame_idx: int) -> None:
        session.t3_hardware_last_lift_target_frame = max(
            int(getattr(session, "t3_hardware_last_lift_target_frame", -1)),
            int(frame_idx),
        )

    def _wait_for_t3_lift_target_frame(self, client_id: int, stop_event) -> int | None:
        session = self.client_sessions[client_id]
        timeout_s = float(os.environ.get("ARDY_T3_RETARGET_WAIT_TIMEOUT", "120.0"))
        started_at = time.time()
        last_request_at = 0.0
        last_status_at = 0.0
        while self.client_active(client_id):
            if stop_event is not None and stop_event.is_set():
                return None
            target_frame = self._next_t3_lift_target_frame(session, 0)
            if target_frame is not None:
                return target_frame
            now = time.time()
            if now - started_at > timeout_s:
                raise RuntimeError(f"Timed out waiting for a T3 lift retarget batch after {timeout_s:.1f}s.")
            if now - last_request_at >= 1.0:
                self.request_soma_t3_retarget(client_id, start_frame=0)
                last_request_at = now
            if now - last_status_at >= 0.5:
                ready_end = int(getattr(session, "t3_retarget_csv_end_frame", -1))
                session.gui_elements.gui_t3_hardware_payload_md.content = (
                    "**T3 Lift Waiting**\n\n"
                    f"Waiting for retarget batch `0-{max(0, int(getattr(session, 't3_stream_packet_size', 1)) - 1)}`. "
                    f"Current ready end is `{ready_end}`."
                )
                last_status_at = now
            if stop_event is None:
                time.sleep(0.02)
            elif stop_event.wait(0.02):
                return None
        return None

    def _validate_t3_robot_row_ready(self, session, frame_idx: int) -> tuple[bool, str]:
        from ardy.t3_hardware.payloads import LEFT_ARM_COLUMNS, RIGHT_ARM_COLUMNS

        row = self._current_t3_row(session, frame_idx)
        ready_end = int(getattr(session, "t3_retarget_csv_end_frame", -1))
        status = str(getattr(session, "t3_retarget_status", "idle"))
        if row is None:
            return (
                False,
                f"No Soma T3 robot row is ready for frame `{frame_idx}`. "
                f"Current ready end is `{ready_end}`. Status: `{status}`.",
            )
        missing = []
        invalid = []
        for column in [*RIGHT_ARM_COLUMNS, *LEFT_ARM_COLUMNS]:
            value = row.get(column)
            if isinstance(value, str):
                value = value.strip()
            if value in ("", None):
                missing.append(column)
                continue
            try:
                float(value)
            except (TypeError, ValueError):
                invalid.append(column)
        if missing or invalid:
            details = []
            if missing:
                details.append("missing/blank: " + ", ".join(missing[:6]))
            if invalid:
                details.append("invalid: " + ", ".join(invalid[:6]))
            return False, f"Soma T3 row for frame `{frame_idx}` is not usable: {'; '.join(details)}."
        return True, ""

    def _wait_for_t3_robot_row_ready(self, client_id: int, frame_idx: int, stop_event) -> bool:
        session = self.client_sessions[client_id]
        timeout_s = float(os.environ.get("ARDY_T3_RETARGET_WAIT_TIMEOUT", "120.0"))
        started_at = time.time()
        last_request_at = 0.0
        last_status_at = 0.0
        while self.client_active(client_id):
            if stop_event is not None and stop_event.is_set():
                return False

            ready, reason = self._validate_t3_robot_row_ready(session, frame_idx)
            if ready:
                return True

            now = time.time()
            if now - started_at > timeout_s:
                raise RuntimeError(
                    f"Timed out waiting for accurate Soma T3 frame `{frame_idx}` after {timeout_s:.1f}s. "
                    f"{reason}"
                )

            if now - last_request_at >= 1.0:
                self.request_soma_t3_retarget(client_id, start_frame=0)
                last_request_at = now

            if now - last_status_at >= 0.5:
                ready_end = int(getattr(session, "t3_retarget_csv_end_frame", -1))
                status = str(getattr(session, "t3_retarget_status", "idle"))
                session.gui_elements.gui_t3_hardware_payload_md.content = (
                    "**T3 Hardware Waiting**\n\n"
                    f"Waiting for accurate Soma T3 frame `{frame_idx}`. "
                    f"Ready to `{ready_end}`. Status: `{status}`."
                )
                last_status_at = now

            if stop_event is None:
                time.sleep(0.02)
            elif stop_event.wait(0.02):
                return False

        return False

    def _wait_for_t3_robot_buffer(self, client_id: int, mode: str, stop_event) -> bool:
        if not self._mode_requires_arms(mode):
            return True
        session = self.client_sessions[client_id]
        playback_end_frame = int(session.max_frame_idx)
        if not session.realtime_mode and session.task_end_frame_idx is not None:
            playback_end_frame = int(session.task_end_frame_idx)
        buffer_frames = int(os.environ.get("ARDY_T3_RETARGET_START_BUFFER_FRAMES", "120"))
        if self._mode_streams_lift(mode):
            target_frame = 0
        else:
            target_frame = min(max(0, playback_end_frame), max(0, buffer_frames - 1))
        self.request_soma_t3_retarget(client_id, start_frame=0)
        return self._wait_for_t3_robot_row_ready(client_id, target_frame, stop_event)

    def _build_current_t3_hardware_payload(
        self,
        client_id: int,
        mode: str,
        frame_idx: int | None = None,
        *,
        emit_lift: bool = True,
        lift_frame_idx: int | None = None,
        lift_value_frame_idx: int | None = None,
    ):
        from ardy.t3_hardware import build_t3_frame_payload

        session = self.client_sessions[client_id]
        if session.joints_pos is None or session.joints_rot is None:
            raise RuntimeError("No generated motion is loaded yet.")
        if not session.characters:
            raise RuntimeError("No character is loaded yet.")
        if frame_idx is None:
            frame_idx = session.frame_idx
        frame_idx = max(0, min(int(frame_idx), int(session.max_frame_idx)))
        character = session.characters.get(0) or next(iter(session.characters.values()))
        playback_speed = max(float(getattr(session, "playback_speed", 1.0)), 0.05)
        root_velocities = None
        if session.root_velocities is not None and session.root_velocities.shape[0] > 0:
            root_velocities = session.root_velocities[0]
        t3_row = self._current_t3_row(session, frame_idx)
        rpm_scale = float(getattr(session.gui_elements, "gui_t3_hardware_rpm_scale").value)
        max_abs_rpm = float(getattr(session.gui_elements, "gui_t3_hardware_max_abs_rpm").value)
        linear_scale = float(getattr(session.gui_elements, "gui_t3_hardware_linear_scale").value)
        backward_scale = float(getattr(session.gui_elements, "gui_t3_hardware_backward_scale").value)
        yaw_scale = float(getattr(session.gui_elements, "gui_t3_hardware_yaw_scale").value)
        rack_yaw_scale = float(getattr(session.gui_elements, "gui_t3_hardware_rack_yaw_scale").value)
        base_lead_frames = max(0, int(getattr(session.gui_elements, "gui_t3_hardware_base_lead_frames").value))
        base_frame_idx = min(frame_idx + base_lead_frames, int(session.max_frame_idx))
        mapping_label = str(getattr(session.gui_elements, "gui_t3_hardware_base_mapping").value)
        base_mapping = self._T3_BASE_MAPPING_KEYS.get(mapping_label, "direct")
        base_route_positions = getattr(session, "t3_base_route_positions", None)
        base_route_headings = getattr(session, "t3_base_route_headings", None)
        use_base_route = base_route_positions is not None and base_route_headings is not None
        effective_yaw_scale = rack_yaw_scale if use_base_route else yaw_scale
        payload = build_t3_frame_payload(
            mode=mode,
            frame_idx=frame_idx,
            skeleton=character.skeleton,
            joints_pos_seq=session.joints_pos[0],
            joints_rot_seq=session.joints_rot[0],
            fps=session.model_fps,
            t3_row=t3_row,
            root_velocities_seq=root_velocities,
            rpm_scale=rpm_scale,
            playback_speed=playback_speed,
            base_mapping=base_mapping,
            linear_scale=linear_scale,
            backward_scale=backward_scale,
            yaw_scale=effective_yaw_scale,
            max_abs_rpm=max_abs_rpm,
            base_frame_idx=base_frame_idx,
            base_route_positions=base_route_positions,
            base_route_headings=base_route_headings,
            emit_lift=emit_lift,
            lift_frame_idx=lift_frame_idx,
            lift_value_frame_idx=lift_value_frame_idx,
        )
        if payload.base_debug is not None:
            payload.base_debug["base_frame_lead"] = int(base_frame_idx - frame_idx)
            payload.base_debug["base_rack_yaw_scale"] = rack_yaw_scale if use_base_route else ""
            payload.base_debug["base_effective_yaw_scale"] = effective_yaw_scale
        return payload

    def _preview_or_send_t3_hardware_payload(
        self,
        client_id: int,
        mode: str,
        frame_idx: int,
        *,
        emit_lift: bool = True,
        lift_frame_idx: int | None = None,
        lift_value_frame_idx: int | None = None,
    ) -> None:
        session = self.client_sessions[client_id]
        payload = self._build_current_t3_hardware_payload(
            client_id,
            mode,
            frame_idx=frame_idx,
            emit_lift=emit_lift,
            lift_frame_idx=lift_frame_idx,
            lift_value_frame_idx=lift_value_frame_idx,
        )
        status = payload.preview()
        if payload.lift is not None and lift_frame_idx is not None:
            status += f"\n\nLift hardware send frame: `{int(lift_frame_idx)}`"
        if payload.lift is not None and lift_value_frame_idx is not None:
            status += f"\n\nLift value source frame: `{int(lift_value_frame_idx)}`"
        dry_run = not bool(session.gui_elements.gui_t3_hardware_enable_checkbox.value)
        if bool(session.gui_elements.gui_t3_hardware_send_checkbox.value):
            bridge = self._ensure_t3_hardware_bridge(
                session,
                dry_run=dry_run,
                require_arms=self._mode_requires_arms(mode),
                require_base=self._mode_requires_base(mode),
                require_lift=self._mode_requires_lift_subscriber(mode),
            )
            self._append_t3_hardware_log(
                session,
                payload,
                payload.to_stream_payload(),
                sent_to_stream=True,
                dry_run=dry_run,
            )
            sent = bridge.send(payload)
            status += "\n\nStream payload JSON:\n\n```json\n" + json.dumps(sent, indent=2) + "\n```"
            status += "\n\nStreaming in dry-run mode." if dry_run else "\n\nStreaming to real T3 hardware."
            if dry_run:
                status += "\n\nTurn on `Enable Real T3 Hardware` to move the physical lift."
        else:
            self._append_t3_hardware_log(session, payload, None, sent_to_stream=False, dry_run=True)
            status += "\n\nPreview only. Enable `Send to connected stream` to publish."
        if payload.base_wheel_rpm is not None:
            status += (
                "\n\nCSV columns `left_motor_rpm`, `right_motor_rpm` are the exact "
                "`base_wheel_rpm` values sent to ROS."
            )
        if self._mode_streams_lift(mode):
            status += (
                "\n\nLive lift height is sent once per retarget batch, using that batch's last frame "
                "as `69 + extension_cm`."
            )
        status += (
            f"\n\nCSV log file:\n\n`{session.t3_hardware_csv_log_path}`"
            f"\n\nRaw JSONL log file:\n\n`{session.t3_hardware_log_path}`"
        )
        session.gui_elements.gui_t3_hardware_payload_md.content = status
        session.t3_hardware_last_sent_frame = int(frame_idx)

    def _split_t3_hardware_csv_segments(
        self,
        rows: list[dict[str, str]],
    ) -> list[list[dict[str, str]]]:
        segments: list[list[dict[str, str]]] = []
        current: list[dict[str, str]] = []
        previous_frame: int | None = None
        for row in rows:
            frame_value = row.get("frame_index") or row.get("Frame") or ""
            try:
                frame_idx = int(float(frame_value))
            except (TypeError, ValueError):
                frame_idx = 0
            if current and previous_frame is not None and frame_idx < previous_frame:
                segments.append(current)
                current = []
            current.append(row)
            previous_frame = frame_idx
        if current:
            segments.append(current)
        return [segment for segment in segments if len(segment) > 1]

    def _read_t3_hardware_csv_rows(self, csv_path: str) -> tuple[list[dict[str, str]], list[str], int, int]:
        path = Path(csv_path).expanduser()
        if not path.is_file():
            raise FileNotFoundError(f"T3 CSV file not found: {path}")
        with path.open(newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            if reader.fieldnames is None:
                raise ValueError(f"T3 CSV has no header: {path}")
            fieldnames = list(reader.fieldnames)
            rows = [dict(row) for row in reader]
        if not rows:
            raise ValueError(f"T3 CSV has no rows: {path}")
        required_robot = [*[f"right_joint{i}_dof" for i in range(1, 8)], *[f"left_joint{i}_dof" for i in range(1, 8)]]
        missing = [column for column in required_robot if column not in reader.fieldnames]
        if missing:
            raise ValueError("T3 CSV is missing robot columns: " + ", ".join(missing))
        segments = self._split_t3_hardware_csv_segments(rows)
        return rows, fieldnames, 0, len(segments)

    def _select_t3_hardware_csv_segment(
        self,
        rows: list[dict[str, str]],
        requested_segment: int,
    ) -> tuple[list[dict[str, str]], int, int]:
        segments = self._split_t3_hardware_csv_segments(rows)
        if not segments:
            raise ValueError("T3 CSV has no playable frame segments.")
        segment_index = max(0, min(int(requested_segment), len(segments) - 1))
        return segments[segment_index], segment_index, len(segments)

    def _write_t3_hardware_segment_csv(
        self,
        session,
        rows: list[dict[str, str]],
        fieldnames: list[str],
        source_csv_path: str,
        segment_index: int,
    ) -> Path:
        log_dir = Path(REPO_ROOT) / "outputs" / "t3_hardware_csv_segments"
        log_dir.mkdir(parents=True, exist_ok=True)
        stamp = time.strftime("%Y%m%d_%H%M%S")
        source_stem = Path(source_csv_path).expanduser().stem
        path = log_dir / f"{source_stem}_client_{session.client.client_id}_segment_{segment_index}_{stamp}.csv"
        with path.open("w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            for row in rows:
                writer.writerow({column: row.get(column, "") for column in fieldnames})
        return path

    def _show_only_t3_csv_player(self, session) -> None:
        if session.t3_live_retargeter is not None:
            session.t3_live_retargeter.set_visible(False)
        if session.t3_csv_player is not None:
            session.t3_csv_player.set_visible(bool(session.gui_elements.gui_viz_t3_robot_checkbox.value))

    def _t3_hardware_csv_fps(self, session, rows: list[dict[str, str]]) -> float:
        override_fps = float(getattr(session.gui_elements, "gui_t3_hardware_csv_fps").value)
        if override_fps > 0.0:
            return override_fps
        for key in ("effective_send_fps", "native_fps"):
            value = rows[0].get(key, "")
            if value not in ("", None):
                parsed = float(value)
                if parsed > 0.0:
                    return parsed
        playback_speed = max(float(rows[0].get("playback_speed", getattr(session, "playback_speed", 1.0)) or 1.0), 0.05)
        native_fps = max(float(rows[0].get("native_fps", getattr(session, "model_fps", 30.0)) or 30.0), 1.0)
        return native_fps * playback_speed

    def _run_t3_hardware_csv_clock(
        self,
        client_id: int,
        mode: str,
        rows: list[dict[str, str]],
        fps: float,
        segment_index: int,
    ) -> None:
        if not self.client_active(client_id):
            return
        from ardy.t3_hardware import build_t3_csv_frame_payload

        session = self.client_sessions[client_id]
        stop_event = session.t3_hardware_stop_event
        dry_run = not bool(session.gui_elements.gui_t3_hardware_enable_checkbox.value)
        try:
            bridge = None
            if bool(session.gui_elements.gui_t3_hardware_send_checkbox.value):
                bridge = self._restart_t3_hardware_bridge(
                    session,
                    dry_run=dry_run,
                    require_arms=self._mode_requires_arms(mode),
                    require_base=self._mode_requires_base(mode),
                    require_lift=self._mode_requires_lift_subscriber(mode),
                )
            rpm_scale = float(getattr(session.gui_elements, "gui_t3_hardware_rpm_scale").value)
            max_abs_rpm = float(getattr(session.gui_elements, "gui_t3_hardware_max_abs_rpm").value)
            linear_scale = float(getattr(session.gui_elements, "gui_t3_hardware_linear_scale").value)
            backward_scale = float(getattr(session.gui_elements, "gui_t3_hardware_backward_scale").value)
            yaw_scale = float(getattr(session.gui_elements, "gui_t3_hardware_yaw_scale").value)
            dt = 1.0 / max(float(fps), 1e-6)
            for row_index, row in enumerate(rows):
                if stop_event is not None and stop_event.is_set():
                    break
                started_at = time.time()
                payload = build_t3_csv_frame_payload(
                    row,
                    mode=mode,
                    rpm_scale=rpm_scale,
                    max_abs_rpm=max_abs_rpm,
                    linear_scale=linear_scale,
                    backward_scale=backward_scale,
                    yaw_scale=yaw_scale,
                    emit_lift=self._should_emit_lift(session, mode, row_index),
                )
                if payload.base_debug is not None:
                    payload.base_debug["csv_segment_index"] = int(segment_index)
                with session.t3_hardware_lock:
                    if session.t3_csv_player is not None and session.t3_csv_player.has_frame(row_index):
                        if session.t3_live_retargeter is not None:
                            session.t3_live_retargeter.set_visible(False)
                        session.t3_csv_player.update(
                            row_index,
                            offset=session.gui_elements.gui_viz_t3_offset.value,
                            yaw_offset_deg=session.gui_elements.gui_viz_t3_yaw_offset.value,
                        )
                        session.t3_csv_player.set_visible(bool(session.gui_elements.gui_viz_t3_robot_checkbox.value))
                    stream_payload = payload.to_stream_payload()
                    sent_to_stream = bridge is not None
                    self._append_t3_hardware_log(
                        session,
                        payload,
                        stream_payload,
                        sent_to_stream=sent_to_stream,
                        dry_run=dry_run or bridge is None,
                    )
                    if bridge is not None:
                        sent = bridge.send(payload)
                    else:
                        sent = stream_payload
                    session.t3_hardware_last_sent_frame = int(payload.frame_index)
                    if row_index % 10 == 0 or row_index == len(rows) - 1:
                        session.gui_elements.gui_t3_hardware_payload_md.content = (
                            f"**T3 CSV Hardware Playback**\n\n"
                            f"Mode: `{mode}`\n\n"
                            f"CSV Segment: `{segment_index}`\n\n"
                            f"Row: `{row_index + 1}/{len(rows)}`\n\n"
                            f"Frame: `{payload.frame_index}`\n\n"
                            f"FPS: `{fps:.3f}`\n\n"
                            "CSV columns `left_motor_rpm`, `right_motor_rpm` are the exact "
                            "`base_wheel_rpm` values sent to ROS.\n\n"
                            f"Lift step frames: `{self._lift_step_frames(session)}`.\n\n"
                            "Last stream payload:\n\n```json\n"
                            + json.dumps(sent, indent=2)
                            + "\n```"
                            f"\n\nCSV log file:\n\n`{session.t3_hardware_csv_log_path}`"
                            f"\n\nRaw JSONL log file:\n\n`{session.t3_hardware_log_path}`"
                        )
                sleep_s = max(0.0, dt - (time.time() - started_at))
                if stop_event is None:
                    time.sleep(sleep_s)
                elif stop_event.wait(sleep_s):
                    break
        except Exception as exc:
            session.gui_elements.gui_t3_hardware_payload_md.content = f"T3 CSV hardware playback stopped:\n\n`{exc}`"
            session.client.add_notification(title="T3 CSV playback stopped", body=str(exc), color="red")
        finally:
            was_base_active = session.t3_hardware_stream_base
            session.t3_hardware_clock_active = False
            session.t3_hardware_stream_base = False
            session.t3_hardware_stream_robot = False
            session.t3_hardware_stream_lift = False
            session.playing = False

    def _start_t3_hardware_csv_stream(self, event, client_id: int, *, mode: str) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        try:
            if mode not in {"robot", "both", "full"}:
                raise ValueError(f"Unsupported CSV T3 mode: {mode}")
            source_csv_path = str(session.gui_elements.gui_t3_hardware_csv_path.value)
            all_rows, fieldnames, _, segment_count = self._read_t3_hardware_csv_rows(source_csv_path)
            requested_segment = int(getattr(session.gui_elements, "gui_t3_hardware_csv_segment").value)
            rows, segment_index, segment_count = self._select_t3_hardware_csv_segment(all_rows, requested_segment)
            fps = self._t3_hardware_csv_fps(session, rows)
            if session.t3_hardware_stop_event is not None:
                session.t3_hardware_stop_event.set()
            session.t3_hardware_log_path = None
            session.t3_hardware_csv_log_path = None
            session.t3_hardware_last_sent_frame = -1
            session.t3_hardware_last_log_wall_time_s = None
            session.t3_hardware_last_log_frame_idx = None
            session.t3_hardware_stream_base = mode in {"both", "full"}
            session.t3_hardware_stream_robot = True
            session.t3_hardware_stream_lift = mode == "full"
            from ardy.retarget_to_t3 import T3CsvPlaybackRobot

            session.gui_elements.gui_viz_t3_robot_checkbox.value = True
            session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value = False
            if session.t3_csv_player is not None:
                session.t3_csv_player.clear()
            segment_csv_path = self._write_t3_hardware_segment_csv(
                session,
                rows,
                fieldnames,
                source_csv_path,
                segment_index,
            )
            session.t3_csv_player = T3CsvPlaybackRobot(
                self.server,
                segment_csv_path,
                root_node_name=f"/t3_hardware_csv_client_{client_id}",
            )
            session.t3_csv_player_generation += 1
            self._show_only_t3_csv_player(session)
            session.t3_hardware_stop_event = threading.Event()
            session.t3_hardware_clock_active = True
            session.t3_hardware_clock_thread = threading.Thread(
                target=self._run_t3_hardware_csv_clock,
                args=(client_id, mode, rows, fps, segment_index),
                daemon=True,
            )
            session.t3_hardware_clock_thread.start()
            event.client.add_notification(
                title=f"T3 CSV {mode} playback started",
                body=f"Streaming segment {segment_index}/{segment_count - 1}: {len(rows)} rows at {fps:.2f} FPS.",
                color="green",
                auto_close_seconds=3.0,
            )
        except Exception as exc:
            session.t3_hardware_stream_base = False
            session.t3_hardware_stream_robot = False
            session.t3_hardware_stream_lift = False
            session.t3_hardware_clock_active = False
            session.gui_elements.gui_t3_hardware_payload_md.content = f"T3 CSV playback failed:\n\n`{exc}`"
            event.client.add_notification(title="T3 CSV playback failed", body=str(exc), color="red")

    def _sync_t3_hardware_frame(self, client_id: int, frame_idx: int) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        if getattr(session, "t3_hardware_clock_active", False):
            return
        if not session.playing:
            return
        mode = self._hardware_mode(session)
        if mode is None:
            return
        frame_idx = int(frame_idx)
        if session.t3_hardware_last_sent_frame == frame_idx:
            return
        last_frame = int(session.t3_hardware_last_sent_frame)
        try:
            if last_frame >= 0 and frame_idx != last_frame + 1:
                if last_frame == 0:
                    session.frame_idx = 0
                    session.gui_elements.gui_frame_idx_input.value = 0
                    session.gui_elements.gui_t3_hardware_payload_md.content = (
                        f"Hardware startup frame jump avoided: last sent `{last_frame}`, next was `{frame_idx}`. "
                        "Rewinding playback to continue from frame `1`."
                    )
                    return
                raise RuntimeError(
                    f"Hardware frame jump detected: last sent `{last_frame}`, next `{frame_idx}`. "
                    "Restart hardware playback from frame 0 for accurate base motion."
                )
            with session.t3_hardware_lock:
                lift_target_frame = self._next_t3_lift_target_frame(
                    session,
                    frame_idx,
                ) if self._mode_streams_lift(mode) else None
                emit_lift = lift_target_frame is not None
                self._preview_or_send_t3_hardware_payload(
                    client_id,
                    mode,
                    frame_idx,
                    emit_lift=emit_lift,
                    lift_frame_idx=lift_target_frame,
                    lift_value_frame_idx=lift_target_frame,
                )
                if lift_target_frame is not None:
                    self._consume_t3_lift_target_frame(session, lift_target_frame)
        except Exception as exc:
            session.t3_hardware_stream_base = False
            session.t3_hardware_stream_robot = False
            session.t3_hardware_stream_lift = False
            session.gui_elements.gui_t3_hardware_payload_md.content = (
                f"T3 hardware stream stopped at frame `{frame_idx}`:\n\n`{exc}`"
            )
            session.client.add_notification(title="T3 hardware stream stopped", body=str(exc), color="red")

    def _run_t3_hardware_clock(self, client_id: int, mode: str) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        stop_event = session.t3_hardware_stop_event
        try:
            if session.realtime_mode and int(session.max_frame_idx) < self._T3_HARDWARE_MIN_BUFFER_FRAMES:
                session.gui_elements.gui_t3_hardware_payload_md.content = (
                    "**T3 Hardware Preparing**\n\n"
                    f"Buffering motion before hardware start: `{session.max_frame_idx + 1}` frames ready."
                )
                while (
                    self.client_active(client_id)
                    and session.realtime_mode
                    and int(session.max_frame_idx) < self._T3_HARDWARE_MIN_BUFFER_FRAMES
                ):
                    if stop_event is not None and stop_event.is_set():
                        return
                    self.on_replan_trigger(client_id, skip_if_busy=False)
                    session.gui_elements.gui_t3_hardware_payload_md.content = (
                        "**T3 Hardware Preparing**\n\n"
                        f"Buffered `{session.max_frame_idx + 1}` frames. "
                        f"Starting after `{self._T3_HARDWARE_MIN_BUFFER_FRAMES + 1}` frames are ready."
                    )
            if self._mode_streams_lift(mode):
                self.request_soma_t3_retarget(client_id, start_frame=0)
                if not self._wait_for_t3_lift_target_frame(client_id, stop_event):
                    return
            if not self._wait_for_t3_robot_buffer(client_id, mode, stop_event):
                return
            frame_idx = 0
            pending_replan = False
            stagnant_waits = 0
            previous_max_frame = int(session.max_frame_idx)
            while self.client_active(client_id):
                if stop_event is not None and stop_event.is_set():
                    break
                playback_end_frame = int(session.max_frame_idx)
                if not session.realtime_mode and session.task_end_frame_idx is not None:
                    playback_end_frame = int(session.task_end_frame_idx)
                if frame_idx > playback_end_frame:
                    break
                if frame_idx > int(session.max_frame_idx):
                    waiting_for_more_motion = (
                        session.realtime_mode
                        or (
                            not session.realtime_mode
                            and session.task_end_frame_idx is not None
                            and (
                                session.task_generation_pending
                                or int(session.max_frame_idx) < int(session.task_end_frame_idx)
                            )
                        )
                    )
                    if waiting_for_more_motion:
                        if not pending_replan and not session.replan_lock.locked():
                            pending_replan = True
                            previous_max_frame = int(session.max_frame_idx)
                            threading.Thread(
                                target=self.on_replan_trigger,
                                args=(client_id,),
                                kwargs={"skip_if_busy": True},
                                daemon=True,
                            ).start()
                        if frame_idx <= int(session.max_frame_idx):
                            pending_replan = False
                            stagnant_waits = 0
                            continue
                        stagnant_waits += 1
                        if stagnant_waits % 100 == 0:
                            session.gui_elements.gui_t3_hardware_payload_md.content = (
                                "**T3 Hardware Waiting**\n\n"
                                f"Waiting for generated frame `{frame_idx}`. "
                                f"Current max frame is `{session.max_frame_idx}`."
                            )
                        if stop_event is None:
                            time.sleep(0.02)
                        else:
                            stop_event.wait(0.02)
                        continue
                    break
                while not session.playing:
                    if stop_event is not None and stop_event.is_set():
                        break
                    time.sleep(0.02)
                if stop_event is not None and stop_event.is_set():
                    break
                refill_threshold = max(self._T3_HARDWARE_MIN_BUFFER_FRAMES, int(session.gen_horizon_len) * 4)
                if (
                    session.realtime_mode
                    and not pending_replan
                    and not session.replan_lock.locked()
                    and int(session.max_frame_idx) - frame_idx <= refill_threshold
                ):
                    pending_replan = True
                    threading.Thread(
                        target=self.on_replan_trigger,
                        args=(client_id,),
                        kwargs={"skip_if_busy": True},
                        daemon=True,
                    ).start()

                if self._mode_requires_arms(mode) and not self._wait_for_t3_robot_row_ready(
                    client_id,
                    frame_idx,
                    stop_event,
                ):
                    break
                started_at = time.time()
                self.set_frame(client_id, frame_idx)
                skip_payload = False
                with session.t3_hardware_lock:
                    lift_target_frame = self._next_t3_lift_target_frame(
                        session,
                        frame_idx,
                    ) if self._mode_streams_lift(mode) else None
                    emit_lift = lift_target_frame is not None
                    if mode == "lift" and not emit_lift:
                        skip_payload = True
                        if frame_idx % max(1, int(session.model_fps)) == 0:
                            ready_end = int(getattr(session, "t3_retarget_csv_end_frame", -1))
                            session.gui_elements.gui_t3_hardware_payload_md.content = (
                                "**T3 Lift Stream**\n\n"
                                f"Waiting for next retarget batch after frame "
                                f"`{session.t3_hardware_last_lift_target_frame}`. Ready end: `{ready_end}`."
                            )
                    if not skip_payload:
                        self._preview_or_send_t3_hardware_payload(
                            client_id,
                            mode,
                            frame_idx,
                            emit_lift=emit_lift,
                            lift_frame_idx=lift_target_frame,
                            lift_value_frame_idx=lift_target_frame,
                        )
                        if lift_target_frame is not None:
                            self._consume_t3_lift_target_frame(session, lift_target_frame)

                playback_speed = max(float(getattr(session, "playback_speed", 1.0)), 0.05)
                effective_fps = max(float(session.model_fps) * playback_speed, 1e-6)
                sleep_s = max(0.0, 1.0 / effective_fps - (time.time() - started_at))
                if stop_event is None:
                    time.sleep(sleep_s)
                else:
                    stop_event.wait(sleep_s)
                frame_idx += 1
                if frame_idx <= int(session.max_frame_idx):
                    pending_replan = False
                    stagnant_waits = 0
        except Exception as exc:
            session.gui_elements.gui_t3_hardware_payload_md.content = (
                f"T3 hardware clock stopped:\n\n`{exc}`"
            )
            session.client.add_notification(title="T3 hardware clock stopped", body=str(exc), color="red")
        finally:
            was_base_active = session.t3_hardware_stream_base
            session.t3_hardware_clock_active = False
            session.t3_hardware_stream_base = False
            session.t3_hardware_stream_robot = False
            session.t3_hardware_stream_lift = False
            session.playing = False
            session.gui_elements.gui_play_pause_button.label = "Play"
            session.gui_elements.gui_next_frame_button.disabled = False
            session.gui_elements.gui_prev_frame_button.disabled = int(session.frame_idx) <= 0

    def _start_t3_hardware_stream(self, event, client_id: int, *, base: bool, robot: bool, lift: bool) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        try:
            if session.t3_hardware_stop_event is not None:
                session.t3_hardware_stop_event.set()
            if session.t3_hardware_clock_thread is not None and session.t3_hardware_clock_thread.is_alive():
                session.t3_hardware_clock_thread.join(timeout=1.0)
            session.playing = False
            session.t3_hardware_stream_base = False
            session.t3_hardware_stream_robot = False
            session.t3_hardware_stream_lift = False
            session.t3_hardware_clock_active = False
            session.t3_hardware_log_path = None
            session.t3_hardware_csv_log_path = None
            if int(session.frame_idx) != 0:
                self.set_frame(client_id, 0)
            session.t3_hardware_last_sent_frame = -1
            session.t3_hardware_last_log_wall_time_s = None
            session.t3_hardware_last_log_frame_idx = None
            session.t3_hardware_last_lift_target_frame = -1
            session.t3_hardware_stream_base = bool(base)
            session.t3_hardware_stream_robot = bool(robot)
            session.t3_hardware_stream_lift = bool(lift)
            mode = self._hardware_mode(session)
            if mode is None:
                raise RuntimeError("No T3 hardware stream mode selected.")
            if robot:
                session.gui_elements.gui_viz_t3_robot_checkbox.value = True
                self.set_frame(client_id, 0)
                ready, reason = self._validate_t3_robot_row_ready(session, 0)
                if not ready:
                    session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value = True
                    with session.t3_retarget_lock:
                        session.t3_stream_rows = []
                        session.t3_retarget_packet_ranges = []
                        session.t3_retarget_packet_end_frames = []
                        session.t3_retarget_csv_path = None
                        session.t3_retarget_csv_start_frame = 0
                        session.t3_retarget_csv_end_frame = -1
                        session.t3_retarget_requested_end_frame = -1
                        session.t3_retarget_ready_generation = -1
                        session.t3_retarget_pending_after_current = False
                        session.t3_retarget_pending_start_frame = None
                    self.request_soma_t3_retarget(client_id, force=True, start_frame=0)
                    raise RuntimeError(
                        reason
                        + " Restarted Soma T3 retargeting from frame `0`; wait for frame `0` to be ready, then press Play again."
                    )
            if self._mode_streams_lift(mode):
                session.gui_elements.gui_viz_t3_soma_retarget_checkbox.value = True
                self.request_soma_t3_retarget(client_id, start_frame=0)
            self._build_current_t3_hardware_payload(client_id, mode, frame_idx=0, emit_lift=False)
            session.t3_hardware_stop_event = threading.Event()
            session.t3_hardware_clock_active = True
            session.playing = True
            session.play_once = session.playing and not session.realtime_mode
            session.gui_elements.gui_play_pause_button.label = "Pause"
            session.gui_elements.gui_next_frame_button.disabled = True
            session.gui_elements.gui_prev_frame_button.disabled = True
            session.t3_hardware_clock_thread = threading.Thread(
                target=self._run_t3_hardware_clock,
                args=(client_id, mode),
                daemon=True,
            )
            session.t3_hardware_clock_thread.start()
            event.client.add_notification(
                title=f"T3 {mode} stream started",
                body="Hardware is running on a dedicated sequential frame clock.",
                color="green",
                auto_close_seconds=3.0,
            )
        except Exception as exc:
            session.t3_hardware_stream_base = False
            session.t3_hardware_stream_robot = False
            session.t3_hardware_stream_lift = False
            session.gui_elements.gui_t3_hardware_payload_md.content = f"T3 hardware payload failed:\n\n`{exc}`"
            event.client.add_notification(title="T3 hardware stream failed", body=str(exc), color="red")

    def _stop_t3_hardware_stream(self, event, client_id: int, *, base: bool, robot: bool, lift: bool) -> None:
        if not self.client_active(client_id):
            return
        from ardy.t3_hardware import T3FramePayload

        session = self.client_sessions[client_id]
        if session.t3_hardware_stop_event is not None:
            session.t3_hardware_stop_event.set()
        was_base_active = session.t3_hardware_stream_base
        if base:
            session.t3_hardware_stream_base = False
        if robot:
            session.t3_hardware_stream_robot = False
        if lift:
            session.t3_hardware_stream_lift = False
        if base and robot and lift:
            session.t3_hardware_clock_active = False
        session.t3_hardware_last_sent_frame = -1
        status_lines = [
            "**T3 Hardware Stream**",
            "",
            f"Base active: `{session.t3_hardware_stream_base}`",
            f"Robot active: `{session.t3_hardware_stream_robot}`",
            f"Lift active: `{session.t3_hardware_stream_lift}`",
        ]
        try:
            if base and was_base_active and bool(session.gui_elements.gui_t3_hardware_send_checkbox.value):
                dry_run = not bool(session.gui_elements.gui_t3_hardware_enable_checkbox.value)
                bridge = self._ensure_t3_hardware_bridge(
                    session,
                    dry_run=dry_run,
                    require_arms=False,
                    require_base=True,
                    require_lift=False,
                )
                stop_payload = T3FramePayload(
                    frame_index=max(0, int(session.frame_idx)),
                    mode="base",
                    base_wheel_rpm=(0.0, 0.0),
                )
                self._append_t3_hardware_log(
                    session,
                    stop_payload,
                    stop_payload.to_stream_payload(),
                    sent_to_stream=True,
                    dry_run=dry_run,
                )
                sent = bridge.send(stop_payload)
                status_lines.extend(
                    [
                        "",
                        "Sent base stop JSON:",
                        "",
                        "```json\n" + json.dumps(sent, indent=2) + "\n```",
                        "",
                        f"CSV log file: `{session.t3_hardware_csv_log_path}`",
                        "",
                        f"Raw JSONL log file: `{session.t3_hardware_log_path}`",
                    ]
                )
        except Exception as exc:
            status_lines.extend(["", f"Stop command failed: `{exc}`"])
            event.client.add_notification(title="T3 hardware stop failed", body=str(exc), color="red")
        session.gui_elements.gui_t3_hardware_payload_md.content = "\n\n".join(status_lines)
        event.client.add_notification(title="T3 hardware stream updated", body="Selected stream stopped.", color="orange")

    def _pause_t3_hardware_motion(self, client_id: int) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        if not session.t3_hardware_stream_base:
            return
        if not bool(session.gui_elements.gui_t3_hardware_send_checkbox.value):
            session.gui_elements.gui_t3_hardware_payload_md.content += "\n\nSimulation paused; base preview is stopped."
            return
        from ardy.t3_hardware import T3FramePayload

        try:
            dry_run = not bool(session.gui_elements.gui_t3_hardware_enable_checkbox.value)
            bridge = self._ensure_t3_hardware_bridge(
                session,
                dry_run=dry_run,
                require_arms=False,
                require_base=True,
                require_lift=False,
            )
            stop_payload = T3FramePayload(
                frame_index=max(0, int(session.frame_idx)),
                mode="base",
                base_wheel_rpm=(0.0, 0.0),
            )
            self._append_t3_hardware_log(
                session,
                stop_payload,
                stop_payload.to_stream_payload(),
                sent_to_stream=True,
                dry_run=dry_run,
            )
            sent = bridge.send(stop_payload)
            session.gui_elements.gui_t3_hardware_payload_md.content = (
                "**T3 Hardware Paused**\n\n"
                "Sent zero base RPM while keeping the stream ready for resume.\n\n"
                "```json\n" + json.dumps(sent, indent=2) + "\n```"
                f"\n\nCSV log file:\n\n`{session.t3_hardware_csv_log_path}`"
                f"\n\nRaw JSONL log file:\n\n`{session.t3_hardware_log_path}`"
            )
        except Exception as exc:
            session.gui_elements.gui_t3_hardware_payload_md.content = f"T3 hardware pause failed:\n\n`{exc}`"

    def _disconnect_t3_hardware(self, client_id: int) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        session.t3_hardware_stream_base = False
        session.t3_hardware_stream_robot = False
        session.t3_hardware_stream_lift = False
        session.t3_hardware_last_sent_frame = -1
        if session.t3_hardware_bridge is not None:
            session.t3_hardware_bridge.disconnect()
        if session.t3_live_retargeter is not None:
            session.t3_live_retargeter.clear()
            session.t3_live_retargeter = None
        if session.t3_csv_player is not None:
            session.t3_csv_player.clear()
            session.t3_csv_player = None
        session.t3_csv_player_generation = -1
        session.gui_elements.gui_t3_hardware_payload_md.content = "Disconnected."
