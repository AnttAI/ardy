# ARDY to T3 Retargeting Flow

This document explains the live T3 retargeting path used by the ARDY Viser demo.
The current accurate path is:

```text
ARDY Core27 motion
  -> SOMA BVH export
  -> embedded SOMA/Newton retargeter
  -> T3 upper-body CSV rows
  -> Viser T3 robot update
```

The important split is:

```text
T3 base, wheels, and lift: computed live from ARDY/Core motion
T3 upper body and hands: computed by SOMA/Newton retargeting
```

## Runtime Entry Point

Run the demo normally:

```bash
python scripts/run_demo.py --no-compile
```

## Dependencies

The embedded SOMA/Newton retargeter runs inside the active ARDY Python environment.
It does not call an external `soma-retargeter` checkout, but the ARDY environment
must have the SOMA/Newton runtime libraries installed.

Tested working versions in the `ardy` conda environment:

```text
warp-lang==1.12.0
newton==1.0.0
usd-core==26.3
numpy==1.26.4
scipy==1.17.1
torch==2.8.0+cu129
tqdm==4.69.0
viser==1.0.16
trimesh==4.12.2
pandas==3.0.3
pillow==12.2.0
```

Key retarget-specific imports:

```bash
python -c "import warp; print('warp ok')"
python -c "import newton; print('newton ok')"
python -c "from pxr import Usd; print('usd ok')"
```

If installing into a fresh ARDY environment, install ARDY's normal demo dependencies first,
then install the SOMA/Newton pieces:

```bash
pip install warp-lang==1.12.0 newton==1.0.0 usd-core==26.3
```

The three required SOMA/Newton packages are:

```text
warp-lang==1.12.0
newton==1.0.0
usd-core==26.3
```

The exact CUDA build must match the machine. On this workstation the tested stack is
CUDA Toolkit `12.9`, NVIDIA Driver `12.9`, and `torch==2.8.0+cu129`.

In the Viser **Visualize** tab:

- `Show Live T3` creates and shows the T3 robot.
- `Use Soma T3 Retarget` enables the accurate SOMA/Newton upper-body path.
- `Soma Packet Frames` controls how many generated frames are sent per SOMA retarget packet.
- `Reset Soma T3` clears the current streamed T3 rows and starts retargeting again.

Good packet values:

- `40`: best default for smooth Viser playback; usually fastest overall.
- `20`: lower startup chunk, still usually realtime.
- `10`: lowest packet size, but can be slower overall if per-call overhead dominates.

## File Map

Main live demo flow:

- `scripts/interactive_demo/generation.py`
  - Generates ARDY motion.
  - Calls `request_soma_t3_retarget(...)` after new frames are available.

- `scripts/interactive_demo/session_io.py`
  - Owns the background SOMA retarget worker.
  - Converts generated ARDY motion tensors back to local rotations/root positions.
  - Exports packet BVHs.
  - Sends BVH paths to the warm SOMA worker.
  - Reads T3 CSV rows and appends them into `session.t3_stream_rows`.

- `scripts/interactive_demo/playback.py`
  - Advances the Viser timeline.
  - Updates the ARDY mesh, optional SOMA debug mesh, and live T3 robot.
  - For T3, reads the already-retargeted row for the current frame from `session.t3_stream_rows`.

- `scripts/interactive_demo/gui/visualize.py`
  - Adds the Visualize controls, including `Soma Packet Frames`.

Core27 to SOMA BVH:

- `ardy/exports/bvh.py`
  - Maps ARDY/Core27 joints into SOMA77 BVH names.
  - `core27_to_soma77_bvh_local_rotations(...)`
  - `export_soma_bvh_from_arrays(...)`

Embedded SOMA retargeting:

- `ardy/retarget_to_t3/soma_t3_worker.py`
  - Long-lived stdin/stdout worker process.
  - Keeps a reusable `SomaBvhT3UpperBodyRetargeter` alive until the Viser demo exits.

- `ardy/retarget_to_t3/embedded_soma_t3.py`
  - Imports the vendored SOMA runtime from `vendor/soma_retargeter_runtime`.
  - `SomaBvhT3UpperBodyRetargeter` keeps the expensive SOMA/Newton retargeter initialized.
  - Retargets a SOMA BVH packet into T3 upper-body CSV rows.

