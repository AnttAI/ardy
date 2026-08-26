# Newton RTX Viewer

This folder runs the Newton RTX websocket viewer for ARDY/T3 live frames.

## Install Requirements

Use the `ardy` conda environment:

```bash
conda activate ardy
```

Newton is bundled locally in:

```text
deps/newton/
```

The run commands below add this local Newton copy to `PYTHONPATH`. RTX viewer dependencies must also be installed in the same environment. If RTX import fails, install/sync Newton with RTX support in your environment before running the viewer.

## Run RTX Websocket Viewer

Use this command when you want the RTX websocket viewer without the lobby background USD:

```bash
ARDY_REPO_ROOT=/home/jony/Downloads/ardy/newton_rtx_viewer \
PYTHONUNBUFFERED=1 \
PYTHONPATH=/home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton:/home/jony/Downloads/ardy/newton_rtx_viewer \
WARP_CACHE_PATH=/home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton_cache/warp \
conda run --no-capture-output -n soma-retargeter python /home/jony/Downloads/ardy/newton_rtx_viewer/viewer_process.py \
  --viewer rtx \
  --websocket-server \
  --websocket-host 0.0.0.0 \
  --websocket-port 8765 \
  --camera-preset saved_front \
  --playback-mode exact \
  --rtx-environment studio
```

## Run With Background USD

Use this command when you want the lobby background loaded:

```bash
ARDY_REPO_ROOT=/home/jony/Downloads/ardy/newton_rtx_viewer \
PYTHONUNBUFFERED=1 \
PYTHONPATH=/home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton:/home/jony/Downloads/ardy/newton_rtx_viewer \
WARP_CACHE_PATH=/home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton_cache/warp \
conda run --no-capture-output -n soma-retargeter python /home/jony/Downloads/ardy/newton_rtx_viewer/viewer_process.py \
  --viewer rtx \
  --websocket-server \
  --websocket-host 0.0.0.0 \
  --websocket-port 8765 \
  --background-usd /home/jony/Downloads/ardy/newton_rtx_viewer/deps/world_lobby_newton_bg.usda \
  --camera-preset saved_front \
  --playback-mode exact \
  --rtx-environment studio \
  --pick-object none
```

## Bundled Paths

```text
viewer_process.py
assets/
deps/newton/
deps/newton_cache/warp/
deps/world_lobby_newton_bg.usda
deps/Collected_World_Lobby/
```
