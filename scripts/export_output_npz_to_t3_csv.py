#!/usr/bin/env python3
"""Export an ARDY CoreSkeleton27 output NPZ as a Soma-retargeted T3 CSV."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from ardy.retarget_to_t3 import export_t3_csv_from_core27_arrays, retarget_soma_bvh_to_t3_csv


def export_t3_csv(
    input_npz: Path,
    output_csv: Path,
    reference_bvh: Path,
    keep_intermediate_bvh: bool = False,
) -> Path:
    data = np.load(input_npz, allow_pickle=True)
    local_rot_mats = data["local_rot_mats"]
    root_positions = data["smooth_root_pos"] if "smooth_root_pos" in data.files else data["root_positions"]
    fps = float(data["fps"]) if "fps" in data.files else 20.0
    return export_t3_csv_from_core27_arrays(
        filepath=output_csv,
        local_rot_mats=local_rot_mats,
        root_positions=root_positions,
        fps=fps,
        reference_bvh=reference_bvh,
        keep_intermediate_bvh=keep_intermediate_bvh,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="outputs/output.npz", type=Path)
    parser.add_argument("--bvh", type=Path, help="Retarget an already exported Soma BVH instead of an NPZ.")
    parser.add_argument(
        "--reference",
        default="/home/jony/Downloads/soma-retargeter/assets/motions/bvh/Neutral_walk_forward_002__A057.bvh",
        type=Path,
    )
    parser.add_argument("--output", default="outputs/output_t3.csv", type=Path)
    parser.add_argument("--keep-intermediate-bvh", action="store_true")
    args = parser.parse_args()

    if args.bvh is not None:
        path = retarget_soma_bvh_to_t3_csv(args.bvh, args.output)
    else:
        path = export_t3_csv(args.input, args.output, args.reference, args.keep_intermediate_bvh)
    print(path)


if __name__ == "__main__":
    main()
