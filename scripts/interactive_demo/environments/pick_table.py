"""Pick-and-place table environment shared with the Newton RTX scene."""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
import trimesh
import viser


SCENE_PATH = Path(__file__).resolve().parents[3] / "newton_rtx_viewer" / "assets" / "environment" / "pick_table_scene.json"


def _load_scene() -> dict:
    with SCENE_PATH.open("r", encoding="utf-8") as file:
        data = json.load(file)
    return data if isinstance(data, dict) else {}


def _newton_to_viser(point: list[float] | tuple[float, float, float]) -> np.ndarray:
    x, y, z = (float(value) for value in point)
    return np.array([x, z, -y], dtype=np.float64)


def _newton_size_to_viser(size: list[float] | tuple[float, float, float]) -> tuple[float, float, float]:
    sx, sy, sz = (float(value) for value in size)
    return (sx, sz, sy)


def _z_up_mesh_to_y_up(vertices: np.ndarray) -> np.ndarray:
    return vertices @ np.array([[1.0, 0.0, 0.0], [0.0, 0.0, 1.0], [0.0, -1.0, 0.0]], dtype=np.float64)


def add_pick_table_environment(client: viser.ClientHandle) -> list[viser.SceneHandle]:
    """Add the same table/bottle layout used by Newton RTX physics."""
    scene = _load_scene()
    handles: list[viser.SceneHandle] = []

    table = scene.get("table") or {}
    table_center = table.get("center", [0.0, -1.25, 0.375])
    table_size = table.get("size", [1.8, 0.9, 0.75])
    top_thickness = float(table.get("top_thickness", 0.05))
    table_color = tuple(int(value) for value in table.get("color", [235, 238, 240]))
    table_size_viser = _newton_size_to_viser(table_size)
    table_center_viser = _newton_to_viser(table_center)

    handles.append(
        client.scene.add_box(
            "/pick_table/table/top",
            dimensions=(table_size_viser[0], top_thickness, table_size_viser[2]),
            color=table_color,
            position=np.array(
                [table_center_viser[0], float(table.get("top_z", 0.75)) - top_thickness * 0.5, table_center_viser[2]],
                dtype=np.float64,
            ),
        )
    )

    leg_size = 0.045
    leg_height = max(float(table_size[2]) - top_thickness, 0.05)
    half_x = table_size_viser[0] * 0.5 - leg_size * 1.5
    half_z = table_size_viser[2] * 0.5 - leg_size * 1.5
    for index, (x_offset, z_offset) in enumerate(
        ((-half_x, -half_z), (-half_x, half_z), (half_x, -half_z), (half_x, half_z)),
        start=1,
    ):
        handles.append(
            client.scene.add_box(
                f"/pick_table/table/leg_{index}",
                dimensions=(leg_size, leg_height, leg_size),
                color=(82, 90, 98),
                position=np.array(
                    [table_center_viser[0] + x_offset, leg_height * 0.5, table_center_viser[2] + z_offset],
                    dtype=np.float64,
                ),
            )
        )

    for index, bottle in enumerate(scene.get("bottles") or [], start=1):
        center = _newton_to_viser(bottle.get("center", [0.0, -0.86, 0.895]))
        radius = float(bottle.get("radius", 0.04))
        half_height = float(bottle.get("half_height", 0.145))
        neck_radius = float(bottle.get("neck_radius", 0.03))
        neck_half_height = float(bottle.get("neck_half_height", 0.035))

        body = trimesh.creation.cylinder(radius=radius, height=half_height * 2.0, sections=32)
        handles.append(
            client.scene.add_mesh_simple(
                f"/pick_table/bottles/bottle_{index}/body",
                vertices=_z_up_mesh_to_y_up(body.vertices),
                faces=body.faces,
                color=(97, 184, 245),
                position=center,
            )
        )

        label = trimesh.creation.cylinder(radius=radius * 1.015, height=0.080, sections=32)
        handles.append(
            client.scene.add_mesh_simple(
                f"/pick_table/bottles/bottle_{index}/label",
                vertices=_z_up_mesh_to_y_up(label.vertices),
                faces=label.faces,
                color=(8, 46, 107),
                position=center + np.array([0.0, -0.030, 0.0], dtype=np.float64),
            )
        )

        neck = trimesh.creation.cylinder(radius=neck_radius, height=neck_half_height * 2.0, sections=32)
        handles.append(
            client.scene.add_mesh_simple(
                f"/pick_table/bottles/bottle_{index}/neck",
                vertices=_z_up_mesh_to_y_up(neck.vertices),
                faces=neck.faces,
                color=(199, 235, 255),
                position=center + np.array([0.0, half_height + neck_half_height, 0.0], dtype=np.float64),
            )
        )

        cap = trimesh.creation.cylinder(radius=0.028, height=0.036, sections=32)
        handles.append(
            client.scene.add_mesh_simple(
                f"/pick_table/bottles/bottle_{index}/cap",
                vertices=_z_up_mesh_to_y_up(cap.vertices),
                faces=cap.faces,
                color=(10, 87, 224),
                position=center + np.array([0.0, half_height + 0.088, 0.0], dtype=np.float64),
            )
        )

    for target in scene.get("place_targets") or []:
        center = _newton_to_viser(target.get("center", [0.0, -1.42, 0.755]))
        color = tuple(int(value) for value in target.get("color", [70, 170, 110]))
        radius = float(target.get("radius", 0.06))
        marker = trimesh.creation.annulus(r_min=radius * 0.7, r_max=radius, height=0.006)
        handles.append(
            client.scene.add_mesh_simple(
                f"/pick_table/place_targets/{target.get('name', 'target')}",
                vertices=_z_up_mesh_to_y_up(marker.vertices),
                faces=marker.faces,
                color=color,
                position=center,
            )
        )

    return handles
