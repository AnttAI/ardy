#!/usr/bin/env python3
"""Route Newton viewer T3 frames into the existing direct CSV ROS bridge."""

from __future__ import annotations

import math
import os
import sys
from dataclasses import dataclass, field
from pathlib import Path


HERE = Path(__file__).resolve().parent
ARDY_ROOT = HERE.parent
DIRECT_ROS_ROOT = ARDY_ROOT / "direct_t3_csv_ros"
if DIRECT_ROS_ROOT.is_dir() and str(DIRECT_ROS_ROOT) not in sys.path:
    sys.path.insert(0, str(DIRECT_ROS_ROOT))

try:
    from t3_bridge import T3HardwareBridge
    from t3_payloads import T3FramePayload, build_t3_csv_frame_payload
except Exception as exc:  # pragma: no cover - depends on local ROS helper files.
    T3HardwareBridge = None
    T3FramePayload = None
    build_t3_csv_frame_payload = None
    IMPORT_ERROR = exc
else:
    IMPORT_ERROR = None


T3_LINEAR_JOINTS = {
    "telescopic_lift_joint",
    "left_gripper_joint1",
    "left_gripper_joint2",
    "right_gripper_joint1",
    "right_gripper_joint2",
}
T3_ROW_TO_JOINT = {
    "telescopic_lift_joint_dof": "telescopic_lift_joint",
    "right_joint1_dof": "right_joint1",
    "right_joint2_dof": "right_joint2",
    "right_joint3_dof": "right_joint3",
    "right_joint4_dof": "right_joint4",
    "right_joint5_dof": "right_joint5",
    "right_joint6_dof": "right_joint6",
    "right_joint7_dof": "right_joint7",
    "right_gripper_joint1_dof": "right_gripper_joint1",
    "right_gripper_joint2_dof": "right_gripper_joint2",
    "left_joint1_dof": "left_joint1",
    "left_joint2_dof": "left_joint2",
    "left_joint3_dof": "left_joint3",
    "left_joint4_dof": "left_joint4",
    "left_joint5_dof": "left_joint5",
    "left_joint6_dof": "left_joint6",
    "left_joint7_dof": "left_joint7",
    "left_gripper_joint1_dof": "left_gripper_joint1",
    "left_gripper_joint2_dof": "left_gripper_joint2",
}
T3_JOINT_TO_ROW = {joint: column for column, joint in T3_ROW_TO_JOINT.items()}
T3_GRIPPER_MAX_APERTURE_M = 0.10


def _env_bool(name: str, default: bool = False) -> bool:
    raw = os.environ.get(name)
    if raw is None:
        return bool(default)
    return raw.strip().lower() in {"1", "true", "yes", "on"}


def _as_float(value: object, default: float = 0.0) -> float:
    try:
        if value in {"", None}:
            return default
    except TypeError:
        pass
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return default
    return parsed if math.isfinite(parsed) else default


def _row_uses_normalized_grippers(row: dict[str, object]) -> bool:
    mode = str(row.get("gripper_mode") or row.get("gripper_range") or "").strip().lower()
    return mode in {"normalized", "normalized_0_closed_1_open", "0_closed_1_open", "0close_1open"}


def _row_uses_aperture_grippers(row: dict[str, object]) -> bool:
    mode = str(row.get("gripper_mode") or row.get("gripper_range") or "").strip().lower()
    return mode in {"aperture", "aperture_m", "aperture_m_0_closed_0p1_open", "0_closed_0p1_open", "0close_0p1open"}


def _normalized_gripper_to_aperture(value: object) -> float:
    return max(0.0, min(1.0, _as_float(value))) * T3_GRIPPER_MAX_APERTURE_M * 0.5


def _aperture_gripper_to_joint(value: object) -> float:
    return max(0.0, min(T3_GRIPPER_MAX_APERTURE_M, _as_float(value))) * 0.5


