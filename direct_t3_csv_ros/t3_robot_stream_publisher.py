#!/usr/bin/env python3
"""Publish streamed T3 arm frames and optional base wheel RPM to ROS 2."""

from __future__ import annotations

import argparse
import json
import math
import sys
import time
from typing import Iterator


ROBOT_JOINT_NAMES = [f"joint{i}" for i in range(1, 8)]


def _non_negative_float(value: str) -> float:
    parsed = float(value)
    if parsed < 0.0:
        raise argparse.ArgumentTypeError("value must be greater than or equal to 0")
    return parsed


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

    start = time.monotonic()
    last_counts: dict[str, int] = {}
    while time.monotonic() - start < timeout_sec:
        try:
            import rclpy

            rclpy.spin_once(node, timeout_sec=0.0)
        except Exception:
            pass

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
        required.extend(
            [
                f"right arm subscriber count on {right_pub.topic_name}: {last_counts.get('right_arm', 0)}",
                f"left arm subscriber count on {left_pub.topic_name}: {last_counts.get('left_arm', 0)}",
            ]
        )
    if require_base:
        required.append(f"base subscriber count on {base_pub.topic_name}: {last_counts.get('base', 0)}")
    if require_lift:
        required.append(f"lift subscriber count on {lift_pub.topic_name}: {last_counts.get('lift', 0)}")
    raise TimeoutError(
        "Timed out waiting for the requested T3 ROS subscribers: "
        + "; ".join(required)
        + ". Start the robot-side dual Nero + TaraBase + lift launch first, and check ROS_DOMAIN_ID."
    )


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Stream current ARDY T3 frames to AGX Nero ROS 2 JointState topics."
    )
    parser.add_argument("--right-topic", default="/right_arm/control/move_j")
    parser.add_argument("--left-topic", default="/left_arm/control/move_j")
    parser.add_argument(
        "--right-gripper-topic",
        "--gripper-topic",
        dest="right_gripper_topic",
        default="/right_arm/control/joint_states",
    )
    parser.add_argument("--left-gripper-topic", default="/left_arm/control/joint_states")
    parser.add_argument("--base-topic", default="/base/cmd_wheel_rpm")
    parser.add_argument("--lift-topic", default="/control/lift_frame")
    parser.add_argument(
        "--arm-smooth-rate",
        type=_non_negative_float,
        default=0.0,
        help="Interpolate arm targets at this Hz before publishing; 0 disables smoothing.",
    )
    parser.add_argument(
        "--require-arm-subscribers",
        action="store_true",
        help="Wait for both AGX arm ROS subscribers before accepting streamed frames.",
    )
    parser.add_argument(
        "--require-base-subscriber",
        action="store_true",
        help="Wait for the TaraBase ROS subscriber before accepting streamed frames.",
    )
    parser.add_argument(
        "--require-lift-subscriber",
        action="store_true",
        help="Wait for the lift ROS subscriber before accepting streamed frames.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Read streamed visualizer frames and print validated data without importing ROS or publishing.",
    )
    parser.add_argument(
        "--wait-for-subscribers",
        type=_non_negative_float,
        default=5.0,
        help="Seconds to wait for robot-side subscribers before accepting frames.",
    )
    return parser.parse_args(argv)


def _validate_positions(value: object, label: str) -> list[float]:
    if not isinstance(value, list) or len(value) != len(ROBOT_JOINT_NAMES):
        raise ValueError(f"{label} must be a list with {len(ROBOT_JOINT_NAMES)} values")
    return [float(item) for item in value]


def _optional_gripper(payload: dict[str, object], key: str) -> float | None:
    value = payload.get(key)
    if value is None:
        return None
    width = float(value)
    if not math.isfinite(width) or width < 0.0 or width > 0.1:
        raise ValueError(f"{key} must be in the AGX gripper range 0.0..0.1 m")
    return width


