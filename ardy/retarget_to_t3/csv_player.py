# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Viser playback helper for T3 CSV files."""

from __future__ import annotations

import ast
import csv
import math
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
from scipy.spatial.transform import Rotation

from .constants import DEFAULT_T3_URDF_PATH
from .lift import lift_csv_value_to_extension_m

WHEEL_Z_UP_TO_SCENE_Y_UP = Rotation.from_euler("x", -90.0, degrees=True)
T3_LINEAR_JOINTS = {
    "telescopic_lift_joint",
    "left_gripper_joint1",
    "left_gripper_joint2",
    "right_gripper_joint1",
    "right_gripper_joint2",
}
T3_STIFF_POSTURE_JOINTS = {
    "waist_yaw_joint",
    "waist_roll_joint",
    "waist_pitch_joint",
}
T3_ROOT_GROUND_HEIGHT_M = 0.0


def _rotation_wxyz(rotation: Rotation) -> np.ndarray:
    xyzw = rotation.as_quat()
    return np.array([xyzw[3], xyzw[0], xyzw[1], xyzw[2]], dtype=np.float64)


class T3CsvPlaybackRobot:
    """Draw and update a T3 robot directly from a retargeted T3 CSV."""

    def __init__(self, server, csv_path: str | Path, urdf_path: str | Path = DEFAULT_T3_URDF_PATH, root_node_name: str = "/t3_csv"):
        self.server = server
        self.csv_path = Path(csv_path)
        self.urdf_path = Path(urdf_path)
        if not self.csv_path.exists():
            raise FileNotFoundError(f"T3 CSV not found: {self.csv_path}")
        if not self.urdf_path.exists():
            raise FileNotFoundError(f"T3 URDF not found: {self.urdf_path}")

        self.rows, self.header = self._read_rows(self.csv_path)
        self.num_frames = len(self.rows)
        if self.num_frames == 0:
            raise ValueError(f"T3 CSV has no frames: {self.csv_path}")

        from viser.extras import ViserUrdf

        self.root_frame = server.scene.add_frame(root_node_name, show_axes=False)
        self.robot = ViserUrdf(
            server,
            urdf_or_path=self.urdf_path,
            root_node_name=self.root_frame.name,
            scale=1.0,
            load_meshes=True,
            load_collision_meshes=False,
        )
        self.joint_names = self.robot.get_actuated_joint_names()
        self.joint_index = {name: idx for idx, name in enumerate(self.joint_names)}
        self.joint_limits = self._read_joint_limits()
        self.cfg = np.zeros(len(self.joint_names), dtype=np.float64)
        self._apply_differential_drive_root()
        self.left_wheel_angles, self.right_wheel_angles = self._integrate_wheel_angles()

    @staticmethod
    def _read_rows(path: str | Path) -> tuple[list[dict[str, float]], list[str]]:
        path = Path(path)
        with path.open(newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            if reader.fieldnames is None:
                raise ValueError(f"{path} has no CSV header")
            rows = []
            for row in reader:
                parsed_row = {}
                for key, value in row.items():
                    if isinstance(value, str):
                        value = value.strip()
                    if value in {"", None}:
                        parsed_row[key] = 0.0
                        continue
                    try:
                        parsed_row[key] = float(value)
                    except (TypeError, ValueError):
                        parsed_row[key] = value
                rows.append(parsed_row)
        return rows, list(reader.fieldnames)

    def _read_joint_limits(self) -> dict[str, tuple[float, float]]:
        limits: dict[str, tuple[float, float]] = {}
        root = ET.parse(self.urdf_path).getroot()
        for joint in root.findall("joint"):
            limit = joint.find("limit")
            if limit is None or "lower" not in limit.attrib or "upper" not in limit.attrib:
                continue
            limits[joint.attrib["name"]] = (float(limit.attrib["lower"]), float(limit.attrib["upper"]))
        return limits

    def _integrate_wheel_angles(self) -> tuple[np.ndarray, np.ndarray]:
        left = np.zeros(self.num_frames, dtype=np.float64)
        right = np.zeros(self.num_frames, dtype=np.float64)
        for idx in range(1, self.num_frames):
            prev = self.rows[idx - 1]
            cur = self.rows[idx]
            dt = max(cur.get("time_s", idx / 30.0) - prev.get("time_s", (idx - 1) / 30.0), 1.0 / 120.0)
            left[idx] = left[idx - 1] + prev.get("left_wheel_rad_s", 0.0) * dt
            right[idx] = right[idx - 1] + prev.get("right_wheel_rad_s", 0.0) * dt
        return np.remainder(left + math.pi, 2.0 * math.pi) - math.pi, np.remainder(right + math.pi, 2.0 * math.pi) - math.pi

    def _csv_fps(self, default: float = 30.0) -> float:
        for key in ("effective_send_fps", "native_fps"):
            value = self.rows[0].get(key, 0.0)
            if isinstance(value, (int, float)) and value > 0.0:
                return float(value)
        times = [float(row["time_s"]) for row in self.rows if isinstance(row.get("time_s"), (int, float))]
        if len(times) < 2:
            return default
        deltas = np.diff(np.asarray(times, dtype=np.float64))
        deltas = deltas[deltas > 1.0e-6]
        if deltas.size == 0:
            return default
        return float(np.clip(1.0 / float(np.median(deltas)), 1.0, 240.0))

    def _apply_differential_drive_root(self) -> None:
        if not any("forward_velocity_m_s" in row or "yaw_rate_rad_s" in row for row in self.rows):
            return
        fps = self._csv_fps(default=30.0)
        x = float(self.rows[0].get("root_x_m", 0.0))
        z = float(self.rows[0].get("root_y_m", 0.0))
        yaw = float(self.rows[0].get("root_yaw_rad", math.radians(float(self.rows[0].get("root_rotateZ", 0.0)))))
        previous_time = float(self.rows[0].get("time_s", 0.0))
        for idx, row in enumerate(self.rows):
            if idx > 0:
                current_time = float(row.get("time_s", previous_time + 1.0 / max(fps, 1.0e-6)))
                dt = current_time - previous_time
                if dt <= 0.0 or not np.isfinite(dt):
                    dt = 1.0 / max(fps, 1.0e-6)
                prev = self.rows[idx - 1]
                v = float(prev.get("forward_velocity_m_s", 0.0))
                w = float(prev.get("yaw_rate_rad_s", 0.0))
                mid_yaw = yaw + 0.5 * w * dt
                x += v * math.cos(mid_yaw) * dt
                z += v * math.sin(mid_yaw) * dt
                yaw += w * dt
                previous_time = current_time
            row["root_x_m"] = x
            row["root_y_m"] = z
            row["root_yaw_rad"] = yaw
            row["root_yaw_deg"] = math.degrees(yaw)

    def _set_joint(self, name: str, value: float) -> None:
        idx = self.joint_index.get(name)
        if idx is None:
            return
        limits = self.joint_limits.get(name)
        if limits is not None:
            value = float(np.clip(value, limits[0], limits[1]))
        self.cfg[idx] = float(value)

    def _stiffen_waist(self) -> None:
        for joint_name in T3_STIFF_POSTURE_JOINTS:
            self._set_joint(joint_name, 0.0)

    @staticmethod
    def _array_value(value, expected_len: int) -> np.ndarray | None:
        if isinstance(value, str):
            try:
                value = ast.literal_eval(value)
            except (SyntaxError, ValueError):
                return None
        array = np.asarray(value, dtype=np.float64)
        if array.shape != (expected_len,):
            return None
        return array

    def update(self, frame_idx: int, offset=(0.0, 0.0, 0.0), yaw_offset_deg: float = -90.0) -> None:
        idx = int(frame_idx)
        if idx < 0 or idx >= self.num_frames:
            raise IndexError(f"T3 CSV frame {idx} is outside available range [0, {self.num_frames - 1}]")
        row = self.rows[idx]
        offset_np = np.asarray(offset, dtype=np.float64)

        exact_position = self._array_value(row.get("viser_root_position"), 3)
        if exact_position is not None:
            exact_position = exact_position.copy()
            exact_position[1] = T3_ROOT_GROUND_HEIGHT_M
            self.root_frame.position = exact_position + offset_np
            exact_wxyz = self._array_value(row.get("viser_root_wxyz"), 4)
            if exact_wxyz is not None:
                self.root_frame.wxyz = exact_wxyz
            else:
                self.root_frame.wxyz = _rotation_wxyz(WHEEL_Z_UP_TO_SCENE_Y_UP)
        elif "root_x_m" in row and "root_y_m" in row:
            x = row["root_x_m"]
            z = row["root_y_m"]
            y = T3_ROOT_GROUND_HEIGHT_M
            self.root_frame.position = np.array([x, y, z], dtype=np.float64) + offset_np

            if "root_yaw_rad" in row:
                yaw = row["root_yaw_rad"]
            elif "root_rotateZ" in row:
                yaw = math.radians(row.get("root_rotateZ", 0.0))
            else:
                yaw = math.radians(row.get("root_rotateY", 0.0))
            yaw = yaw + math.radians(float(yaw_offset_deg))
            yaw_rot = Rotation.from_euler("y", yaw)
            self.root_frame.wxyz = _rotation_wxyz(yaw_rot * WHEEL_Z_UP_TO_SCENE_Y_UP)
        else:
            x = row.get("root_translateX", 0.0) * 0.01
            y = T3_ROOT_GROUND_HEIGHT_M
            z = row.get("root_translateY", 0.0) * 0.01
            self.root_frame.position = np.array([x, y, z], dtype=np.float64) + offset_np

            if "root_rotateZ" in row:
                yaw = math.radians(row.get("root_rotateZ", 0.0))
            else:
                yaw = math.radians(row.get("root_rotateY", 0.0))
            yaw = yaw + math.radians(float(yaw_offset_deg))
            yaw_rot = Rotation.from_euler("y", yaw)
            self.root_frame.wxyz = _rotation_wxyz(yaw_rot * WHEEL_Z_UP_TO_SCENE_Y_UP)

        self._stiffen_waist()
        for column, value in row.items():
            if not column.endswith("_dof"):
                continue
            joint_name = column[:-4]
            if joint_name in T3_STIFF_POSTURE_JOINTS:
                continue
            if joint_name == "telescopic_lift_joint":
                joint_value = lift_csv_value_to_extension_m(value)
            elif joint_name in T3_LINEAR_JOINTS:
                joint_value = value
            else:
                joint_value = math.radians(value)
            self._set_joint(joint_name, joint_value)
        self._stiffen_waist()
        self._set_joint("left_wheel_joint", float(self.left_wheel_angles[idx]))
        self._set_joint("right_wheel_joint", float(self.right_wheel_angles[idx]))
        self.robot.update_cfg(self.cfg)

    def has_frame(self, frame_idx: int) -> bool:
        return 0 <= int(frame_idx) < self.num_frames

    def set_visible(self, visible: bool) -> None:
        self.root_frame.visible = bool(visible)
        self.robot.show_visual = bool(visible)

    def clear(self) -> None:
        self.root_frame.remove()
