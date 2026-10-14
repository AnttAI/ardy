# Camera/robot integration retest — 2026-09-23

Overall result: **not ready for automatic picking**. Software tests and robot
feedback passed; camera acquisition failed. There is no physical camera-to-robot
calibration or end-to-end pick validation yet.

## Passed

- 15 tests across `test_robot_calibration`, `test_core`, `test_camera`, and
  `test_bridge` using the ARDY Python environment.
- Synthetic calibration recovers a known proper rotation/translation and predicts
  an independent point. Two-point/collinear/invalid input is rejected.
- CLI tests cover successful output, refusing overwrite, rejection of excessive
  held-out error, missing validation, reused reference IDs, and missing evidence.
- Live ten-second feedback recording: 1,990 right-arm joint messages (~200 Hz)
  and 1,986 left-arm messages (~199.84 Hz), with TCP messages also received.
  These verify feedback reception, not command execution or physical accuracy.

## Failed / blocked

- D455 `243122301874`, firmware `5.17.0.10`, still enumerates at USB 2.1 / 480 Mbps.
- Fresh depth-only capture timed out after eight seconds. The SDK configured the
  V4L2 stream, but no frames arrived. Diagnostic log: `/tmp/d455_retest.log`.
- Camera hardware reset and re-enumeration succeeded. Combined colour/depth
  capture still timed out afterward. No usable RGB-D reference was collected.
- USB 2 speed alone does not establish the cause. The next physical diagnostic is
  a direct USB 3 port with a known USB 3 data cable, followed by another stream test.

## Changes made during testing

The camera recorder now writes `status.json` distinguishing failed attempts from
recorded but unvalidated sessions and rejects recordings with no nonzero depth.
Both recorders reject non-finite capture durations. Added five CLI integration
tests for the calibration solver.

Evidence is saved under `calibration_sessions/retest/`. Synthetic test references
were temporary and were not installed as a physical calibration. No robot motion
commands were issued. Camera mounting, verified playback launcher, physical
reference extraction, additional reference positions, and real grasp validation
remain outstanding.
