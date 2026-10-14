# Bottle reference calibration

This is acquisition and offline fitting infrastructure. It does not publish robot
commands, replay picks, or enable automatic picking. Existing viewer files and
motion routes have not been modified.

## Current hardware check

Update 2026-09-24: the D455 now enumerates at USB 3.2 / 5000 Mbps and
successfully recorded 75 aligned RGB-D frames in five seconds. Both arm feedback
streams were recorded again. A live YOLO preview detected three bottles over
40 processed frames. `preview_realsense.py` provides a desktop preview with
camera-left-to-right labels and central-patch surface-depth checks; these labels
are not simulation IDs and the measurements are not bottle grasp centres.

The visible Jetson terminal was awaiting approval for a generated bottle 3
trajectory (1,238 frames). No input or robot commands were sent. Camera mounting
and bottle identity correspondence remain unconfirmed, and no physical
calibration references have been accepted. The laptop viewer is currently GL.

Subsequent user confirmation: camera is fixed outside the robot; camera-left is
simulation bottle 1 and camera-right is simulation bottle 3. These confirmations
are saved in `calibration_setup.json`. Both live arm drivers report speed 20%,
`agx_gripper`, and zero TCP offsets. Consequently TCP feedback is not automatically
the grasp centre. Direct subscriptions still received no lift height or lift
status. The queued bottle 3 motion explicitly assumes table height 0.78 m and
planned lift 0.10 m; physical confirmation of these values remains pending.

The following describes the earlier 2026-09-23 failure:

- D455 serial `243122301874` was enumerated at USB 2.1 / 480 Mbps.
- Combined 640x480 colour/depth at 5 and 15 FPS started but produced no frames.
  Separate colour-only and depth-only 15 FPS tests also timed out.
- ROS domain 10 delivered approximately 198 Hz joint/TCP feedback from both arms
  during a 30-second capture. Messages have empty frame IDs: TCP poses must not
  be assumed to be in the shared robot base frame or at the grasp centre.
- Lift-connected feedback was true, but no lift-height sample arrived.
  Base-connected feedback was false. This is not a validated base/lift control path.
- Evidence is under `calibration_sessions/setup_check/`. Camera metadata files
  alone do not indicate a successful capture; no RGB-D reference was collected.

The immediate next step is to restore camera streaming (try a direct USB 3 data
connection), confirm the camera mounting, and identify the exact verified motion
launcher. Then record bottle 1 and 3 references during those known picks. At least
one additional non-collinear fitting reference and an independent validation
reference are needed. No calibration transform has been produced yet.

## Acquisition

Run from the ARDY repository. Choose new output paths for every attempt; recordings
refuse to overwrite existing files. The camera reader uses a workspace-local
`pyrealsense2` install in `.realsense_deps`, leaving the ARDY environment unchanged.

Camera recording:

```bash
/home/jony/miniconda3/envs/ardy/bin/python -m real_to_sim.record_realsense \
  --serial 243122301874 --output real_to_sim/calibration_sessions/reference_01/camera \
  --fps 15 --seconds 30
```

Start feedback recording before starting camera recording in another terminal:

```bash
source /opt/ros/humble/setup.bash
ROS_DOMAIN_ID=10 ROS_LOCALHOST_ONLY=0 ROS_LOG_DIR=/tmp/ardy_ros_logs \
  /usr/bin/python3 -m real_to_sim.record_feedback \
  --output real_to_sim/calibration_sessions/reference_01/feedback.jsonl --seconds 45
```

Depth PNGs preserve unsigned 16-bit raw values. Multiply by `depth_scale_m` to
obtain metres. They are aligned to the color optical frame. Metadata preserves
camera intrinsics, factory depth-to-color extrinsics, serial, and stream timing.
Host monotonic receive timestamps permit approximate pairing on this laptop;
they do not synchronize camera exposure with the robot's source clock. For
calibration, use settled stationary observations, reject stale/moving data, and
review timing before extracting any correspondence.

## Reference extraction requirements

- Use a shared, verified robot coordinate frame across both arms. Raw left and
  right TCP coordinates may have different origins. Use measured joint feedback
  with verified kinematics, arm mounting, lift position, and grasp-centre offset.
- Establish the same physical point in both observations. A bottle surface depth
  pixel is not its axis/grasp centre. Estimate its geometry and grasp height;
  reject missing, background-contaminated, or uncertain depth.
- Pair a visible bottle observation before occlusion with the stationary grasp
  before lift only after verifying that the bottle did not move during approach.
- Do not substitute simulation bottle positions or commanded joints for physical
  reference measurements. Do not use a moving wrist/head camera as if it were fixed.

## Offline fit

`fit_robot_calibration.py` accepts a JSON object with `units: "m"`, `camera_serial`,
`camera_frame`, `robot_frame`, `mount_description`, `physical_point_definition`,
and `fitting` / `validation` arrays. Each reference contains a unique `id`,
`camera_point_m` and `robot_point_m` (three numbers each), plus `camera_evidence`
and `robot_feedback_evidence` identifying the captured frames/messages.

```bash
python -m real_to_sim.fit_robot_calibration reviewed_references.json \
  --output candidate_calibration.json --max-error-mm YOUR_MEASURED_TOLERANCE
python -m unittest real_to_sim.test_robot_calibration
```

Select the tolerance from actual bottle/gripper clearance. The solver requires
at least three sufficiently separated, non-collinear fit references and a held-out
validation reference. It fits a proper rotation and translation, reports errors
in millimetres, and exits unsuccessfully if the error exceeds tolerance. Output
always has `hardware_execution_enabled: false`; a successful geometric fit is
not hardware validation. Validate a slow approach with clearance before grasping.
