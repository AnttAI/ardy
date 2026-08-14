#!/usr/bin/env python3
"""Build a repeatable rack-route then BVH pick-constraint workflow.

This script does not replace the interactive demo. It prepares the exact data
and GUI values for the requested flow:

1. Go to a rack with the existing rack-route constraints.
2. Wait for confirmation that the route has finished.
3. Sample a BVH pick motion with only hand constraints enabled.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

PROGRAM_DIR = Path(__file__).resolve().parent
REPO_ROOT = PROGRAM_DIR.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from ardy.retail_rack_route import (
    plan_rack_pick,
    plan_rack_route,
    rack_pick_auto_frame_count,
    rack_route_auto_frame_count,
)


DEFAULT_CONFIG = PROGRAM_DIR / "config.json"
DEFAULT_OUTPUT_DIR = PROGRAM_DIR / "generated"
DEFAULT_FPS = 30.0


@dataclass(frozen=True)
class BvhInfo:
    path: Path
    frames: int
    frame_time: float | None

    @property
    def fps(self) -> float | None:
        if self.frame_time is None or self.frame_time <= 0.0:
            return None
        return 1.0 / self.frame_time


def read_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def parse_bvh_info(path: Path) -> BvhInfo:
    if not path.exists():
        raise FileNotFoundError(f"Motion BVH does not exist: {path}")

    frames = None
    frame_time = None
    with path.open("r", encoding="utf-8", errors="replace") as f:
        for line in f:
            stripped = line.strip()
            if stripped.startswith("Frames:"):
                frames = int(stripped.split(":", 1)[1].strip())
            elif stripped.startswith("Frame Time:"):
                frame_time = float(stripped.split(":", 1)[1].strip())
            if frames is not None and frame_time is not None:
                break

    if frames is None:
        raise ValueError(f"Could not find a 'Frames:' line in BVH: {path}")
    return BvhInfo(path=path, frames=frames, frame_time=frame_time)


def resolve_constraint_frames(raw_frames: list[Any], motion_frames: int) -> list[int]:
    resolved = []
    for value in raw_frames:
        token = str(value).strip()
        if not token:
            continue
        if token.lower() == "end":
            frame = motion_frames - 1
        else:
            frame = int(token)
        if frame < 0:
            raise ValueError(f"Constraint frame cannot be negative: {frame}")
        resolved.append(min(frame, motion_frames - 1))
    return sorted(dict.fromkeys(resolved))


def build_pick_constraints(config: dict[str, Any], bvh_info: BvhInfo) -> dict[str, Any]:
    frames = resolve_constraint_frames(config["constraint_frames"], bvh_info.frames)
    labels = ["start", "reach", "pregrasp", "grasp", "lift", "chest_hold", "end"]
    keyframes = {label: frame for label, frame in zip(labels, frames)}

    return {
        "type": "kimodo_pick_constraints",
        "motion_file_path": str(bvh_info.path),
        "constraint_frames": frames,
        "keyframes": keyframes,
        "gui_state": config["gui_state"],
        "notes": [
            "Use this JSON path in the demo's Constraint Frames field.",
            "The demo parser reads the keyframes object and samples these deterministic BVH frames.",
        ],
    }


def build_workflow_summary(config: dict[str, Any], bvh_info: BvhInfo, pick_constraints_path: Path) -> dict[str, Any]:
    fps = float(config.get("fps") or bvh_info.fps or DEFAULT_FPS)
    rack = str(config["rack"])
    shelf_number = int(config["shelf_number"])
    object_index = int(config["object_index"])

    route_frames = rack_route_auto_frame_count(rack, fps=fps)
    route = plan_rack_route(rack, total_frames=route_frames, fps=fps)
    pick_frames = rack_pick_auto_frame_count(rack, shelf_number, object_index, fps=fps)
    pick = plan_rack_pick(rack, shelf_number, object_index, total_frames=pick_frames, fps=fps)

    return {
        "rack_route": {
            "rack": route.rack_name,
            "fps": fps,
            "total_frames": route_frames,
            "duration_seconds": route_frames / fps,
            "approach_position": route.approach_position,
            "final_heading_radians": route.final_heading,
            "waypoint_indices": route.waypoint_indices,
            "turn_degrees": route.turn_degrees,
        },
        "confirmation": {
            "required": True,
            "message": "After the rack route finishes, confirm visually that the character stopped at the rack.",
        },
        "pick_motion": {
            "rack": pick.rack_name,
            "shelf_number": shelf_number,
            "object_index": object_index,
            "hand_side": pick.hand_side,
            "motion_file_path": str(bvh_info.path),
            "motion_frames": bvh_info.frames,
            "motion_fps": bvh_info.fps,
            "constraint_frames_text": ",".join(str(x) for x in config["constraint_frames"]),
            "constraint_frames_json": str(pick_constraints_path),
            "gui_state": config["gui_state"],
        },
    }


def build_checklist(config: dict[str, Any], pick_constraints_path: Path) -> str:
    gui = config["gui_state"]
    checked = [name for name, value in gui.items() if value is True]
    unchecked = [name for name, value in gui.items() if value is False]

    return "\n".join(
        [
            "# Rack Pick Checklist",
            "",
            f"Target rack: `{config['rack']}`",
            f"Pick shelf: `{config['shelf_number']}`",
            f"Pick object: `{config['object_index']}`",
            "",
            "1. In `Rack Route`, choose the target rack and click `Go To Rack`.",
            "2. Wait until the route finishes and confirm the character is standing at the rack.",
            "3. In `Constraints`, set these values:",
            f"   - `Motion File Path`: `{config['motion_file_path']}`",
            f"   - `Constraint Frames`: `{pick_constraints_path}`",
            f"   - Checked: `{', '.join(checked)}`",
            f"   - Unchecked: `{', '.join(unchecked)}`",
            "   - `Max Keyframes`: leave as-is; deterministic frames override random sampling.",
            "4. Click `Sample Constraints` and play/generate the pick motion.",
            "",
        ]
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    args = parser.parse_args()

    config = read_json(args.config)
    bvh_path = Path(config["motion_file_path"]).expanduser().resolve()
    bvh_info = parse_bvh_info(bvh_path)

    output_dir = args.output_dir
    pick_constraints_path = output_dir / "pick_constraints.json"
    workflow_summary_path = output_dir / "workflow_summary.json"
    checklist_path = output_dir / "checklist.md"

    pick_constraints = build_pick_constraints(config, bvh_info)
    workflow_summary = build_workflow_summary(config, bvh_info, pick_constraints_path)
    checklist = build_checklist(config, pick_constraints_path)

    write_json(pick_constraints_path, pick_constraints)
    write_json(workflow_summary_path, workflow_summary)
    checklist_path.parent.mkdir(parents=True, exist_ok=True)
    checklist_path.write_text(checklist, encoding="utf-8")

    print("Rack pick constraints program generated:")
    print(f"  BVH frames: {bvh_info.frames}")
    if bvh_info.fps is not None:
        print(f"  BVH fps: {bvh_info.fps:.2f}")
    print(f"  Pick constraints: {pick_constraints_path}")
    print(f"  Workflow summary: {workflow_summary_path}")
    print(f"  Checklist: {checklist_path}")
    print("")
    print("Use the generated pick_constraints.json path in the Constraint Frames field.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
