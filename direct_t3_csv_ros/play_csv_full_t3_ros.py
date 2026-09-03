#!/usr/bin/env python3
"""Play a saved T3 CSV directly to ROS 2, like the GUI "Play CSV Full T3" button."""

from __future__ import annotations

import argparse
import csv
import math
import sys
import time
from pathlib import Path
from typing import Iterable


HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))


ROBOT_JOINT_NAMES = [f"joint{i}" for i in range(1, 8)]
DEFAULT_CSV_PATH = HERE / "client_0_gen_23_full.csv"


def non_negative_float(value: str) -> float:
    parsed = float(value)
    if parsed < 0.0:
        raise argparse.ArgumentTypeError("value must be greater than or equal to 0")
    return parsed


def read_rows(csv_path: Path) -> tuple[list[dict[str, str]], list[str]]:
    with csv_path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames is None:
            raise ValueError(f"T3 CSV has no header: {csv_path}")
        rows = [dict(row) for row in reader]
        fieldnames = list(reader.fieldnames)
    if not rows:
        raise ValueError(f"T3 CSV has no rows: {csv_path}")

    required = [*[f"right_joint{i}_dof" for i in range(1, 8)], *[f"left_joint{i}_dof" for i in range(1, 8)]]
    missing = [column for column in required if column not in fieldnames]
    if missing:
        raise ValueError("T3 CSV is missing robot columns: " + ", ".join(missing))
    return rows, fieldnames


def split_segments(rows: Iterable[dict[str, str]]) -> list[list[dict[str, str]]]:
    segments: list[list[dict[str, str]]] = []
    current: list[dict[str, str]] = []
    previous_frame: int | None = None
    for row in rows:
        frame_text = row.get("frame_index") or row.get("Frame") or "0"
        try:
            frame_idx = int(float(frame_text))
        except (TypeError, ValueError):
            frame_idx = 0
        if current and previous_frame is not None and frame_idx < previous_frame:
            segments.append(current)
            current = []
        current.append(row)
        previous_frame = frame_idx
    if current:
        segments.append(current)
    return [segment for segment in segments if len(segment) > 1]


def select_segment(rows: list[dict[str, str]], requested_segment: int) -> tuple[list[dict[str, str]], int, int]:
    segments = split_segments(rows)
    if not segments:
        raise ValueError("T3 CSV has no playable frame segments")
    segment_index = max(0, min(int(requested_segment), len(segments) - 1))
    return segments[segment_index], segment_index, len(segments)


def infer_fps(rows: list[dict[str, str]], override_fps: float) -> float:
    if override_fps > 0.0:
        return override_fps
    for key in ("effective_send_fps", "native_fps"):
        value = str(rows[0].get(key, "")).strip()
        if value:
            parsed = float(value)
            if parsed > 0.0:
                return parsed
    playback_speed = max(float(rows[0].get("playback_speed", "1.0") or 1.0), 0.05)
    return 20.0 * playback_speed


def wait_for_subscribers(
    node,
    right_pub,
    left_pub,
    base_pub,
    lift_pub,
    timeout_sec: float,
    require_arms: bool,
    require_base: bool,
    require_lift: bool,
) -> None:
    if timeout_sec <= 0.0:
        return

    import rclpy

    start = time.monotonic()
    last_counts: dict[str, int] = {}
    while time.monotonic() - start < timeout_sec:
        rclpy.spin_once(node, timeout_sec=0.0)
        last_counts = {
            "right_arm": int(right_pub.get_subscription_count()),
            "left_arm": int(left_pub.get_subscription_count()),
            "base": int(base_pub.get_subscription_count()),
            "lift": int(lift_pub.get_subscription_count()),
        }
        arms_ready = not require_arms or (last_counts["right_arm"] > 0 and last_counts["left_arm"] > 0)
        base_ready = not require_base or last_counts["base"] > 0
        lift_ready = not require_lift or last_counts["lift"] > 0
        if arms_ready and base_ready and lift_ready:
            return
        time.sleep(0.1)

    required = []
    if require_arms:
        required.append(f"arms right={last_counts.get('right_arm', 0)} left={last_counts.get('left_arm', 0)}")
    if require_base:
        required.append(f"base={last_counts.get('base', 0)}")
    if require_lift:
        required.append(f"lift={last_counts.get('lift', 0)}")
    raise TimeoutError("Timed out waiting for ROS subscribers: " + ", ".join(required))


