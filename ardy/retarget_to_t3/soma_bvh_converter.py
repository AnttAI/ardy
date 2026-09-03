# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Retarget ARDY-generated SOMA BVHs to T3 CSVs via the embedded Soma runtime."""

from __future__ import annotations

import csv
import math
import tempfile
from pathlib import Path

import numpy as np
from scipy.spatial.transform import Rotation

from ardy.exports.bvh import export_soma_bvh_from_arrays

from .embedded_soma_t3 import VENDORED_REFERENCE_BVH, ensure_vendored_soma_importable, limit_t3_arm_joint_rates
from .lift import lift_extension_m_to_display_cm
from .constants import (
    T3_LIFT_HEIGHT_OFFSET_M,
    T3_LIFT_MAX_M,
    T3_LIFT_MIN_M,
    T3_SHOULDER_HEIGHT_NO_LIFT_M,
    T3_WAIST_HEIGHT_NO_LIFT_M,
    WHEEL_RADIUS_M,
    WHEEL_SEPARATION_M,
)

DEFAULT_REFERENCE_BVH = VENDORED_REFERENCE_BVH
DEFAULT_SOURCE_FACING_DIRECTION = "Mujoco"

T3_LIFT_COLUMN = "telescopic_lift_joint_dof"
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
T3_WHEEL_CSV_COLUMNS = [
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
    "left_motor_rpm",
    "right_motor_rpm",
]


def _ensure_soma_retargeter_importable() -> None:
    ensure_vendored_soma_importable()


def _save_t3_csv_from_t2_buffer(path: Path, buffer) -> None:
    _ensure_soma_retargeter_importable()
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


def _joint_indices(skeleton, names: tuple[str, ...]) -> list[int]:
    indices = [skeleton.joint_index(name) for name in names]
    return [idx for idx in indices if idx != -1]


def _compute_bvh_lift_extensions(
    bvh_path: Path,
    source_facing_direction: str = DEFAULT_SOURCE_FACING_DIRECTION,
    match_target: str = "waist",
    lift_height_offset_m: float = T3_LIFT_HEIGHT_OFFSET_M,
    waist_joint_names: tuple[str, ...] = ("Spine1", "Spine2", "Chest"),
    shoulder_joint_names: tuple[str, ...] = ("LeftShoulder", "RightShoulder"),
) -> np.ndarray:
    _ensure_soma_retargeter_importable()
    import warp as wp

    import soma_retargeter.assets.bvh as bvh_utils
    from soma_retargeter.utils.space_conversion_utils import SpaceConverter, get_facing_direction_type_from_str

    skeleton, animation = bvh_utils.load_bvh(bvh_path)
    converter = SpaceConverter(get_facing_direction_type_from_str(source_facing_direction))
    offset = converter.transform(wp.transform_identity())

    waist_indices = _joint_indices(skeleton, waist_joint_names)
    shoulder_indices = _joint_indices(skeleton, shoulder_joint_names)
    if not waist_indices and match_target in {"waist", "average"}:
        raise RuntimeError(f"BVH does not expose any waist joints {waist_joint_names!r}: {bvh_path}")
    if not shoulder_indices and match_target in {"waist", "shoulders", "average"}:
        raise RuntimeError(f"BVH does not expose any shoulder joints {shoulder_joint_names!r}: {bvh_path}")

    lift_extensions = np.zeros(animation.num_frames, dtype=np.float64)
    for frame_idx in range(animation.num_frames):
        transforms = animation.compute_global_transforms(frame_idx, offset)
        waist_height = None
        shoulder_height = None
        required_extensions = []
        if match_target in {"waist", "average"}:
            waist_height = float(np.mean([float(transforms[idx][2]) for idx in waist_indices]))
        if match_target in {"waist", "shoulders", "average"}:
            shoulder_height = float(np.mean([float(transforms[idx][2]) for idx in shoulder_indices]))

        if match_target == "waist":
            human_waist_to_shoulder = shoulder_height - waist_height
            t3_waist_to_shoulder = T3_SHOULDER_HEIGHT_NO_LIFT_M - T3_WAIST_HEIGHT_NO_LIFT_M
            target_waist_height = waist_height + (human_waist_to_shoulder - t3_waist_to_shoulder)
            required_extensions.append(target_waist_height - T3_WAIST_HEIGHT_NO_LIFT_M)
        elif match_target == "shoulders":
            required_extensions.append(shoulder_height - T3_SHOULDER_HEIGHT_NO_LIFT_M)
        elif match_target == "average":
            required_extensions.append(waist_height - T3_WAIST_HEIGHT_NO_LIFT_M)
            required_extensions.append(shoulder_height - T3_SHOULDER_HEIGHT_NO_LIFT_M)
        else:
            raise ValueError(f"Unknown lift match target: {match_target}")
        lift_extensions[frame_idx] = float(np.mean(required_extensions))

    return np.clip(lift_extensions + float(lift_height_offset_m), T3_LIFT_MIN_M, T3_LIFT_MAX_M)


