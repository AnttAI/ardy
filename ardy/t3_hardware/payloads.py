"""Build inspectable hardware payloads from ARDY live T3 data."""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Any

import numpy as np

from ardy.retarget_to_t3.base import T3BaseTracker
from ardy.retarget_to_t3.constants import WHEEL_RADIUS_M, WHEEL_SEPARATION_M
from ardy.retarget_to_t3.lift import (
    compute_t3_lift_extension,
    lift_csv_value_to_extension_m,
    lift_extension_m_to_display_cm,
    lift_extension_m_to_hardware_cm,
)


RIGHT_ARM_COLUMNS = [f"right_joint{i}_dof" for i in range(1, 8)]
LEFT_ARM_COLUMNS = [f"left_joint{i}_dof" for i in range(1, 8)]
RAD_S_TO_RPM = 60.0 / (2.0 * math.pi)


@dataclass(frozen=True)
class ArmFrame:
    frame_index: int
    right: list[float]
    left: list[float]


@dataclass(frozen=True)
class T3FramePayload:
    frame_index: int
    mode: str
    arm_frame: ArmFrame | None = None
    base_wheel_rpm: tuple[int, int] | None = None
    gripper: float | None = None
    lift: float | None = None
    lift_frame_index: int | None = None
    lift_value_frame_index: int | None = None
    base_debug: dict[str, float] | None = None
    t3_row: dict[str, float] | None = None

    def to_stream_payload(self) -> dict[str, object]:
        data: dict[str, object] = {"frame_index": int(self.frame_index)}
        if self.arm_frame is not None:
            data["right"] = [float(value) for value in self.arm_frame.right]
            data["left"] = [float(value) for value in self.arm_frame.left]
        if self.gripper is not None:
            data["gripper"] = float(self.gripper)
            data["gripper_effort"] = 1.0
        if self.lift is not None:
            data["lift"] = float(self.lift)
            if self.lift_frame_index is not None:
                data["lift_frame_index"] = int(self.lift_frame_index)
        if self.base_wheel_rpm is not None:
            data["base_wheel_rpm"] = [int(self.base_wheel_rpm[0]), int(self.base_wheel_rpm[1])]
        return data

    def preview(self) -> str:
        lines = [f"**Outgoing T3 Payload**", "", f"Mode: `{self.mode}`", f"Frame: `{self.frame_index}`"]
        if self.base_wheel_rpm is not None:
            lines.append(f"Base wheel RPM `[left, right]`: `{self.base_wheel_rpm[0]}, {self.base_wheel_rpm[1]}`")
        if self.base_debug:
            lines.append(
                "Base debug: "
                f"`v={self.base_debug['forward_velocity_m_s']:.3f} m/s, "
                f"yaw_rate={self.base_debug['yaw_rate_rad_s']:.3f} rad/s`"
            )
        if self.arm_frame is not None:
            right = ", ".join(f"{v:.4f}" for v in self.arm_frame.right)
            left = ", ".join(f"{v:.4f}" for v in self.arm_frame.left)
            lines.extend(["Right arm rad:", f"`[{right}]`", "Left arm rad:", f"`[{left}]`"])
        if self.gripper is not None:
            lines.append(f"Gripper: `{self.gripper:.4f}`")
        if self.lift is not None:
            lines.append(f"Lift cm: `{self.lift:.1f}`")
        if self.lift_frame_index is not None:
            lines.append(f"Lift hardware frame: `{self.lift_frame_index}`")
        if self.lift_value_frame_index is not None:
            lines.append(f"Lift value source frame: `{self.lift_value_frame_index}`")
        return "\n\n".join(lines)


def _to_numpy(value: Any) -> np.ndarray:
    if hasattr(value, "detach") and hasattr(value, "cpu"):
        return value.detach().cpu().numpy()
    return np.asarray(value)


def _idx(skeleton: Any, *names: str) -> int | None:
    bone_index = getattr(skeleton, "bone_order_names_index", {})
    for name in names:
        if name in bone_index:
            return int(bone_index[name])
    return None


def _yaw_from_matrix(rot: np.ndarray) -> float:
    forward = rot @ np.array([0.0, 0.0, 1.0], dtype=np.float64)
    return float(math.atan2(forward[0], forward[2]))


