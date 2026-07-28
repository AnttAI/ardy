# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Retail rack route helpers shared by scripts and demos."""

from __future__ import annotations

from dataclasses import dataclass
import math
import re
from typing import TYPE_CHECKING, Any, Sequence

import numpy as np

if TYPE_CHECKING:
    from ardy.constraints import Root2DConstraintSet
    from ardy.skeleton import SkeletonBase


@dataclass(frozen=True)
class RackRoute:
    rack_name: str
    positions: tuple[tuple[float, float, float], ...]
    headings: tuple[float, ...]
    waypoint_indices: tuple[int, ...]
    approach_position: tuple[float, float, float]
    final_heading: float
    required_seconds: float
    walk_speed_m_s: float
    turn_degrees: tuple[int, ...]


@dataclass(frozen=True)
class RackPickPlan:
    rack_name: str
    shelf_number: int
    object_index: int
    hand_side: str
    object_position: tuple[float, float, float]
    pregrasp_position: tuple[float, float, float]
    grasp_position: tuple[float, float, float]
    lift_position: tuple[float, float, float]
    chest_hold_position: tuple[float, float, float]
    frame_indices: tuple[int, int, int, int, int]
    total_frames: int
    approach_position: tuple[float, float, float]
    rack_facing_heading: float


RACK_ROUTE_WALKING_PROMPT = "A person is walking."
RACK_PICK_CALM_PROMPT = "A person is standing."
MAX_ALLOWED_BACKWALK_M = 0.20
RACK_WIDTH_M = 0.34
RACK_FIRST_SHELF_HEIGHT_M = 0.10
RACK_SHELF_SPACING_M = 0.3048
RACK_SHELF_COUNT = 5
RACK_PICK_OBJECT_SIZE_M = 0.06
RACK_HUMAN_APPROACH_CLEARANCE_M = 0.45
RACK_HUMAN_SLOW_WALK_SPEED_M_S = 0.60
RACK_HUMAN_FAST_WALK_SPEED_M_S = 0.90
WORK_AREA_GRID_SECTION_M = 0.60
WORK_AREA_GRID_SHAPE = (4, 6)
WORK_AREA_SIDE_SHIFT_M = 0.60

RACK_MAP_POSITIONS = {
    "rack_1": np.array([-1.63, 0.0, -1.20], dtype=np.float64),
    "rack_2": np.array([-1.63, 0.0, -2.40], dtype=np.float64),
    "rack_3": np.array([-1.10, 0.0, -3.43], dtype=np.float64),
    "rack_4": np.array([0.00, 0.0, -3.43], dtype=np.float64),
}
RACK_MAP_YAWS_RAD = {
    "rack_3": -np.pi / 2.0,
    "rack_4": -np.pi / 2.0,
}


def normalize_rack_name(value: str) -> str:
    """Accept rack1, rack_1, rack 1, etc. and return rack_N."""
    normalized = value.strip().lower().replace("-", "_").replace(" ", "_")
    match = re.fullmatch(r"rack_?([1-4])", normalized)
    if not match:
        available = ", ".join(sorted(RACK_MAP_POSITIONS))
        raise ValueError(f"Unknown rack {value!r}. Available racks: {available}.")
    return f"rack_{match.group(1)}"


def rack_walk_model_prompt(rack_name: str) -> str:
    rack_label = rack_name.replace("_", " ")
    return (
        "An ordinary healthy person walks at a steady normal pace with a neutral natural gait. "
        "They stand upright, look forward, and use a relaxed symmetrical arm swing. They stop at "
        "each corner, make a controlled slow turn in place, resume the same steady walking pace, "
        f"and finish standing naturally in front of {rack_label} facing it."
    )


def rack_shelf_surface_height(shelf_number: int) -> float:
    if shelf_number not in range(1, RACK_SHELF_COUNT + 1):
        raise ValueError(f"shelf_number must be between 1 and {RACK_SHELF_COUNT}")
    return RACK_FIRST_SHELF_HEIGHT_M + (shelf_number - 1) * RACK_SHELF_SPACING_M


