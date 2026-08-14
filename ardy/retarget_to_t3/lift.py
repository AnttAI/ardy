# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""T3 lift matching logic ported from the BVH-to-T3 converter."""

from __future__ import annotations

import numpy as np

from .constants import (
    T3_LIFT_HEIGHT_OFFSET_M,
    T3_LIFT_MAX_M,
    T3_LIFT_MIN_M,
    T3_SHOULDER_HEIGHT_NO_LIFT_M,
    T3_WAIST_HEIGHT_NO_LIFT_M,
)


T3_LIFT_DISPLAY_BASE_CM = 60.0
T3_LIFT_HARDWARE_BASE_CM = 69.0


def lift_extension_m_to_display_cm(extension_m: float) -> float:
    """Convert lift extension in meters to the CSV display height in centimeters."""
    return float(T3_LIFT_DISPLAY_BASE_CM + 100.0 * float(extension_m))


def lift_extension_m_to_hardware_cm(extension_m: float) -> float:
    """Convert lift extension in meters to the physical lift command height in centimeters."""
    return float(T3_LIFT_HARDWARE_BASE_CM + 100.0 * float(extension_m))


def lift_csv_value_to_extension_m(value: float) -> float:
    """Accept old meter CSVs or new 60+cm CSVs and return extension in meters."""
    value = float(value)
    if value <= T3_LIFT_MAX_M:
        return float(np.clip(value, T3_LIFT_MIN_M, T3_LIFT_MAX_M))
    return float(np.clip((value - T3_LIFT_DISPLAY_BASE_CM) / 100.0, T3_LIFT_MIN_M, T3_LIFT_MAX_M))


def _available_indices(skeleton, names: tuple[str, ...]) -> list[int]:
    return [skeleton.bone_order_names_index[name] for name in names if name in skeleton.bone_order_names_index]


def compute_t3_lift_extension(
    joints_pos: np.ndarray,
    skeleton,
    match_target: str = "waist",
    lift_height_offset_m: float = T3_LIFT_HEIGHT_OFFSET_M,
) -> float:
    """Compute telescopic lift from generated human body height.

    This mirrors the batch converter's `waist` mode: anchor around the human waist while accounting
    for the human shoulder-to-waist height relative to the T3 torso proportion.
    """

    waist_indices = _available_indices(skeleton, ("Spine1", "Spine2", "Spine3", "Chest"))
    shoulder_indices = _available_indices(skeleton, ("LeftShoulder", "RightShoulder"))
    root_idx = getattr(skeleton, "root_idx", 0)
    if not waist_indices:
        waist_indices = [root_idx]

    waist_height = float(np.mean(joints_pos[waist_indices, 1]))
    shoulder_height = float(np.mean(joints_pos[shoulder_indices, 1])) if shoulder_indices else waist_height

    if match_target == "shoulders":
        extension = shoulder_height - T3_SHOULDER_HEIGHT_NO_LIFT_M
    elif match_target == "average":
        extension = 0.5 * (
            (waist_height - T3_WAIST_HEIGHT_NO_LIFT_M)
            + (shoulder_height - T3_SHOULDER_HEIGHT_NO_LIFT_M)
        )
    else:
        human_waist_to_shoulder = shoulder_height - waist_height
        t3_waist_to_shoulder = T3_SHOULDER_HEIGHT_NO_LIFT_M - T3_WAIST_HEIGHT_NO_LIFT_M
        target_waist_height = waist_height + (human_waist_to_shoulder - t3_waist_to_shoulder)
        extension = target_waist_height - T3_WAIST_HEIGHT_NO_LIFT_M

    return float(np.clip(extension + float(lift_height_offset_m), T3_LIFT_MIN_M, T3_LIFT_MAX_M))
