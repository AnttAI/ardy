"""Supermarket environment built from Viser primitives."""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
import viser


@dataclass(frozen=True)
class RackSpec:
    name: str
    position: tuple[float, float, float]
    yaw_rad: float = 0.0
    products: tuple[str, ...] = ()


WORK_AREA_GRID_SECTION_M = 0.60
WORK_AREA_GRID_SHAPE = (4, 6)
WORK_AREA_SIDE_SHIFT_M = 0.60
WORK_AREA_BOUNDARY_COLOR = (255, 128, 0)

RACK_WIDTH_M = 0.34
RACK_DEPTH_M = 0.72
RACK_HEIGHT_M = 1.65
RACK_FIRST_SHELF_HEIGHT_M = 0.10
RACK_SHELF_SPACING_M = 0.3048
RACK_SHELF_THICKNESS_M = 0.018
RACK_POST_SIZE_M = 0.025
RACK_SHELF_COUNT = 5

PRODUCT_SIZE_M = 0.06
PRODUCT_COLORS = ((220, 70, 70), (70, 180, 90), (70, 120, 220))

COUNTER_LENGTH_M = 0.80
COUNTER_WIDTH_M = 0.40
COUNTER_HEIGHT_M = 1.03
COUNTER_DISTANCE_FROM_ORIGIN_M = 0.30
COUNTER_TOP_THICKNESS_M = 0.06
COUNTER_LEG_SIZE_M = 0.045

SUPERMARKET_RACKS = (
    RackSpec(
        "rack_1",
        (-1.63, 0.0, -1.20),
        products=("Coconuts", "Tomatoes", "Potatoes", "Water", "Curry leaves"),
    ),
    RackSpec(
        "rack_2",
        (-1.63, 0.0, -2.40),
        products=("Rice", "Red gram", "Ice cream", "Coke", "Chips packets"),
    ),
    RackSpec("rack_3", (-1.10, 0.0, -3.43), yaw_rad=-np.pi / 2.0),
)


def add_supermarket_environment(client: viser.ClientHandle) -> list[viser.SceneHandle]:
    """Add the supermarket racks, product cubes, counter, and boundary."""
    handles: list[viser.SceneHandle] = [_add_work_area_boundary(client)]
    for rack in SUPERMARKET_RACKS:
        handles.extend(_add_rack(client, rack))
        handles.extend(_add_products(client, rack))
    handles.extend(_add_counter(client))
    return handles


def _shelf_surface_heights() -> tuple[float, ...]:
    return tuple(
        RACK_FIRST_SHELF_HEIGHT_M + index * RACK_SHELF_SPACING_M
        for index in range(RACK_SHELF_COUNT)
    )


def _rack_wxyz(yaw_rad: float) -> np.ndarray:
    return np.array(
        [np.cos(yaw_rad / 2.0), 0.0, np.sin(yaw_rad / 2.0), 0.0],
        dtype=np.float64,
    )


def _add_work_area_boundary(client: viser.ClientHandle) -> viser.SceneHandle:
    corners = np.array(
        [
            [0.60, 0.006, 0.00],
            [-1.80, 0.006, 0.00],
            [-1.80, 0.006, -3.60],
            [0.60, 0.006, -3.60],
        ],
        dtype=np.float32,
    )
    points = np.stack((corners, np.roll(corners, -1, axis=0)), axis=1)
    return client.scene.add_line_segments(
        "/supermarket/work_area_boundary",
        points=points,
        colors=WORK_AREA_BOUNDARY_COLOR,
        line_width=4.0,
    )