def rack_shelf_object_position(
    rack: str,
    shelf_number: int,
    object_index: int,
    *,
    front_edge_inset_m: float = 0.05,
    lateral_spacing_m: float = 0.15,
) -> tuple[float, float, float]:
    """Return the visible shelf-object center in world coordinates."""
    rack_name = normalize_rack_name(rack)
    if object_index not in {1, 2, 3}:
        raise ValueError("object_index must be 1, 2, or 3")
    if not 0.0 <= front_edge_inset_m < RACK_WIDTH_M / 2.0:
        raise ValueError("front_edge_inset_m must remain inside the shelf edge")

    rack_center = RACK_MAP_POSITIONS[rack_name]
    rack_yaw = RACK_MAP_YAWS_RAD.get(rack_name, 0.0)
    local_x = RACK_WIDTH_M / 2.0 - front_edge_inset_m
    local_z = (object_index - 2) * lateral_spacing_m
    cos_yaw = math.cos(rack_yaw)
    sin_yaw = math.sin(rack_yaw)
    return (
        float(rack_center[0]) + cos_yaw * local_x + sin_yaw * local_z,
        float(rack_center[1]) + rack_shelf_surface_height(shelf_number) + RACK_PICK_OBJECT_SIZE_M / 2.0,
        float(rack_center[2]) - sin_yaw * local_x + cos_yaw * local_z,
    )


def rack_outward_normal(rack: str) -> tuple[float, float, float]:
    rack_name = normalize_rack_name(rack)
    rack_yaw = RACK_MAP_YAWS_RAD.get(rack_name, 0.0)
    return (math.cos(rack_yaw), 0.0, -math.sin(rack_yaw))


def rack_pick_auto_frame_count(
    rack: str,
    shelf_number: int,
    object_index: int,
    *,
    fps: float,
    reach_speed_m_s: float = 0.45,
    calm_hold_seconds: float = 1.0,
) -> int:
    """Return a stable pick length from reach distance and a final calm hold."""
    if fps <= 0.0 or reach_speed_m_s <= 0.0:
        raise ValueError("fps and reach_speed_m_s must be positive")
    rack_name, approach, _heading, _speed, _axis, _required = _rack_route_setup(rack)
    object_position = np.asarray(rack_shelf_object_position(rack_name, shelf_number, object_index), dtype=np.float64)
    reach_distance = float(np.linalg.norm(object_position - np.asarray(approach, dtype=np.float64)))
    seconds = 1.2 + reach_distance / reach_speed_m_s + calm_hold_seconds
    return max(2, int(math.ceil(seconds * fps)))


def plan_rack_pick(
    rack: str,
    shelf_number: int,
    object_index: int,
    *,
    total_frames: int,
    fps: float,
    hand_side: str | None = None,
) -> RackPickPlan:
    if total_frames < 8:
        raise ValueError("A rack pick needs at least 8 frames.")
    rack_name, approach, heading, _speed, _axis, _required = _rack_route_setup(rack)
    if hand_side is None:
        hand_side = "left" if object_index == 3 else "right"
    if hand_side not in {"left", "right"}:
        raise ValueError("hand_side must be 'left' or 'right'")

    object_position = np.asarray(rack_shelf_object_position(rack_name, shelf_number, object_index), dtype=np.float64)
    outward = np.asarray(rack_outward_normal(rack_name), dtype=np.float64)
    facing = -outward
    lateral = np.array([outward[2], 0.0, -outward[0]], dtype=np.float64)
    if hand_side == "left":
        lateral = -lateral

    pregrasp = object_position + outward * 0.16 + np.array([0.0, 0.03, 0.0], dtype=np.float64)
    grasp = object_position + outward * 0.02
    lift = object_position + outward * 0.03 + np.array([0.0, 0.08, 0.0], dtype=np.float64)
    chest_hold = np.asarray(approach, dtype=np.float64) + facing * 0.18 + lateral * 0.10
    chest_hold[1] = min(max(float(object_position[1]), 0.82), 1.12)

    last = total_frames - 1
    frame_indices = (
        0,
        min(max(1, int(round(last * 0.30))), last),
        min(max(2, int(round(last * 0.48))), last),
        min(max(3, int(round(last * 0.62))), last),
        min(max(4, int(round(last * 0.78))), last),
    )
    return RackPickPlan(
        rack_name=rack_name,
        shelf_number=int(shelf_number),
        object_index=int(object_index),
        hand_side=hand_side,
        object_position=tuple(float(value) for value in object_position),
        pregrasp_position=tuple(float(value) for value in pregrasp),
        grasp_position=tuple(float(value) for value in grasp),
        lift_position=tuple(float(value) for value in lift),
        chest_hold_position=tuple(float(value) for value in chest_hold),
        frame_indices=frame_indices,
        total_frames=total_frames,
        approach_position=approach,
        rack_facing_heading=heading,
    )