def _append_lift_column_to_t3_csv(t3_csv: Path, lift_extensions_m: np.ndarray) -> None:
    with t3_csv.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames is None:
            raise ValueError(f"{t3_csv} has no header")
        rows = list(reader)

    if not rows:
        return

    original_header = [column for column in reader.fieldnames if column != T3_LIFT_COLUMN]
    insert_idx = original_header.index("head_yaw_joint_dof") + 1 if "head_yaw_joint_dof" in original_header else len(original_header)
    header = original_header[:insert_idx] + [T3_LIFT_COLUMN] + original_header[insert_idx:]

    with t3_csv.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        for row_idx, row in enumerate(rows):
            out = {column: row.get(column, "") for column in original_header}
            lift_m = float(lift_extensions_m[min(row_idx, len(lift_extensions_m) - 1)])
            out[T3_LIFT_COLUMN] = lift_extension_m_to_display_cm(lift_m)
            writer.writerow(out)


def _stable_path_headings(root_xy_m: np.ndarray, fps: float, window_size: int = 9) -> np.ndarray:
    del fps
    delta = np.gradient(root_xy_m, axis=0)
    heading = np.unwrap(np.arctan2(delta[:, 1], delta[:, 0]))
    if window_size <= 1 or heading.shape[0] < 3:
        return heading
    if window_size % 2 == 0:
        window_size += 1
    window_size = min(window_size, heading.shape[0] if heading.shape[0] % 2 == 1 else heading.shape[0] - 1)
    kernel = np.ones(window_size, dtype=np.float64) / float(window_size)
    pad = window_size // 2
    sin_values = np.pad(np.sin(heading), (pad, pad), mode="edge")
    cos_values = np.pad(np.cos(heading), (pad, pad), mode="edge")
    return np.unwrap(
        np.arctan2(
            np.convolve(sin_values, kernel, mode="valid"),
            np.convolve(cos_values, kernel, mode="valid"),
        )
    )


def _is_standing_root_motion(root_xy_m: np.ndarray, threshold_m: float) -> bool:
    if root_xy_m.shape[0] == 0:
        return True
    displacement = np.linalg.norm(root_xy_m - root_xy_m[0], axis=1)
    return float(np.max(displacement)) <= threshold_m


def _clamp_root_xy_radius(root_xy_m: np.ndarray, radius_m: float) -> np.ndarray:
    root_xy_m = np.asarray(root_xy_m, dtype=np.float64).copy()
    origin = root_xy_m[0].copy()
    delta = root_xy_m - origin
    norms = np.linalg.norm(delta, axis=1)
    scale = np.ones_like(norms)
    mask = norms > radius_m
    scale[mask] = radius_m / np.clip(norms[mask], 1e-8, None)
    return origin + delta * scale[:, None]


