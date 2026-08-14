#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export ROS_DOMAIN_ID="${ARDY_ROS_DOMAIN_ID:-${KIMODO_ROS_DOMAIN_ID:-10}}"
export ROS_LOCALHOST_ONLY="${ARDY_ROS_LOCALHOST_ONLY:-${KIMODO_ROS_LOCALHOST_ONLY:-0}}"

set +u
if [[ -f /opt/ros/humble/setup.bash ]]; then
  # shellcheck disable=SC1091
  source /opt/ros/humble/setup.bash
fi

if [[ -f "$HOME/catkin_ws/install/setup.bash" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/catkin_ws/install/setup.bash"
fi

if [[ -f /home/jony/agx_arm_ws/install/setup.bash ]]; then
  # shellcheck disable=SC1091
  source /home/jony/agx_arm_ws/install/setup.bash
fi
set -u

ROS_PYTHON_BIN="${ROS_PYTHON:-/usr/bin/python3}"
SUBSCRIBER_WAIT="${ARDY_T3_SUBSCRIBER_WAIT:-${KIMODO_ROBOT_SUBSCRIBER_WAIT:-5}}"
ARM_SMOOTH_RATE="${ARDY_T3_ARM_SMOOTH_RATE:-0}"
EXTRA_ARGS=()
if [[ "${ARDY_T3_DRY_RUN:-${KIMODO_ROBOT_DRY_RUN:-0}}" == "1" ]]; then
  EXTRA_ARGS+=(--dry-run)
fi
if [[ "${ARDY_T3_REQUIRE_ARMS:-1}" == "1" ]]; then
  EXTRA_ARGS+=(--require-arm-subscribers)
fi
if [[ "${ARDY_T3_REQUIRE_BASE:-${KIMODO_ROBOT_REQUIRE_BASE:-1}}" == "1" ]]; then
  EXTRA_ARGS+=(--require-base-subscriber)
fi
if [[ "${ARDY_T3_REQUIRE_LIFT:-0}" == "1" ]]; then
  EXTRA_ARGS+=(--require-lift-subscriber)
fi
"$ROS_PYTHON_BIN" "$REPO_ROOT/scripts/t3_robot_stream_publisher.py" \
  "${EXTRA_ARGS[@]}" \
  --wait-for-subscribers "$SUBSCRIBER_WAIT" \
  --arm-smooth-rate "$ARM_SMOOTH_RATE" \
  "$@"