def max_backwalk_distance(positions: Sequence[Sequence[float]], headings: Sequence[float]) -> float:
    """Largest single-frame reverse displacement relative to the current heading."""
    max_reverse = 0.0
    for left, right, heading in zip(positions[:-1], positions[1:], headings[:-1]):
        delta_x = float(right[0]) - float(left[0])
        delta_z = float(right[2]) - float(left[2])
        forward_x = math.sin(float(heading))
        forward_z = math.cos(float(heading))
        forward_distance = delta_x * forward_x + delta_z * forward_z
        max_reverse = max(max_reverse, -forward_distance)
    return max_reverse


def validate_no_backwalk(
    positions: Sequence[Sequence[float]],
    headings: Sequence[float],
    *,
    max_reverse_m: float = MAX_ALLOWED_BACKWALK_M,
) -> None:
    reverse_m = max_backwalk_distance(positions, headings)
    if reverse_m > max_reverse_m:
        raise ValueError(
            f"Planned route contains {reverse_m:.2f} m of backward travel; "
            f"limit is {max_reverse_m:.2f} m."
        )


def rack_route_waypoint_indices(
    positions: Sequence[Sequence[float]],
    headings: Sequence[float],
    *,
    position_epsilon: float = 1e-6,
    heading_epsilon: float = 1e-6,
) -> tuple[int, ...]:
    """Return salient Root2D waypoint frames: starts/ends of moves and turns."""
    if len(positions) != len(headings):
        raise ValueError("positions and headings must have the same length")
    if not positions:
        return ()
    indices = {0, len(positions) - 1}

    prev_kind = None
    for frame in range(1, len(positions)):
        prev = np.asarray(positions[frame - 1], dtype=np.float64)
        cur = np.asarray(positions[frame], dtype=np.float64)
        displacement = float(np.linalg.norm(cur[[0, 2]] - prev[[0, 2]]))
        heading_delta = abs(_normalize_angle(float(headings[frame]) - float(headings[frame - 1])))
        kind = (
            "move"
            if displacement > position_epsilon
            else "turn"
            if heading_delta > heading_epsilon
            else "hold"
        )
        if prev_kind is not None and kind != prev_kind:
            indices.add(frame - 1)
            indices.add(frame)
        prev_kind = kind

    return tuple(sorted(indices))


def _rack_human_walk_speed_m_s(rack_name: str) -> float:
    if rack_name in {"rack_3", "rack_4"}:
        return RACK_HUMAN_FAST_WALK_SPEED_M_S
    return RACK_HUMAN_SLOW_WALK_SPEED_M_S


def _work_area_limits() -> tuple[tuple[float, float], tuple[float, float]]:
    x_near = WORK_AREA_SIDE_SHIFT_M
    x_far = x_near - WORK_AREA_GRID_SHAPE[0] * WORK_AREA_GRID_SECTION_M
    z_far = -WORK_AREA_GRID_SHAPE[1] * WORK_AREA_GRID_SECTION_M
    return (x_far, x_near), (z_far, 0.0)


def _normalize_angle(angle: float) -> float:
    return (angle + math.pi) % (2.0 * math.pi) - math.pi


def _append_unique_point(points: list[tuple[float, float, float]], point: tuple[float, float, float]) -> None:
    if not points or any(not math.isclose(a, b, abs_tol=1e-9) for a, b in zip(points[-1], point)):
        points.append(point)


