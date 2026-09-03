#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

if [ -z "$ROS_DOMAIN_ID" ]; then
  export ROS_DOMAIN_ID=10
fi
if [ -z "$ROS_LOCALHOST_ONLY" ]; then
  export ROS_LOCALHOST_ONLY=0
fi

if [ -f /opt/ros/humble/setup.bash ]; then
  source /opt/ros/humble/setup.bash
fi
if [ -f "$HOME/catkin_ws/install/setup.bash" ]; then
  source "$HOME/catkin_ws/install/setup.bash"
fi
if [ -f /home/jony/agx_arm_ws/install/setup.bash ]; then
  source /home/jony/agx_arm_ws/install/setup.bash
fi

python_bin="${ROS_PYTHON:-/usr/bin/python3}"

"$python_bin" t3_robot_stream_publisher.py "$@"