def _joint_facing_heading(skeleton, joint_targets: np.ndarray, base_direction_sign: float) -> np.ndarray:
    forward_axis = np.asarray(skeleton.forward_axis, dtype=np.float64)
    forward_world = Rotation.from_quat(joint_targets[:, 3:7]).apply(forward_axis)
    heading = np.unwrap(np.arctan2(forward_world[:, 1], forward_world[:, 0]))
    if base_direction_sign < 0.0:
        heading = heading + math.pi
    return np.unwrap(heading)


def _align_heading_with_path(heading: np.ndarray, path_heading: np.ndarray) -> np.ndarray:
    heading = np.unwrap(np.asarray(heading, dtype=np.float64))
    path_heading = np.unwrap(np.asarray(path_heading, dtype=np.float64))
    if heading.shape != path_heading.shape or heading.shape[0] == 0:
        return heading
    if float(np.mean(np.cos(heading - path_heading))) < 0.0:
        heading = heading + math.pi
    return np.unwrap(heading)


def _write_wheel_csv_from_root_trajectory(
    root_xy_m: np.ndarray,
    yaw_rad: np.ndarray,
    output_csv: Path,
    fps: float,
    wheel_radius_m: float,
    wheel_separation_m: float,
    max_forward_speed: float | None,
    max_yaw_rate: float | None,
    drive_heading_rad: np.ndarray | None = None,
    enforce_no_slip: bool = False,
) -> None:
    root_xy_m = np.asarray(root_xy_m, dtype=np.float64).copy()
    yaw_rad = np.unwrap(np.asarray(yaw_rad, dtype=np.float64))
    if root_xy_m.shape[0] != yaw_rad.shape[0]:
        raise ValueError("root trajectory and yaw must have the same number of frames")
    if root_xy_m.shape[0] < 2:
        raise ValueError("Need at least two frames to compute wheel commands")
    root_xy_m -= root_xy_m[0]

    dt = 1.0 / fps
    ground_delta = root_xy_m[1:] - root_xy_m[:-1]
    drive_heading_rad = yaw_rad if drive_heading_rad is None else np.unwrap(np.asarray(drive_heading_rad, dtype=np.float64))
    if drive_heading_rad.shape[0] != root_xy_m.shape[0]:
        raise ValueError("drive heading and root trajectory must have the same number of frames")
    heading = np.stack([np.cos(drive_heading_rad[:-1]), np.sin(drive_heading_rad[:-1])], axis=1)
    forward_step_m = np.sum(ground_delta * heading, axis=1)
    if enforce_no_slip:
        no_slip_xy = np.zeros_like(root_xy_m)
        heading_mid = 0.5 * (drive_heading_rad[:-1] + drive_heading_rad[1:])
        for frame_idx in range(1, root_xy_m.shape[0]):
            distance = forward_step_m[frame_idx - 1]
            no_slip_xy[frame_idx] = no_slip_xy[frame_idx - 1] + distance * np.array(
                [math.cos(heading_mid[frame_idx - 1]), math.sin(heading_mid[frame_idx - 1])],
                dtype=np.float64,
            )
        root_xy_m = no_slip_xy
        ground_delta = root_xy_m[1:] - root_xy_m[:-1]

    step_distance_m = np.linalg.norm(ground_delta, axis=1)
    distance_from_start_m = np.concatenate([[0.0], np.cumsum(step_distance_m)])
    forward_velocity_m_s = forward_step_m / dt
    yaw_rate_rad_s = np.diff(yaw_rad) / dt

    if max_forward_speed is not None:
        forward_velocity_m_s = np.clip(forward_velocity_m_s, -max_forward_speed, max_forward_speed)
    if max_yaw_rate is not None:
        yaw_rate_rad_s = np.clip(yaw_rate_rad_s, -max_yaw_rate, max_yaw_rate)

    left_rad_s = (forward_velocity_m_s - yaw_rate_rad_s * wheel_separation_m / 2.0) / wheel_radius_m
    right_rad_s = (forward_velocity_m_s + yaw_rate_rad_s * wheel_separation_m / 2.0) / wheel_radius_m
    rad_s_to_rpm = 60.0 / (2.0 * math.pi)

    def pad_last(values: np.ndarray) -> np.ndarray:
        return np.concatenate([values, values[-1:]], axis=0)

    step_distance_m = np.concatenate([[0.0], step_distance_m])
    forward_velocity_m_s = pad_last(forward_velocity_m_s)
    yaw_rate_rad_s = pad_last(yaw_rate_rad_s)
    left_rad_s = pad_last(left_rad_s)
    right_rad_s = pad_last(right_rad_s)
    left_motor_rpm = np.rint(left_rad_s * rad_s_to_rpm).astype(np.int64)
    right_motor_rpm = np.rint(right_rad_s * rad_s_to_rpm).astype(np.int64)

    output_csv.parent.mkdir(parents=True, exist_ok=True)
    with output_csv.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["Frame", *T3_WHEEL_CSV_COLUMNS[1:]])
        for frame_idx in range(root_xy_m.shape[0]):
            writer.writerow(
                [
                    frame_idx,
                    root_xy_m[frame_idx, 0],
                    root_xy_m[frame_idx, 1],
                    0.0,
                    yaw_rad[frame_idx],
                    math.degrees(yaw_rad[frame_idx]),
                    step_distance_m[frame_idx],
                    distance_from_start_m[frame_idx],
                    forward_velocity_m_s[frame_idx],
                    yaw_rate_rad_s[frame_idx],
                    left_rad_s[frame_idx],
                    right_rad_s[frame_idx],
                    int(left_motor_rpm[frame_idx]),
                    int(right_motor_rpm[frame_idx]),
                ]
            )