def _iter_stream_frames() -> Iterator[
    tuple[
        int,
        list[float] | None,
        list[float] | None,
        dict[str, float],
        float,
        tuple[float, float] | None,
        float | None,
        int | None,
    ]
]:
    for line in sys.stdin:
        stripped = line.strip()
        if not stripped:
            continue
        payload = json.loads(stripped)
        frame_index = int(payload.get("frame_index", -1))
        right_value = payload.get("right")
        left_value = payload.get("left")
        if right_value is None and left_value is None:
            right = None
            left = None
        elif right_value is None or left_value is None:
            raise ValueError("right and left arm positions must either both be present or both be omitted")
        else:
            right = _validate_positions(right_value, "right")
            left = _validate_positions(left_value, "left")

        grippers: dict[str, float] = {}
        right_gripper = _optional_gripper(payload, "right_gripper")
        left_gripper = _optional_gripper(payload, "left_gripper")
        legacy_gripper = _optional_gripper(payload, "gripper")
        if right_gripper is not None:
            grippers["right"] = right_gripper
        elif legacy_gripper is not None:
            grippers["right"] = legacy_gripper
        if left_gripper is not None:
            grippers["left"] = left_gripper
        effort = float(payload.get("gripper_effort", 1.0))
        base_value = payload.get("base_wheel_rpm")
        if base_value is None:
            base_wheel_rpm = None
        elif not isinstance(base_value, list) or len(base_value) != 2:
            raise ValueError("base_wheel_rpm must be [left_rpm, right_rpm]")
        else:
            base_wheel_rpm = (float(base_value[0]), float(base_value[1]))
        lift_value = payload.get("lift")
        lift = None if lift_value is None else float(lift_value)
        lift_frame_value = payload.get("lift_frame_index", frame_index)
        lift_frame_index = None if lift is None else int(lift_frame_value)
        yield frame_index, right, left, grippers, effort, base_wheel_rpm, lift, lift_frame_index


def _format_positions(values: list[float]) -> str:
    return ", ".join(f"{name}={value:.4f}" for name, value in zip(ROBOT_JOINT_NAMES, values))


def _gripper_msg(joint_state_cls, stamp, gripper: float, effort: float):
    msg = joint_state_cls()
    msg.header.stamp = stamp
    msg.name = ["gripper"]
    msg.position = [gripper]
    msg.velocity = []
    msg.effort = [effort]
    return msg


