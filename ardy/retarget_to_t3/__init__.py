# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Fast ARDY-generated motion to T3 retargeting helpers."""

__all__ = [
    "T3LiveRetargeter",
    "T3CsvPlaybackRobot",
    "SomaBvhT3UpperBodyRetargeter",
    "SomaT3LiveUpperBodySolver",
    "VENDORED_REFERENCE_BVH",
    "export_t3_csv_from_core27_arrays",
    "retarget_soma_bvh_to_t3_csv",
]


def __getattr__(name: str):
    if name == "T3LiveRetargeter":
        from .live_retargeter import T3LiveRetargeter

        return T3LiveRetargeter
    if name == "T3CsvPlaybackRobot":
        from .csv_player import T3CsvPlaybackRobot

        return T3CsvPlaybackRobot
    if name in {"SomaBvhT3UpperBodyRetargeter", "SomaT3LiveUpperBodySolver", "VENDORED_REFERENCE_BVH"}:
        from .embedded_soma_t3 import (
            SomaBvhT3UpperBodyRetargeter,
            SomaT3LiveUpperBodySolver,
            VENDORED_REFERENCE_BVH,
        )

        return {
            "SomaBvhT3UpperBodyRetargeter": SomaBvhT3UpperBodyRetargeter,
            "SomaT3LiveUpperBodySolver": SomaT3LiveUpperBodySolver,
            "VENDORED_REFERENCE_BVH": VENDORED_REFERENCE_BVH,
        }[name]
    if name == "export_t3_csv_from_core27_arrays":
        from .soma_bvh_converter import export_t3_csv_from_core27_arrays

        return export_t3_csv_from_core27_arrays
    if name == "retarget_soma_bvh_to_t3_csv":
        from .soma_bvh_converter import retarget_soma_bvh_to_t3_csv

        return retarget_soma_bvh_to_t3_csv
    raise AttributeError(f"module {__name__!r} has no attribute {name!r}")
