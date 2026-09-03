#!/usr/bin/env python3
"""Local T3 CSV payload helpers for the standalone direct_t3_csv_ros UI."""

from __future__ import annotations

import math
from dataclasses import dataclass


RIGHT_ARM_COLUMNS = [f"right_joint{i}_dof" for i in range(1, 8)]
LEFT_ARM_COLUMNS = [f"left_joint{i}_dof" for i in range(1, 8)]
RAD_S_TO_RPM = 60.0 / (2.0 * math.pi)
WHEEL_RADIUS_M = 0.1
WHEEL_SEPARATION_M = 0.406


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
    t3_row: dict[str, object] | None = None

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


def _float_from_row(row: dict[str, object], key: str, default: float = 0.0) -> float:
    value = row.get(key, default)
    if isinstance(value, str):
        value = value.strip()
    if value in ("", None):
        return default
    return float(value)


def _csv_has_values(row: dict[str, object], columns: list[str]) -> bool:
    for column in columns:
        value = row.get(column)
        if isinstance(value, str):
            value = value.strip()
        if value not in ("", None):
            return True
    return False


def _arm_frame_from_t3_row(row: dict[str, object], frame_idx: int) -> ArmFrame:
    missing = [column for column in [*RIGHT_ARM_COLUMNS, *LEFT_ARM_COLUMNS] if column not in row]
    if missing:
        raise ValueError("T3 row is missing arm columns: " + ", ".join(missing))
    return ArmFrame(
        frame_index=int(frame_idx),
        right=[math.radians(_float_from_row(row, column)) for column in RIGHT_ARM_COLUMNS],
        left=[math.radians(_float_from_row(row, column)) for column in LEFT_ARM_COLUMNS],
    )


def _gripper_from_t3_row(row: dict[str, object]) -> float | None:
    values = []
    for column in (
        "left_gripper_joint1_dof",
        "left_gripper_joint2_dof",
        "right_gripper_joint1_dof",
        "right_gripper_joint2_dof",
    ):
        if column in row and _csv_has_values(row, [column]):
            values.append(_float_from_row(row, column))
    if not values:
        return None
    return float(sum(abs(value) for value in values) / len(values))


def _base_rpm_from_t3_row(
    row: dict[str, object],
    rpm_scale: float,
    max_abs_rpm: float | None,
    linear_scale: float,
    backward_scale: float,
    yaw_scale: float,
) -> tuple[int, int]:
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

    forward_velocity_m_s *= float(linear_scale)
    if forward_velocity_m_s < 0.0:
        forward_velocity_m_s *= float(backward_scale)
    yaw_rate_rad_s *= float(yaw_scale)

    scaled_left_rad_s = (forward_velocity_m_s - yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0) / WHEEL_RADIUS_M
    scaled_right_rad_s = (forward_velocity_m_s + yaw_rate_rad_s * WHEEL_SEPARATION_M / 2.0) / WHEEL_RADIUS_M
    hardware_left = int(round(scaled_left_rad_s * RAD_S_TO_RPM * float(rpm_scale)))
    hardware_right = int(round(scaled_right_rad_s * RAD_S_TO_RPM * float(rpm_scale)))

    if max_abs_rpm is not None and float(max_abs_rpm) > 0.0:
        peak = max(abs(float(hardware_left)), abs(float(hardware_right)))
        if peak > float(max_abs_rpm):
            scale = float(max_abs_rpm) / peak
            hardware_left = int(round(float(hardware_left) * scale))
            hardware_right = int(round(float(hardware_right) * scale))
    return hardware_left, hardware_right


def build_t3_csv_frame_payload(
    row: dict[str, object],
    *,
    mode: str,
    rpm_scale: float = 1.0,
    max_abs_rpm: float | None = 90.0,
    linear_scale: float = 1.0,
    backward_scale: float = 1.0,
    yaw_scale: float = 1.0,
    emit_lift: bool = True,
) -> T3FramePayload:
    if mode not in {"robot", "robot_lift", "base_lift", "full"}:
        raise ValueError(f"Unsupported T3 CSV hardware mode: {mode}")

    stream_robot = mode in {"robot", "robot_lift", "full"}
    stream_base = mode in {"base_lift", "full"}
    stream_lift = mode in {"robot_lift", "base_lift", "full"}
    frame_idx = int(_float_from_row(row, "frame_index", _float_from_row(row, "Frame", 0.0)))

    arm_frame = None
    if stream_robot and _csv_has_values(row, [*RIGHT_ARM_COLUMNS, *LEFT_ARM_COLUMNS]):
        arm_frame = _arm_frame_from_t3_row(row, frame_idx)

    base_wheel_rpm = None
    if stream_base and _csv_has_values(row, ["base_left_rpm", "base_right_rpm", "left_motor_rpm", "right_motor_rpm"]):
        base_wheel_rpm = _base_rpm_from_t3_row(row, rpm_scale, max_abs_rpm, linear_scale, backward_scale, yaw_scale)

    lift = None
    lift_frame_index = None
    if stream_lift and emit_lift and _csv_has_values(row, ["telescopic_lift_joint_dof"]):
        lift = _float_from_row(row, "telescopic_lift_joint_dof")
        lift_frame_index = frame_idx

    return T3FramePayload(
        frame_index=frame_idx,
        mode=f"csv_{mode}",
        arm_frame=arm_frame,
        base_wheel_rpm=base_wheel_rpm,
        gripper=_gripper_from_t3_row(row) if stream_robot else None,
        lift=lift,
        lift_frame_index=lift_frame_index,
        t3_row=dict(row),
    )
