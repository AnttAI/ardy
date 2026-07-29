# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""BVH export helpers for external retargeting pipelines."""

from pathlib import Path
from typing import Optional

import numpy as np
from scipy.spatial.transform import Rotation


CSKEL27_JOINTS = [
    "Hips",
    "Spine",
    "Spine1",
    "Spine2",
    "Spine3",
    "Neck",
    "Head",
    "RightShoulder",
    "RightArm",
    "RightForeArm",
    "RightHand",
    "RightHandEnd",
    "RightHandThumb1",
    "LeftShoulder",
    "LeftArm",
    "LeftForeArm",
    "LeftHand",
    "LeftHandEnd",
    "LeftHandThumb1",
    "RightUpLeg",
    "RightLeg",
    "RightFoot",
    "RightToeBase",
    "LeftUpLeg",
    "LeftLeg",
    "LeftFoot",
    "LeftToeBase",
]


TARGET_TO_SOURCE = {
    "Hips": "Hips",
    "Spine1": "Spine",
    "Spine2": "Spine2",
    "Chest": "Spine3",
    "Neck1": "Neck",
    "Neck2": "Neck",
    "Head": "Head",
    "LeftShoulder": "LeftShoulder",
    "LeftArm": "LeftArm",
    "LeftForeArm": "LeftForeArm",
    "LeftHand": "LeftHand",
    "LeftHandThumb1": "LeftHandThumb1",
    "LeftHandThumbEnd": "LeftHandThumb1",
    "LeftHandMiddleEnd": "LeftHandEnd",
    "RightShoulder": "RightShoulder",
    "RightArm": "RightArm",
    "RightForeArm": "RightForeArm",
    "RightHand": "RightHand",
    "RightHandThumb1": "RightHandThumb1",
    "RightHandThumbEnd": "RightHandThumb1",
    "RightHandMiddleEnd": "RightHandEnd",
    "LeftLeg": "LeftUpLeg",
    "LeftShin": "LeftLeg",
    "LeftFoot": "LeftFoot",
    "LeftToeBase": "LeftToeBase",
    "LeftToeEnd": "LeftToeBase",
    "RightLeg": "RightUpLeg",
    "RightShin": "RightLeg",
    "RightFoot": "RightFoot",
    "RightToeBase": "RightToeBase",
    "RightToeEnd": "RightToeBase",
}


CORE27_PARENTS = np.array(
    [
        -1,
        0,
        1,
        2,
        3,
        4,
        5,
        4,
        7,
        8,
        9,
        10,
        10,
        4,
        13,
        14,
        15,
        16,
        16,
        0,
        19,
        20,
        21,
        0,
        23,
        24,
        25,
    ],
    dtype=np.int64,
)


SOMA77_JOINTS = [
    "Hips",
    "Spine1",
    "Spine2",
    "Chest",
    "Neck1",
    "Neck2",
    "Head",
    "HeadEnd",
    "Jaw",
    "LeftEye",
    "RightEye",
    "LeftShoulder",
    "LeftArm",
    "LeftForeArm",
    "LeftHand",
    "LeftHandThumb1",
    "LeftHandThumb2",
    "LeftHandThumb3",
    "LeftHandThumbEnd",
    "LeftHandIndex1",
    "LeftHandIndex2",
    "LeftHandIndex3",
    "LeftHandIndex4",
    "LeftHandIndexEnd",
    "LeftHandMiddle1",
    "LeftHandMiddle2",
    "LeftHandMiddle3",
    "LeftHandMiddle4",
    "LeftHandMiddleEnd",
    "LeftHandRing1",
    "LeftHandRing2",
    "LeftHandRing3",
    "LeftHandRing4",
    "LeftHandRingEnd",
    "LeftHandPinky1",
    "LeftHandPinky2",
    "LeftHandPinky3",
    "LeftHandPinky4",
    "LeftHandPinkyEnd",
    "RightShoulder",
    "RightArm",
    "RightForeArm",
    "RightHand",
    "RightHandThumb1",
    "RightHandThumb2",
    "RightHandThumb3",
    "RightHandThumbEnd",
    "RightHandIndex1",
    "RightHandIndex2",
    "RightHandIndex3",
    "RightHandIndex4",
    "RightHandIndexEnd",
    "RightHandMiddle1",
    "RightHandMiddle2",
    "RightHandMiddle3",
    "RightHandMiddle4",
    "RightHandMiddleEnd",
    "RightHandRing1",
    "RightHandRing2",
    "RightHandRing3",
    "RightHandRing4",
    "RightHandRingEnd",
    "RightHandPinky1",
    "RightHandPinky2",
    "RightHandPinky3",
    "RightHandPinky4",
    "RightHandPinkyEnd",
    "LeftLeg",
    "LeftShin",
    "LeftFoot",
    "LeftToeBase",
    "LeftToeEnd",
    "RightLeg",
    "RightShin",
    "RightFoot",
    "RightToeBase",
    "RightToeEnd",
]