T3 visualization and robot logic:

- `ardy/retarget_to_t3/live_retargeter.py`
  - Creates the T3 URDF in Viser.
  - `update_with_soma_upper_body_csv(...)` combines ARDY base/lift/wheels with SOMA upper-body CSV joints.

- `ardy/retarget_to_t3/base.py`
  - Online differential-drive base tracker.
  - Converts ARDY root X/Z motion and facing yaw into T3 base pose and wheel angles.

- `ardy/retarget_to_t3/lift.py`
  - Computes the telescopic lift extension from ARDY body height.

- `ardy/retarget_to_t3/constants.py`
  - T3 URDF path, lift limits, wheel radius/separation, and base motion limits.

- `ardy/retarget_to_t3/assets/t3_robot/`
  - Local T3 URDF and meshes used by Viser rendering.
  - Keeps T3 visualization independent from external Kimodo or SOMA checkout folders.

Vendored SOMA code:

- `ardy/retarget_to_t3/vendor/soma_retargeter_runtime/`
  - Local copy of the useful SOMA/Newton runtime code and configs.
  - ARDY does not need to call `/home/jony/Downloads/soma-retargeter` at runtime.

## Step-by-Step Flow

### 1. ARDY Generates Motion

`scripts/interactive_demo/generation.py` creates/extends:

```text
session.motion_tensor
session.joints_pos
session.joints_rot
session.root_velocities
session.max_frame_idx
```

When SOMA T3 retargeting is enabled, generation calls:

```text
request_soma_t3_retarget(client_id, start_frame=0)
```

### 2. Session Worker Extracts Core Motion

`scripts/interactive_demo/session_io.py` clones the generated motion tensor and runs:

```text
motion_rep.unnormalize(...)
motion_rep.inverse(...)
```

This produces:

```text
local_rot_mats   # Core27 local joint rotations
root_positions   # Core root translations
```

The same function also computes the optional SOMA debug mesh so we can see the intermediate body in Viser.

### 3. Core27 Is Exported as SOMA BVH

`ardy/exports/bvh.py` maps ARDY/Core27 joints into SOMA77:

```text
Core27 Hips        -> SOMA Hips
Core27 Spine       -> SOMA Spine1
Core27 Spine2      -> SOMA Spine2
Core27 Spine3      -> SOMA Chest
Core27 LeftArm     -> SOMA LeftArm
Core27 LeftForeArm -> SOMA LeftForeArm
Core27 LeftHand    -> SOMA LeftHand
...
```

The exported BVH uses the vendored reference BVH:

```text
ardy/retarget_to_t3/vendor/soma_retargeter_runtime/assets/motions/bvh/Neutral_walk_forward_002__A057.bvh
```

This is the same style of input expected by the SOMA/Newton retargeter.

### 4. BVH Packets Are Sent to the Warm SOMA Worker

`session_io.py` splits the generated timeline into packets:

```text
packet_start -> packet_end
```

It also includes context frames before each packet:

```text
context_start = max(0, packet_start - context_frames)
```

That helps SOMA/Newton solve smoothly at packet boundaries. After retargeting, ARDY discards the context rows and keeps only the useful packet rows.

The packet size comes from the Visualize UI:

```text
Soma Packet Frames
```

Internally it is stored as:

```text
session.t3_stream_packet_size
```

### 5. SOMA/Newton Retargets Upper Body to T3 CSV

`soma_t3_worker.py` starts once and stays alive while the demo is open.

On the first request it creates:

```text
SomaBvhT3UpperBodyRetargeter
```

That class lives in `embedded_soma_t3.py` and keeps the static SOMA/Newton setup alive:

```text
SOMA skeleton
SpaceConverter
NewtonPipeline
human_robot_scaler
target asset/configs
initialization pose
```

For each packet:

```text
load packet BVH
reattach cached SOMA skeleton
pipeline.clear()
pipeline.add_input_motions(...)
pipeline.execute()
write T3 CSV rows
```

The CSV columns include upper-body robot joints such as:

```text
head_pitch_joint_dof
head_yaw_joint_dof
right_joint1_dof ... right_joint7_dof
left_joint1_dof  ... left_joint7_dof
right_gripper_joint1_dof
left_gripper_joint1_dof
```

