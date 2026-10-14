# Webcam → predefined Newton objects

Initial standalone demo: YOLO detection + ByteTrack IDs → calibrated table XY →
preloaded Newton bodies. No markers attached to objects and no generated meshes.
The default registry contains two bottle instances. The integrated launcher feeds
ARDY's existing native viewer, T3 robot, table, and predefined bottle bodies.

## Open tracking inside ARDY's simulation

Run from the ARDY environment:

```bash
python -m real_to_sim.launch --preview-area
```

This opens both the USB camera preview and the native Newton GL viewer. The
`--preview-area` option deliberately maps the whole image to the simulated table;
it is labelled UNCALIBRATED and demonstrates movement, not accurate real-world
placement or marked-area filtering. Two tracked IDs drive two existing bottles;
the unused third bottle is hidden. Missing/stale tracks are hidden too.

For metric tabletop mapping, omit `--preview-area` and calibrate:

```bash
python -m real_to_sim.launch --calibrate --width 0.60 --depth 0.40
```

Replace dimensions with measured values. In the ARDY bridge, the clicked origin
maps to Newton `(-0.9, -1.2, 0.9)` at the table's lower XY corner; +X and +Y follow
the clicked calibration axes. This is explicit placement of the marked rectangle
on the virtual table, not a measured camera-to-robot extrinsic calibration.
The native bridge uses its existing table height (0.9 m).

The launcher uses the current Python environment for both the viewer and
AI inference. Override the viewer with `--viewer-python PATH` if
needed. `--viewer rtx` selects the RTX backend when installed. Closing either
process stops both. Stop any existing detection-only preview first to release
the camera. Existing robot/SOMA animation logic is unchanged; camera poses use
a separate local atomic snapshot file. Camera-controlled bottles are kinematic,
so gravity and simulated grasps cannot take ownership from the physical objects.
The native bridge currently supports the bottle class, up to three instances;
the standalone viewer supports the mesh registry below.

## Run

Use a desktop Python environment where Newton, Warp, and the Newton GL viewer
already work. Install the additional dependencies there:

```bash
python -m pip install -r real_to_sim/requirements.txt
python -m real_to_sim.run --calibrate --width 0.60 --depth 0.40
```

Replace 0.60 and 0.40 with the **measured** dimensions of your marked rectangle in
meters. Keep the camera fixed with both bottles' bottoms visible. Click the four
corners in this order: origin, corner along +X, opposite corner, corner along +Y.
Press Enter to save, R to reset, or Q to cancel. Table height defaults to 0.9 m;
set `--table-z` during calibration to change it. These define a new local Newton
coordinate frame, not registration to the existing robot's coordinates.

Subsequent runs reuse calibration:

```bash
python -m real_to_sim.run
```

The default camera is the external **Lenovo FHD USB webcam**, selected by its
stable `/dev/v4l/by-id/` path (currently `/dev/video2`), rather than laptop camera
0. It will report an error if that camera is disconnected, without falling back
to the laptop camera. The default `--rotation 180` corrects its current inverted
mount. Use `--rotation 0` if you physically turn it upright. Camera and rotation
are stored with calibration; an old laptop calibration must be replaced.

To immediately check both bottles without calibration or Newton:

```bash
python -m real_to_sim.run --detect-only
```

The preview displays a bottle count and individual tracked boxes.
`--confidence` controls the detection threshold (default 0.25).
`--device cpu` selects CPU inference; `--device 0` selects CUDA GPU 0.
The first use of `yolo11n.pt` downloads pretrained weights. `--weights PATH`
selects local/custom weights. The camera argument also accepts a device path or
stream URL. Q closes the preview and viewer. Calibration must be repeated if the
camera moves, its resolution changes, or the marked area changes.

## Register predefined assets

`registry.json` maps detector class names to predefined assets and instance
capacities. Models are allocated once at startup. Extra detections beyond a
class's capacity are not mirrored. Unknown classes are ignored; use trained
weights with matching class names for objects the pretrained model cannot detect.
Category detection does not distinguish brands or bottle variants.

To use an existing triangle mesh, add an entry such as:

```json
"cup": {
  "kind": "mesh",
  "path": "assets/cup.obj",
  "scale": [1, 1, 1],
  "origin_height": 0.06,
  "capacity": 2,
  "color": [0.8, 0.5, 0.2]
}
```

Paths are relative to the registry. Meshes must be upright with Z up; scale them
to meters. `origin_height` is the model origin's height above its bottom after
scaling. Mesh geometry and a uniform color are loaded, not material textures.

## Current limits and verification

- This is an **upright tabletop XY mirror**, not full 6D pose estimation. Known
  models do not by themselves reveal camera-space depth or rotation. Lifting or
  tipping objects produces incorrect positions; orientation remains identity.
- The bottom-center of the detection box approximates the table contact point.
  Perspective, lens distortion, occlusion, and detection jitter limit accuracy.
  Homography calibration does not correct lens distortion.
- IDs are maintained by ByteTrack; overlap or occlusion can cause identity swaps.
  Both reference bottles use the same predefined geometry. Tracks are held for
  0.75 seconds when missing/outside the area, then parked below the scene. The
  next detection can reuse that model slot. Camera read failure closes the demo.
- Rendering and detection run sequentially. Achievable update rate and capture
  buffering depend on the webcam/backend and inference hardware; no latency
  guarantee has been measured.
- USB camera capture and bottle detection were verified on the connected Lenovo
  webcam. Newton rendering and calibrated position accuracy require a separately
  calibrated marked area.

Run the coordinate/identity lifecycle tests with:

```bash
python -m unittest real_to_sim.test_core real_to_sim.test_camera
```

Tracking API: https://docs.ultralytics.com/modes/track/
