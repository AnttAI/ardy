#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export ARDY_REPO_ROOT="${ARDY_REPO_ROOT:-${SCRIPT_DIR}}"
export NEWTON_REPO_ROOT="${NEWTON_REPO_ROOT:-${SCRIPT_DIR}/deps/newton}"
export WARP_CACHE_PATH="${WARP_CACHE_PATH:-${SCRIPT_DIR}/deps/newton_cache/warp}"
export PYTHONPATH="${NEWTON_REPO_ROOT}:${SCRIPT_DIR}${PYTHONPATH:+:${PYTHONPATH}}"
export PYTHONUNBUFFERED=1

BACKGROUND_USD="${BACKGROUND_USD:-${SCRIPT_DIR}/deps/world_lobby_newton_bg.usda}"
WEBSOCKET_HOST="${WEBSOCKET_HOST:-0.0.0.0}"
WEBSOCKET_PORT="${WEBSOCKET_PORT:-8765}"
CAMERA_PRESET="${CAMERA_PRESET:-saved_front}"
PLAYBACK_MODE="${PLAYBACK_MODE:-exact}"
RTX_ENVIRONMENT="${RTX_ENVIRONMENT:-studio}"

conda run --no-capture-output -n soma-retargeter python "${SCRIPT_DIR}/viewer_process.py" \
  --viewer rtx \
  --websocket-server \
  --websocket-host "${WEBSOCKET_HOST}" \
  --websocket-port "${WEBSOCKET_PORT}" \
  --background-usd "${BACKGROUND_USD}" \
  --camera-preset "${CAMERA_PRESET}" \
  --playback-mode "${PLAYBACK_MODE}" \
  --rtx-environment "${RTX_ENVIRONMENT}" \
  "$@"