def _convert_bvh_hips_to_wheels(
    bvh_path: Path,
    wheel_csv: Path,
    fps: float,
    wheel_radius_m: float = WHEEL_RADIUS_M,
    wheel_separation_m: float = WHEEL_SEPARATION_M,
    max_forward_speed: float | None = 3.0,
    max_yaw_rate: float | None = 12.0,
    source_facing_direction: str = DEFAULT_SOURCE_FACING_DIRECTION,
    base_direction_sign: float = 1.0,
    standing_motion_threshold: float = 0.25,
    standing_base_radius: float = 0.04,
    base_joint_name: str = "Hips",
    base_yaw_source: str = "waist",
    standing_yaw_offset_deg: float = 180.0,
) -> None:
    _ensure_soma_retargeter_importable()
    import warp as wp

    import soma_retargeter.assets.bvh as bvh_utils
    from soma_retargeter.utils.space_conversion_utils import SpaceConverter, get_facing_direction_type_from_str

    skeleton, animation = bvh_utils.load_bvh(bvh_path)
    base_joint_idx = skeleton.joint_index(base_joint_name)
    if base_joint_idx == -1:
        raise RuntimeError(f"BVH does not expose base joint {base_joint_name!r}: {bvh_path}")

    converter = SpaceConverter(get_facing_direction_type_from_str(source_facing_direction))
    offset = converter.transform(wp.transform_identity())
    base_targets = np.asarray(
        [animation.compute_global_transforms(frame_idx, offset)[base_joint_idx] for frame_idx in range(animation.num_frames)],
        dtype=np.float64,
    )
    base_pos = base_targets[:, 0:3]
    root_xy_m = base_direction_sign * (base_pos[:, 0:2] - base_pos[0, 0:2])
    waist_heading = _joint_facing_heading(skeleton, base_targets, base_direction_sign)
    standing_motion = _is_standing_root_motion(root_xy_m, standing_motion_threshold)

    path_heading = _stable_path_headings(root_xy_m, fps) if not standing_motion else waist_heading
    if not standing_motion:
        waist_heading = _align_heading_with_path(waist_heading, path_heading)
    else:
        waist_heading = np.unwrap(waist_heading + math.radians(standing_yaw_offset_deg))

    if base_yaw_source == "waist" or standing_motion:
        base_yaw = waist_heading
        drive_heading = waist_heading
        root_xy_m = _clamp_root_xy_radius(root_xy_m, standing_base_radius) if standing_motion else root_xy_m
    else:
        drive_heading = path_heading
        base_yaw = np.unwrap(drive_heading)

    _write_wheel_csv_from_root_trajectory(
        root_xy_m=root_xy_m,
        yaw_rad=base_yaw,
        output_csv=wheel_csv,
        fps=fps,
        wheel_radius_m=wheel_radius_m,
        wheel_separation_m=wheel_separation_m,
        max_forward_speed=max_forward_speed,
        max_yaw_rate=max_yaw_rate,
        drive_heading_rad=drive_heading,
        enforce_no_slip=True,
    )