def forward_route_heading(start_position: Sequence[float], target_position: Sequence[float]) -> float:
    delta_x = float(target_position[0]) - float(start_position[0])
    delta_z = float(target_position[2]) - float(start_position[2])
    if math.isclose(delta_x, 0.0, abs_tol=1e-9) and math.isclose(delta_z, 0.0, abs_tol=1e-9):
        raise ValueError("start_position and target_position must be different")
    return math.atan2(delta_x, delta_z)


def rack_width_side_approach_pose(
    rack_center: Sequence[float],
    rack_yaw_rad: float,
    rack_width_m: float,
    clearance_m: float,
    x_limits: tuple[float, float],
    z_limits: tuple[float, float],
    face_sign: float = 1.0,
) -> tuple[tuple[float, float, float], float]:
    if face_sign not in (-1.0, 1.0):
        raise ValueError("face_sign must be -1 or 1")
    center_x, center_y, center_z = (float(value) for value in rack_center)
    normal_x = face_sign * math.cos(rack_yaw_rad)
    normal_z = -face_sign * math.sin(rack_yaw_rad)
    face_distance = rack_width_m / 2.0 + clearance_m
    approach = (
        center_x + normal_x * face_distance,
        center_y,
        center_z + normal_z * face_distance,
    )
    if not (x_limits[0] <= approach[0] <= x_limits[1] and z_limits[0] <= approach[2] <= z_limits[1]):
        raise ValueError("The requested rack width-side approach is outside the work-area boundary")
    facing_rack = math.atan2(-normal_x, -normal_z)
    return approach, facing_rack


def _route_points(target: tuple[float, float, float], final_heading: float, first_axis: str | None):
    start = (0.0, 0.0, 0.0)
    points = [start]
    use_z_first = first_axis == "z" or (first_axis is None and abs(math.sin(final_heading)) < 0.5)
    if use_z_first:
        _append_unique_point(points, (0.0, 0.0, target[2]))
    else:
        _append_unique_point(points, (target[0], 0.0, 0.0))
    _append_unique_point(points, target)
    return points


def cardinal_rack_route_required_seconds(
    *,
    approach_position: Sequence[float],
    final_heading: float,
    initial_heading: float = 0.0,
    turn_seconds_per_90: float = 0.75,
    walk_speed_m_s: float = 0.90,
    first_axis: str | None = None,
) -> float:
    points = _route_points(tuple(float(value) for value in approach_position), final_heading, first_axis)
    seconds = 0.0
    current_heading = initial_heading
    for start_point, end_point in zip(points, points[1:]):
        movement_heading = forward_route_heading(start_point, end_point)
        turn_delta = _normalize_angle(movement_heading - current_heading)
        seconds += turn_seconds_per_90 * abs(turn_delta) / (math.pi / 2.0)
        seconds += math.hypot(end_point[0] - start_point[0], end_point[2] - start_point[2]) / walk_speed_m_s
        current_heading = movement_heading
    final_turn = _normalize_angle(final_heading - current_heading)
    seconds += turn_seconds_per_90 * abs(final_turn) / (math.pi / 2.0)
    return seconds


def _route_required_seconds_for_points(
    points: Sequence[Sequence[float]],
    *,
    initial_heading: float,
    final_heading: float,
    turn_seconds_per_90: float,
    walk_speed_m_s: float,
) -> float:
    seconds = 0.0
    current_heading = initial_heading
    for start_point, end_point in zip(points, points[1:]):
        movement_heading = forward_route_heading(start_point, end_point)
        turn_delta = _normalize_angle(movement_heading - current_heading)
        seconds += turn_seconds_per_90 * abs(turn_delta) / (math.pi / 2.0)
        seconds += math.hypot(
            float(end_point[0]) - float(start_point[0]),
            float(end_point[2]) - float(start_point[2]),
        ) / walk_speed_m_s
        current_heading = movement_heading
    final_turn = _normalize_angle(final_heading - current_heading)
    seconds += turn_seconds_per_90 * abs(final_turn) / (math.pi / 2.0)
    return seconds


