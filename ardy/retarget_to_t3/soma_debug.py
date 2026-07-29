"""Live Core27 -> SOMA77 pose mapper for Viser debugging."""

from __future__ import annotations

import numpy as np
import torch

from ardy.exports.bvh import SOMA77_JOINTS, SOMA77_PARENTS, TARGET_TO_SOURCE, global_to_local_rotations
from ardy.skeleton import SOMASkeleton77


def _to_numpy(value) -> np.ndarray:
    if isinstance(value, torch.Tensor):
        return value.detach().cpu().numpy()
    return np.asarray(value)


class SomaLivePoseMapper:
    """Map the currently displayed ARDY frame to a SOMA mesh pose with no worker latency."""

    def __init__(self, source_skeleton):
        self.source_skeleton = source_skeleton
        self.soma_skeleton = SOMASkeleton77().cpu()
        self.source_index = source_skeleton.bone_order_names_index
        self.soma_index = {name: idx for idx, name in enumerate(SOMA77_JOINTS)}

    def map_frame(self, joints_pos, joints_rot) -> tuple[torch.Tensor, torch.Tensor]:
        joints_pos_np = _to_numpy(joints_pos).astype(np.float32, copy=False)
        joints_rot_np = _to_numpy(joints_rot).astype(np.float32, copy=False)

        soma_global = np.tile(np.eye(3, dtype=np.float32), (len(SOMA77_JOINTS), 1, 1))
        for target_name, source_name in TARGET_TO_SOURCE.items():
            target_idx = self.soma_index.get(target_name)
            source_idx = self.source_index.get(source_name)
            if target_idx is None or source_idx is None:
                continue
            soma_global[target_idx] = joints_rot_np[source_idx]

        soma_local = global_to_local_rotations(soma_global[None], SOMA77_PARENTS)[0]
        root_idx = self.source_index.get("Hips", 0)
        root_position = joints_pos_np[root_idx]

        local_t = torch.from_numpy(soma_local[None])
        root_t = torch.from_numpy(root_position[None])
        soma_global_rot, soma_joints_pos, _ = self.soma_skeleton.fk(local_t, root_t)
        return soma_joints_pos[0].detach().cpu(), soma_global_rot[0].detach().cpu()
