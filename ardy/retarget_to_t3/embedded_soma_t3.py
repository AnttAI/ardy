"""Embedded SOMA/Newton BVH -> T3 upper-body retargeting for ARDY.

This module vendors the useful non-viewer parts of the Soma retargeter flow so
ARDY does not depend on an external ``/home/.../soma-retargeter`` checkout at
runtime. It still requires the Python dependencies used by Soma/Newton
(``warp``, ``newton``, etc.) to be installed in the active environment.
"""

from __future__ import annotations

import csv
import os
import sys
from pathlib import Path

import numpy as np
from scipy.spatial.transform import Rotation


VENDORED_RUNTIME_ROOT = Path(__file__).resolve().parent / "vendor" / "soma_retargeter_runtime"
VENDORED_REFERENCE_BVH = VENDORED_RUNTIME_ROOT / "assets" / "motions" / "bvh" / "Neutral_walk_forward_002__A057.bvh"

T3_LIFT_HEIGHT_OFFSET_M = -0.03

T3_CSV_HEADER = [
    "Frame",
    "root_translateX",
    "root_translateY",
    "root_translateZ",
    "root_rotateX",
    "root_rotateY",
    "root_rotateZ",
    "waist_yaw_joint_dof",
    "waist_roll_joint_dof",
    "waist_pitch_joint_dof",
    "head_pitch_joint_dof",
    "head_yaw_joint_dof",
    "right_joint1_dof",
    "right_joint2_dof",
    "right_joint3_dof",
    "right_joint4_dof",
    "right_joint5_dof",
    "right_joint6_dof",
    "right_joint7_dof",
    "right_gripper_joint1_dof",
    "right_gripper_joint2_dof",
    "left_joint1_dof",
    "left_joint2_dof",
    "left_joint3_dof",
    "left_joint4_dof",
    "left_joint5_dof",
    "left_joint6_dof",
    "left_joint7_dof",
    "left_gripper_joint1_dof",
    "left_gripper_joint2_dof",
]

T3_ARM_JOINT_LIMIT_DEG_S = {
    **{f"{side}_joint{i}_dof": 180.0 for side in ("right", "left") for i in range(1, 4)},
    **{f"{side}_joint{i}_dof": 225.0 for side in ("right", "left") for i in range(4, 8)},
}


def limit_t3_arm_joint_rates(
    rows: list[list[float]],
    header: list[str],
    *,
    fps: float,
    speed_percent: float | None = None,
) -> list[list[float]]:
    """Clamp T3 arm joint deltas so generated CSV rows obey configured joint speed."""
    if len(rows) < 2:
        return rows
    if speed_percent is None:
        speed_percent = float(os.environ.get("ARDY_T3_ARM_SPEED_PERCENT", "20.0"))
    speed_scale = max(float(speed_percent), 0.0) / 100.0
    if speed_scale <= 0.0:
        return rows

    dt = 1.0 / max(float(fps), 1e-6)
    column_indices = {
        joint_name: header.index(joint_name)
        for joint_name in T3_ARM_JOINT_LIMIT_DEG_S
        if joint_name in header
    }
    limited = [list(rows[0])]
    for target in rows[1:]:
        previous = limited[-1]
        current = list(target)
        for joint_name, column_idx in column_indices.items():
            max_delta = T3_ARM_JOINT_LIMIT_DEG_S[joint_name] * speed_scale * dt
            delta = float(target[column_idx]) - float(previous[column_idx])
            if abs(delta) > max_delta:
                current[column_idx] = float(previous[column_idx]) + float(np.sign(delta)) * max_delta
        limited.append(current)
    return limited


def ensure_vendored_soma_importable() -> None:
    """Put ARDY's vendored Soma runtime before any external Soma checkout."""
    runtime = str(VENDORED_RUNTIME_ROOT)
    if runtime in sys.path:
        sys.path.remove(runtime)
    sys.path.insert(0, runtime)


def _save_t3_csv_from_t2_buffer(path: Path, buffer) -> None:
    ensure_vendored_soma_importable()
    import soma_retargeter.assets.csv as csv_utils

    t2_config = csv_utils.get_csv_config("t2")
    t2_header = t2_config.csv_header
    t3_indices = [t2_header.index(column) for column in T3_CSV_HEADER]
    rows = [
        [float(t2_config.to_csv_row(frame_idx, buffer.get_data(frame_idx))[index]) for index in t3_indices]
        for frame_idx in range(buffer.num_frames)
    ]
    rows = limit_t3_arm_joint_rates(rows, T3_CSV_HEADER, fps=float(buffer.sample_rate))

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(T3_CSV_HEADER)
        writer.writerows(rows)