def _add_rack(client: viser.ClientHandle, rack: RackSpec) -> list[viser.SceneHandle]:
    root = f"/supermarket/racks/{rack.name}"
    handles: list[viser.SceneHandle] = [
        client.scene.add_frame(
            root,
            show_axes=False,
            position=np.asarray(rack.position, dtype=np.float64),
            wxyz=_rack_wxyz(rack.yaw_rad),
        )
    ]

    half_x = (RACK_WIDTH_M - RACK_POST_SIZE_M) / 2.0
    half_z = (RACK_DEPTH_M - RACK_POST_SIZE_M) / 2.0
    for index, (x_offset, z_offset) in enumerate(
        ((-half_x, -half_z), (-half_x, half_z), (half_x, -half_z), (half_x, half_z)),
        start=1,
    ):
        handles.append(
            client.scene.add_box(
                f"{root}/post_{index}",
                dimensions=(RACK_POST_SIZE_M, RACK_HEIGHT_M, RACK_POST_SIZE_M),
                color=(70, 78, 86),
                position=np.array([x_offset, RACK_HEIGHT_M / 2.0, z_offset], dtype=np.float64),
            )
        )

    for index, surface_height in enumerate(_shelf_surface_heights(), start=1):
        handles.append(
            client.scene.add_box(
                f"{root}/shelf_{index}",
                dimensions=(RACK_WIDTH_M, RACK_SHELF_THICKNESS_M, RACK_DEPTH_M),
                color=(150, 158, 166),
                position=np.array(
                    [0.0, surface_height - RACK_SHELF_THICKNESS_M / 2.0, 0.0],
                    dtype=np.float64,
                ),
            )
        )
        if index <= len(rack.products):
            handles.append(
                client.scene.add_label(
                    f"{root}/shelf_{index}_product",
                    text=f"S{index}: {rack.products[index - 1]}",
                    position=np.array(
                        [0.0, surface_height + 0.08, RACK_DEPTH_M / 2.0 + 0.03],
                        dtype=np.float64,
                    ),
                    font_size_mode="screen",
                    font_screen_scale=0.45,
                    anchor="center-center",
                )
            )

    handles.append(
        client.scene.add_label(
            f"{root}/label",
            text=rack.name.replace("_", " ").title(),
            position=np.array([0.0, 1.73, 0.0], dtype=np.float64),
            font_size_mode="screen",
            font_screen_scale=0.55,
            anchor="center-center",
        )
    )
    return handles


def _add_products(client: viser.ClientHandle, rack: RackSpec) -> list[viser.SceneHandle]:
    handles: list[viser.SceneHandle] = []
    rack_center_x, rack_center_y, rack_center_z = rack.position
    cos_yaw = np.cos(rack.yaw_rad)
    sin_yaw = np.sin(rack.yaw_rad)

    for shelf_number, shelf_surface_height in enumerate(_shelf_surface_heights(), start=1):
        for object_index in range(1, 4):
            local_x = RACK_WIDTH_M / 2.0 - 0.05
            local_z = (object_index - 2) * 0.15
            position = np.array(
                [
                    rack_center_x + cos_yaw * local_x + sin_yaw * local_z,
                    rack_center_y + shelf_surface_height + PRODUCT_SIZE_M / 2.0,
                    rack_center_z - sin_yaw * local_x + cos_yaw * local_z,
                ],
                dtype=np.float64,
            )
            handles.append(
                client.scene.add_box(
                    f"/supermarket/products/{rack.name}/shelf_{shelf_number}/object_{object_index}",
                    dimensions=(PRODUCT_SIZE_M, PRODUCT_SIZE_M, PRODUCT_SIZE_M),
                    color=PRODUCT_COLORS[object_index - 1],
                    position=position,
                )
            )
    return handles


def _add_counter(client: viser.ClientHandle) -> list[viser.SceneHandle]:
    root = "/supermarket/counter"
    handles: list[viser.SceneHandle] = [
        client.scene.add_frame(
            root,
            show_axes=False,
            position=np.array([0.0, 0.0, 0.50], dtype=np.float64),
        )
    ]

    handles.append(
        client.scene.add_box(
            f"{root}/top",
            dimensions=(COUNTER_LENGTH_M, COUNTER_TOP_THICKNESS_M, COUNTER_WIDTH_M),
            color=(128, 92, 58),
            position=np.array([0.0, 1.00, 0.0], dtype=np.float64),
        )
    )

    leg_height = COUNTER_HEIGHT_M - COUNTER_TOP_THICKNESS_M
    half_x = COUNTER_LENGTH_M / 2.0 - COUNTER_LEG_SIZE_M / 2.0
    half_z = COUNTER_WIDTH_M / 2.0 - COUNTER_LEG_SIZE_M / 2.0
    for index, (x_offset, z_offset) in enumerate(
        ((-half_x, -half_z), (-half_x, half_z), (half_x, -half_z), (half_x, half_z)),
        start=1,
    ):
        handles.append(
            client.scene.add_box(
                f"{root}/leg_{index}",
                dimensions=(COUNTER_LEG_SIZE_M, leg_height, COUNTER_LEG_SIZE_M),
                color=(92, 64, 45),
                position=np.array([x_offset, leg_height / 2.0, z_offset], dtype=np.float64),
            )
        )

    handles.append(
        client.scene.add_box(
            f"{root}/front_panel",
            dimensions=(COUNTER_LENGTH_M, 0.679, 0.025),
            color=(116, 78, 50),
            position=np.array([0.0, 0.388, half_z], dtype=np.float64),
        )
    )
    return handles
