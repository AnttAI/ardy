#!/usr/bin/env python3
"""Build a small USD scene from downloaded GLB environment props."""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
import trimesh
from pxr import Gf, Sdf, Usd, UsdGeom, UsdShade


ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = ROOT / "assets" / "environment"
OUTPUT = ASSET_DIR / "table_bottles_preview.usda"
SCENE_JSON = ASSET_DIR / "pick_table_scene.json"
SOURCE_TABLE_TOP_Z = 0.75


def _glb_meshes(path: Path) -> list[trimesh.Trimesh]:
    scene = trimesh.load(path, force="scene")
    dumped = scene.dump(concatenate=False)
    if isinstance(dumped, trimesh.Trimesh):
        return [dumped]
    return [mesh for mesh in dumped if isinstance(mesh, trimesh.Trimesh) and len(mesh.vertices) and len(mesh.faces)]


def _color(mesh: trimesh.Trimesh, fallback: tuple[float, float, float]) -> Gf.Vec3f:
    material = getattr(getattr(mesh.visual, "material", None), "main_color", None)
    if material is None:
        return Gf.Vec3f(*fallback)
    rgba = np.asarray(material, dtype=np.float32).reshape(-1)
    if rgba.size < 3:
        return Gf.Vec3f(*fallback)
    return Gf.Vec3f(float(rgba[0] / 255.0), float(rgba[1] / 255.0), float(rgba[2] / 255.0))


def _make_material(stage: Usd.Stage, path: str, color: Gf.Vec3f, roughness: float = 0.55) -> UsdShade.Material:
    material = UsdShade.Material.Define(stage, path)
    shader = UsdShade.Shader.Define(stage, f"{path}/PreviewSurface")
    shader.CreateIdAttr("UsdPreviewSurface")
    shader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(color)
    shader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(float(roughness))
    shader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.0)
    material.CreateSurfaceOutput().ConnectToSource(shader.ConnectableAPI(), "surface")
    return material


def _add_mesh_instance(
    stage: Usd.Stage,
    meshes: list[trimesh.Trimesh],
    root_path: str,
    translation: tuple[float, float, float],
    scale: float | tuple[float, float, float],
    fallback_color: tuple[float, float, float],
) -> None:
    root = UsdGeom.Xform.Define(stage, root_path)
    root.AddTranslateOp().Set(Gf.Vec3d(*translation))
    if isinstance(scale, tuple):
        root.AddScaleOp().Set(Gf.Vec3f(float(scale[0]), float(scale[1]), float(scale[2])))
    else:
        root.AddScaleOp().Set(Gf.Vec3f(scale, scale, scale))
    for index, src in enumerate(meshes):
        mesh_path = f"{root_path}/mesh_{index}"
        mesh = UsdGeom.Mesh.Define(stage, mesh_path)
        vertices = np.asarray(src.vertices, dtype=np.float32)
        faces = np.asarray(src.faces, dtype=np.int32)
        # Convert glTF Y-up convention into USD/Newton Z-up convention.
        points = [Gf.Vec3f(float(v[0]), float(v[2]), float(v[1])) for v in vertices]
        mesh.GetPointsAttr().Set(points)
        mesh.GetFaceVertexCountsAttr().Set([3] * len(faces))
        mesh.GetFaceVertexIndicesAttr().Set(faces.reshape(-1).astype(np.int32).tolist())
        mesh.CreateSubdivisionSchemeAttr().Set("none")
        material = _make_material(stage, f"{root_path}/Materials/mat_{index}", _color(src, fallback_color))
        UsdShade.MaterialBindingAPI.Apply(mesh.GetPrim())
        UsdShade.MaterialBindingAPI(mesh).Bind(material)


def main() -> None:
    table_meshes = _glb_meshes(ASSET_DIR / "dining_table.glb")
    scene = json.loads(SCENE_JSON.read_text(encoding="utf-8"))
    table = scene.get("table", {})
    table_center = table.get("center", [0.0, -0.75, 0.0])
    table_top_z = float(table.get("top_z", SOURCE_TABLE_TOP_Z))
    table_z_scale = table_top_z / SOURCE_TABLE_TOP_Z

    if OUTPUT.exists():
        OUTPUT.unlink()
    stage = Usd.Stage.CreateNew(str(OUTPUT))
    UsdGeom.SetStageUpAxis(stage, UsdGeom.Tokens.z)
    UsdGeom.SetStageMetersPerUnit(stage, 1.0)
    world = UsdGeom.Xform.Define(stage, "/World")
    stage.SetDefaultPrim(world.GetPrim())

    _add_mesh_instance(
        stage,
        table_meshes,
        "/World/Table",
        (float(table_center[0]), float(table_center[1]), 0.0),
        (1.0, 1.0, table_z_scale),
        (0.55, 0.36, 0.20),
    )
    # Bottles are rendered by Newton bodies in the viewer so they can be picked.

    stage.GetRootLayer().Save()
    print(OUTPUT)


if __name__ == "__main__":
    main()
