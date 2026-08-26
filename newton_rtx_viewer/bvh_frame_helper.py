#!/usr/bin/env python3
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Convert a SOMA BVH into Newton RTX playback frame payloads.

This runs outside the RTX viewer Python when that environment does not provide
torch. Stdout is reserved for JSON; logs go to stderr.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np
import torch
from scipy.spatial.transform import Rotation

from ardy.data_processing.bvh import Bvh
from ardy.skeleton import SOMASkeleton77
from ardy.viz.soma_skin import SOMASkin


def _rotation_from_bvh_channels(channels: list[str], values: np.ndarray) -> np.ndarray:
    angles = {}
    for axis in ("X", "Y", "Z"):
        channel = f"{axis}rotation"
        angles[axis] = float(values[channels.index(channel)]) if channel in channels else 0.0
    return Rotation.from_euler("ZYX", [angles["Z"], angles["Y"], angles["X"]], degrees=True).as_matrix().astype(
        np.float32
    )


def _load_soma_bvh_motion(path: str | Path):
    bvh_path = Path(path).expanduser()
    bvh = Bvh(bvh_path.read_text(encoding="utf-8"), backend="np")
    skeleton = SOMASkeleton77(load=True)
    bvh_name_set = set(bvh.get_joints_names())
    if "Hips" not in bvh_name_set:
        raise ValueError(f"SOMA BVH must contain a Hips joint: {bvh_path}")

    joint_names = list(skeleton.bone_order_names)
    frame_count = int(bvh.nframes)
    local_rots = np.repeat(np.eye(3, dtype=np.float32)[None, None], frame_count * len(joint_names), axis=0).reshape(
        frame_count, len(joint_names), 3, 3
    )
    root_positions = np.zeros((frame_count, 3), dtype=np.float32)
    for joint_idx, joint_name in enumerate(joint_names):
        if joint_name not in bvh_name_set:
            continue
        channels = list(bvh.joint_channels(joint_name))
        values = np.asarray(bvh.frames_joints_channels([joint_name], channels), dtype=np.float32)[:, 0]
        local_rots[:, joint_idx] = np.stack(
            [_rotation_from_bvh_channels(channels, row) for row in values],
            axis=0,
        )
        if joint_name == "Hips":
            position_columns = []
            for channel in ("Xposition", "Yposition", "Zposition"):
                if channel in channels:
                    position_columns.append(values[:, channels.index(channel)])
                else:
                    position_columns.append(np.zeros(frame_count, dtype=np.float32))
            root_positions = (np.stack(position_columns, axis=-1) / 100.0).astype(np.float32)

    with torch.no_grad():
        local_rots_t = torch.as_tensor(local_rots, dtype=torch.float32)
        root_positions_t = torch.as_tensor(root_positions, dtype=torch.float32)
        global_rots_t, _, _ = skeleton.fk(local_rots_t, root_positions_t)
        if hasattr(skeleton, "global_rot_offsets"):
            offsets = skeleton.global_rot_offsets.to(dtype=torch.float32)
            global_rots_t = torch.einsum("T N m n, N o n -> T N m o", global_rots_t, offsets)
            local_rots_t = skeleton.global_rots_to_local_rots(global_rots_t)
        global_rots_t, joints_pos_t, _ = skeleton.fk(local_rots_t, root_positions_t)
    fps = 1.0 / max(float(bvh.frame_time), 1.0e-6)
    return skeleton.cpu(), joints_pos_t.detach().cpu(), global_rots_t.detach().cpu(), fps


def make_frames(bvh_path: str | Path) -> tuple[list[dict], float]:
    soma_skeleton, joints_pos, joints_rot, fps = _load_soma_bvh_motion(bvh_path)
    soma_skin = SOMASkin(soma_skeleton)
    faces = soma_skin.faces.detach().cpu().numpy().astype(int).tolist()
    frames = []
    for frame_idx in range(int(joints_pos.shape[0])):
        soma_vertices = soma_skin.skin(
            joints_rot[frame_idx : frame_idx + 1],
            joints_pos[frame_idx : frame_idx + 1],
            rot_is_global=True,
        )[0].detach().cpu().numpy()
        frames.append(
            {
                "show_soma_mesh": True,
                "show_t3_robot": False,
                "t3_row": None,
                "fps": float(fps),
                "frame_idx": int(frame_idx),
                "soma_joint_names": list(soma_skeleton.bone_order_names),
                "soma_joint_parents": soma_skeleton.joint_parents.detach().cpu().numpy().astype(int).tolist(),
                "soma_joints_pos": joints_pos[frame_idx].numpy().astype(float).tolist(),
                "soma_joints_rot": joints_rot[frame_idx].numpy().astype(float).tolist(),
                "soma_mesh_vertices": soma_vertices.astype(float).tolist(),
                "soma_mesh_faces": faces if frame_idx < 10 or frame_idx % 30 == 0 else None,
                "soma_root_pos": joints_pos[frame_idx, 0].numpy().astype(float).tolist(),
            }
        )
    return frames, fps


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bvh", required=True)
    args = parser.parse_args()
    frames, fps = make_frames(args.bvh)
    print(json.dumps({"fps": float(fps), "frames": frames}, separators=(",", ":")))
    print(f"[ARDY BVH Helper] loaded {len(frames)} frames from {args.bvh}", file=sys.stderr, flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