def _append_wheel_columns_to_t3_csv(t3_csv: Path, wheel_csv: Path, fps: float) -> None:
    with t3_csv.open(newline="", encoding="utf-8") as f:
        t3_reader = csv.DictReader(f)
        if t3_reader.fieldnames is None:
            raise ValueError(f"{t3_csv} has no header")
        t3_rows = list(t3_reader)

    with wheel_csv.open(newline="", encoding="utf-8") as f:
        wheel_reader = csv.DictReader(f)
        if wheel_reader.fieldnames is None:
            raise ValueError(f"{wheel_csv} has no header")
        wheel_rows = list(wheel_reader)

    if not t3_rows or not wheel_rows:
        return

    original_header = [column for column in t3_reader.fieldnames if column not in T3_WHEEL_CSV_COLUMNS]
    header = original_header + T3_WHEEL_CSV_COLUMNS

    with t3_csv.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        for row_idx, t3_row in enumerate(t3_rows):
            wheel_row = wheel_rows[min(row_idx, len(wheel_rows) - 1)]
            out = {column: t3_row.get(column, "") for column in original_header}
            out["time_s"] = row_idx / fps if fps > 0 else 0.0
            for column in T3_WHEEL_CSV_COLUMNS:
                if column == "time_s":
                    continue
                out[column] = wheel_row.get(column, 0.0)
            writer.writerow(out)


