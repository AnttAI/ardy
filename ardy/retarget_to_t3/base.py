# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""T3 differential-drive base logic ported from the BVH-to-T3 converter."""

from __future__ import annotations

import math
from dataclasses import dataclass

import numpy as np

from .constants import (
    MAX_FORWARD_SPEED_M_S,
    MAX_YAW_RATE_RAD_S,
    STANDING_BASE_RADIUS_M,
    STANDING_MOTION_THRESHOLD_M,
    STANDING_YAW_OFFSET_RAD,
    WHEEL_RADIUS_M,
    WHEEL_SEPARATION_M,
)


def angle_delta(a: float, b: float) -> float:
    return float(math.atan2(math.sin(a - b), math.cos(a - b)))


def smooth_angles(angles: np.ndarray, window_size: int = 9) -> np.ndarray:
    if window_size <= 1 or angles.shape[0] < 3:
        return angles
    if window_size % 2 == 0:
        window_size += 1
    window_size = min(window_size, angles.shape[0] if angles.shape[0] % 2 == 1 else angles.shape[0] - 1)
    if window_size <= 1:
        return angles
    kernel = np.ones(window_size, dtype=np.float64) / float(window_size)
    pad = window_size // 2
    sin_values = np.pad(np.sin(angles), (pad, pad), mode="edge")
    cos_values = np.pad(np.cos(angles), (pad, pad), mode="edge")
    return np.unwrap(
        np.arctan2(
            np.convolve(sin_values, kernel, mode="valid"),
            np.convolve(cos_values, kernel, mode="valid"),
        )
    )


@dataclass
class T3BaseFrame:
    x_m: float
    z_m: float
    world_x_m: float
    world_z_m: float
    yaw_rad: float
    left_wheel_angle_rad: float
    right_wheel_angle_rad: float
    forward_velocity_m_s: float
    yaw_rate_rad_s: float