def _body_facing_yaw(skeleton: Any, joints_pos: np.ndarray, joints_rot: np.ndarray, fallback_idx: int) -> float:
    left_shoulder_idx = _idx(skeleton, "LeftShoulder")
    right_shoulder_idx = _idx(skeleton, "RightShoulder")
    left_hip_idx = _idx(skeleton, "LeftUpLeg", "LeftLeg")
    right_hip_idx = _idx(skeleton, "RightUpLeg", "RightLeg")
    lateral_vectors = []
    if left_shoulder_idx is not None and right_shoulder_idx is not None:
        lateral_vectors.append(joints_pos[left_shoulder_idx] - joints_pos[right_shoulder_idx])
    if left_hip_idx is not None and right_hip_idx is not None:
        lateral_vectors.append(joints_pos[left_hip_idx] - joints_pos[right_hip_idx])
    if lateral_vectors:
        lateral = np.mean(np.stack(lateral_vectors, axis=0), axis=0)
        lateral[1] = 0.0
        norm = float(np.linalg.norm(lateral))
        if norm > 1e-6:
            lateral = lateral / norm
            forward = np.cross(lateral, np.array([0.0, 1.0, 0.0], dtype=np.float64))
            return float(math.atan2(forward[0], forward[2]))
    return _yaw_from_matrix(joints_rot[fallback_idx])


def _arm_frame_from_t3_row(t3_row: dict[str, float], frame_idx: int) -> ArmFrame:
    missing = [column for column in [*RIGHT_ARM_COLUMNS, *LEFT_ARM_COLUMNS] if column not in t3_row]
    if missing:
        raise ValueError("T3 row is missing arm columns: " + ", ".join(missing))
    return ArmFrame(
        frame_index=int(frame_idx),
        right=[math.radians(float(t3_row[column])) for column in RIGHT_ARM_COLUMNS],
        left=[math.radians(float(t3_row[column])) for column in LEFT_ARM_COLUMNS],
    )


def _gripper_from_t3_row(t3_row: dict[str, float]) -> float | None:
    values = []
    for column in (
        "left_gripper_joint1_dof",
        "left_gripper_joint2_dof",
        "right_gripper_joint1_dof",
        "right_gripper_joint2_dof",
    ):
        if column not in t3_row:
            continue
        value = t3_row[column]
        if isinstance(value, str):
            value = value.strip()
        if value in ("", None):
            continue
        values.append(float(value))
    if not values:
        return None
    return float(np.mean(np.abs(values)))


