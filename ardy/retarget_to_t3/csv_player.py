# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Viser playback helper for T3 CSV files."""

from __future__ import annotations

import csv
import math
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
from scipy.spatial.transform import Rotation

from .constants import DEFAULT_T3_URDF_PATH

WHEEL_Z_UP_TO_SCENE_Y_UP = Rotation.from_euler("x", -90.0, degrees=True)
T3_LINEAR_JOINTS = {"telescopic_lift_joint"}


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
                rows.append({key: float(value) if value not in {"", None} else 0.0 for key, value in row.items()})
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

    def _set_joint(self, name: str, value: float) -> None:
        idx = self.joint_index.get(name)
        if idx is None:
            return
        limits = self.joint_limits.get(name)
        if limits is not None:
            value = float(np.clip(value, limits[0], limits[1]))
        self.cfg[idx] = float(value)

    def update(self, frame_idx: int, offset=(0.0, 0.0, 0.0), yaw_offset_deg: float = -90.0) -> None:
        idx = int(frame_idx)
        if idx < 0 or idx >= self.num_frames:
            raise IndexError(f"T3 CSV frame {idx} is outside available range [0, {self.num_frames - 1}]")
        row = self.rows[idx]
        offset_np = np.asarray(offset, dtype=np.float64)

        if "root_x_m" in row and "root_y_m" in row:
            x = row["root_x_m"]
            z = row["root_y_m"]
            y = row.get("root_z_m", 0.0)
        else:
            x = row.get("root_translateX", 0.0) * 0.01
            y = row.get("root_translateY", 0.0) * 0.01
            z = row.get("root_translateZ", 0.0) * 0.01
        self.root_frame.position = np.array([x, y, z], dtype=np.float64) + offset_np

        if "root_yaw_rad" in row:
            yaw = row["root_yaw_rad"]
        elif "root_rotateZ" in row:
            yaw = math.radians(row.get("root_rotateZ", 0.0))
        else:
            yaw = math.radians(row.get("root_rotateY", 0.0))
        yaw = yaw + math.radians(float(yaw_offset_deg))
        yaw_rot = Rotation.from_euler("y", yaw)
        self.root_frame.wxyz = (yaw_rot * WHEEL_Z_UP_TO_SCENE_Y_UP).as_quat(scalar_first=True)

        for column, value in row.items():
            if not column.endswith("_dof"):
                continue
            joint_name = column[:-4]
            joint_value = value if joint_name in T3_LINEAR_JOINTS else math.radians(value)
            self._set_joint(joint_name, joint_value)
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
