# Reference trial — 2026-09-24

The user confirmed the external camera is fixed, camera-left is bottle 1,
camera-right is bottle 3, and both existing reference motions work physically.

The Jetson controller was launched against the outdated viewer address
192.168.31.178. It was relaunched with the same motion options and the actual
laptop address, 192.168.31.126. Its fresh bottle 3 plan passed IK and modeled
clearance checks. With RGB-D and robot feedback recording active, the authorized
bottle 3 trial was requested through the existing controller.

The Jetson connected to the viewer but timed out waiting for rendered frame 0
after 30 seconds. Its log reported ROS disconnect and motion-stream stop. No
successful grasp occurred, so no camera/robot calibration pair was accepted.

The local `NativeWebSocketReceiver` accepts and queues motion frames and responds
to `get_pick_scene`, but has no rendered-frame acknowledgment implementation.
The Jetson explicitly waits for these acknowledgments before progressing. This
is a protocol mismatch, not a camera failure. The render confirmation must be
implemented at actual render completion, matching the controller protocol; it
must not be spoofed or disabled to make the robot move.

Automatic approval review rejected copying the private Jetson controller source
to this laptop over the LAN without explicit authorization. That copy is pending
user approval. The temporary receiving server was stopped. No source was copied.
The existing controller was restored and then relaunched as described above.

Next: inspect the controller protocol after approved source access, implement and
test genuine render acknowledgments with robot output disabled, then repeat the
reference trials. A valid transform, independent positional validation, and live
camera-to-planner integration are still required before automatic random-position
picking. Current raw evidence is under:

`calibration_sessions/sep24/reference_execution/`

It contains 2,473 RGB-D frames, approximately 35,700 joint-state messages per arm,
the execution-request event, and `trial_result.json`. The earlier
`bottle3_trial` recording covered setup only and contains no grasp reference.