def _base_command_for_frame(
    skeleton: Any,
    joints_pos_seq: Any,
    joints_rot_seq: Any,
    frame_idx: int,
    fps: float,
    root_velocities_seq: Any | None,
    rpm_scale: float,
    playback_speed: float,
    base_mapping: str,
    linear_scale: float,
    backward_scale: float,
    yaw_scale: float,
    max_abs_rpm: float | None,
) -> tuple[tuple[int, int] | None, dict[str, float]]:
    joints_pos = _to_numpy(joints_pos_seq).astype(np.float64, copy=False)
    joints_rot = _to_numpy(joints_rot_seq).astype(np.float64, copy=False)
    root_velocities = None if root_velocities_seq is None else _to_numpy(root_velocities_seq).astype(np.float64, copy=False)
    root_idx = _idx(skeleton, "Hips", "Pelvis")
    if root_idx is None:
        root_idx = int(getattr(skeleton, "root_idx", 0))

    tracker = T3BaseTracker()
    frame_idx = max(0, min(int(frame_idx), joints_pos.shape[0] - 1))
    base = None
    step_ground_distance_m = 0.0
    prev_root_xz = None
    for idx in range(frame_idx + 1):
        root_xz = joints_pos[idx, root_idx, [0, 2]]
        if prev_root_xz is not None:
            step_ground_distance_m = float(np.linalg.norm(root_xz - prev_root_xz))
        prev_root_xz = root_xz.copy()
        root_velocity = None if root_velocities is None else root_velocities[idx, [0, 2]]
        waist_yaw = _body_facing_yaw(skeleton, joints_pos[idx], joints_rot[idx], root_idx)
        base = tracker.update(root_xz, waist_yaw, fps, root_velocity_xz_m_s=root_velocity)
    if base is None:
        raise RuntimeError("No generated base frame is available.")

    playback_speed = max(float(playback_speed), 0.05)
    linear_scale = float(linear_scale)
    backward_scale = float(backward_scale)
    yaw_scale = float(yaw_scale)
    scaled_forward_velocity_m_s = float(base.forward_velocity_m_s) * playback_speed * linear_scale
    if scaled_forward_velocity_m_s < 0.0:
        scaled_forward_velocity_m_s *= backward_scale
    scaled_yaw_rate_rad_s = float(base.yaw_rate_rad_s) * playback_speed * yaw_scale
    left_rad_s = (scaled_forward_velocity_m_s - scaled_yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0) / WHEEL_RADIUS_M
    right_rad_s = (scaled_forward_velocity_m_s + scaled_yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0) / WHEEL_RADIUS_M
    left_rpm = left_rad_s * RAD_S_TO_RPM
    right_rpm = right_rad_s * RAD_S_TO_RPM
    sim_left_rpm = int(round(float(left_rpm * rpm_scale)))
    sim_right_rpm = int(round(float(right_rpm * rpm_scale)))
    if base_mapping == "kimodo_tara":
        hardware_left = int(round(float(right_rpm * rpm_scale)))
        hardware_right = int(round(float(-left_rpm * rpm_scale)))
    elif base_mapping == "direct":
        hardware_left = sim_left_rpm
        hardware_right = sim_right_rpm
    elif base_mapping == "swap":
        hardware_left = sim_right_rpm
        hardware_right = sim_left_rpm
    elif base_mapping == "invert_both":
        hardware_left = -sim_left_rpm
        hardware_right = -sim_right_rpm
    else:
        raise ValueError(f"Unknown base mapping {base_mapping!r}")
    unlimited_hardware_left = hardware_left
    unlimited_hardware_right = hardware_right
    rpm_limit_scale = 1.0
    if max_abs_rpm is not None and float(max_abs_rpm) > 0.0:
        peak = max(abs(float(hardware_left)), abs(float(hardware_right)))
        if peak > float(max_abs_rpm):
            rpm_limit_scale = float(max_abs_rpm) / peak
            hardware_left = int(round(float(hardware_left) * rpm_limit_scale))
            hardware_right = int(round(float(hardware_right) * rpm_limit_scale))
    debug = {
        "time_s": float(frame_idx / max(float(fps) * playback_speed, 1e-6)),
        "root_x_m": float(base.world_x_m),
        "root_y_m": float(base.world_z_m),
        "root_z_m": 0.0,
        "root_yaw_rad": float(base.yaw_rad),
        "root_yaw_deg": float(math.degrees(base.yaw_rad)),
        "step_ground_distance_m": float(step_ground_distance_m),
        "distance_from_start_m": float(tracker.total_distance),
        "forward_velocity_m_s": scaled_forward_velocity_m_s,
        "yaw_rate_rad_s": scaled_yaw_rate_rad_s,
        "left_wheel_rad_s": float(left_rad_s),
        "right_wheel_rad_s": float(right_rad_s),
        "left_motor_rpm": int(hardware_left),
        "right_motor_rpm": int(hardware_right),
        "unlimited_left_motor_rpm": int(unlimited_hardware_left),
        "unlimited_right_motor_rpm": int(unlimited_hardware_right),
        "base_max_abs_rpm": "" if max_abs_rpm is None else float(max_abs_rpm),
        "base_rpm_limit_scale": float(rpm_limit_scale),
        "sim_left_rpm": int(sim_left_rpm),
        "sim_right_rpm": int(sim_right_rpm),
        "raw_left_rpm": float(left_rpm),
        "raw_right_rpm": float(right_rpm),
        "base_mapping": base_mapping,
        "base_linear_scale": linear_scale,
        "base_backward_scale": backward_scale,
        "base_yaw_scale": yaw_scale,
    }
    return (hardware_left, hardware_right), debug