def _plan_points_route(
    *,
    rack_name: str,
    points: Sequence[Sequence[float]],
    total_frames: int,
    fps: float,
    initial_heading: float,
    final_heading: float,
    required_seconds: float,
    walk_speed_m_s: float,
    turn_seconds_per_90: float,
) -> RackRoute:
    if total_frames < 2:
        raise ValueError("total_frames must be at least 2")
    available_seconds = (total_frames - 1) / fps
    if available_seconds < required_seconds:
        raise ValueError(
            f"Motion duration is too short for {rack_name}; use at least {math.ceil(required_seconds + 1.0)} seconds."
        )

    actions: list[tuple[str, object]] = []
    current_heading = initial_heading
    turn_degrees: list[int] = []
    route_points = [tuple(float(value) for value in point) for point in points]
    for start_point, end_point in zip(route_points, route_points[1:]):
        movement_heading = forward_route_heading(start_point, end_point)
        turn_delta = _normalize_angle(movement_heading - current_heading)
        if not math.isclose(turn_delta, 0.0, abs_tol=1e-8):
            actions.append(("turn", turn_delta))
            turn_degrees.append(int(round(abs(math.degrees(turn_delta)))))
        actions.append(("move", (start_point, end_point)))
        current_heading = movement_heading
    final_turn = _normalize_angle(final_heading - current_heading)
    if not math.isclose(final_turn, 0.0, abs_tol=1e-8):
        actions.append(("turn", final_turn))
        turn_degrees.append(int(round(abs(math.degrees(final_turn)))))

    positions = [route_points[0]]
    headings = [initial_heading]
    position = positions[0]
    heading = initial_heading
    for kind, value in actions:
        if kind == "turn":
            steps = max(1, int(round(turn_seconds_per_90 * fps * abs(float(value)) / (math.pi / 2.0))))
            delta = float(value)
            for step in range(1, steps + 1):
                positions.append(position)
                headings.append(heading + delta * step / steps)
            heading = _normalize_angle(heading + delta)
        else:
            start_point, end_point = value
            distance = math.hypot(end_point[0] - start_point[0], end_point[2] - start_point[2])
            steps = max(1, int(round(distance / walk_speed_m_s * fps)))
            heading = forward_route_heading(start_point, end_point)
            for step in range(1, steps + 1):
                ratio = step / steps
                position = tuple(
                    float(start_point[axis] + ratio * (end_point[axis] - start_point[axis]))
                    for axis in range(3)
                )
                positions.append(position)
                headings.append(heading)

    while len(positions) < total_frames:
        positions.append(position)
        headings.append(heading)
    if len(positions) > total_frames:
        positions = positions[:total_frames]
        headings = headings[:total_frames]
    validate_no_backwalk(positions, headings)
    return RackRoute(
        rack_name=rack_name,
        positions=tuple(positions),
        headings=tuple(headings),
        waypoint_indices=rack_route_waypoint_indices(positions, headings),
        approach_position=route_points[-1],
        final_heading=_normalize_angle(final_heading),
        required_seconds=required_seconds,
        walk_speed_m_s=walk_speed_m_s,
        turn_degrees=tuple(turn_degrees),
    )


def _rack_route_setup(
    rack: str,
    *,
    initial_heading: float = 0.0,
    turn_seconds_per_90: float = 0.75,
) -> tuple[str, tuple[float, float, float], float, float, str, float]:
    rack_name = normalize_rack_name(rack)
    x_limits, z_limits = _work_area_limits()
    approach, final_heading = rack_width_side_approach_pose(
        RACK_MAP_POSITIONS[rack_name],
        RACK_MAP_YAWS_RAD.get(rack_name, 0.0),
        RACK_WIDTH_M,
        RACK_HUMAN_APPROACH_CLEARANCE_M,
        x_limits,
        z_limits,
    )
    walk_speed = _rack_human_walk_speed_m_s(rack_name)
    first_axis = "z" if rack_name in {"rack_1", "rack_2", "rack_3"} else "x"
    required_seconds = cardinal_rack_route_required_seconds(
        approach_position=approach,
        final_heading=final_heading,
        initial_heading=initial_heading,
        turn_seconds_per_90=turn_seconds_per_90,
        walk_speed_m_s=walk_speed,
        first_axis=first_axis,
    )
    return rack_name, approach, final_heading, walk_speed, first_axis, required_seconds


