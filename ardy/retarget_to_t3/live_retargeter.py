# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Live T3 robot driver for ARDY's generated frames."""

from __future__ import annotations

import math
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
import torch
from scipy.spatial.transform import Rotation
from viser.extras import ViserUrdf

from .base import T3BaseTracker
from .constants import DEFAULT_T3_URDF_PATH, T3_LIFT_JOINT
from .lift import compute_t3_lift_extension

WHEEL_Z_UP_TO_SCENE_Y_UP = Rotation.from_euler("x", -90.0, degrees=True)
T3_UPPER_BODY_CSV_JOINTS = {
    "head_pitch_joint_dof": "head_pitch_joint",
    "head_yaw_joint_dof": "head_yaw_joint",
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
T3_PRISMATIC_CSV_JOINTS = {
    "left_gripper_joint1",
    "left_gripper_joint2",
    "right_gripper_joint1",
    "right_gripper_joint2",
}


def _to_numpy(value) -> np.ndarray:
    if isinstance(value, torch.Tensor):
        return value.detach().cpu().numpy()
    return np.asarray(value)


def _yaw_from_matrix(rot: np.ndarray) -> float:
    forward = rot @ np.array([0.0, 0.0, 1.0], dtype=np.float64)
    return float(math.atan2(forward[0], forward[2]))


def _clip(value: float, limits: tuple[float, float] | None) -> float:
    if limits is None:
        return float(value)
    lo, hi = limits
    return float(np.clip(value, lo, hi))


class T3LiveRetargeter:
    """Draw and update a T3 robot from ARDY-generated human frames."""

    def __init__(self, server, skeleton, urdf_path: str | Path = DEFAULT_T3_URDF_PATH, root_node_name: str = "/t3_live"):
        self.server = server
        self.skeleton = skeleton
        self.urdf_path = Path(urdf_path)
        if not self.urdf_path.exists():
            raise FileNotFoundError(f"T3 URDF not found: {self.urdf_path}")

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
        self.base_tracker = T3BaseTracker()

    def _read_joint_limits(self) -> dict[str, tuple[float, float]]:
        limits: dict[str, tuple[float, float]] = {}
        root = ET.parse(self.urdf_path).getroot()
        for joint in root.findall("joint"):
            limit = joint.find("limit")
            if limit is None or "lower" not in limit.attrib or "upper" not in limit.attrib:
                continue
            limits[joint.attrib["name"]] = (float(limit.attrib["lower"]), float(limit.attrib["upper"]))
        return limits

    def _idx(self, *names: str) -> int | None:
        for name in names:
            if name in self.skeleton.bone_order_names_index:
                return self.skeleton.bone_order_names_index[name]
        return None

    def _body_facing_yaw(self, joints_pos: np.ndarray, joints_rot: np.ndarray, fallback_idx: int) -> float:
        left_shoulder_idx = self._idx("LeftShoulder")
        right_shoulder_idx = self._idx("RightShoulder")
        left_hip_idx = self._idx("LeftUpLeg", "LeftLeg")
        right_hip_idx = self._idx("RightUpLeg", "RightLeg")

        lateral_vectors = []
        if left_shoulder_idx is not None and right_shoulder_idx is not None:
            lateral_vectors.append(joints_pos[left_shoulder_idx] - joints_pos[right_shoulder_idx])
        if left_hip_idx is not None and right_hip_idx is not None:
            lateral_vectors.append(joints_pos[left_hip_idx] - joints_pos[right_hip_idx])

        if lateral_vectors:
            lateral = np.mean(np.stack(lateral_vectors, axis=0), axis=0)
            lateral[1] = 0.0
            lateral_norm = float(np.linalg.norm(lateral))
            if lateral_norm > 1e-6:
                lateral = lateral / lateral_norm
                forward = np.cross(lateral, np.array([0.0, 1.0, 0.0], dtype=np.float64))
                return float(math.atan2(forward[0], forward[2]))

        return _yaw_from_matrix(joints_rot[fallback_idx])

    def _set_joint(self, name: str, value: float) -> None:
        idx = self.joint_index.get(name)
        if idx is not None:
            self.cfg[idx] = _clip(value, self.joint_limits.get(name))

    def _relative_euler_from_index(
        self,
        joints_rot: np.ndarray,
        bone_index: dict[str, int],
        child: str,
        parent: str,
        order: str = "xyz",
    ) -> np.ndarray:
        child_idx = bone_index.get(child)
        parent_idx = bone_index.get(parent)
        if child_idx is None or parent_idx is None:
            return np.zeros(3, dtype=np.float64)
        rel = joints_rot[parent_idx].T @ joints_rot[child_idx]
        return Rotation.from_matrix(rel).as_euler(order, degrees=False)

    def _relative_euler(self, joints_rot: np.ndarray, child: str, parent: str, order: str = "xyz") -> np.ndarray:
        return self._relative_euler_from_index(joints_rot, self.skeleton.bone_order_names_index, child, parent, order)

    def _local_pos(self, point: np.ndarray, origin: np.ndarray, yaw_rad: float) -> np.ndarray:
        delta = point - origin
        c = math.cos(-yaw_rad)
        s = math.sin(-yaw_rad)
        return np.array([c * delta[0] - s * delta[2], delta[1], s * delta[0] + c * delta[2]], dtype=np.float64)

    def _update_base_and_lift(
        self,
        joints_pos: np.ndarray,
        joints_rot: np.ndarray,
        fps: float,
        offset: np.ndarray,
        yaw_offset_rad: float,
        root_velocity: np.ndarray | None,
    ):
        root_idx = self._idx("Hips", "Pelvis")
        if root_idx is None:
            root_idx = getattr(self.skeleton, "root_idx", 0)
        root_pos = joints_pos[root_idx]
        waist_yaw = self._body_facing_yaw(joints_pos, joints_rot, root_idx)
        root_velocity_xz = None if root_velocity is None else root_velocity[[0, 2]]
        base = self.base_tracker.update(root_pos[[0, 2]], waist_yaw, fps, root_velocity_xz_m_s=root_velocity_xz)

        self.root_frame.position = np.array([base.world_x_m, 0.0, base.world_z_m], dtype=np.float64) + offset
        yaw_rot = Rotation.from_euler("y", base.yaw_rad + yaw_offset_rad)
        self.root_frame.wxyz = (yaw_rot * WHEEL_Z_UP_TO_SCENE_Y_UP).as_quat(scalar_first=True)

        self._set_joint("left_wheel_joint", base.left_wheel_angle_rad)
        self._set_joint("right_wheel_joint", base.right_wheel_angle_rad)
        self._set_joint(T3_LIFT_JOINT, compute_t3_lift_extension(joints_pos, self.skeleton))
        return root_pos, base.yaw_rad + yaw_offset_rad

    def _stiffen_waist(self) -> None:
        self._set_joint("waist_yaw_joint", 0.0)
        self._set_joint("waist_roll_joint", 0.0)
        self._set_joint("waist_pitch_joint", 0.0)

    def _update_torso_head(self, joints_rot: np.ndarray) -> None:
        spine = self._relative_euler(joints_rot, "Spine3", "Hips")
        if not np.any(spine):
            spine = self._relative_euler(joints_rot, "Chest", "Hips")
        self._set_joint("waist_roll_joint", spine[0] * 0.35)
        self._set_joint("waist_pitch_joint", spine[1] * 0.35)

        head = self._relative_euler(joints_rot, "Head", "Neck")
        if not np.any(head):
            head = self._relative_euler(joints_rot, "Head", "Neck2")
        self._set_joint("head_pitch_joint", head[1] * 0.6)
        self._set_joint("head_yaw_joint", head[2] * 0.6)

    def _update_arm_from_index(
        self,
        side: str,
        joints_pos: np.ndarray,
        joints_rot: np.ndarray,
        bone_index: dict[str, int],
        yaw: float,
    ) -> None:
        prefix = "left" if side == "Left" else "right"
        shoulder_idx = bone_index.get(f"{side}Shoulder")
        arm_idx = bone_index.get(f"{side}Arm")
        elbow_idx = bone_index.get(f"{side}ForeArm")
        hand_idx = bone_index.get(f"{side}Hand")
        if shoulder_idx is None or arm_idx is None or elbow_idx is None or hand_idx is None:
            return

        shoulder = joints_pos[shoulder_idx]
        elbow = joints_pos[elbow_idx]
        hand = joints_pos[hand_idx]
        upper = self._local_pos(elbow, shoulder, yaw)
        lower = self._local_pos(hand, elbow, yaw)
        target = self._local_pos(hand, shoulder, yaw)
        mirror = 1.0 if side == "Left" else -1.0

        upper_len = max(float(np.linalg.norm(upper)), 1e-6)
        lower_len = max(float(np.linalg.norm(lower)), 1e-6)
        target_len = float(np.clip(np.linalg.norm(target), 1e-6, upper_len + lower_len - 1e-6))
        elbow_angle = math.pi - math.acos(
            np.clip((upper_len * upper_len + lower_len * lower_len - target_len * target_len) / (2.0 * upper_len * lower_len), -1.0, 1.0)
        )

        shoulder_yaw = math.atan2(target[0], max(abs(target[2]), 1e-6))
        shoulder_pitch = math.atan2(-target[1], max(np.linalg.norm(target[[0, 2]]), 1e-6))
        shoulder_roll = math.atan2(mirror * upper[2], max(abs(upper[1]), 1e-6))
        wrist = self._relative_euler_from_index(joints_rot, bone_index, f"{side}Hand", f"{side}ForeArm")

        self._set_joint(f"{prefix}_joint1", mirror * shoulder_yaw)
        self._set_joint(f"{prefix}_joint2", shoulder_pitch)
        self._set_joint(f"{prefix}_joint3", shoulder_roll)
        self._set_joint(f"{prefix}_joint4", -abs(elbow_angle))
        self._set_joint(f"{prefix}_joint5", mirror * wrist[2])
        self._set_joint(f"{prefix}_joint6", wrist[1])
        self._set_joint(f"{prefix}_joint7", mirror * wrist[0])
        self._set_joint(f"{prefix}_gripper_joint1", 0.0)
        self._set_joint(f"{prefix}_gripper_joint2", 0.0)

    def _update_arm(self, side: str, joints_pos: np.ndarray, joints_rot: np.ndarray, root_pos: np.ndarray, yaw: float) -> None:
        self._update_arm_from_index(side, joints_pos, joints_rot, self.skeleton.bone_order_names_index, yaw)

    def update(
        self,
        joints_pos,
        joints_rot,
        fps: float,
        offset=(0.0, 0.0, 0.0),
        yaw_offset_deg: float = -90.0,
        root_velocity=None,
    ) -> None:
        joints_pos_np = _to_numpy(joints_pos).astype(np.float64, copy=False)
        joints_rot_np = _to_numpy(joints_rot).astype(np.float64, copy=False)
        offset_np = np.asarray(offset, dtype=np.float64)
        yaw_offset_rad = math.radians(float(yaw_offset_deg))
        root_velocity_np = None if root_velocity is None else _to_numpy(root_velocity).astype(np.float64, copy=False)

        root_pos, base_yaw = self._update_base_and_lift(
            joints_pos_np,
            joints_rot_np,
            fps,
            offset_np,
            yaw_offset_rad,
            root_velocity_np,
        )
        self._update_torso_head(joints_rot_np)
        self._update_arm("Left", joints_pos_np, joints_rot_np, root_pos, base_yaw)
        self._update_arm("Right", joints_pos_np, joints_rot_np, root_pos, base_yaw)
        self.robot.update_cfg(self.cfg)

    def update_with_soma_upper_body_csv(
        self,
        joints_pos,
        joints_rot,
        t3_csv_row: dict[str, float],
        fps: float,
        offset=(0.0, 0.0, 0.0),
        yaw_offset_deg: float = -90.0,
        root_velocity=None,
        match_csv_root_yaw: bool = True,
    ) -> None:
        """Use ARDY base/lift/wheels, but Soma/Newton CSV upper-body joints."""
        joints_pos_np = _to_numpy(joints_pos).astype(np.float64, copy=False)
        joints_rot_np = _to_numpy(joints_rot).astype(np.float64, copy=False)
        offset_np = np.asarray(offset, dtype=np.float64)
        yaw_offset_rad = math.radians(float(yaw_offset_deg))
        root_velocity_np = None if root_velocity is None else _to_numpy(root_velocity).astype(np.float64, copy=False)

        self._update_base_and_lift(
            joints_pos_np,
            joints_rot_np,
            fps,
            offset_np,
            yaw_offset_rad,
            root_velocity_np,
        )
        if match_csv_root_yaw:
            # Soma/Newton CSVs are authored in a Z-up frame, so the character
            # heading lives in root_rotateZ. Viser renders T3 in Y-up; after the
            # fixed Z-up->Y-up conversion this heading maps to scene yaw.
            if "root_rotateZ" in t3_csv_row:
                csv_yaw_rad = math.radians(float(t3_csv_row["root_rotateZ"]))
            elif "root_yaw_rad" in t3_csv_row:
                csv_yaw_rad = float(t3_csv_row["root_yaw_rad"])
            else:
                csv_yaw_rad = math.radians(float(t3_csv_row.get("root_rotateY", 0.0)))
            yaw_rot = Rotation.from_euler("y", csv_yaw_rad)
            self.root_frame.wxyz = (yaw_rot * WHEEL_Z_UP_TO_SCENE_Y_UP).as_quat(scalar_first=True)
        self._stiffen_waist()
        for csv_column, joint_name in T3_UPPER_BODY_CSV_JOINTS.items():
            if csv_column not in t3_csv_row:
                continue
            value = float(t3_csv_row[csv_column])
            if joint_name not in T3_PRISMATIC_CSV_JOINTS:
                value = math.radians(value)
            self._set_joint(joint_name, value)
        self.robot.update_cfg(self.cfg)

    def update_with_soma_mesh_ik(
        self,
        core_joints_pos,
        core_joints_rot,
        soma_joints_pos,
        soma_joints_rot,
        soma_skeleton,
        fps: float,
        offset=(0.0, 0.0, 0.0),
        yaw_offset_deg: float = -90.0,
        root_velocity=None,
    ) -> None:
        """Use ARDY base/lift/wheels, but aim T3 arms from the live SOMA mesh joints."""
        core_pos_np = _to_numpy(core_joints_pos).astype(np.float64, copy=False)
        core_rot_np = _to_numpy(core_joints_rot).astype(np.float64, copy=False)
        soma_pos_np = _to_numpy(soma_joints_pos).astype(np.float64, copy=False)
        soma_rot_np = _to_numpy(soma_joints_rot).astype(np.float64, copy=False)
        offset_np = np.asarray(offset, dtype=np.float64)
        yaw_offset_rad = math.radians(float(yaw_offset_deg))
        root_velocity_np = None if root_velocity is None else _to_numpy(root_velocity).astype(np.float64, copy=False)

        _root_pos, base_yaw = self._update_base_and_lift(
            core_pos_np,
            core_rot_np,
            fps,
            offset_np,
            yaw_offset_rad,
            root_velocity_np,
        )
        self._stiffen_waist()
        soma_index = soma_skeleton.bone_order_names_index
        self._update_arm_from_index("Left", soma_pos_np, soma_rot_np, soma_index, base_yaw)
        self._update_arm_from_index("Right", soma_pos_np, soma_rot_np, soma_index, base_yaw)
        self.robot.update_cfg(self.cfg)

    def update_base_lift_stiff_upper(
        self,
        joints_pos,
        joints_rot,
        fps: float,
        offset=(0.0, 0.0, 0.0),
        yaw_offset_deg: float = -90.0,
        root_velocity=None,
    ) -> None:
        """Keep T3 visible using ARDY base/lift/wheels while exact Soma upper body is unavailable."""
        joints_pos_np = _to_numpy(joints_pos).astype(np.float64, copy=False)
        joints_rot_np = _to_numpy(joints_rot).astype(np.float64, copy=False)
        offset_np = np.asarray(offset, dtype=np.float64)
        yaw_offset_rad = math.radians(float(yaw_offset_deg))
        root_velocity_np = None if root_velocity is None else _to_numpy(root_velocity).astype(np.float64, copy=False)

        self._update_base_and_lift(
            joints_pos_np,
            joints_rot_np,
            fps,
            offset_np,
            yaw_offset_rad,
            root_velocity_np,
        )
        self._stiffen_waist()
        self.robot.update_cfg(self.cfg)

    def set_visible(self, visible: bool) -> None:
        self.root_frame.visible = bool(visible)
        self.robot.show_visual = bool(visible)

    def clear(self) -> None:
        self.root_frame.remove()