SOMA77_PARENTS = np.array(
    [
        -1,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        6,
        6,
        6,
        3,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        14,
        19,
        20,
        21,
        22,
        14,
        24,
        25,
        26,
        27,
        14,
        29,
        30,
        31,
        32,
        14,
        34,
        35,
        36,
        37,
        3,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
        42,
        47,
        48,
        49,
        50,
        42,
        52,
        53,
        54,
        55,
        42,
        57,
        58,
        59,
        60,
        42,
        62,
        63,
        64,
        65,
        0,
        67,
        68,
        69,
        70,
        0,
        72,
        73,
        74,
        75,
    ],
    dtype=np.int64,
)


def hierarchy_and_channels(reference_bvh: Path) -> tuple[str, list[tuple[str, list[str]]]]:
    text = reference_bvh.read_text()
    hierarchy = text[: text.index("MOTION")].rstrip()
    channels: list[tuple[str, list[str]]] = []
    current_joint: str | None = None

    for line in hierarchy.splitlines():
        parts = line.strip().split()
        if not parts:
            continue
        if parts[0] in {"ROOT", "JOINT"}:
            current_joint = parts[1]
        elif parts[0] == "CHANNELS":
            if current_joint is None:
                raise ValueError("CHANNELS line appeared before a joint declaration")
            channels.append((current_joint, parts[2:]))

    return hierarchy, channels


def matrix_to_zyx_degrees(rot_mats: np.ndarray) -> np.ndarray:
    flat = rot_mats.reshape(-1, 3, 3)
    eulers = Rotation.from_matrix(flat).as_euler("ZYX", degrees=True)
    return eulers.reshape(rot_mats.shape[:-2] + (3,))


def local_to_global_rotations(local_rot_mats: np.ndarray, parents: np.ndarray) -> np.ndarray:
    global_rot_mats = np.empty_like(local_rot_mats)
    for joint_idx, parent_idx in enumerate(parents):
        if parent_idx < 0:
            global_rot_mats[:, joint_idx] = local_rot_mats[:, joint_idx]
        else:
            global_rot_mats[:, joint_idx] = global_rot_mats[:, parent_idx] @ local_rot_mats[:, joint_idx]
    return global_rot_mats


def global_to_local_rotations(global_rot_mats: np.ndarray, parents: np.ndarray) -> np.ndarray:
    local_rot_mats = np.empty_like(global_rot_mats)
    for joint_idx, parent_idx in enumerate(parents):
        if parent_idx < 0:
            local_rot_mats[:, joint_idx] = global_rot_mats[:, joint_idx]
        else:
            local_rot_mats[:, joint_idx] = np.swapaxes(global_rot_mats[:, parent_idx], -1, -2) @ global_rot_mats[
                :, joint_idx
            ]
    return local_rot_mats


def default_soma_standard_offsets_path() -> Path:
    return Path(__file__).resolve().parents[1] / "assets" / "skeletons" / "somaskel77" / (
        "standard_t_pose_global_offsets_rots.p"
    )


def load_standard_offsets(path: Path) -> Optional[np.ndarray]:
    if not path.exists():
        return None
    try:
        import torch
    except ImportError:
        return None
    offsets = torch.load(path, map_location="cpu", weights_only=True).squeeze()
    return offsets.detach().cpu().numpy()


