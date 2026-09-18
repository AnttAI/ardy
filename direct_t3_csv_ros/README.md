# T3 CSV ROS Control UI

This folder is a standalone CSV-to-ROS controller for T3.

It does not run the ARDY model, compile a model, or generate motion. It only loads an already generated T3 CSV, reads each frame row, converts that row into robot/base/lift commands, publishes to ROS, and shows the current frame values in a browser UI.

## Run

```bash
cd /home/jony/Downloads/ardy/direct_t3_csv_ros
python server.py
```

Open:

```text
http://127.0.0.1:8765
```

For a copied folder, run from that copied folder:

```bash
cd /path/to/direct_t3_csv_ros
python server.py
```

## Real Robot Use

1. Start the ROS subscribers on the Jetson.
2. Run this UI on the laptop.
3. Open the browser UI.
4. Load a T3 CSV.
5. Turn off `Dry run`.
6. Click one of the play buttons.

The UI publishes over the ROS network using these defaults:

```text
ROS_DOMAIN_ID=10
ROS_LOCALHOST_ONLY=0
```

If the robot uses a different domain, run:

```bash
ARDY_ROS_DOMAIN_ID=YOUR_DOMAIN python server.py
```

## Files

### `server.py`

This is the backend for the browser UI.

It starts a local web server on port `8765`, serves the HTML/CSS/JS files, loads CSV files, tracks playback state, handles play/pause/resume/stop, and starts ROS publishing when `Dry run` is off.

Important functions:

- `read_csv()` reads CSV rows.
- `split_segments()` splits a CSV when frame numbers restart.
- `infer_fps()` chooses playback FPS.
- `row_capabilities()` checks whether the CSV supports robot, base, and lift.
- `mode_requirements()` defines what each play button needs.
- `load_path()` loads a CSV into the UI state.
- `start_playback()` starts the playback thread.
- `pause_playback()` pauses without resetting the current frame.
- `resume_playback()` continues from the paused position.
- `stop_playback()` stops playback.
- `Handler` handles HTTP requests from the browser.

### `t3_payloads.py`

This converts one CSV row into one T3 command payload.

It handles:

- right arm columns
- left arm columns
- degree-to-radian conversion for arm joints
- gripper values
- lift height
- base wheel RPM values

Main function:

```python
build_t3_csv_frame_payload(...)
```

That function receives one CSV row and a mode such as `robot`, `robot_lift`, `base_lift`, or `full`, then returns a payload ready to send to the ROS publisher.

### `t3_bridge.py`

This starts the ROS publishing child process and streams frame payloads to it.

It launches:

```text
t3_robot_stream_publisher.py
```

Then it sends each frame payload as JSON through stdin.

Important methods:

- `connect()` starts the ROS publisher process.
- `wait_until_ready()` waits for the publisher to be ready.
- `send()` sends one T3 frame payload.
- `send_raw()` sends a raw command, used to send zero base RPM on pause.
- `disconnect()` stops the child process and sends base `[0, 0]`.

### `t3_robot_stream_publisher.py`

This is the actual ROS publisher.

It reads JSON frames from stdin and publishes to ROS topics.

Default topics:

```text
/right_arm/control/move_j
/left_arm/control/move_j
/right_arm/control/joint_states
/left_arm/control/joint_states
/base/cmd_wheel_rpm
/control/lift_frame
```

Message types:

- arms: `sensor_msgs/JointState`
- grippers: `sensor_msgs/JointState`
- base: `std_msgs/Float64MultiArray`
- lift: `std_msgs/Float64MultiArray`

For AGX grippers, launch each arm driver with `effector_type:=agx_gripper`. The gripper command is published as a `JointState` containing only:

```text
name: ["gripper"]
position: [opening_width_m]
effort: [1.0]
```

The CSV columns `right_gripper_joint1_dof` and `right_gripper_joint2_dof` are converted to one right gripper opening width by adding their absolute values. The left gripper uses `left_gripper_joint1_dof` and `left_gripper_joint2_dof` the same way. Valid AGX gripper width is `0.0` to `0.1` metres.

### `stream_t3_robot_sync.sh`

This is a fallback/manual launcher for the ROS publisher.

It sources ROS workspaces if they exist:

```bash
/opt/ros/humble/setup.bash
$HOME/catkin_ws/install/setup.bash
/home/jony/agx_arm_ws/install/setup.bash
```

Then it runs:

```bash
t3_robot_stream_publisher.py
```

Normal browser UI playback uses `t3_bridge.py`.

### `web/index.html`

This is the browser UI layout.

Left side:

- CSV upload
- CSV path input
- segment number
- playback FPS
- play buttons
- pause/resume
- stop
- dry run checkbox
- ROS topic fields

Right side:

- current frame
- current row
- FPS
- CSV information
- live base values
- live lift value
- live right arm values
- live left arm values

### `web/app.js`

This is the browser logic.

It:

- calls backend APIs
- loads CSV files
- starts playback modes
- pauses/resumes/stops playback
- updates the live values panel
- polls `/api/status` every `200 ms`
- disables play buttons when the loaded CSV does not contain required columns

### `web/style.css`

This controls the UI look.

It defines:

- dark control panel
- dashboard background
- button colors
- value display blocks
- responsive layout

### `client_0_gen_23_full.csv`

This is the sample/default CSV included in the folder.

It has robot and lift columns. If your CSV does not include base RPM columns, base playback will not be available.

### `play_csv_full_t3_ros.py`

This is a command-line player without the browser UI.

Dry-run:

```bash
python play_csv_full_t3_ros.py --dry-run
```

Direct playback:

```bash
python play_csv_full_t3_ros.py your_file.csv
```

## Playback Flow

When you click a play button, the flow is:

```text
Browser button
-> server.py
-> selected CSV rows
-> t3_payloads.py
-> JSON frame payload
-> t3_bridge.py
-> t3_robot_stream_publisher.py
-> ROS topics
-> Jetson subscribers
-> robot
```

If `Dry run` is on, the flow stops before ROS:

```text
Browser button
-> server.py
-> selected CSV rows
-> t3_payloads.py
-> UI live values only
```

## Play Modes

### Play Robot

Uses:

```text
right_joint1_dof ... right_joint7_dof
left_joint1_dof ... left_joint7_dof
```

Publishes:

```text
/right_arm/control/move_j
/left_arm/control/move_j
/right_arm/control/joint_states
/left_arm/control/joint_states
```

### Play Robot + Lift

Uses robot columns plus:

```text
telescopic_lift_joint_dof
```

Publishes arms, gripper, and lift.

### Play Base + Lift

Uses lift plus base columns.

Base columns can be:

```text
left_motor_rpm,right_motor_rpm
```

or:

```text
base_left_rpm,base_right_rpm
```

Publishes base and lift.

### Play Full T3

Uses all available T3 controls:

```text
arms + gripper + base + lift
```

Publishes everything.

## CSV Columns

Robot playback needs:

```text
right_joint1_dof
right_joint2_dof
right_joint3_dof
right_joint4_dof
right_joint5_dof
right_joint6_dof
right_joint7_dof
left_joint1_dof
left_joint2_dof
left_joint3_dof
left_joint4_dof
left_joint5_dof
left_joint6_dof
left_joint7_dof
```

Lift playback needs:

```text
telescopic_lift_joint_dof
```

Base playback needs either:

```text
left_motor_rpm
right_motor_rpm
```

or:

```text
base_left_rpm
base_right_rpm
```

Gripper playback is optional with robot playback. If these columns exist, they are sent through the right and left arm `/control/joint_states` topics:

```text
right_gripper_joint1_dof
right_gripper_joint2_dof
left_gripper_joint1_dof
left_gripper_joint2_dof
```

## Pause And Stop

Pause keeps the current playback position.

Example:

```text
Current row: 80
Pause
Resume
Continues from row 81
```

If base playback is active, pause sends:

```text
[0, 0]
```

to stop the base while paused.

Stop ends playback. Starting again begins from the first row of the loaded segment.

## Dry Run

Dry Run ON:

```text
No ROS publish
Only UI live values update
Safe for testing
```

Dry Run OFF:

```text
Publishes to ROS
Can move the real robot
```

## FPS

The UI has a `Playback FPS` field.

Default:

```text
20
```

Allowed range in the UI:

```text
0 to 20
```

If the value is `0`, the backend tries to infer FPS from the CSV. If it cannot infer FPS, it uses `20`.
