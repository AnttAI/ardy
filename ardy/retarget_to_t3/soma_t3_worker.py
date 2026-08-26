#!/usr/bin/env python3
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Warm stdin/stdout worker for SOMA BVH -> T3 upper-body CSV retargeting."""

from __future__ import annotations

import contextlib
import json
import sys
import traceback
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from ardy.retarget_to_t3.embedded_soma_t3 import (  # noqa: E402
    SomaBvhT3UpperBodyRetargeter,
    SomaT3LiveUpperBodySolver,
    T3_LIFT_HEIGHT_OFFSET_M,
)
from ardy.retarget_to_t3.soma_bvh_converter import (  # noqa: E402
    _append_lift_column_to_t3_csv,
    _compute_bvh_lift_extensions,
)


DEFAULT_CONFIG = {
    "retarget_source": "soma",
    "retarget_source_facing_direction": "Mujoco",
}

_LIVE_SOLVER: SomaT3LiveUpperBodySolver | None = None
_BVH_RETARGETER: SomaBvhT3UpperBodyRetargeter | None = None


def _handle_retarget_bvh(payload: dict) -> dict:
    global _BVH_RETARGETER
    bvh_path = Path(payload["bvh_path"]).expanduser().resolve()
    output_csv = Path(payload["output_csv"]).expanduser().resolve()
    config = dict(DEFAULT_CONFIG)
    config.update(payload.get("config") or {})
    if _BVH_RETARGETER is None:
        _BVH_RETARGETER = SomaBvhT3UpperBodyRetargeter(
            retarget_source=config.get("retarget_source", DEFAULT_CONFIG["retarget_source"]),
            retarget_source_facing_direction=config.get(
                "retarget_source_facing_direction",
                DEFAULT_CONFIG["retarget_source_facing_direction"],
            ),
        )
    sample_rate = _BVH_RETARGETER.retarget_bvh_to_csv(
        bvh_path,
        output_csv,
    )
    lift_extensions = _compute_bvh_lift_extensions(
        bvh_path,
        source_facing_direction=config.get("retarget_source_facing_direction", DEFAULT_CONFIG["retarget_source_facing_direction"]),
        lift_height_offset_m=T3_LIFT_HEIGHT_OFFSET_M,
    )
    _append_lift_column_to_t3_csv(output_csv, lift_extensions)
    return {
        "ok": True,
        "output_csv": str(output_csv),
        "sample_rate": float(sample_rate),
    }


def _handle_live_init(payload: dict) -> dict:
    global _LIVE_SOLVER
    config = dict(DEFAULT_CONFIG)
    config.update(payload.get("config") or {})
    _LIVE_SOLVER = SomaT3LiveUpperBodySolver(
        retarget_source=config.get("retarget_source", DEFAULT_CONFIG["retarget_source"]),
        retarget_source_facing_direction=config.get(
            "retarget_source_facing_direction",
            DEFAULT_CONFIG["retarget_source_facing_direction"],
        ),
    )
    return {"ok": True, "live_ready": True}


def _handle_live_reset(payload: dict) -> dict:
    if _LIVE_SOLVER is not None:
        _LIVE_SOLVER.reset()
    return {"ok": True, "live_ready": _LIVE_SOLVER is not None}


def _handle_live_solve_frame(payload: dict) -> dict:
    global _LIVE_SOLVER
    if _LIVE_SOLVER is None:
        _handle_live_init(payload)
    if _LIVE_SOLVER is None:
        raise RuntimeError("Soma T3 live solver is unavailable")
    row = _LIVE_SOLVER.solve_frame(
        payload["root_position_m"],
        payload["soma77_local_rot_mats"],
    )
    return {
        "ok": True,
        "frame_idx": int(payload.get("frame_idx", -1)),
        "row": row,
    }


def _handle_live_solve_sequence(payload: dict) -> dict:
    global _LIVE_SOLVER
    if _LIVE_SOLVER is None:
        _handle_live_init(payload)
    if _LIVE_SOLVER is None:
        raise RuntimeError("Soma T3 live solver is unavailable")
    row = _LIVE_SOLVER.solve_frames(
        payload["root_positions_m"],
        payload["soma77_local_rot_mats_seq"],
    )
    return {
        "ok": True,
        "frame_idx": int(payload.get("frame_idx", -1)),
        "num_solved": len(payload.get("root_positions_m", [])),
        "row": row,
    }


def _handle(payload: dict) -> dict:
    command = payload.get("command", "retarget_bvh")
    if command == "retarget_bvh":
        return _handle_retarget_bvh(payload)
    if command == "live_init":
        return _handle_live_init(payload)
    if command == "live_reset":
        return _handle_live_reset(payload)
    if command == "live_solve_frame":
        return _handle_live_solve_frame(payload)
    if command == "live_solve_sequence":
        return _handle_live_solve_sequence(payload)
    raise ValueError(f"Unknown Soma T3 worker command: {command}")


def main() -> None:
    print(json.dumps({"ok": True, "ready": True}), flush=True)
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            payload = json.loads(line)
            with contextlib.redirect_stdout(sys.stderr):
                result = _handle(payload)
        except Exception as exc:
            result = {
                "ok": False,
                "error": str(exc),
                "traceback": traceback.format_exc(),
            }
        print(json.dumps(result), flush=True)


if __name__ == "__main__":
    main()
