"""Record robot feedback only; run with the ROS system Python, never publishes."""
import argparse
import json
import math
import time
from pathlib import Path

import rclpy
from rclpy.qos import qos_profile_sensor_data
from rosidl_runtime_py.convert import message_to_ordereddict
from sensor_msgs.msg import JointState
from geometry_msgs.msg import PoseStamped
from std_msgs.msg import Float64, Bool, Float64MultiArray, String


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--seconds', type=float, default=15)
    args = parser.parse_args()
    if not math.isfinite(args.seconds) or args.seconds <= 0:
        parser.error('--seconds must be positive')
    args.output.parent.mkdir(parents=True, exist_ok=True)
    rclpy.init()
    node = rclpy.create_node('bottle_calibration_feedback_recorder')
    counts = {}
    try:
        with args.output.open('x') as output:
            def receive(topic, msg):
                counts[topic] = counts.get(topic, 0) + 1
                output.write(json.dumps(dict(topic=topic,
                    receive_monotonic_ns=time.monotonic_ns(),
                    receive_unix_ns=time.time_ns(),
                    message=message_to_ordereddict(msg))) + '\n')
                output.flush()
            topics = {
                '/feedback/lift_height': Float64,
                '/feedback/lift_connected': Bool,
                '/feedback/lift_status': String,
                '/base/wheel_rpm': Float64MultiArray,
                '/base/connected': Bool,
            }
            for side in ('left', 'right'):
                topics[f'/{side}_arm/feedback/joint_states'] = JointState
                topics[f'/{side}_arm/feedback/tcp_pose'] = PoseStamped
            for topic, msg_type in topics.items():
                node.create_subscription(msg_type, topic,
                    lambda msg, topic=topic: receive(topic, msg), qos_profile_sensor_data)
            deadline = time.monotonic() + args.seconds
            while rclpy.ok() and time.monotonic() < deadline:
                rclpy.spin_once(node, timeout_sec=0.1)
    finally:
        node.destroy_node()
        rclpy.shutdown()
    print(json.dumps({'feedback_counts': counts}), flush=True)
    if not any(topic.endswith('/joint_states') for topic in counts):
        raise SystemExit('No arm feedback received; session is not usable for calibration')


if __name__ == '__main__':
    main()