def publish_arm_pair(node, joint_state_cls, right_pub, left_pub, right: list[float], left: list[float]) -> None:
    now = node.get_clock().now().to_msg()
    right_msg = joint_state_cls()
    right_msg.header.stamp = now
    right_msg.name = ROBOT_JOINT_NAMES
    right_msg.position = right

    left_msg = joint_state_cls()
    left_msg.header.stamp = now
    left_msg.name = ROBOT_JOINT_NAMES
    left_msg.position = left

    right_pub.publish(right_msg)
    left_pub.publish(left_msg)


def gripper_msg(joint_state_cls, stamp, right: list[float], gripper: float, effort: float):
    msg = joint_state_cls()
    msg.header.stamp = stamp
    msg.name = [*ROBOT_JOINT_NAMES, "gripper"]
    msg.position = [*right, gripper]
    msg.velocity = []
    msg.effort = [0.0] * len(ROBOT_JOINT_NAMES) + [effort]
    return msg


def payload_preview(payload) -> str:
    data = payload.to_stream_payload()
    return (
        f"frame={data.get('frame_index')} "
        f"arms={'yes' if 'right' in data and 'left' in data else 'no'} "
        f"base={data.get('base_wheel_rpm', 'none')} "
        f"lift={data.get('lift', 'none')}"
    )


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "csv_path",
        nargs="?",
        type=Path,
        default=DEFAULT_CSV_PATH,
        help=f"T3 CSV to play. Default: {DEFAULT_CSV_PATH}",
    )
    parser.add_argument("--segment", type=int, default=0)
    parser.add_argument("--fps", type=non_negative_float, default=0.0, help="Override CSV FPS; 0 means infer")
    parser.add_argument("--lift-step-frames", type=int, default=10, help="Publish lift once every N CSV rows")
    parser.add_argument("--right-topic", default="/right_arm/control/move_j")
    parser.add_argument("--left-topic", default="/left_arm/control/move_j")
    parser.add_argument("--gripper-topic", default="/right_arm/control/joint_states")
    parser.add_argument("--base-topic", default="/base/cmd_wheel_rpm")
    parser.add_argument("--lift-topic", default="/control/lift_frame")
    parser.add_argument("--rpm-scale", type=float, default=1.0)
    parser.add_argument("--max-abs-rpm", type=float, default=90.0)
    parser.add_argument("--linear-scale", type=float, default=1.0)
    parser.add_argument("--backward-scale", type=float, default=1.0)
    parser.add_argument("--yaw-scale", type=float, default=1.0)
    parser.add_argument("--wait-for-subscribers", type=non_negative_float, default=5.0)
    parser.add_argument("--no-require-arms", action="store_true")
    parser.add_argument("--no-require-base", action="store_true")
    parser.add_argument("--require-lift-subscriber", action="store_true")
    parser.add_argument("--no-zero-base-on-exit", action="store_true")
    parser.add_argument("--dry-run", action="store_true", help="Print payloads without importing ROS or publishing")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    csv_path = args.csv_path.expanduser()
    if not csv_path.is_absolute():
        csv_path = (Path.cwd() / csv_path).resolve()
    rows, _fieldnames = read_rows(csv_path)
    rows, segment_index, segment_count = select_segment(rows, args.segment)
    fps = infer_fps(rows, args.fps)

    from t3_payloads import build_t3_csv_frame_payload

    print(
        f"Playing CSV Full T3: {csv_path} segment {segment_index}/{segment_count - 1} "
        f"rows={len(rows)} fps={fps:.3f}",
        flush=True,
    )

    if args.dry_run:
        for row_index, row in enumerate(rows):
            payload = build_t3_csv_frame_payload(
                row,
                mode="full",
                rpm_scale=args.rpm_scale,
                max_abs_rpm=args.max_abs_rpm,
                linear_scale=args.linear_scale,
                backward_scale=args.backward_scale,
                yaw_scale=args.yaw_scale,
                emit_lift=row_index % max(1, int(args.lift_step_frames)) == 0,
            )
            print("[DRY-RUN] " + payload_preview(payload), flush=True)
        return 0

    try:
        import rclpy
        from rclpy.node import Node
        from sensor_msgs.msg import JointState
        from std_msgs.msg import Float64MultiArray
    except ImportError as exc:
        print("ROS 2 Python packages are not available. Source ROS 2 and the robot workspace.", file=sys.stderr)
        print(str(exc), file=sys.stderr)
        return 1

    rclpy.init()
    node = Node("ardy_play_csv_full_t3")
    right_pub = node.create_publisher(JointState, args.right_topic, 10)
    left_pub = node.create_publisher(JointState, args.left_topic, 10)
    gripper_pub = node.create_publisher(JointState, args.gripper_topic, 10)
    base_pub = node.create_publisher(Float64MultiArray, args.base_topic, 10)
    lift_pub = node.create_publisher(Float64MultiArray, args.lift_topic, 10)
    dt = 1.0 / max(float(fps), 1.0e-6)
    published_base = False

    try:
        wait_for_subscribers(
            node,
            right_pub,
            left_pub,
            base_pub,
            lift_pub,
            args.wait_for_subscribers,
            not args.no_require_arms,
            not args.no_require_base,
            args.require_lift_subscriber,
        )
        for row_index, row in enumerate(rows):
            started_at = time.time()
            payload = build_t3_csv_frame_payload(
                row,
                mode="full",
                rpm_scale=args.rpm_scale,
                max_abs_rpm=args.max_abs_rpm,
                linear_scale=args.linear_scale,
                backward_scale=args.backward_scale,
                yaw_scale=args.yaw_scale,
                emit_lift=row_index % max(1, int(args.lift_step_frames)) == 0,
            )
            data = payload.to_stream_payload()
            now = node.get_clock().now().to_msg()

            if "base_wheel_rpm" in data:
                base_msg = Float64MultiArray()
                base_msg.data = [float(data["base_wheel_rpm"][0]), float(data["base_wheel_rpm"][1])]
                base_pub.publish(base_msg)
                published_base = True
            if "lift" in data:
                lift_msg = Float64MultiArray()
                lift_msg.data = [float(data.get("lift_frame_index", data["frame_index"])), float(data["lift"])]
                lift_pub.publish(lift_msg)
            if "right" in data and "left" in data:
                publish_arm_pair(node, JointState, right_pub, left_pub, data["right"], data["left"])
            if "gripper" in data and "right" in data:
                gripper_pub.publish(gripper_msg(JointState, now, data["right"], float(data["gripper"]), 1.0))

            if row_index % 10 == 0 or row_index == len(rows) - 1:
                print("[ROS] " + payload_preview(payload), flush=True)
            rclpy.spin_once(node, timeout_sec=0.0)
            time.sleep(max(0.0, dt - (time.time() - started_at)))
    except KeyboardInterrupt:
        print("\nStopped by user.", flush=True)
        return 130
    except Exception as exc:
        print(f"Playback failed: {exc}", file=sys.stderr)
        return 1
    finally:
        if published_base and not args.no_zero_base_on_exit:
            stop_msg = Float64MultiArray()
            stop_msg.data = [0.0, 0.0]
            base_pub.publish(stop_msg)
            rclpy.spin_once(node, timeout_sec=0.1)
        node.destroy_node()
        rclpy.shutdown()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
