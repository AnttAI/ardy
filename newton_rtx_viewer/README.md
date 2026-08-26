# Newton RTX Viewer

This folder runs the Newton RTX websocket viewer for ARDY/T3 live frames.

## Install Requirements

Use the `ardy` conda environment:

```bash
conda activate ardy
```

Install Newton with RTX support into that environment:

```bash
python -m pip install --upgrade pip
python -m pip install "newton[rtx]" --extra-index-url https://pypi.nvidia.com
```

Check that Newton and the RTX viewer import correctly:

```bash
python -c "import newton; import newton.viewer; print(newton.__version__)"
```

If you want to install Newton from source instead of PyPI:

```bash
git clone https://github.com/newton-physics/newton.git
cd newton
python -m pip install -e ".[rtx]" --extra-index-url https://pypi.nvidia.com
```

The `deps/` folder is local-only and does not need to be pushed. After installing Newton into the conda environment, the viewer only needs this project folder on `PYTHONPATH`.

## Run RTX Websocket Viewer

Use this command when you want the RTX websocket viewer without the lobby background USD:

```bash
ARDY_REPO_ROOT=/home/jony/Downloads/ardy/newton_rtx_viewer \
PYTHONUNBUFFERED=1 \
PYTHONPATH=/home/jony/Downloads/ardy/newton_rtx_viewer \
WARP_CACHE_PATH=/home/jony/Downloads/ardy/newton_rtx_viewer/.cache/warp \
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
PYTHONPATH=/home/jony/Downloads/ardy/newton_rtx_viewer \
WARP_CACHE_PATH=/home/jony/Downloads/ardy/newton_rtx_viewer/.cache/warp \
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
run_rtx_viewer.sh
```

Optional local-only paths:

```text
deps/world_lobby_newton_bg.usda
deps/Collected_World_Lobby/
```