def rack_route_auto_frame_count(
    rack: str,
    *,
    fps: float,
    initial_heading: float = 0.0,
    turn_seconds_per_90: float = 0.75,
    calm_hold_seconds: float = 1.0,
) -> int:
    """Return a route length from distance, speed, turns, and a final calm hold."""
    if fps <= 0.0:
        raise ValueError("fps must be positive")
    *_unused, required_seconds = _rack_route_setup(
        rack,
        initial_heading=initial_heading,
        turn_seconds_per_90=turn_seconds_per_90,
    )
    return max(2, int(math.ceil((required_seconds + calm_hold_seconds) * fps)))


def plan_rack_route(
    rack: str,
    *,
    total_frames: int,
    fps: float,
    initial_heading: float = 0.0,
    turn_seconds_per_90: float = 0.75,
) -> RackRoute:
    rack_name, approach, final_heading, walk_speed, first_axis, required_seconds = _rack_route_setup(
        rack,
        initial_heading=initial_heading,
        turn_seconds_per_90=turn_seconds_per_90,
    )
    if total_frames < 2:
        raise ValueError("total_frames must be at least 2")
    available_seconds = (total_frames - 1) / fps
    if available_seconds < required_seconds:
        raise ValueError(
            f"Motion duration is too short for {rack_name}; use at least {math.ceil(required_seconds + 1.0)} seconds."
        )

    points = _route_points(approach, final_heading, first_axis)
    route = _plan_points_route(
        rack_name=rack_name,
        points=points,
        total_frames=total_frames,
        fps=fps,
        initial_heading=initial_heading,
        final_heading=final_heading,
        required_seconds=required_seconds,
        walk_speed_m_s=walk_speed,
        turn_seconds_per_90=turn_seconds_per_90,
    )
    return RackRoute(
        rack_name=route.rack_name,
        positions=route.positions,
        headings=route.headings,
        waypoint_indices=route.waypoint_indices,
        approach_position=approach,
        final_heading=route.final_heading,
        required_seconds=route.required_seconds,
        walk_speed_m_s=route.walk_speed_m_s,
        turn_degrees=route.turn_degrees,
    )


def _rack_return_setup(
    rack: str,
    *,
    turn_seconds_per_90: float = 0.75,
) -> tuple[str, list[tuple[float, float, float]], float, float, float, float]:
    rack_name, approach, rack_heading, walk_speed, _first_axis, _required = _rack_route_setup(rack)
    points = [approach]
    if not math.isclose(approach[0], 0.0, abs_tol=1e-9):
        _append_unique_point(points, (0.0, 0.0, approach[2]))
    _append_unique_point(points, (0.0, 0.0, 0.0))
    final_heading = 0.0
    required_seconds = _route_required_seconds_for_points(
        points,
        initial_heading=rack_heading,
        final_heading=final_heading,
        turn_seconds_per_90=turn_seconds_per_90,
        walk_speed_m_s=walk_speed,
    )
    return rack_name, points, rack_heading, final_heading, walk_speed, required_seconds


def _rack_to_rack_points(
    source_position: Sequence[float],
    target_position: Sequence[float],
) -> list[tuple[float, float, float]]:
    source = tuple(float(value) for value in source_position)
    target = tuple(float(value) for value in target_position)
    points = [source]
    dx = abs(target[0] - source[0])
    dz = abs(target[2] - source[2])
    if dx > 1e-9 and dz > 1e-9:
        if dz >= dx:
            _append_unique_point(points, (source[0], source[1], target[2]))
        else:
            _append_unique_point(points, (target[0], source[1], source[2]))
    _append_unique_point(points, target)
    return points


def _rack_to_rack_setup(
    source_rack: str,
    target_rack: str,
    *,
    turn_seconds_per_90: float = 0.75,
) -> tuple[str, str, list[tuple[float, float, float]], float, float, float, float]:
    source_name, source_approach, source_heading, source_speed, _axis, _required = _rack_route_setup(source_rack)
    target_name, target_approach, target_heading, target_speed, _axis, _required = _rack_route_setup(target_rack)
    if source_name == target_name:
        raise ValueError("Source rack and target rack must be different.")
    walk_speed = min(source_speed, target_speed)
    points = _rack_to_rack_points(source_approach, target_approach)
    required_seconds = _route_required_seconds_for_points(
        points,
        initial_heading=source_heading,
        final_heading=target_heading,
        turn_seconds_per_90=turn_seconds_per_90,
        walk_speed_m_s=walk_speed,
    )
    return source_name, target_name, points, source_heading, target_heading, walk_speed, required_seconds