class SomaBvhT3UpperBodyRetargeter:
    """Reusable accurate SOMA BVH -> T3 upper-body retargeter.

    This keeps the expensive static SOMA/Newton pipeline setup alive for the
    lifetime of the worker process. Each request still runs the official
    pipeline execution for accuracy, but avoids rebuilding the retargeter,
    scaler, configs, target asset, and initialization pose on every packet.
    """

    def __init__(
        self,
        *,
        retarget_source: str = "soma",
        retarget_source_facing_direction: str = "Mujoco",
    ) -> None:
        ensure_vendored_soma_importable()

        import warp as wp

        import soma_retargeter.assets.bvh as bvh_utils
        import soma_retargeter.pipelines.newton_pipeline as newton_pipeline
        from soma_retargeter.utils.space_conversion_utils import SpaceConverter, get_facing_direction_type_from_str

        self.wp = wp
        self.bvh_utils = bvh_utils
        self.skeleton, _reference_animation = bvh_utils.load_bvh(VENDORED_REFERENCE_BVH)
        self.converter = SpaceConverter(get_facing_direction_type_from_str(retarget_source_facing_direction))
        self.bvh_tx_converter = self.converter.transform(wp.transform_identity())
        self.pipeline = newton_pipeline.NewtonPipeline(
            self.skeleton,
            retarget_source,
            "t2",
        )

    def retarget_bvh_to_csv(self, bvh_path: str | Path, output_csv: str | Path) -> float:
        bvh_path = Path(bvh_path).expanduser().resolve()
        output_csv = Path(output_csv).expanduser().resolve()

        _loaded_skeleton, animation = self.bvh_utils.load_bvh(bvh_path)
        # ARDY exports every live SOMA BVH from the same vendored reference
        # hierarchy. Reattach the cached skeleton so HumanToRobotScaler sees the
        # exact object it was initialized with.
        animation.skeleton = self.skeleton

        self.pipeline.clear()
        self.pipeline.add_input_motions([animation], [self.bvh_tx_converter], True)
        buffers = self.pipeline.execute()
        if len(buffers) != 1:
            raise RuntimeError(f"Expected one retargeted buffer for {bvh_path}, got {len(buffers)}")

        _save_t3_csv_from_t2_buffer(output_csv, buffers[0])
        return float(animation.sample_rate)


def _t2_anim_row_to_t3_row_dict(frame_idx: int, anim_row: np.ndarray) -> dict[str, float]:
    ensure_vendored_soma_importable()
    import soma_retargeter.assets.csv as csv_utils

    t2_config = csv_utils.get_csv_config("t2")
    t2_header = t2_config.csv_header
    t2_row = t2_config.to_csv_row(frame_idx, anim_row)
    t3_indices = [t2_header.index(column) for column in T3_CSV_HEADER]
    return {column: float(t2_row[index]) for column, index in zip(T3_CSV_HEADER, t3_indices)}