def _base_command_from_route(
    route_positions: Any,
    route_headings: Any,
    frame_idx: int,
    fps: float,
    rpm_scale: float,
    playback_speed: float,
    base_mapping: str,
    linear_scale: float,
    backward_scale: float,
    yaw_scale: float,
    max_abs_rpm: float | None,
) -> tuple[tuple[int, int], dict[str, float]]:
    positions = _to_numpy(route_positions).astype(np.float64, copy=False)
    headings = np.unwrap(_to_numpy(route_headings).astype(np.float64, copy=False))
    if positions.ndim != 2 or positions.shape[0] == 0 or positions.shape[1] < 3:
        raise RuntimeError("Rack base route positions are invalid.")
    if headings.ndim != 1 or headings.shape[0] != positions.shape[0]:
        raise RuntimeError("Rack base route headings are invalid.")

    requested_frame_idx = max(0, int(frame_idx))
    frame_idx = min(requested_frame_idx, positions.shape[0] - 1)
    emit_base_rpm = requested_frame_idx < positions.shape[0]
    playback_speed = max(float(playback_speed), 0.05)
    dt = 1.0 / max(float(fps), 1.0)
    if frame_idx <= 0 or not emit_base_rpm:
        forward_velocity_m_s = 0.0
        yaw_rate_rad_s = 0.0
        step_ground_distance_m = 0.0
    else:
        prev_pos = positions[frame_idx - 1]
        cur_pos = positions[frame_idx]
        prev_heading = float(headings[frame_idx - 1])
        cur_heading = float(headings[frame_idx])
        delta_xz = cur_pos[[0, 2]] - prev_pos[[0, 2]]
        drive_heading = np.array([math.sin(prev_heading), math.cos(prev_heading)], dtype=np.float64)
        step_ground_distance_m = float(np.linalg.norm(delta_xz))
        forward_velocity_m_s = float(np.dot(delta_xz / dt, drive_heading))
        yaw_rate_rad_s = float((cur_heading - prev_heading) / dt)

    linear_scale = float(linear_scale)
    backward_scale = float(backward_scale)
    yaw_scale = float(yaw_scale)
    scaled_forward_velocity_m_s = forward_velocity_m_s * playback_speed * linear_scale
    if scaled_forward_velocity_m_s < 0.0:
        scaled_forward_velocity_m_s *= backward_scale
    scaled_yaw_rate_rad_s = yaw_rate_rad_s * playback_speed * yaw_scale
    left_rad_s = (scaled_forward_velocity_m_s - scaled_yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0) / WHEEL_RADIUS_M
    right_rad_s = (scaled_forward_velocity_m_s + scaled_yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0) / WHEEL_RADIUS_M
    left_rpm = left_rad_s * RAD_S_TO_RPM
    right_rpm = right_rad_s * RAD_S_TO_RPM
    sim_left_rpm = int(round(float(left_rpm * rpm_scale)))
    sim_right_rpm = int(round(float(right_rpm * rpm_scale)))
    if base_mapping == "kimodo_tara":
        hardware_left = int(round(float(right_rpm * rpm_scale)))
        hardware_right = int(round(float(-left_rpm * rpm_scale)))
    elif base_mapping == "direct":
        hardware_left = sim_left_rpm
        hardware_right = sim_right_rpm
    elif base_mapping == "swap":
        hardware_left = sim_right_rpm
        hardware_right = sim_left_rpm
    elif base_mapping == "invert_both":
        hardware_left = -sim_left_rpm
        hardware_right = -sim_right_rpm
    else:
        raise ValueError(f"Unknown base mapping {base_mapping!r}")

    unlimited_hardware_left = hardware_left
    unlimited_hardware_right = hardware_right
    rpm_limit_scale = 1.0
    if max_abs_rpm is not None and float(max_abs_rpm) > 0.0:
        peak = max(abs(float(hardware_left)), abs(float(hardware_right)))
        if peak > float(max_abs_rpm):
            rpm_limit_scale = float(max_abs_rpm) / peak
            hardware_left = int(round(float(hardware_left) * rpm_limit_scale))
            hardware_right = int(round(float(hardware_right) * rpm_limit_scale))

    route_xz = positions[:, [0, 2]]
    if frame_idx > 0:
        total_distance = float(np.sum(np.linalg.norm(np.diff(route_xz[: frame_idx + 1], axis=0), axis=1)))
    else:
        total_distance = 0.0
    debug = {
        "time_s": float(frame_idx / max(float(fps) * playback_speed, 1e-6)),
        "root_x_m": float(positions[frame_idx, 0]),
        "root_y_m": float(positions[frame_idx, 2]),
        "root_z_m": 0.0,
        "root_yaw_rad": float(headings[frame_idx]),
        "root_yaw_deg": float(math.degrees(headings[frame_idx])),
        "step_ground_distance_m": step_ground_distance_m,
        "distance_from_start_m": total_distance,
        "forward_velocity_m_s": scaled_forward_velocity_m_s,
        "yaw_rate_rad_s": scaled_yaw_rate_rad_s,
        "left_wheel_rad_s": float(left_rad_s),
        "right_wheel_rad_s": float(right_rad_s),
        "left_motor_rpm": int(hardware_left),
        "right_motor_rpm": int(hardware_right),
        "unlimited_left_motor_rpm": int(unlimited_hardware_left),
        "unlimited_right_motor_rpm": int(unlimited_hardware_right),
        "base_max_abs_rpm": "" if max_abs_rpm is None else float(max_abs_rpm),
        "base_rpm_limit_scale": float(rpm_limit_scale),
        "sim_left_rpm": int(sim_left_rpm),
        "sim_right_rpm": int(sim_right_rpm),
        "raw_left_rpm": float(left_rpm),
        "raw_right_rpm": float(right_rpm),
        "base_mapping": f"{base_mapping}:rack_route",
        "base_linear_scale": linear_scale,
        "base_backward_scale": backward_scale,
        "base_yaw_scale": yaw_scale,
    }
    return (hardware_left, hardware_right) if emit_base_rpm else None, debug