class T3BaseTracker:
    """Online version of the T3 wheel/base CSV logic.

    The batch converter derives a differential-drive base from the human hips path and waist yaw.
    This class does the same incrementally from generated ARDY root frames.
    """

    def __init__(
        self,
        wheel_radius_m: float = WHEEL_RADIUS_M,
        wheel_separation_m: float = WHEEL_SEPARATION_M,
        max_forward_speed_m_s: float | None = MAX_FORWARD_SPEED_M_S,
        max_yaw_rate_rad_s: float | None = MAX_YAW_RATE_RAD_S,
        standing_motion_threshold_m: float = STANDING_MOTION_THRESHOLD_M,
        standing_base_radius_m: float = STANDING_BASE_RADIUS_M,
        standing_yaw_offset_rad: float = STANDING_YAW_OFFSET_RAD,
    ) -> None:
        self.wheel_radius_m = float(wheel_radius_m)
        self.wheel_separation_m = float(wheel_separation_m)
        self.max_forward_speed_m_s = max_forward_speed_m_s
        self.max_yaw_rate_rad_s = max_yaw_rate_rad_s
        self.standing_motion_threshold_m = float(standing_motion_threshold_m)
        self.standing_base_radius_m = float(standing_base_radius_m)
        self.standing_yaw_offset_rad = float(standing_yaw_offset_rad)
        self.forward_error_gain = 5.0
        self.position_heading_gain = 5.0
        self.yaw_error_gain = 8.0
        self.max_forward_correction_m_s = 0.25
        self.max_yaw_correction_rad_s = 8.0
        self.max_position_steer_rad = math.radians(35.0)
        self.reset()

    def reset(self) -> None:
        self.start_xz: np.ndarray | None = None
        self.prev_xz: np.ndarray | None = None
        self.prev_yaw: float | None = None
        self.pose_xz: np.ndarray | None = None
        self.pose_yaw: float | None = None
        self.left_wheel_angle = 0.0
        self.right_wheel_angle = 0.0
        self.total_distance = 0.0

    def update(
        self,
        root_xz_m: np.ndarray,
        waist_yaw_rad: float,
        fps: float,
        root_velocity_xz_m_s: np.ndarray | None = None,
    ) -> T3BaseFrame:
        root_xz_m = np.asarray(root_xz_m, dtype=np.float64)
        if self.start_xz is None:
            self.start_xz = root_xz_m.copy()
            self.prev_xz = root_xz_m.copy()
            self.prev_yaw = waist_yaw_rad
            self.pose_xz = root_xz_m.copy()
            self.pose_yaw = waist_yaw_rad

        relative_xz = root_xz_m - self.start_xz
        dt = 1.0 / max(float(fps), 1.0)
        forward_velocity = 0.0
        yaw_rate = 0.0
        if (
            self.prev_xz is not None
            and self.prev_yaw is not None
            and self.pose_xz is not None
            and self.pose_yaw is not None
        ):
            ground_delta = root_xz_m - self.prev_xz
            self.total_distance += float(np.linalg.norm(ground_delta))

            heading = np.array([math.sin(self.pose_yaw), math.cos(self.pose_yaw)], dtype=np.float64)
            if root_velocity_xz_m_s is None:
                target_velocity = ground_delta / dt
            else:
                target_velocity = np.asarray(root_velocity_xz_m_s, dtype=np.float64)
            target_speed = float(np.linalg.norm(target_velocity))
            position_error = root_xz_m - self.pose_xz
            human_heading = np.array([math.sin(waist_yaw_rad), math.cos(waist_yaw_rad)], dtype=np.float64)
            human_left = np.array([human_heading[1], -human_heading[0]], dtype=np.float64)
            forward_error = float(np.dot(position_error, human_heading))
            lateral_error = float(np.dot(position_error, human_left))

            # Keep human facing as the primary yaw target. Position error becomes
            # a bounded steering angle around that yaw, so the base can recover
            # position by wheel motion without completely abandoning facing.
            position_steer = math.atan2(lateral_error, max(abs(forward_error), 0.35))
            position_steer = float(np.clip(position_steer, -self.max_position_steer_rad, self.max_position_steer_rad))
            drive_yaw = waist_yaw_rad + position_steer
            drive_heading = np.array([math.sin(drive_yaw), math.cos(drive_yaw)], dtype=np.float64)

            target_forward_velocity = float(np.dot(target_velocity, drive_heading))
            forward_correction = float(
                np.clip(
                    self.forward_error_gain * forward_error,
                    -self.max_forward_correction_m_s,
                    self.max_forward_correction_m_s,
                )
            )
            yaw_correction = float(
                np.clip(
                    self.yaw_error_gain * angle_delta(waist_yaw_rad, self.pose_yaw)
                    + self.position_heading_gain * position_steer,
                    -self.max_yaw_correction_rad_s,
                    self.max_yaw_correction_rad_s,
                )
            )
            forward_velocity = target_forward_velocity + forward_correction
            yaw_rate = yaw_correction

            if self.max_forward_speed_m_s is not None:
                forward_velocity = float(
                    np.clip(forward_velocity, -self.max_forward_speed_m_s, self.max_forward_speed_m_s)
                )
            if self.max_yaw_rate_rad_s is not None:
                yaw_rate = float(np.clip(yaw_rate, -self.max_yaw_rate_rad_s, self.max_yaw_rate_rad_s))

            left_rad_s = (forward_velocity - yaw_rate * self.wheel_separation_m / 2.0) / self.wheel_radius_m
            right_rad_s = (forward_velocity + yaw_rate * self.wheel_separation_m / 2.0) / self.wheel_radius_m
            self.left_wheel_angle += left_rad_s * dt
            self.right_wheel_angle += right_rad_s * dt

            mid_yaw = self.pose_yaw + 0.5 * yaw_rate * dt
            heading_mid = np.array([math.sin(mid_yaw), math.cos(mid_yaw)], dtype=np.float64)
            self.pose_xz = self.pose_xz + forward_velocity * dt * heading_mid
            self.pose_yaw = self.pose_yaw + yaw_rate * dt

        self.prev_xz = root_xz_m.copy()
        self.prev_yaw = waist_yaw_rad
        display_xz = self.pose_xz if self.pose_xz is not None else root_xz_m
        display_yaw = self.pose_yaw if self.pose_yaw is not None else waist_yaw_rad
        return T3BaseFrame(
            x_m=float(relative_xz[0]),
            z_m=float(relative_xz[1]),
            world_x_m=float(display_xz[0]),
            world_z_m=float(display_xz[1]),
            yaw_rad=float(display_yaw),
            left_wheel_angle_rad=math.remainder(self.left_wheel_angle, 2.0 * math.pi),
            right_wheel_angle_rad=math.remainder(self.right_wheel_angle, 2.0 * math.pi),
            forward_velocity_m_s=forward_velocity,
            yaw_rate_rad_s=yaw_rate,
        )