class SomaT3LiveUpperBodySolver:
    """Persistent Soma/Newton solver for one live T3 upper-body frame at a time."""

    def __init__(
        self,
        *,
        retarget_source: str = "soma",
        retarget_source_facing_direction: str = "Mujoco",
    ) -> None:
        ensure_vendored_soma_importable()

        import newton
        import newton.ik as ik
        import warp as wp

        import soma_retargeter.assets.bvh as bvh_utils
        import soma_retargeter.pipelines.newton_pipeline as newton_pipeline
        from soma_retargeter.animation.skeleton import SkeletonInstance
        from soma_retargeter.utils.space_conversion_utils import SpaceConverter, get_facing_direction_type_from_str

        self.wp = wp
        self.newton = newton
        self.ik = ik
        self.SkeletonInstance = SkeletonInstance

        skeleton, reference_animation = bvh_utils.load_bvh(VENDORED_REFERENCE_BVH)
        self.skeleton = skeleton
        self.reference_local_transforms = np.array(reference_animation.get_local_transforms(0), copy=True)
        self.converter = SpaceConverter(get_facing_direction_type_from_str(retarget_source_facing_direction))
        self.bvh_tx_converter = self.converter.transform(wp.transform_identity())

        self.pipeline = newton_pipeline.NewtonPipeline(skeleton, retarget_source, "t2")
        self.pipeline.clear()
        self.num_envs = 1
        self.model = self.pipeline._build_model(self.num_envs)
        self.state = self.model.state()
        (
            self.position_objectives,
            self.rotation_objectives,
            self.joint_limit_objective,
            self.smooth_joint_filter_objective,
            self.joint_target_objective,
            self.temporal_joint_smooth_objective,
        ) = self.pipeline._create_ik_objectives(self.num_envs, self.model, self.state)

        objectives = [*self.position_objectives, *self.rotation_objectives]
        if self.pipeline.joint_limit_weight > 0.0:
            objectives.append(self.joint_limit_objective)
        if self.pipeline.smooth_joint_filter_weight > 0.0:
            objectives.append(self.smooth_joint_filter_objective)
        if self.joint_target_objective is not None:
            objectives.append(self.joint_target_objective)
        if self.temporal_joint_smooth_objective is not None:
            objectives.append(self.temporal_joint_smooth_objective)

        self.ik_solver = ik.IKSolver(
            model=self.pipeline.ik_model,
            n_problems=self.num_envs,
            objectives=objectives,
            lambda_initial=0.1,
            jacobian_mode=ik.IKJacobianType.ANALYTIC,
        )
        self.joint_q = wp.empty(shape=(self.num_envs, self.pipeline.ik_model.joint_coord_count))
        wp.copy(self.joint_q, self.model.joint_q)
        self.pipeline._apply_initial_joint_q_overrides(self.joint_q, self.num_envs)
        if self.temporal_joint_smooth_objective is not None:
            self.temporal_joint_smooth_objective.set_targets(self.joint_q)
        self.ik_solver.reset()

        def single_step():
            self.ik_solver.step(self.joint_q, self.joint_q, iterations=self.pipeline.ik_iterations)

        self._single_step = single_step
        # Do not CUDA-graph-capture the live solver inside ARDY. The interactive
        # demo also runs PyTorch generation/playback work on CUDA from other
        # threads, and Warp capture can fail with legacy-stream dependency
        # errors in that mixed workload. Plain launches are slower than capture
        # but stable and still avoid the old subprocess/CSV playback latency.
        self.graph_capture = None

        self.frame_idx = 0
        self._needs_motion_initialization = True

    def _make_local_transforms(self, root_position_m: np.ndarray, local_rot_mats: np.ndarray) -> np.ndarray:
        local = np.array(self.reference_local_transforms, copy=True)
        for joint_idx in range(min(len(local), len(local_rot_mats))):
            position = local[joint_idx][0:3]
            if joint_idx == 0:
                position = root_position_m
            quat_xyzw = Rotation.from_matrix(local_rot_mats[joint_idx]).as_quat()
            local[joint_idx] = self.wp.transform(
                self.wp.vec3(float(position[0]), float(position[1]), float(position[2])),
                self.wp.quat(
                    float(quat_xyzw[0]),
                    float(quat_xyzw[1]),
                    float(quat_xyzw[2]),
                    float(quat_xyzw[3]),
                ),
            )
        return local

    def reset(self) -> None:
        self.wp.copy(self.joint_q, self.model.joint_q)
        self.pipeline._apply_initial_joint_q_overrides(self.joint_q, self.num_envs)
        if self.temporal_joint_smooth_objective is not None:
            self.temporal_joint_smooth_objective.set_targets(self.joint_q)
        self.ik_solver.reset()
        self.frame_idx = 0
        self._needs_motion_initialization = True

    def _solve_local_transforms(self, local_transforms: np.ndarray) -> np.ndarray:
        skel_instance = self.SkeletonInstance(self.skeleton, [0.0, 0.0, 0.0], self.bvh_tx_converter)
        skel_instance.set_local_transforms(local_transforms)
        effectors = self.pipeline.human_robot_scaler.compute_effectors_from_skeleton(skel_instance, True)
        frame_targets = effectors[self.pipeline.target_effector_indices]

        for i, target in enumerate(frame_targets):
            self.position_objectives[i].set_target_position(0, self.wp.vec3(*target[0:3]))
            self.rotation_objectives[i].set_target_rotation(0, self.wp.quat(*target[3:7]))

        if self.temporal_joint_smooth_objective is not None:
            self.temporal_joint_smooth_objective.set_targets(self.joint_q)

        if self.graph_capture is not None:
            self.wp.capture_launch(self.graph_capture)
        else:
            self._single_step()

        return self.pipeline.joint_limit_clamper.apply(self.joint_q).numpy()[0].copy()

    def _run_motion_initialization(self, first_local_transforms: np.ndarray) -> None:
        if self.pipeline.initialization_pose is None:
            return

        ensure_vendored_soma_importable()
        import soma_retargeter.utils.pose_utils as pose_utils

        num_frames_to_insert = max(0, int(self.pipeline.num_initialization_frames))
        num_stabilization_frames = max(0, int(self.pipeline.num_stabilization_frames))
        num_frames_to_remove = num_frames_to_insert + num_stabilization_frames
        if num_frames_to_remove <= 0:
            return

        num_root_blend_frames = max(0, num_frames_to_insert // 2)
        num_joint_blend_frames = max(0, num_frames_to_insert - num_root_blend_frames)

        index_map = np.fromiter(
            (self.pipeline.initialization_pose.skeleton.joint_index(name) for name in self.skeleton.joint_names),
            dtype=np.int32,
            count=self.skeleton.num_joints,
        )
        mask = index_map != -1
        start_pose = np.array(self.skeleton.reference_local_transforms, copy=True)
        start_pose[mask] = self.pipeline.initialization_pose.get_local_transforms()[index_map[mask]]
        end_pose = np.array(first_local_transforms, copy=True)

        start_pose_wp = self.wp.transform(start_pose[0][:3], start_pose[0][3:])
        root_start_t = self.wp.transform_get_translation(start_pose_wp)
        root_start_q = self.wp.transform_get_rotation(start_pose_wp)
        end_pose_wp = self.wp.transform(end_pose[0][:3], end_pose[0][3:])
        root_end_t = self.wp.transform_get_translation(end_pose_wp)
        root_end_q = self.wp.transform_get_rotation(end_pose_wp)

        initialization_poses = []
        for i in range(num_root_blend_frames):
            t = 1.0 if num_root_blend_frames <= 1 else i / (num_root_blend_frames - 1)
            pose = np.array(start_pose, copy=True)
            pose[0] = self.wp.transform(
                self.wp.lerp(root_start_t, root_end_t, t),
                self.wp.quat_slerp(root_start_q, root_end_q, t),
            )
            initialization_poses.append(pose)

        blend_start_pose = initialization_poses[-1] if initialization_poses else start_pose
        for i in range(num_joint_blend_frames):
            initialization_poses.append(
                pose_utils.blend_poses(blend_start_pose, end_pose, (i + 1) / num_joint_blend_frames)
            )

        for _ in range(num_stabilization_frames):
            initialization_poses.append(np.array(end_pose, copy=True))

        for frame, pose in enumerate(initialization_poses):
            if num_frames_to_remove > 0:
                weight = self.pipeline.smooth_joint_filter_weight * (frame / float(num_frames_to_remove))
                self.smooth_joint_filter_objective.set_weight(weight)
            self._solve_local_transforms(pose)
        self.smooth_joint_filter_objective.set_weight(self.pipeline.smooth_joint_filter_weight)

    def solve_frame(self, root_position_m, soma77_local_rot_mats) -> dict[str, float]:
        root_position_np = np.asarray(root_position_m, dtype=np.float32)
        local_rot_np = np.asarray(soma77_local_rot_mats, dtype=np.float32)
        local_transforms = self._make_local_transforms(root_position_np, local_rot_np)
        if self._needs_motion_initialization:
            self._run_motion_initialization(local_transforms)
            self._needs_motion_initialization = False
        data = self._solve_local_transforms(local_transforms)
        row = _t2_anim_row_to_t3_row_dict(self.frame_idx, data)
        self.frame_idx += 1
        return row

    def solve_soma_global_frame(self, soma_joints_pos, soma_joints_rot, soma_joint_names) -> dict[str, float]:
        """Retarget one frame from the currently displayed SOMA mesh global pose."""
        positions = np.asarray(soma_joints_pos, dtype=np.float32)
        rotations = np.asarray(soma_joints_rot, dtype=np.float32)
        if positions.ndim != 2 or positions.shape[1] != 3:
            raise ValueError(f"Expected SOMA joint positions [J, 3], got {positions.shape}")
        if rotations.ndim != 3 or rotations.shape[1:] != (3, 3):
            raise ValueError(f"Expected SOMA joint rotations [J, 3, 3], got {rotations.shape}")

        source_index = {name: idx for idx, name in enumerate(soma_joint_names)}
        local_transforms = np.array(self.reference_local_transforms, copy=True)
        for target_idx, joint_name in enumerate(self.skeleton.joint_names):
            source_idx = source_index.get(joint_name)
            if source_idx is None:
                continue
            parent_idx = self.skeleton.parent_indices[target_idx]
            child_rot = rotations[source_idx]
            child_pos = positions[source_idx]
            if parent_idx < 0:
                local_pos = child_pos
                local_rot = child_rot
            else:
                parent_source_idx = source_index.get(self.skeleton.joint_names[parent_idx])
                if parent_source_idx is None:
                    continue
                parent_rot = rotations[parent_source_idx]
                parent_pos = positions[parent_source_idx]
                local_rot = parent_rot.T @ child_rot
                local_pos = parent_rot.T @ (child_pos - parent_pos)
            quat_xyzw = Rotation.from_matrix(local_rot).as_quat()
            local_transforms[target_idx] = self.wp.transform(
                self.wp.vec3(float(local_pos[0]), float(local_pos[1]), float(local_pos[2])),
                self.wp.quat(
                    float(quat_xyzw[0]),
                    float(quat_xyzw[1]),
                    float(quat_xyzw[2]),
                    float(quat_xyzw[3]),
                ),
            )

        if self._needs_motion_initialization:
            self._run_motion_initialization(local_transforms)
            self._needs_motion_initialization = False
        data = self._solve_local_transforms(local_transforms)
        row = _t2_anim_row_to_t3_row_dict(self.frame_idx, data)
        self.frame_idx += 1
        return row

    def solve_frames(self, root_positions_m, soma77_local_rot_mats_seq) -> dict[str, float]:
        rows = self.solve_frame_rows(root_positions_m, soma77_local_rot_mats_seq)
        if not rows:
            raise ValueError("Cannot solve an empty live sequence")
        return rows[-1]

    def solve_frame_rows(self, root_positions_m, soma77_local_rot_mats_seq) -> list[dict[str, float]]:
        roots_np = np.asarray(root_positions_m, dtype=np.float32)
        local_rots_np = np.asarray(soma77_local_rot_mats_seq, dtype=np.float32)
        if roots_np.ndim != 2 or local_rots_np.ndim != 4:
            raise ValueError(
                "Expected root_positions_m shape [T, 3] and soma77_local_rot_mats_seq shape [T, J, 3, 3]"
            )
        if roots_np.shape[0] != local_rots_np.shape[0]:
            raise ValueError(
                f"Mismatched live sequence lengths: roots={roots_np.shape[0]} rotations={local_rots_np.shape[0]}"
            )
        rows: list[dict[str, float]] = []
        for frame_idx in range(roots_np.shape[0]):
            rows.append(self.solve_frame(roots_np[frame_idx], local_rots_np[frame_idx]))
        return rows


def retarget_soma_bvh_to_t3_upper_csv(
    bvh_path: str | Path,
    output_csv: str | Path,
    *,
    retarget_source: str = "soma",
    retarget_source_facing_direction: str = "Mujoco",
) -> float:
    """Retarget one SOMA BVH to a T3 upper-body CSV using vendored Soma code."""
    ensure_vendored_soma_importable()

    import warp as wp

    import soma_retargeter.assets.bvh as bvh_utils
    import soma_retargeter.pipelines.newton_pipeline as newton_pipeline
    from soma_retargeter.utils.space_conversion_utils import SpaceConverter, get_facing_direction_type_from_str

    bvh_path = Path(bvh_path).expanduser().resolve()
    output_csv = Path(output_csv).expanduser().resolve()

    skeleton, animation = bvh_utils.load_bvh(bvh_path)
    converter = SpaceConverter(get_facing_direction_type_from_str(retarget_source_facing_direction))
    bvh_tx_converter = converter.transform(wp.transform_identity())

    pipeline = newton_pipeline.NewtonPipeline(
        skeleton,
        retarget_source,
        "t2",
    )
    pipeline.clear()
    pipeline.add_input_motions([animation], [bvh_tx_converter], True)
    buffers = pipeline.execute()
    if len(buffers) != 1:
        raise RuntimeError(f"Expected one retargeted buffer for {bvh_path}, got {len(buffers)}")

    _save_t3_csv_from_t2_buffer(output_csv, buffers[0])
    return float(animation.sample_rate)