### 6. ARDY Stores Rows in a Live Buffer

After each packet finishes, `session_io.py` reads the generated CSV and appends rows into:

```text
session.t3_stream_rows
```

The row index matches the ARDY frame index:

```text
session.t3_stream_rows[frame_idx]
```

This is what lets Viser update the T3 robot frame-by-frame during playback.

### 7. Viser Plays ARDY Mesh and T3 Together

`scripts/interactive_demo/playback.py` updates every frame.

For the ARDY mesh:

```text
character.set_pose(session.joints_pos[..., frame_idx], session.joints_rot[..., frame_idx])
```

For the optional SOMA debug mesh:

```text
SomaLivePoseMapper.map_frame(...)
soma_debug_character.set_pose(...)
```

For the T3 robot:

```text
t3_row = session.t3_stream_rows[frame_idx]
t3_live_retargeter.update_with_soma_upper_body_csv(...)
```

If the T3 row for a frame is not ready yet, playback waits for the accurate SOMA row instead of showing a wrong preview.

## Base, Wheels, and Lift Logic

The SOMA CSV is used only for upper-body/head/arms/grippers. The robot base and lift come from ARDY live motion.

### Base and Wheels

`live_retargeter.py` calls:

```text
_update_base_and_lift(...)
```

That calls `T3BaseTracker.update(...)` in `base.py`.

Inputs:

```text
ARDY root X/Z position
ARDY body facing yaw
model FPS
optional ARDY root velocity
```

Outputs:

```text
T3 base world X/Z position
T3 base yaw
left_wheel_joint angle
right_wheel_joint angle
```

The base tracker behaves like an online differential-drive controller:

```text
human root path -> target base path
human facing -> base yaw target
forward velocity + yaw rate -> wheel angular velocity
integrated wheel velocity -> wheel joint angles
```

### Lift

`live_retargeter.py` calls:

```text
compute_t3_lift_extension(joints_pos, skeleton)
```

This lives in `lift.py`.

It estimates the human waist/shoulder height and maps it to the T3 telescopic lift:

```text
human waist/shoulder height
  -> target T3 waist height
  -> telescopic_lift_joint
```

The result is clamped by:

```text
T3_LIFT_MIN_M
T3_LIFT_MAX_M
```

Those constants live in `constants.py`.

### Waist

When using the accurate SOMA upper-body CSV, `live_retargeter.py` calls:

```text
_stiffen_waist()
```

That sets:

```text
waist_yaw_joint = 0
waist_roll_joint = 0
waist_pitch_joint = 0
```

This keeps the T3 torso stiff while the lift and upper body do the visible work.

## Why Packet Size Matters

The demo logs show both motion duration and retarget time:

```text
[T3 Live] Soma stream ready: frames 160-199 (2.00s motion) in 0.83s
```

That means:

```text
40 useful frames / 0.83 sec = about 48 FPS retarget throughput
```

Since ARDY playback is usually `20 FPS`, this packet is faster than realtime.

Smaller packets can reduce the first playable chunk size, but they also pay the SOMA/Newton packet overhead more often. If a 10-frame packet takes `0.53s`, it only produces `0.50s` of motion, so it can fall behind playback. A 40-frame packet producing `2.00s` of motion in `0.83s` can stay ahead.

## Current Recommended Setting

For smooth Viser playback:

```text
Soma Packet Frames = 40
```

For experiments with slightly lower initial wait:

```text
Soma Packet Frames = 20
```

Use `10` only when testing packet behavior; it is often too close to realtime speed and can cause waiting.

## Accuracy and Latency Notes

The accurate path intentionally uses SOMA BVH plus SOMA/Newton because that is the path that matched the standalone SOMA retargeter best.

The remaining delay is mostly scheduling/buffering and the per-packet `pipeline.execute()` work. The worker process and static retargeter are already kept alive, but the official SOMA pipeline still rebuilds some per-execution IK solve state internally.

The next deeper optimization would be a true persistent exact IK execution path:

```text
keep IK model/objectives/solver alive
feed new packet targets directly
solve frames
append rows
```

That would reduce per-packet overhead further, but it needs careful validation because earlier direct live IK paths were faster but less accurate than the BVH pipeline.