def _set_gripper_aperture(row: dict[str, object], side: str, aperture: float) -> None:
    half = max(0.0, min(T3_GRIPPER_MAX_APERTURE_M, float(aperture))) * 0.5
    row[f"{side}_gripper_joint1_dof"] = half
    row[f"{side}_gripper_joint2_dof"] = -half
    row["gripper_mode"] = "joint_m_signed_width_sum"


def _clamp_gripper_pair(row: dict[str, object], side: str) -> None:
    c1 = f"{side}_gripper_joint1_dof"
    c2 = f"{side}_gripper_joint2_dof"
    if c1 not in row and c2 not in row:
        return
    j1 = _as_float(row.get(c1), 0.0)
    j2 = _as_float(row.get(c2), 0.0)
    width = abs(j1) + abs(j2)
    if width <= T3_GRIPPER_MAX_APERTURE_M:
        return
    scale = T3_GRIPPER_MAX_APERTURE_M / max(width, 1.0e-12)
    row[c1] = round(j1 * scale, 6)
    row[c2] = round(j2 * scale, 6)
    row["gripper_mode"] = "joint_m_signed_width_sum"


def _clamp_grippers(row: dict[str, object]) -> dict[str, object]:
    for side in ("left", "right"):
        _clamp_gripper_pair(row, side)
    return row


def _normalize_row(row: dict[str, object], frame_idx: int, fps: float) -> dict[str, object]:
    normalized = dict(row)
    normalized.setdefault("frame_index", normalized.get("frame_idx", frame_idx))
    normalized.setdefault("Frame", normalized.get("frame_idx", frame_idx))
    normalized.setdefault("fps", fps)

    if "joint_names" in normalized and "joint_cfg" in normalized:
        for joint_name, value in zip(normalized.get("joint_names", []), normalized.get("joint_cfg", [])):
            column = T3_JOINT_TO_ROW.get(str(joint_name))
            if column is None:
                continue
            value_f = _as_float(value)
            normalized[column] = value_f if str(joint_name) in T3_LINEAR_JOINTS else math.degrees(value_f)
        normalized["gripper_mode"] = "joint_m_signed_width_sum"
        return _clamp_grippers(normalized)

    if _row_uses_normalized_grippers(normalized):
        for side in ("left", "right"):
            for suffix, sign in (("joint1", 1.0), ("joint2", -1.0)):
                column = f"{side}_gripper_{suffix}_dof"
                if column in normalized:
                    normalized[column] = sign * _normalized_gripper_to_aperture(normalized[column])
        normalized["gripper_mode"] = "joint_m_signed_width_sum"
    elif _row_uses_aperture_grippers(normalized):
        for side in ("left", "right"):
            for suffix, sign in (("joint1", 1.0), ("joint2", -1.0)):
                column = f"{side}_gripper_{suffix}_dof"
                if column in normalized:
                    normalized[column] = sign * _aperture_gripper_to_joint(normalized[column])
        normalized["gripper_mode"] = "joint_m_signed_width_sum"
    return _clamp_grippers(normalized)