def _t3_log_row_for_frame(
    t3_row: dict[str, float] | None,
    skeleton: Any,
    joints_pos_seq: Any,
    frame_idx: int,
) -> dict[str, float]:
    row = dict(t3_row or {})
    joints_pos = _to_numpy(joints_pos_seq).astype(np.float64, copy=False)
    frame_idx = max(0, min(int(frame_idx), joints_pos.shape[0] - 1))
    lift_m = compute_t3_lift_extension(joints_pos[frame_idx], skeleton)
    row["telescopic_lift_joint_dof"] = lift_extension_m_to_display_cm(lift_m)
    return row


def _lift_hardware_value_from_row_or_motion(
    row: dict[str, float] | None,
    skeleton: Any,
    joints_pos_seq: Any,
    frame_idx: int,
) -> float:
    if row is not None and "telescopic_lift_joint_dof" in row:
        value = row.get("telescopic_lift_joint_dof")
        if isinstance(value, str):
            value = value.strip()
        if value not in ("", None):
            return float(value)
    log_row = _t3_log_row_for_frame(None, skeleton, joints_pos_seq, frame_idx)
    return float(log_row["telescopic_lift_joint_dof"])


def build_t3_frame_payload(
    *,
    mode: str,
    frame_idx: int,
    skeleton: Any,
    joints_pos_seq: Any,
    joints_rot_seq: Any,
    fps: float,
    t3_row: dict[str, float] | None,
    root_velocities_seq: Any | None = None,
    rpm_scale: float = 1.0,
    playback_speed: float = 1.0,
    base_mapping: str = "direct",
    linear_scale: float = 1.0,
    backward_scale: float = 1.0,
    yaw_scale: float = 1.0,
    max_abs_rpm: float | None = None,
    base_frame_idx: int | None = None,
    base_route_positions: Any | None = None,
    base_route_headings: Any | None = None,
    emit_lift: bool = True,
    lift_frame_idx: int | None = None,
    lift_value_frame_idx: int | None = None,
) -> T3FramePayload:
    if mode not in {"base", "robot", "both", "lift", "base_lift", "robot_lift", "full"}:
        raise ValueError(f"Unsupported T3 hardware mode: {mode}")
    stream_robot = mode in {"robot", "both", "robot_lift", "full"}
    stream_base = mode in {"base", "both", "base_lift", "full"}
    stream_lift = mode in {"lift", "base_lift", "robot_lift", "full"}
    log_t3_row = _t3_log_row_for_frame(t3_row, skeleton, joints_pos_seq, frame_idx)
    arm_frame = _arm_frame_from_t3_row(t3_row, frame_idx) if stream_robot and t3_row is not None else None
    if stream_robot and arm_frame is None:
        raise ValueError("No accurate Soma T3 row is ready for this frame. Generate/retarget T3 first.")
    base_wheel_rpm = None
    base_debug = None
    if stream_base:
        base_frame_idx = frame_idx if base_frame_idx is None else int(base_frame_idx)
        if base_route_positions is not None and base_route_headings is not None:
            base_wheel_rpm, base_debug = _base_command_from_route(
                base_route_positions,
                base_route_headings,
                base_frame_idx,
                fps,
                rpm_scale,
                playback_speed,
                base_mapping,
                linear_scale,
                backward_scale,
                yaw_scale,
                max_abs_rpm,
            )
        else:
            base_wheel_rpm, base_debug = _base_command_for_frame(
                skeleton,
                joints_pos_seq,
                joints_rot_seq,
                base_frame_idx,
                fps,
                root_velocities_seq,
                rpm_scale,
                playback_speed,
                base_mapping,
                linear_scale,
                backward_scale,
                yaw_scale,
                max_abs_rpm,
            )
        base_debug["base_frame_index"] = int(base_frame_idx)
    lift = None
    lift_hardware_frame = None
    lift_source_frame = None
    if stream_lift and emit_lift:
        lift_hardware_frame = int(frame_idx if lift_frame_idx is None else lift_frame_idx)
        lift_source_frame = int(frame_idx if lift_value_frame_idx is None else lift_value_frame_idx)
        lift_row = t3_row if lift_source_frame == int(frame_idx) else None
        lift = _lift_hardware_value_from_row_or_motion(lift_row, skeleton, joints_pos_seq, lift_source_frame)
    return T3FramePayload(
        frame_index=int(frame_idx),
        mode=mode,
        arm_frame=arm_frame,
        base_wheel_rpm=base_wheel_rpm,
        gripper=None if t3_row is None else _gripper_from_t3_row(t3_row),
        lift=lift,
        lift_frame_index=lift_hardware_frame,
        lift_value_frame_index=lift_source_frame,
        base_debug=base_debug,
        t3_row=log_t3_row,
    )