def _publish_arm_pair(node, joint_state_cls, right_pub, left_pub, right: list[float], left: list[float]) -> None:
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


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    if args.dry_run:
        print("[READY] Dry-running streamed ARDY T3 frames", flush=True)
        try:
            for frame_index, right, left, grippers, effort, base_wheel_rpm, lift, lift_frame_index in _iter_stream_frames():
                print(f"[DRY-RUN] frame={frame_index}", flush=True)
                if right is not None and left is not None:
                    print(f"[DRY-RUN]   right: {_format_positions(right)}", flush=True)
                    print(f"[DRY-RUN]   left:  {_format_positions(left)}", flush=True)
                for side in ("right", "left"):
                    if side in grippers:
                        print(
                            f"[DRY-RUN]   {side} gripper msg: "
                            f"name={['gripper']} position={[grippers[side]]} effort={[effort]}",
                            flush=True,
                        )
                if base_wheel_rpm is not None:
                    print(f"[DRY-RUN]   base wheel RPM: {list(base_wheel_rpm)}", flush=True)
                if lift is not None:
                    print(f"[DRY-RUN]   lift frame/height: [{lift_frame_index}, {lift:.1f} cm]", flush=True)
        except KeyboardInterrupt:
            print("\n[INFO] Stopped by user.", flush=True)
            return 130
        except Exception as exc:
            print(f"[ERROR] {exc}", file=sys.stderr, flush=True)
            return 1
        return 0

    try:
        import rclpy
        from rclpy.node import Node
        from sensor_msgs.msg import JointState
        from std_msgs.msg import Float64MultiArray
    except ImportError as exc:
        print(
            "[ERROR] ROS 2 Python packages are not available. Source ROS 2 and the robot workspace.",
            file=sys.stderr,
        )
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1

    rclpy.init()
    node = Node("ardy_t3_robot_stream_publisher")
    right_pub = node.create_publisher(JointState, args.right_topic, 10)
    left_pub = node.create_publisher(JointState, args.left_topic, 10)
    right_gripper_pub = node.create_publisher(JointState, args.right_gripper_topic, 10)
    left_gripper_pub = node.create_publisher(JointState, args.left_gripper_topic, 10)
    base_pub = node.create_publisher(Float64MultiArray, args.base_topic, 10)
    lift_pub = node.create_publisher(Float64MultiArray, args.lift_topic, 10)

    try:
        wait_for_subscribers(
            node,
            right_pub,
            left_pub,
            base_pub,
            lift_pub,
            args.wait_for_subscribers,
            args.require_arm_subscribers,
            args.require_base_subscriber,
            args.require_lift_subscriber,
        )
        print(
            f"[READY] Streaming ARDY T3 frames to {args.right_topic}, {args.left_topic}, "
            f"gripper commands to {args.right_gripper_topic} and {args.left_gripper_topic}, base RPM to {args.base_topic}, "
            f"and lift to {args.lift_topic}; arm_smooth_rate={float(args.arm_smooth_rate):.1f} Hz",
            flush=True,
        )

        last_right = None
        last_left = None
        last_arm_time = None
        for _frame_index, right, left, grippers, effort, base_wheel_rpm, lift, lift_frame_index in _iter_stream_frames():
            now = node.get_clock().now().to_msg()

            if base_wheel_rpm is not None:
                base_msg = Float64MultiArray()
                base_msg.data = [base_wheel_rpm[0], base_wheel_rpm[1]]
                base_pub.publish(base_msg)
            if lift is not None:
                lift_msg = Float64MultiArray()
                lift_msg.data = [float(lift_frame_index if lift_frame_index is not None else _frame_index), float(lift)]
                lift_pub.publish(lift_msg)
            if right is not None and left is not None:
                smooth_rate = float(args.arm_smooth_rate)
                current_time = time.monotonic()
                if (
                    smooth_rate > 0.0
                    and last_right is not None
                    and last_left is not None
                    and last_arm_time is not None
                ):
                    elapsed = max(0.0, current_time - last_arm_time)
                    steps = max(1, int(round(elapsed * smooth_rate)))
                    for step in range(1, steps + 1):
                        alpha = step / float(steps)
                        alpha = alpha * alpha * (3.0 - 2.0 * alpha)
                        interp_right = [
                            float(prev + (cur - prev) * alpha)
                            for prev, cur in zip(last_right, right)
                        ]
                        interp_left = [
                            float(prev + (cur - prev) * alpha)
                            for prev, cur in zip(last_left, left)
                        ]
                        _publish_arm_pair(node, JointState, right_pub, left_pub, interp_right, interp_left)
                        if step < steps:
                            time.sleep(1.0 / smooth_rate)
                else:
                    _publish_arm_pair(node, JointState, right_pub, left_pub, right, left)
                last_right = right
                last_left = left
                last_arm_time = time.monotonic()
            if "right" in grippers:
                right_gripper_pub.publish(_gripper_msg(JointState, now, grippers["right"], effort))
            if "left" in grippers:
                left_gripper_pub.publish(_gripper_msg(JointState, now, grippers["left"], effort))
            rclpy.spin_once(node, timeout_sec=0.0)
    except KeyboardInterrupt:
        print("\n[INFO] Stopped by user.", flush=True)
        return 130
    except Exception as exc:
        print(f"[ERROR] {exc}", file=sys.stderr, flush=True)
        return 1
    finally:
        node.destroy_node()
        rclpy.shutdown()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