def retarget_soma_bvh_to_t3_csv(
    bvh_path: str | Path,
    output_csv: str | Path,
    *,
    wheel_csv: str | Path | None = None,
    fps: float | None = None,
    source_facing_direction: str = DEFAULT_SOURCE_FACING_DIRECTION,
    retarget_source: str = "soma",
    lift_match_target: str = "waist",
    lift_height_offset_m: float = T3_LIFT_HEIGHT_OFFSET_M,
    include_lift_column: bool = True,
    embed_wheel_columns: bool = True,
    wheel_radius_m: float = WHEEL_RADIUS_M,
    wheel_separation_m: float = WHEEL_SEPARATION_M,
    max_forward_speed: float | None = 3.0,
    max_yaw_rate: float | None = 12.0,
    base_direction_sign: float = 1.0,
    standing_motion_threshold: float = 0.25,
    standing_base_radius: float = 0.04,
    base_joint_name: str = "Hips",
    base_yaw_source: str = "waist",
    standing_yaw_offset_deg: float = 180.0,
) -> Path:
    """Retarget one SOMA BVH to a T3 CSV, preserving the working lift/base path."""

    _ensure_soma_retargeter_importable()
    import warp as wp

    import soma_retargeter.assets.bvh as bvh_utils
    import soma_retargeter.pipelines.newton_pipeline as newton_pipeline
    from soma_retargeter.utils.space_conversion_utils import SpaceConverter, get_facing_direction_type_from_str

    bvh_path = Path(bvh_path).expanduser().resolve()
    output_csv = Path(output_csv).expanduser().resolve()
    if wheel_csv is None:
        wheel_csv = output_csv.with_name(f"{output_csv.stem}_diff_drive.csv")
    wheel_csv = Path(wheel_csv).expanduser().resolve()

    skeleton, animation = bvh_utils.load_bvh(bvh_path)
    sample_rate = float(animation.sample_rate)
    output_fps = float(fps) if fps is not None else sample_rate

    converter = SpaceConverter(get_facing_direction_type_from_str(source_facing_direction))
    bvh_tx_converter = converter.transform(wp.transform_identity())
    pipeline = newton_pipeline.NewtonPipeline(skeleton, retarget_source, "t2")
    pipeline.clear()
    pipeline.add_input_motions([animation], [bvh_tx_converter], True)
    buffers = pipeline.execute()
    if len(buffers) != 1:
        raise RuntimeError(f"Expected one retargeted buffer for {bvh_path}, got {len(buffers)}")

    _save_t3_csv_from_t2_buffer(output_csv, buffers[0])
    if include_lift_column:
        lift_extensions = _compute_bvh_lift_extensions(
            bvh_path,
            source_facing_direction,
            lift_match_target,
            lift_height_offset_m,
        )
        _append_lift_column_to_t3_csv(output_csv, lift_extensions)

    _convert_bvh_hips_to_wheels(
        bvh_path=bvh_path,
        wheel_csv=wheel_csv,
        fps=output_fps,
        wheel_radius_m=wheel_radius_m,
        wheel_separation_m=wheel_separation_m,
        max_forward_speed=max_forward_speed,
        max_yaw_rate=max_yaw_rate,
        source_facing_direction=source_facing_direction,
        base_direction_sign=base_direction_sign,
        standing_motion_threshold=standing_motion_threshold,
        standing_base_radius=standing_base_radius,
        base_joint_name=base_joint_name,
        base_yaw_source=base_yaw_source,
        standing_yaw_offset_deg=standing_yaw_offset_deg,
    )
    if embed_wheel_columns:
        _append_wheel_columns_to_t3_csv(output_csv, wheel_csv, output_fps)

    return output_csv


def export_t3_csv_from_core27_arrays(
    filepath: str | Path,
    local_rot_mats: np.ndarray,
    root_positions: np.ndarray,
    fps: float,
    *,
    reference_bvh: str | Path = DEFAULT_REFERENCE_BVH,
    keep_intermediate_bvh: bool = False,
    intermediate_bvh: str | Path | None = None,
    **retarget_kwargs,
) -> Path:
    """Export CoreSkeleton27 arrays by first mapping them to a SOMA BVH."""

    output_csv = Path(filepath).expanduser().resolve()
    reference_bvh = Path(reference_bvh).expanduser().resolve()
    if not reference_bvh.exists():
        raise FileNotFoundError(f"SOMA reference BVH not found: {reference_bvh}")

    if intermediate_bvh is not None:
        bvh_path = Path(intermediate_bvh).expanduser().resolve()
        export_soma_bvh_from_arrays(local_rot_mats, root_positions, fps, reference_bvh, bvh_path)
        return retarget_soma_bvh_to_t3_csv(bvh_path, output_csv, fps=fps, **retarget_kwargs)

    with tempfile.TemporaryDirectory(prefix="ardy_soma_to_t3_") as tmpdir:
        bvh_path = Path(tmpdir) / f"{output_csv.stem}_soma.bvh"
        export_soma_bvh_from_arrays(local_rot_mats, root_positions, fps, reference_bvh, bvh_path)
        result = retarget_soma_bvh_to_t3_csv(bvh_path, output_csv, fps=fps, **retarget_kwargs)
        if keep_intermediate_bvh:
            kept_bvh = output_csv.with_suffix(".soma.bvh")
            export_soma_bvh_from_arrays(local_rot_mats, root_positions, fps, reference_bvh, kept_bvh)
        return result