def _float_from_row(row: dict[str, str | float], key: str, default: float = 0.0) -> float:
    value = row.get(key, default)
    if isinstance(value, str):
        value = value.strip()
    if value == "" or value is None:
        return float(default)
    return float(value)


def _typed_csv_row(row: dict[str, str | float]) -> dict[str, str | float]:
    typed: dict[str, str | float] = {}
    for key, value in row.items():
        if isinstance(value, str):
            value = value.strip()
        if value in ("", None):
            typed[key] = ""
            continue
        try:
            typed[key] = float(value)
        except (TypeError, ValueError):
            typed[key] = str(value)
    return typed


def _csv_base_rpm(
    row: dict[str, str | float],
    rpm_scale: float,
    max_abs_rpm: float | None,
    linear_scale: float,
    backward_scale: float,
    yaw_scale: float,
) -> tuple[tuple[int, int], dict[str, float]]:
    if "base_left_rpm" in row and "base_right_rpm" in row:
        left = _float_from_row(row, "base_left_rpm")
        right = _float_from_row(row, "base_right_rpm")
    else:
        left = _float_from_row(row, "left_motor_rpm")
        right = _float_from_row(row, "right_motor_rpm")
    left_rad_s = left / RAD_S_TO_RPM
    right_rad_s = right / RAD_S_TO_RPM
    forward_velocity_m_s = WHEEL_RADIUS_M * (left_rad_s + right_rad_s) / 2.0
    yaw_rate_rad_s = WHEEL_RADIUS_M * (right_rad_s - left_rad_s) / WHEEL_SEPARATION_M
    scaled_forward_velocity_m_s = forward_velocity_m_s * float(linear_scale)
    backward_scale = float(backward_scale)
    if scaled_forward_velocity_m_s < 0.0:
        scaled_forward_velocity_m_s *= backward_scale
    scaled_yaw_rate_rad_s = yaw_rate_rad_s * float(yaw_scale)
    scaled_left_rad_s = (
        scaled_forward_velocity_m_s - scaled_yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0
    ) / WHEEL_RADIUS_M
    scaled_right_rad_s = (
        scaled_forward_velocity_m_s + scaled_yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0
    ) / WHEEL_RADIUS_M
    unlimited_left = int(round(scaled_left_rad_s * RAD_S_TO_RPM * float(rpm_scale)))
    unlimited_right = int(round(scaled_right_rad_s * RAD_S_TO_RPM * float(rpm_scale)))
    hardware_left = unlimited_left
    hardware_right = unlimited_right
    rpm_limit_scale = 1.0
    if max_abs_rpm is not None and float(max_abs_rpm) > 0.0:
        peak = max(abs(float(hardware_left)), abs(float(hardware_right)))
        if peak > float(max_abs_rpm):
            rpm_limit_scale = float(max_abs_rpm) / peak
            hardware_left = int(round(float(hardware_left) * rpm_limit_scale))
            hardware_right = int(round(float(hardware_right) * rpm_limit_scale))
    debug = {
        "time_s": _float_from_row(row, "time_s", 0.0),
        "root_x_m": _float_from_row(row, "root_x_m", 0.0),
        "root_y_m": _float_from_row(row, "root_y_m", 0.0),
        "root_z_m": _float_from_row(row, "root_z_m", 0.0),
        "root_yaw_rad": _float_from_row(row, "root_yaw_rad", 0.0),
        "root_yaw_deg": _float_from_row(row, "root_yaw_deg", 0.0),
        "step_ground_distance_m": _float_from_row(row, "step_ground_distance_m", 0.0),
        "distance_from_start_m": _float_from_row(row, "distance_from_start_m", 0.0),
        "forward_velocity_m_s": float(scaled_forward_velocity_m_s),
        "yaw_rate_rad_s": float(scaled_yaw_rate_rad_s),
        "left_wheel_rad_s": float(scaled_left_rad_s),
        "right_wheel_rad_s": float(scaled_right_rad_s),
        "left_motor_rpm": int(hardware_left),
        "right_motor_rpm": int(hardware_right),
        "unlimited_left_motor_rpm": int(unlimited_left),
        "unlimited_right_motor_rpm": int(unlimited_right),
        "base_max_abs_rpm": "" if max_abs_rpm is None else float(max_abs_rpm),
        "base_rpm_limit_scale": float(rpm_limit_scale),
        "sim_left_rpm": int(unlimited_left),
        "sim_right_rpm": int(unlimited_right),
        "base_mapping": str(row.get("base_mapping", "csv")),
        "base_linear_scale": float(linear_scale),
        "base_backward_scale": backward_scale,
        "base_yaw_scale": float(yaw_scale),
        "base_frame_index": int(_float_from_row(row, "base_frame_index", _float_from_row(row, "frame_index", 0.0))),
    }
    return (hardware_left, hardware_right), debug