def rack_to_rack_auto_frame_count(
    source_rack: str,
    target_rack: str,
    *,
    fps: float,
    turn_seconds_per_90: float = 0.75,
    calm_hold_seconds: float = 1.0,
) -> int:
    if fps <= 0.0:
        raise ValueError("fps must be positive")
    *_unused, required_seconds = _rack_to_rack_setup(
        source_rack,
        target_rack,
        turn_seconds_per_90=turn_seconds_per_90,
    )
    return max(2, int(math.ceil((required_seconds + calm_hold_seconds) * fps)))


def plan_rack_to_rack_route(
    source_rack: str,
    target_rack: str,
    *,
    total_frames: int,
    fps: float,
    turn_seconds_per_90: float = 0.75,
) -> RackRoute:
    source_name, target_name, points, source_heading, target_heading, walk_speed, required_seconds = (
        _rack_to_rack_setup(
            source_rack,
            target_rack,
            turn_seconds_per_90=turn_seconds_per_90,
        )
    )
    route = _plan_points_route(
        rack_name=target_name,
        points=points,
        total_frames=total_frames,
        fps=fps,
        initial_heading=source_heading,
        final_heading=target_heading,
        required_seconds=required_seconds,
        walk_speed_m_s=walk_speed,
        turn_seconds_per_90=turn_seconds_per_90,
    )
    return RackRoute(
        rack_name=f"{source_name}_to_{target_name}",
        positions=route.positions,
        headings=route.headings,
        waypoint_indices=route.waypoint_indices,
        approach_position=route.approach_position,
        final_heading=route.final_heading,
        required_seconds=route.required_seconds,
        walk_speed_m_s=route.walk_speed_m_s,
        turn_degrees=route.turn_degrees,
    )


def rack_return_auto_frame_count(
    rack: str,
    *,
    fps: float,
    turn_seconds_per_90: float = 0.75,
    calm_hold_seconds: float = 1.0,
) -> int:
    if fps <= 0.0:
        raise ValueError("fps must be positive")
    *_unused, required_seconds = _rack_return_setup(rack, turn_seconds_per_90=turn_seconds_per_90)
    return max(2, int(math.ceil((required_seconds + calm_hold_seconds) * fps)))


def plan_rack_return_route(
    rack: str,
    *,
    total_frames: int,
    fps: float,
    turn_seconds_per_90: float = 0.75,
) -> RackRoute:
    rack_name, points, initial_heading, final_heading, walk_speed, required_seconds = _rack_return_setup(
        rack,
        turn_seconds_per_90=turn_seconds_per_90,
    )
    return _plan_points_route(
        rack_name=rack_name,
        points=points,
        total_frames=total_frames,
        fps=fps,
        initial_heading=initial_heading,
        final_heading=final_heading,
        required_seconds=required_seconds,
        walk_speed_m_s=walk_speed,
        turn_seconds_per_90=turn_seconds_per_90,
    )


def create_rack_root2d_constraint(
    skeleton: "SkeletonBase",
    rack: str,
    *,
    total_frames: int,
    fps: float,
    device: Any,
) -> tuple["Root2DConstraintSet", RackRoute]:
    import torch

    from ardy.constraints import Root2DConstraintSet

    route = plan_rack_route(rack, total_frames=total_frames, fps=fps)
    frame_indices = torch.arange(total_frames, dtype=torch.long)
    positions = torch.tensor(route.positions, dtype=torch.float32, device=device)
    headings = torch.tensor(route.headings, dtype=torch.float32, device=device)
    constraint = Root2DConstraintSet(
        skeleton,
        frame_indices=frame_indices,
        root_2d=positions[:, [0, 2]],
        global_root_heading=headings,
    )
    return constraint, route