@dataclass
class T3RosRoute:
    """Small stateful route used by the viewer UI and live frame loop."""

    enabled: bool = field(default_factory=lambda: _env_bool("ARDY_NEWTON_ROS_ENABLED", False))
    dry_run: bool = field(default_factory=lambda: _env_bool("ARDY_NEWTON_ROS_DRY_RUN", False))
    mode: str = field(default_factory=lambda: os.environ.get("ARDY_NEWTON_ROS_MODE", "full").strip().lower())
    require_arms: bool = field(default_factory=lambda: _env_bool("ARDY_NEWTON_ROS_REQUIRE_ARMS", True))
    require_base: bool = field(default_factory=lambda: _env_bool("ARDY_NEWTON_ROS_REQUIRE_BASE", True))
    require_lift: bool = field(default_factory=lambda: _env_bool("ARDY_NEWTON_ROS_REQUIRE_LIFT", False))
    status: str = "ROS route idle"
    last_error: str = ""
    frames_sent: int = 0
    last_frame_idx: int = -1
    last_payload: dict[str, object] | None = None
    _bridge: object | None = None

    def __post_init__(self) -> None:
        if self.mode not in {"robot", "robot_lift", "base_lift", "full"}:
            self.mode = "full"
        if IMPORT_ERROR is not None:
            self.status = f"ROS route unavailable: {IMPORT_ERROR}"

    @property
    def connected(self) -> bool:
        return bool(self._bridge is not None and self._bridge.is_connected())

    def connect(self) -> None:
        if IMPORT_ERROR is not None or T3HardwareBridge is None:
            raise RuntimeError(f"ROS route unavailable: {IMPORT_ERROR}")
        if self.connected:
            self.status = "ROS connected"
            return
        stream_robot = self.mode in {"robot", "robot_lift", "full"}
        stream_base = self.mode in {"base_lift", "full"}
        stream_lift = self.mode in {"robot_lift", "base_lift", "full"}
        self._bridge = T3HardwareBridge(
            dry_run=bool(self.dry_run),
            require_arms=bool(self.require_arms and stream_robot),
            require_base=bool(self.require_base and stream_base),
            require_lift=bool(self.require_lift and stream_lift),
        )
        self._bridge.connect()
        self._bridge.wait_until_ready(float(os.environ.get("ARDY_NEWTON_ROS_READY_TIMEOUT", "10")))
        self.status = "ROS dry run connected" if self.dry_run else "ROS connected"
        self.last_error = ""

    def disconnect(self) -> None:
        if self._bridge is not None:
            self._bridge.disconnect()
        self.status = "ROS route idle"

    def set_enabled(self, enabled: bool) -> None:
        self.enabled = bool(enabled)
        if not self.enabled:
            self.disconnect()
        else:
            self.connect()

    def handle_command(self, frame: dict[str, object]) -> bool:
        command = str(frame.get("command") or frame.get("type") or "").strip().lower()
        if command not in {"ros_connect", "ros_disconnect", "ros_enable", "ros_disable", "ros_start", "ros_stop"}:
            return False
        try:
            if command in {"ros_disconnect", "ros_disable", "ros_stop"}:
                self.set_enabled(False)
            else:
                if "ros_mode" in frame:
                    self.mode = str(frame.get("ros_mode") or self.mode).strip().lower()
                if "ros_dry_run" in frame:
                    self.dry_run = bool(frame.get("ros_dry_run"))
                self.set_enabled(True)
        except Exception as exc:
            self.last_error = str(exc)
            self.status = f"ROS route failed: {exc}"
        return True

    def send_row(
        self,
        row: dict[str, object] | None,
        *,
        frame_idx: int,
        fps: float,
        gripper_override: dict[str, float] | None = None,
    ) -> dict[str, object] | None:
        if not self.enabled or row is None:
            return None
        if not self.connected:
            self.connect()
        routed_row = _normalize_row(row, frame_idx, fps)
        if gripper_override:
            for side, aperture in gripper_override.items():
                _set_gripper_aperture(routed_row, str(side), float(aperture))
        assert build_t3_csv_frame_payload is not None
        payload = build_t3_csv_frame_payload(routed_row, mode=self.mode)
        data = self._bridge.send(payload)
        self.frames_sent += 1
        self.last_frame_idx = int(data.get("frame_index", frame_idx))
        self.last_payload = data
        self.status = (
            f"ROS dry run frame {self.last_frame_idx}"
            if self.dry_run
            else f"ROS frame {self.last_frame_idx}"
        )
        self.last_error = ""
        return data

    def send_stop(self, frame_idx: int = -1) -> None:
        if not self.enabled or not self.connected:
            return
        data = {"frame_index": int(frame_idx), "base_wheel_rpm": [0, 0]}
        self._bridge.send_raw(data)
        self.last_payload = data
        self.last_frame_idx = int(frame_idx)
        self.status = "ROS base stop sent"
