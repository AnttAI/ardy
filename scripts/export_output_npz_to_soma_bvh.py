#!/usr/bin/env python3
"""Export an ARDY CoreSkeleton27 output NPZ as a SOMA-style BVH."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from ardy.exports.bvh import export_soma_bvh_from_arrays
from ardy.retarget_to_t3.embedded_soma_t3 import VENDORED_REFERENCE_BVH


def export_bvh(input_npz: Path, reference_bvh: Path, output_bvh: Path) -> None:
    data = np.load(input_npz, allow_pickle=True)
    local_rot_mats = data["local_rot_mats"]
    root_positions = data["smooth_root_pos"] if "smooth_root_pos" in data.files else data["root_positions"]
    fps = float(data["fps"]) if "fps" in data.files else 20.0
    export_soma_bvh_from_arrays(local_rot_mats, root_positions, fps, reference_bvh, output_bvh)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="outputs/output.npz", type=Path)
    parser.add_argument(
        "--reference",
        default=VENDORED_REFERENCE_BVH,
        type=Path,
    )
    parser.add_argument("--output", default="outputs/output_soma_retarget.bvh", type=Path)
    args = parser.parse_args()
    export_bvh(args.input, args.reference, args.output)
    print(args.output)


if __name__ == "__main__":
    main()
