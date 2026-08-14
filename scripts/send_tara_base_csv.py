#!/usr/bin/env python3
"""Send an ARDY hardware CSV to the Raspberry Pi Tara base CSV player."""

from __future__ import annotations

import argparse
import csv
import io
import json
import sys
from pathlib import Path


def _float_cell(row: dict[str, str], key: str, default: float = 0.0) -> float:
    value = str(row.get(key, "")).strip()
    if not value:
        return default
    return float(value)


def _read_base_csv(path: Path) -> tuple[str, float]:
    with path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))
    if not rows:
        raise ValueError(f"{path} has no rows")
    if "left_motor_rpm" not in rows[0] or "right_motor_rpm" not in rows[0]:
        raise ValueError("CSV must contain left_motor_rpm and right_motor_rpm columns")

    fps = _float_cell(rows[0], "effective_send_fps", 0.0)
    if fps <= 0.0:
        native_fps = _float_cell(rows[0], "native_fps", 20.0)
        playback_speed = _float_cell(rows[0], "playback_speed", 1.0)
        fps = native_fps * playback_speed
    if fps <= 0.0:
        raise ValueError("Could not infer FPS; pass --fps")

    out = io.StringIO()
    writer = csv.DictWriter(out, fieldnames=["Frame", "left_motor_rpm", "right_motor_rpm"])
    writer.writeheader()
    for index, row in enumerate(rows):
        left_text = str(row.get("left_motor_rpm", "")).strip()
        right_text = str(row.get("right_motor_rpm", "")).strip()
        if not left_text or not right_text:
            continue
        writer.writerow(
            {
                "Frame": int(_float_cell(row, "frame_index", float(index))),
                "left_motor_rpm": int(round(float(left_text))),
                "right_motor_rpm": int(round(float(right_text))),
            }
        )
    return out.getvalue(), fps


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_path", type=Path)
    parser.add_argument("--topic", default="/base/play_csv")
    parser.add_argument("--fps", type=float, default=0.0)
    parser.add_argument("--max-abs-rpm", type=float, default=90.0)
    parser.add_argument("--encoder-kp", type=float, default=18.0)
    parser.add_argument("--encoder-max-correction-rpm", type=float, default=8.0)
    args = parser.parse_args(argv)

    csv_text, inferred_fps = _read_base_csv(args.csv_path.expanduser())
    fps = args.fps if args.fps > 0.0 else inferred_fps
    payload = {
        "csv_text": csv_text,
        "options": {
            "fps": fps,
            "speed_scale": 1.0,
            "max_abs_rpm": args.max_abs_rpm,
            "fit_to_rpm_limit": False,
            "encoder_track": True,
            "swap_wheels": False,
            "encoder_kp": args.encoder_kp,
            "encoder_max_correction_rpm": args.encoder_max_correction_rpm,
        },
    }

    try:
        import rclpy
        from rclpy.node import Node
        from std_msgs.msg import String
    except ImportError as exc:
        print(f"ROS 2 Python packages are not available: {exc}", file=sys.stderr)
        return 1

    rclpy.init()
    node = Node("ardy_send_tara_base_csv")
    pub = node.create_publisher(String, args.topic, 10)
    deadline = node.get_clock().now().nanoseconds + int(2e9)
    while pub.get_subscription_count() == 0 and node.get_clock().now().nanoseconds < deadline:
        rclpy.spin_once(node, timeout_sec=0.1)

    msg = String()
    msg.data = json.dumps(payload, separators=(",", ":"))
    pub.publish(msg)
    rclpy.spin_once(node, timeout_sec=0.2)
    print(f"Sent {args.csv_path} to {args.topic} at {fps:.3f} FPS with encoder tracking.")
    node.destroy_node()
    rclpy.shutdown()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