def core27_to_soma77_standard_local_rotations(local_rot_mats: np.ndarray) -> np.ndarray:
    """Map Core27 local rotations into SOMA77 local rotations in standard pose space.

    Use this for direct in-memory consumers. BVH export needs
    ``core27_to_soma77_bvh_local_rotations`` instead, because the BVH importer
    later applies the standard-pose offset correction.
    """
    core_global = local_to_global_rotations(local_rot_mats, CORE27_PARENTS)
    core_index = {name: idx for idx, name in enumerate(CSKEL27_JOINTS)}
    soma_index = {name: idx for idx, name in enumerate(SOMA77_JOINTS)}

    soma_global_standard = np.tile(
        np.eye(3, dtype=local_rot_mats.dtype),
        (local_rot_mats.shape[0], len(SOMA77_JOINTS), 1, 1),
    )
    for target_name, source_name in TARGET_TO_SOURCE.items():
        soma_global_standard[:, soma_index[target_name]] = core_global[:, core_index[source_name]]

    return global_to_local_rotations(soma_global_standard, SOMA77_PARENTS)


def core27_to_soma77_bvh_local_rotations(
    local_rot_mats: np.ndarray,
    standard_offsets_path: Optional[Path] = None,
) -> np.ndarray:
    soma_global_standard = local_to_global_rotations(
        core27_to_soma77_standard_local_rotations(local_rot_mats),
        SOMA77_PARENTS,
    )

    # ARDY's BVH loader post-multiplies parsed SOMA BVH globals by
    # global_rot_offsets.T to reach the standard T-pose frame. Export applies
    # the inverse so importing this BVH lands back on the original ARDY pose.
    offsets_path = standard_offsets_path or default_soma_standard_offsets_path()
    standard_offsets = load_standard_offsets(offsets_path)
    if standard_offsets is not None:
        soma_global_bvh = soma_global_standard @ standard_offsets
    else:
        soma_global_bvh = soma_global_standard

    return global_to_local_rotations(soma_global_bvh, SOMA77_PARENTS)


def export_soma_bvh_from_arrays(
    local_rot_mats: np.ndarray,
    root_positions: np.ndarray,
    fps: float,
    reference_bvh: Path,
    output_bvh: Path,
    standard_offsets_path: Optional[Path] = None,
) -> None:
    if local_rot_mats.shape[1] != len(CSKEL27_JOINTS):
        raise ValueError(
            f"Expected {len(CSKEL27_JOINTS)} source joints, got {local_rot_mats.shape[1]}"
        )

    hierarchy, channels = hierarchy_and_channels(reference_bvh)
    soma_index = {name: idx for idx, name in enumerate(SOMA77_JOINTS)}
    bvh_local_rot_mats = core27_to_soma77_bvh_local_rotations(local_rot_mats, standard_offsets_path)
    bvh_eulers = matrix_to_zyx_degrees(bvh_local_rot_mats)

    frames: list[str] = []
    root_cm = root_positions * 100.0
    for frame_idx in range(local_rot_mats.shape[0]):
        values: list[float] = []
        for joint_name, joint_channels in channels:
            if joint_name == "Root":
                values.extend([0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
                continue

            if joint_name == "Hips":
                pos = root_cm[frame_idx]
                rot = bvh_eulers[frame_idx, soma_index["Hips"]]
                channel_values = {
                    "Xposition": pos[0],
                    "Yposition": pos[1],
                    "Zposition": pos[2],
                    "Zrotation": rot[0],
                    "Yrotation": rot[1],
                    "Xrotation": rot[2],
                }
            else:
                if joint_name not in soma_index:
                    rot = np.zeros(3, dtype=np.float64)
                else:
                    rot = bvh_eulers[frame_idx, soma_index[joint_name]]
                channel_values = {
                    "Zrotation": rot[0],
                    "Yrotation": rot[1],
                    "Xrotation": rot[2],
                }
            values.extend(float(channel_values[channel]) for channel in joint_channels)
        frames.append(" ".join(f"{value:.6f}" for value in values))

    output_bvh.parent.mkdir(parents=True, exist_ok=True)
    output_bvh.write_text(
        "\n".join(
            [
                hierarchy,
                "MOTION",
                f"Frames: {local_rot_mats.shape[0]}",
                f"Frame Time: {1.0 / fps:.6f}",
                *frames,
                "",
            ]
        )
    )