def _csv_has_values(row: dict[str, str | float], columns: list[str]) -> bool:
    for column in columns:
        value = row.get(column)
        if isinstance(value, str):
            value = value.strip()
        if value not in ("", None):
            return True
    return False


def build_t3_csv_frame_payload(
    row: dict[str, str | float],
    *,
    mode: str,
    rpm_scale: float = 1.0,
    max_abs_rpm: float | None = None,
    linear_scale: float = 1.0,
    backward_scale: float = 1.0,
    yaw_scale: float = 1.0,
    emit_lift: bool = True,
) -> T3FramePayload:
    if mode not in {"base", "robot", "both", "lift", "base_lift", "robot_lift", "full"}:
        raise ValueError(f"Unsupported T3 CSV hardware mode: {mode}")
    stream_robot = mode in {"robot", "both", "robot_lift", "full"}
    stream_base = mode in {"base", "both", "base_lift", "full"}
    stream_lift = mode in {"lift", "base_lift", "robot_lift", "full"}
    frame_idx = int(_float_from_row(row, "frame_index", _float_from_row(row, "Frame", 0.0)))
    has_arm_values = _csv_has_values(row, [*RIGHT_ARM_COLUMNS, *LEFT_ARM_COLUMNS])
    arm_frame = _arm_frame_from_t3_row(row, frame_idx) if stream_robot and has_arm_values else None
    base_wheel_rpm = None
    base_debug = None
    has_base_values = _csv_has_values(row, ["base_left_rpm", "base_right_rpm", "left_motor_rpm", "right_motor_rpm"])
    if stream_base and has_base_values:
        base_wheel_rpm, base_debug = _csv_base_rpm(
            row,
            rpm_scale,
            max_abs_rpm,
            linear_scale,
            backward_scale,
            yaw_scale,
        )
    lift = None
    lift_hardware_frame = None
    lift_source_frame = None
    if (
        stream_lift
        and emit_lift
        and "telescopic_lift_joint_dof" in row
        and _csv_has_values(row, ["telescopic_lift_joint_dof"])
    ):
        lift_hardware_frame = frame_idx
        lift_source_frame = frame_idx
        lift = _float_from_row(row, "telescopic_lift_joint_dof", 0.0)
    return T3FramePayload(
        frame_index=frame_idx,
        mode=f"csv_{mode}",
        arm_frame=arm_frame,
        base_wheel_rpm=base_wheel_rpm,
        gripper=_gripper_from_t3_row(row) if stream_robot else None,
        lift=lift,
        lift_frame_index=lift_hardware_frame,
        lift_value_frame_index=lift_source_frame,
        base_debug=base_debug,
        t3_row=_typed_csv_row(row),
    )
