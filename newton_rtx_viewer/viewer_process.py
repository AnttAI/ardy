#!/usr/bin/env python3
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Native Newton viewer fed by ARDY live SOMA/T3 frames on stdin.

 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia python /home/jony/Downloads/ardy/newton_rtx_viewer/viewer_process.py   --viewer gl   --background-usd /home/jony/Downloads/robot-ovrtx.usda   --pick-table-physics   --websocket-server   --websocket-host 0.0.0.0   --websocket-port 8765   --camera-preset saved_front   --playback-mode realtime   --rtx-environment studio   --pick-table-physics-backend mujoco-cpu   --t3-demo-pick-reference-csv "/home/jony/Desktop/csv/ik csv/kimodo_5a07643f16.csv"   --t3-demo-pick-reference-strength 0.30


"""

from __future__ import annotations

import argparse
import atexit
import base64
import csv
import hashlib
import json
import math
import os
import queue
import re
import socket
import struct
import subprocess
import sys
import threading
import time
import traceback
from datetime import datetime
from pathlib import Path

import numpy as np
from scipy.spatial.transform import Rotation

try:
    from .t3_ros_route import T3RosRoute
except ImportError:
    from t3_ros_route import T3RosRoute


REPO_ROOT = Path(os.environ.get("ARDY_REPO_ROOT", Path(__file__).resolve().parent)).expanduser().resolve()
ARDY_WORKSPACE_ROOT = REPO_ROOT.parent if REPO_ROOT.name == "newton_rtx_viewer" else REPO_ROOT
DOWNLOADS_ROOT = Path.home() / "Downloads"
LOCAL_T3_URDF = REPO_ROOT / "assets" / "t3_robot" / "T3.urdf"
DEFAULT_ARDY_TORCH_PYTHON = Path("/home/jony/miniconda3/envs/ardy/bin/python")
BVH_FRAME_HELPER = Path(__file__).resolve().parent / "bvh_frame_helper.py"
ARDY_Y_UP_TO_NEWTON_Z_UP = np.array(
    [
        [1.0, 0.0, 0.0],
        [0.0, 0.0, -1.0],
        [0.0, 1.0, 0.0],
    ],
    dtype=np.float32,
)
T3_LINEAR_JOINTS = {
    "telescopic_lift_joint",
    "left_gripper_joint1",
    "left_gripper_joint2",
    "right_gripper_joint1",
    "right_gripper_joint2",
}
T3_FEEDBACK_VISUAL_BODY_PREFIXES = ("left_", "right_")
T3_FEEDBACK_VISUAL_BODY_MARKERS = ("link", "gripper")
T3_FEEDBACK_GHOST_COLOR = (0.10, 1.00, 0.22)
T3_FEEDBACK_GHOST_SCALE = 1.002
T3_FEEDBACK_MOVE_EPS_RAD = 1.0e-4
T3_FEEDBACK_ACTIVE_SECONDS = 1.2
T3_GRIPPER_MAX_APERTURE_M = 0.10
T3_GRIPPER_DEFAULT_APERTURE_M = 0.0
RENDER_SOURCE_WEBSOCKET = "websocket"
RENDER_SOURCE_SIMULATION = "simulation"
RENDER_SOURCE_LABELS = ("WebSocket Live", "Simulation / IK Picks")
T3_STIFF_POSTURE_JOINTS = {
    "waist_yaw_joint",
    "waist_roll_joint",
    "waist_pitch_joint",
    "head_pitch_joint",
    "head_yaw_joint",
}
T3_GROUND_SUPPORT_BODY_SUFFIXES = (
    "base_link",
    "left_wheel_link",
    "right_wheel_link",
)
T3_ROW_TO_JOINT = {
    "waist_yaw_joint_dof": "waist_yaw_joint",
    "waist_roll_joint_dof": "waist_roll_joint",
    "waist_pitch_joint_dof": "waist_pitch_joint",
    "head_pitch_joint_dof": "head_pitch_joint",
    "head_yaw_joint_dof": "head_yaw_joint",
    "telescopic_lift_joint_dof": "telescopic_lift_joint",
    "right_joint1_dof": "right_joint1",
    "right_joint2_dof": "right_joint2",
    "right_joint3_dof": "right_joint3",
    "right_joint4_dof": "right_joint4",
    "right_joint5_dof": "right_joint5",
    "right_joint6_dof": "right_joint6",
    "right_joint7_dof": "right_joint7",
    "right_gripper_joint1_dof": "right_gripper_joint1",
    "right_gripper_joint2_dof": "right_gripper_joint2",
    "left_joint1_dof": "left_joint1",
    "left_joint2_dof": "left_joint2",
    "left_joint3_dof": "left_joint3",
    "left_joint4_dof": "left_joint4",
    "left_joint5_dof": "left_joint5",
    "left_joint6_dof": "left_joint6",
    "left_joint7_dof": "left_joint7",
    "left_gripper_joint1_dof": "left_gripper_joint1",
    "left_gripper_joint2_dof": "left_gripper_joint2",
}
T3_LIFT_MIN_M = 0.0
T3_LIFT_MAX_M = 0.55
T3_LIFT_DISPLAY_BASE_CM = 60.0
CAMERA_PRESETS = {
    "default": ((0.0, -4.8, 1.55), -4.0, 90.0),
    "front": ((0.40, -7.60, 2.70), 0.0, 90.0),
    "back": ((0.40, 6.40, 2.70), 0.0, -90.0),
    "left": ((-6.60, -0.60, 2.70), 0.0, 0.0),
    "right": ((7.40, -0.60, 2.70), 0.0, 180.0),
    "top": ((0.40, -0.61, 15.00), -89.0, 90.0),
    "lobby": ((-4.01, 4.86, 2.7), -12.0, -51.0),
}
RECORD_VIEW_OFFSETS = {
    "follow": ((0.0, -6.0, 2.10), (0.0, 0.0, 0.75)),
    "orbit_front": ((0.0, -6.0, 2.10), (0.0, 0.0, 0.75)),
    "orbit_left": ((-6.0, 0.0, 2.10), (0.0, 0.0, 0.75)),
    "orbit_right": ((6.0, 0.0, 2.10), (0.0, 0.0, 0.75)),
    "orbit_back": ((0.0, 6.0, 2.10), (0.0, 0.0, 0.75)),
    "hero": ((-2.2, -2.4, 1.65), (0.0, 0.0, 0.90)),
    "top_follow": ((0.0, -0.15, 6.0), (0.0, 0.0, 0.0)),
}
RECORD_VIEW_FOV = {
    "follow": 48.0,
    "orbit_front": 48.0,
    "orbit_left": 48.0,
    "orbit_right": 48.0,
    "orbit_back": 48.0,
    "hero": 40.0,
    "top_follow": 50.0,
}
FIXED_RECORD_SHOTS = {
    "diagonal": ((-4.01, 4.86, 2.70), (0.70, -0.40, 1.00), 37.0),
    "straight": ((-3.20, 1.10, 1.75), (0.85, -0.28, 0.92), 34.0),
    "lobby_wide": ((-4.01, 4.86, 2.70), (0.70, -0.40, 1.00), 37.0),
    "mirror_side": ((-3.20, 1.10, 1.75), (0.85, -0.28, 0.92), 34.0),
    "hall_long": ((-4.45, -2.25, 1.75), (0.70, -0.18, 0.95), 36.0),
    "window_long": ((3.05, 2.70, 1.70), (0.25, -0.25, 0.95), 36.0),
    "window_zoom": ((2.55, 2.10, 1.55), (0.28, -0.25, 0.95), 28.0),
    "front_close": ((0.35, -2.65, 1.28), (0.36, -0.15, 0.95), 31.0),
    "front_zoom": ((0.34, -2.05, 1.18), (0.36, -0.16, 0.96), 24.0),
    "top_close": ((0.70, -0.42, 3.20), (0.55, -0.28, 0.70), 35.0),
    "top_zoom": ((0.64, -0.38, 2.65), (0.55, -0.28, 0.70), 28.0),
}
DIRECT_CAMERA_SHOTS = {
    "saved_diagonal": ((5.654, 3.330, 2.316), -8.95, -119.91, 34.0),
    "saved_full_right": ((13.858, -8.814, 3.479), -15.45, 178.99, 34.0),
    "saved_grass": ((7.365, -2.646, 1.333), -3.95, 172.09, 34.8),
    "saved_straight_left": ((15.088, -2.831, 1.734), -5.95, -177.31, 34.0),
    "saved_straight_left_back": ((0.147, -2.654, 1.353), -4.22, 0.47, 31.0),
    "saved_front": ((1.440, -4.150, 0.760), 0.52, 109.14, 31.0),
    "saved_full_lobby_diagonal": ((16.108, 2.953, 2.585), 0.30, -146.50, 28.0),
    "saved_origin_back": ((1.332, 2.920, 2.269), -17.54, -93.56, 31.0),
    "saved_top_left": ((0.357, 0.537, 4.007), -24.40, -3.61, 28.0),
    "saved_origin_top": ((0.878, 0.570, 4.384), -62.31, -84.21, 28.0),
}
CAMERA_PRESET_CHOICES = tuple(CAMERA_PRESETS) + tuple(DIRECT_CAMERA_SHOTS)
PICK_OBJECT_CHOICES = ("none", "cube")
PICK_OBJECT_DENSITY_KG_M3 = 300.0
PICK_OBJECT_PUSH_MASS_LIMIT_KG = 310.0
DEFAULT_RECORD_VIEWS = ("manual",)
INTERACTIVE_BOTTLE_POSITIONS = (
    (0.22, 0.44, 0.0),
    (0.22, 0.0, 0.0),
    (0.22, -0.44, 0.0),
)
INTERACTIVE_BOTTLE_RADIUS = 0.028
INTERACTIVE_BOTTLE_HALF_HEIGHT = 0.090
INTERACTIVE_BOTTLE_MASS_KG = 0.115
INTERACTIVE_BOTTLE_INSERT_DISTANCE_M = 0.13
INTERACTIVE_BOTTLE_APPROACH_DISTANCE_M = 0.24
INTERACTIVE_TABLE_CONTACT_MARGIN_M = 0.012
T3_GRIPPER_RUBBER_FRICTION = 1.2
T3_GRIPPER_PAD_HALF_EXTENTS_M = (0.022, 0.030, 0.002)
PLACE_BOX_HALF_EXTENTS_M = (0.19, 0.15, 0.01)
PLACE_BOX_DEFAULT_XY = (0.55, -0.02)
T3_DEMO_PICK_FPS = 60.0
PICK_TABLE_SCENE_JSON = Path(__file__).resolve().parent / "assets" / "environment" / "pick_table_scene.json"
T3_DEMO_PICK_CACHE_JSON = Path(__file__).resolve().parent / "assets" / "t3_demo_pick_frames_10fps.json"
T3_DEMO_PICK_REFERENCE_CSV_ENV = "ARDY_T3_DEMO_PICK_REFERENCE_CSV"
T3_DEMO_PICK_REFERENCE_STRENGTH_ENV = "ARDY_T3_DEMO_PICK_REFERENCE_STRENGTH"
T3_GRIPPER_OPEN_APERTURE_M = 0.095
T3_GRIPPER_BOTTLE_GRASP_APERTURE_M = max(0.0, INTERACTIVE_BOTTLE_RADIUS * 2.0 - 0.002)
T3_GRIPPER_CLOSED_APERTURE_M = T3_GRIPPER_BOTTLE_GRASP_APERTURE_M
T3_GRIPPER_SIDES = ("left", "right")
T3_TABLE_GUARD_BODY_SUFFIXES = (
    "left_link6",
    "left_link7",
    "left_link8",
    "left_gripper_base",
    "left_gripper_flange",
    "left_gripper_link1",
    "left_gripper_link2",
    "right_link6",
    "right_link7",
    "right_link8",
    "right_gripper_base",
    "right_gripper_flange",
    "right_gripper_link1",
    "right_gripper_link2",
)
T3_PICK_CONTACT_BODY_SUFFIXES = {
    "left_gripper_link1",
    "left_gripper_link2",
    "right_gripper_link1",
    "right_gripper_link2",
}
T3_LOADED_ARM_POSE = {
    "right_joint1": 0.025115287936198404,
    "right_joint2": 1.5708137800874167,
    "right_joint3": 1.3224185209435837,
    "right_joint4": 0.08307767239493008,
    "right_joint5": -1.7342289579516457,
    "right_joint6": 0.039863320115550493,
    "right_joint7": -0.0014311699866353504,
    "right_gripper_joint1": 0.0,
    "right_gripper_joint2": 0.0,
    "left_joint1": 0.05344198169606638,
    "left_joint2": 1.533132121536859,
    "left_joint3": -1.33271596353035,
    "left_joint4": 0.1751612437301509,
    "left_joint5": -1.1138342220377413,
    "left_joint6": 0.04038691889114879,
    "left_joint7": -0.0007853981633974482,
    "left_gripper_joint1": 1.95e-05,
    "left_gripper_joint2": -1.95e-05,
}
T3_BOTTLE_COLLIDER_RADIUS_BY_SUFFIX = {
    "waist_yaw_link": 0.10,
    "waist_roll_link": 0.10,
    "torso_link": 0.17,
    "head_pitch_link": 0.11,
    "head_yaw_link": 0.11,
    "left_wheel_link": 0.115,
    "right_wheel_link": 0.115,
    "left_base_link": 0.065,
    "right_base_link": 0.065,
    "left_gripper_base": 0.045,
    "right_gripper_base": 0.045,
    "left_gripper_flange": 0.035,
    "right_gripper_flange": 0.035,
    "left_gripper_link1": 0.022,
    "left_gripper_link2": 0.022,
    "right_gripper_link1": 0.022,
    "right_gripper_link2": 0.022,
}
for _t3_side in ("left", "right"):
    for _t3_link_index, _t3_radius in (
        (1, 0.060),
        (2, 0.055),
        (3, 0.060),
        (4, 0.050),
        (5, 0.050),
        (6, 0.045),
        (7, 0.040),
        (8, 0.035),
    ):
        T3_BOTTLE_COLLIDER_RADIUS_BY_SUFFIX[f"{_t3_side}_link{_t3_link_index}"] = _t3_radius
T3_BOTTLE_COLLIDER_BOX_BY_SUFFIX = {
    # Local offsets and half extents follow the T3 URDF collision geometry with
    # a small contact margin so bottles hit the shell instead of the rendered mesh.
    "base_link": (
        ((0.0, 0.0, 0.13), (0.255, 0.175, 0.085)),
        ((0.0, 0.155, 0.10), (0.245, 0.055, 0.115)),
        ((0.0, -0.155, 0.10), (0.245, 0.055, 0.115)),
    ),
    "telescopic_lift_base_link": (
        ((0.0, 0.0, 0.34), (0.075, 0.075, 0.34)),
    ),
    "telescopic_lift_carriage_link": (
        ((0.0, 0.0, 0.22), (0.060, 0.060, 0.22)),
    ),
    "torso_link": (
        ((0.02, 0.0, 0.20), (0.155, 0.105, 0.235)),
    ),
}
SOMA_COLLIDER_SPECS = (
    ("soma_torso", "Hips", "Chest", "box", 0.34, 0.22),
    ("soma_head", "Neck2", "Head", "capsule", 0.18, 0.12),
    ("soma_left_upper_arm", "LeftShoulder", "LeftForeArm", "capsule", 0.09, 0.0),
    ("soma_left_forearm", "LeftForeArm", "LeftHand", "capsule", 0.075, 0.0),
    ("soma_right_upper_arm", "RightShoulder", "RightForeArm", "capsule", 0.09, 0.0),
    ("soma_right_forearm", "RightForeArm", "RightHand", "capsule", 0.075, 0.0),
    ("soma_left_thigh", "LeftLeg", "LeftShin", "capsule", 0.11, 0.0),
    ("soma_left_shin", "LeftShin", "LeftFoot", "capsule", 0.095, 0.0),
    ("soma_right_thigh", "RightLeg", "RightShin", "capsule", 0.11, 0.0),
    ("soma_right_shin", "RightShin", "RightFoot", "capsule", 0.095, 0.0),
)
SOMA_77_JOINT_INDEX = {
    "Hips": 0,
    "Chest": 3,
    "Neck2": 5,
    "Head": 6,
    "LeftShoulder": 11,
    "LeftForeArm": 13,
    "LeftHand": 14,
    "RightShoulder": 39,
    "RightForeArm": 41,
    "RightHand": 42,
    "LeftLeg": 64,
    "LeftShin": 65,
    "LeftFoot": 66,
    "RightLeg": 69,
    "RightShin": 70,
    "RightFoot": 71,
}


def _env_vec3(name: str, default: tuple[float, float, float]) -> tuple[float, float, float]:
    raw = os.environ.get(name)
    if not raw:
        return default
    try:
        values = tuple(float(part.strip()) for part in raw.replace(",", " ").split())
    except ValueError:
        return default
    return values if len(values) == 3 else default


def _env_bool(name: str, default: bool = False) -> bool:
    raw = os.environ.get(name)
    if raw is None:
        return bool(default)
    value = raw.strip().lower()
    if value in {"1", "true", "yes", "on"}:
        return True
    if value in {"0", "false", "no", "off"}:
        return False
    print(f"[ARDY Newton Viewer] ignored invalid {name}={raw!r}; using {default}", flush=True)
    return bool(default)


def _setup_paths() -> None:
    for path in (REPO_ROOT, ARDY_WORKSPACE_ROOT):
        if path.exists() and str(path) not in sys.path:
            sys.path.insert(0, str(path))


def _queue_frame(frame_queue: queue.Queue, playback_mode: str, frame: dict) -> None:
    if playback_mode == "exact":
        frame_queue.put(frame)
        return
    while True:
        try:
            frame_queue.put_nowait(frame)
            break
        except queue.Full:
            try:
                frame_queue.get_nowait()
            except queue.Empty:
                break


def _reader(frame_queue: queue.Queue, playback_mode: str) -> None:
    for line in sys.stdin:
        try:
            frame = json.loads(line)
        except json.JSONDecodeError:
            continue
        _queue_frame(frame_queue, playback_mode, frame)


class NativeWebSocketReceiver:
    def __init__(self, host: str, port: int, frame_queue: queue.Queue, playback_mode: str):
        self.host = host
        self.port = int(port)
        self.frame_queue = frame_queue
        self.playback_mode = playback_mode
        self.enabled = False
        self.status = "websocket stopped"
        self.client_count = 0
        self.frames_received = 0
        self.last_frame_idx = -1
        self.last_payload_bytes = 0
        self._last_receive_log_time = 0.0
        self._sock: socket.socket | None = None
        self._clients: set[socket.socket] = set()
        self._lock = threading.Lock()
        self._thread: threading.Thread | None = None
        self.pick_scene = {"type": "pick_scene", "ready": False, "error": "Wait for RTX scene and robot frames"}
        self.pick_scene_time = 0.0

    def start(self) -> None:
        if self.enabled:
            return
        self.enabled = True
        self._thread = threading.Thread(target=self._run, daemon=True)
        self._thread.start()

    def stop(self) -> None:
        self.enabled = False
        self.status = "websocket stopped"
        with self._lock:
            sockets = [self._sock, *self._clients]
            self._sock = None
            self._clients.clear()
            self.client_count = 0
        for sock in sockets:
            if sock is None:
                continue
            try:
                sock.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass
            try:
                sock.close()
            except OSError:
                pass

    def _run(self) -> None:
        try:
            server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server.bind((self.host, self.port))
            server.listen(8)
            server.settimeout(0.5)
            with self._lock:
                self._sock = server
            self.status = f"listening ws://{self.host}:{self.port}"
            print(f"[ARDY Newton Viewer] websocket server listening: ws://{self.host}:{self.port}", flush=True)
            while self.enabled:
                try:
                    client, addr = server.accept()
                except socket.timeout:
                    continue
                except OSError:
                    break
                threading.Thread(target=self._handle_client, args=(client, addr), daemon=True).start()
        except Exception as exc:
            self.status = f"websocket failed: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
        finally:
            self.stop()

    def _handle_client(self, client: socket.socket, addr) -> None:
        with client:
            try:
                client.settimeout(10.0)
                self._handshake(client)
                client.settimeout(None)
                with self._lock:
                    self._clients.add(client)
                    self.client_count = len(self._clients)
                self.status = f"{self.client_count} websocket client(s)"
                print(f"[ARDY Newton Viewer] websocket client connected: {addr}", flush=True)
                while self.enabled:
                    opcode, payload = self._read_frame(client)
                    if opcode == 0x8:
                        break
                    if opcode != 0x1:
                        continue
                    try:
                        frame = json.loads(payload.decode("utf-8"))
                    except (UnicodeDecodeError, json.JSONDecodeError):
                        continue
                    if frame.get("type") == "get_pick_scene":
                        scene = dict(self.pick_scene)
                        scene["age_s"] = time.monotonic() - self.pick_scene_time
                        self._send_text_frame(client, json.dumps(scene).encode("utf-8"))
                        continue
                    self.frames_received += 1
                    self.last_frame_idx = int(frame.get("frame_idx", -1))
                    self.last_payload_bytes = len(payload)
                    now = time.monotonic()
                    if now - self._last_receive_log_time >= 2.0:
                        print(
                            "[ARDY Newton Viewer] websocket frame received: "
                            f"frame={self.last_frame_idx} total={self.frames_received} "
                            f"bytes={self.last_payload_bytes} queue={self.frame_queue.qsize()} "
                            f"soma_verts={frame.get('soma_mesh_vertices') is not None} "
                            f"soma_joints={frame.get('soma_joints_pos') is not None} "
                            f"t3={frame.get('t3_row') is not None}",
                            flush=True,
                        )
                        self._last_receive_log_time = now
                    _queue_frame(self.frame_queue, self.playback_mode, frame)
            except Exception as exc:
                self.status = f"websocket client ended: {exc}"
                print(f"[ARDY Newton Viewer] websocket client ended: {addr}: {exc}", flush=True)
            finally:
                with self._lock:
                    self._clients.discard(client)
                    self.client_count = len(self._clients)
                if self.enabled:
                    self.status = f"{self.client_count} websocket client(s)"
                    print(f"[ARDY Newton Viewer] websocket clients active: {self.client_count}", flush=True)

    def _handshake(self, client: socket.socket) -> None:
        request = b""
        while b"\r\n\r\n" not in request:
            chunk = client.recv(4096)
            if not chunk:
                raise ConnectionError("empty websocket handshake")
            request += chunk
            if len(request) > 65536:
                raise ConnectionError("websocket handshake too large")
        headers = {}
        for line in request.decode("latin1", errors="replace").split("\r\n")[1:]:
            if ":" in line:
                key, value = line.split(":", 1)
                headers[key.strip().lower()] = value.strip()
        ws_key = headers.get("sec-websocket-key")
        if not ws_key:
            raise ConnectionError("missing Sec-WebSocket-Key")
        accept = base64.b64encode(
            hashlib.sha1((ws_key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11").encode("ascii")).digest()
        ).decode("ascii")
        response = (
            "HTTP/1.1 101 Switching Protocols\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Accept: {accept}\r\n\r\n"
        )
        client.sendall(response.encode("ascii"))

    def _send_text_frame(self, client: socket.socket, payload: bytes) -> None:
        length = len(payload)
        header = bytearray([0x81])
        if length < 126:
            header.append(length)
        elif length < 65536:
            header.extend([126, (length >> 8) & 0xFF, length & 0xFF])
        else:
            header.extend([127])
            header.extend(int(length).to_bytes(8, "big"))
        client.sendall(bytes(header) + payload)

    def _read_frame(self, client: socket.socket) -> tuple[int, bytes]:
        first = client.recv(2)
        if len(first) < 2:
            raise ConnectionError("websocket closed")
        b1, b2 = first
        opcode = b1 & 0x0F
        masked = bool(b2 & 0x80)
        length = b2 & 0x7F
        if length == 126:
            length = struct.unpack("!H", self._recv_exact(client, 2))[0]
        elif length == 127:
            length = struct.unpack("!Q", self._recv_exact(client, 8))[0]
        mask = self._recv_exact(client, 4) if masked else b""
        payload = self._recv_exact(client, length)
        if masked:
            payload = bytes(byte ^ mask[idx % 4] for idx, byte in enumerate(payload))
        return opcode, payload

    @staticmethod
    def _recv_exact(client: socket.socket, length: int) -> bytes:
        chunks = []
        remaining = length
        while remaining > 0:
            chunk = client.recv(remaining)
            if not chunk:
                raise ConnectionError("websocket closed")
            chunks.append(chunk)
            remaining -= len(chunk)
        return b"".join(chunks)


def _get_next_frame(frame_queue: queue.Queue, playback_mode: str):
    if playback_mode == "exact":
        try:
            return frame_queue.get_nowait()
        except queue.Empty:
            return None
    latest_frame = None
    while True:
        try:
            latest_frame = frame_queue.get_nowait()
        except queue.Empty:
            return latest_frame


def _as_float(value, default: float = 0.0) -> float:
    try:
        if value in {"", None}:
            return default
    except TypeError:
        pass
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return default
    return parsed if np.isfinite(parsed) else default


def _clean_pasted_path(value: str | Path) -> str:
    text = str(value or "").strip()
    if not text:
        return ""
    text = text.replace("\n", " ").replace("\r", " ").strip()
    if text.startswith("file://"):
        text = text[len("file://") :]
    text = text.strip().strip("'\"")
    text = re.sub(r"\\([^\\])", r"\1", text)
    return text.strip()


def _resolve_playback_path(value: str | Path, suffixes: tuple[str, ...]) -> Path:
    text = _clean_pasted_path(value)
    if not text:
        return Path("")
    path = Path(text).expanduser()
    if path.is_file():
        return path
    name = path.name
    roots = (
        Path.cwd(),
        DOWNLOADS_ROOT,
        DOWNLOADS_ROOT / "full",
        DOWNLOADS_ROOT / "t3_hardware_logs",
        ARDY_WORKSPACE_ROOT,
        ARDY_WORKSPACE_ROOT / ".cache" / "t3_live",
        ARDY_WORKSPACE_ROOT / ".cache" / "t3_live" / "full",
        REPO_ROOT,
        REPO_ROOT / ".cache" / "t3_live",
        REPO_ROOT / ".cache" / "t3_live" / "full",
    )
    candidates = []
    if name:
        for root in roots:
            candidate = root / name
            if candidate.is_file():
                candidates.append(candidate)
    if not candidates:
        stem = path.stem
        for suffix in suffixes:
            for root in roots:
                candidate = root / f"{stem}{suffix}"
                if candidate.is_file():
                    candidates.append(candidate)
    if candidates:
        return max(candidates, key=lambda candidate: candidate.stat().st_mtime)
    return path


def _read_t3_csv_rows(path: str | Path) -> list[dict[str, float | str]]:
    csv_path = _resolve_playback_path(path, (".csv",))
    with csv_path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames is None:
            raise ValueError(f"T3 CSV has no header: {csv_path}")
        joint_columns = sorted(set(reader.fieldnames) & set(T3_ROW_TO_JOINT))
        if not joint_columns and "joint_names" not in reader.fieldnames and "joint_cfg" not in reader.fieldnames:
            raise ValueError(f"T3 CSV has no known robot joint columns: {csv_path}")
        rows: list[dict[str, float | str]] = []
        for row in reader:
            parsed = {}
            for key, value in row.items():
                if isinstance(value, str):
                    value = value.strip()
                if value in {"", None}:
                    parsed[key] = 0.0
                    continue
                try:
                    parsed[key] = float(value)
                except (TypeError, ValueError):
                    parsed[key] = value
            rows.append(parsed)
    if not rows:
        raise ValueError(f"T3 CSV has no frames: {csv_path}")
    _apply_differential_drive_root(rows)
    return rows


def _csv_fps(rows: list[dict[str, float | str]], default: float = 30.0) -> float:
    for key in ("effective_send_fps", "native_fps"):
        first = _as_float(rows[0].get(key), 0.0) if rows else 0.0
        if first > 0.0:
            return first
    times = [_as_float(row.get("time_s"), np.nan) for row in rows]
    times = [value for value in times if np.isfinite(value)]
    if len(times) < 2:
        return default
    deltas = np.diff(np.asarray(times, dtype=np.float64))
    deltas = deltas[deltas > 1.0e-6]
    if deltas.size == 0:
        return default
    return float(np.clip(1.0 / float(np.median(deltas)), 1.0, 240.0))


def _apply_differential_drive_root(rows: list[dict[str, float | str]]) -> None:
    if not rows or not any("forward_velocity_m_s" in row or "yaw_rate_rad_s" in row for row in rows):
        return
    fps = _csv_fps(rows, default=30.0)
    x = _as_float(rows[0].get("root_x_m"), 0.0)
    y = _as_float(rows[0].get("root_y_m"), 0.0)
    yaw = _as_float(rows[0].get("root_yaw_rad"), math.radians(_as_float(rows[0].get("root_rotateZ"), 0.0)))
    previous_time = _as_float(rows[0].get("time_s"), 0.0)
    left_angle = 0.0
    right_angle = 0.0
    for idx, row in enumerate(rows):
        if idx > 0:
            current_time = _as_float(row.get("time_s"), previous_time + 1.0 / max(fps, 1.0e-6))
            dt = current_time - previous_time
            if dt <= 0.0 or not np.isfinite(dt):
                dt = 1.0 / max(fps, 1.0e-6)
            v = _as_float(rows[idx - 1].get("forward_velocity_m_s"), 0.0)
            w = _as_float(rows[idx - 1].get("yaw_rate_rad_s"), 0.0)
            mid_yaw = yaw + 0.5 * w * dt
            x += v * math.cos(mid_yaw) * dt
            y += v * math.sin(mid_yaw) * dt
            yaw += w * dt
            left_angle += _as_float(rows[idx - 1].get("left_wheel_rad_s"), 0.0) * dt
            right_angle += _as_float(rows[idx - 1].get("right_wheel_rad_s"), 0.0) * dt
            previous_time = current_time
        row["root_x_m"] = x
        row["root_y_m"] = y
        row["root_yaw_rad"] = yaw
        row["root_yaw_deg"] = math.degrees(yaw)
        row["left_wheel_angle_rad"] = left_angle
        row["right_wheel_angle_rad"] = right_angle


def _latest_file(patterns: tuple[str, ...]) -> str:
    all_files = []
    roots = (REPO_ROOT, ARDY_WORKSPACE_ROOT, Path.cwd(), DOWNLOADS_ROOT, DOWNLOADS_ROOT / "full")
    seen = set()
    for root in roots:
        for pattern in patterns:
            for path in Path(root).glob(pattern):
                if not path.is_file():
                    continue
                resolved = path.resolve()
                if resolved in seen:
                    continue
                seen.add(resolved)
                all_files.append(resolved)
    return str(max(all_files, key=lambda path: path.stat().st_mtime)) if all_files else ""


def _latest_t3_csv_path() -> str:
    return _latest_file(
        (
            ".cache/t3_live/*.csv",
            ".cache/t3_live/full/*.csv",
            "full/*.csv",
            "t3_hardware_logs/*.csv",
            "outputs/t3_hardware_logs/*.csv",
            "outputs/t3_hardware_csv_segments/*.csv",
            ".cache/export/*.csv",
        )
    )


def _latest_soma_bvh_path() -> str:
    return _latest_file(
        (
            ".cache/t3_live/*.soma.bvh",
            ".cache/t3_live/*.bvh",
            ".cache/t3_live/full/*.soma.bvh",
            ".cache/t3_live/full/*.bvh",
            "full/*.soma.bvh",
            "full/*.bvh",
            "t3_hardware_logs/*.soma.bvh",
            "t3_hardware_logs/*.bvh",
            "outputs/t3_hardware_logs/*.soma.bvh",
            ".cache/export/*.bvh",
        )
    )


def _matching_bvh_for_csv(csv_path: str | Path) -> str:
    path = _resolve_playback_path(csv_path, (".csv",))
    candidate = path.with_suffix(".soma.bvh")
    if candidate.is_file():
        return str(candidate)
    resolved = _resolve_playback_path(path.with_suffix(".soma.bvh").name, (".soma.bvh", ".bvh"))
    return str(resolved) if resolved.is_file() else ""


def _matching_csv_for_bvh(bvh_path: str | Path) -> str:
    path = _resolve_playback_path(bvh_path, (".soma.bvh", ".bvh"))
    name = path.name
    if name.endswith(".soma.bvh"):
        candidate = path.with_name(name[: -len(".soma.bvh")] + ".csv")
    elif name.endswith(".bvh"):
        candidate = path.with_suffix(".csv")
    else:
        candidate = path.with_suffix(".csv")
    if candidate.is_file():
        return str(candidate)
    resolved = _resolve_playback_path(candidate.name, (".csv",))
    return str(resolved) if resolved.is_file() else ""


def _read_path_file(filename: str) -> str:
    def read_existing(name: str) -> str:
        candidates = (
            REPO_ROOT / ".cache" / "t3_live" / name,
            ARDY_WORKSPACE_ROOT / ".cache" / "t3_live" / name,
            REPO_ROOT / name,
            ARDY_WORKSPACE_ROOT / name,
            Path.cwd() / name,
            Path.cwd() / ".cache" / "t3_live" / name,
        )
        for candidate in candidates:
            try:
                value = candidate.read_text(encoding="utf-8").strip().splitlines()[0].strip()
            except Exception:
                continue
            if value:
                return value
        return ""

    direct_value = read_existing(filename)
    if direct_value:
        return direct_value
    if filename == "rtx_bvh_path.txt":
        csv_path = read_existing("rtx_csv_path.txt")
        paired_bvh = _matching_bvh_for_csv(csv_path) if csv_path else ""
        return paired_bvh or _latest_soma_bvh_path()
    if filename == "rtx_csv_path.txt":
        bvh_path = read_existing("rtx_bvh_path.txt")
        paired_csv = _matching_csv_for_bvh(bvh_path) if bvh_path else ""
        return paired_csv or _latest_t3_csv_path()
    return ""

def _rotation_from_bvh_channels(channels: list[str], values: np.ndarray) -> np.ndarray:
    rotation_channels = []
    rotation_values = []
    for channel, value in zip(channels, values):
        if channel.endswith("rotation"):
            rotation_channels.append(channel[0].upper())
            rotation_values.append(float(value))
    if not rotation_channels:
        return np.eye(3, dtype=np.float32)
    return Rotation.from_euler("".join(rotation_channels), rotation_values, degrees=True).as_matrix().astype(np.float32)


def _load_soma_bvh_motion(path: str | Path):
    import torch

    from ardy.data_processing.bvh import Bvh
    from ardy.skeleton import SOMASkeleton77

    bvh_path = Path(path).expanduser()
    bvh = Bvh(bvh_path.read_text(encoding="utf-8"), backend="np")
    skeleton = SOMASkeleton77(load=True)
    bvh_name_set = set(bvh.get_joints_names())
    if "Hips" not in bvh_name_set:
        raise ValueError(f"SOMA BVH must contain a Hips joint: {bvh_path}")

    frame_count = int(bvh.nframes)
    local_rots = np.tile(np.eye(3, dtype=np.float32), (frame_count, skeleton.nbjoints, 1, 1))
    root_positions = np.zeros((frame_count, 3), dtype=np.float32)
    for joint_name in skeleton.bone_order_names:
        if joint_name not in bvh_name_set:
            continue
        channels = list(bvh.joint_channels(joint_name))
        values = np.asarray(bvh.frames_joints_channels([joint_name], channels), dtype=np.float32)[:, 0]
        joint_idx = skeleton.bone_index[joint_name]
        local_rots[:, joint_idx] = np.stack(
            [_rotation_from_bvh_channels(channels, row) for row in values],
            axis=0,
        )
        if joint_name == "Hips":
            position_columns = []
            for channel in ("Xposition", "Yposition", "Zposition"):
                if channel in channels:
                    position_columns.append(values[:, channels.index(channel)])
                else:
                    position_columns.append(np.zeros(frame_count, dtype=np.float32))
            root_positions = (np.stack(position_columns, axis=-1) / 100.0).astype(np.float32)

    with torch.no_grad():
        local_rots_t = torch.as_tensor(local_rots, dtype=torch.float32)
        root_positions_t = torch.as_tensor(root_positions, dtype=torch.float32)
        global_rots_t, _, _ = skeleton.fk(local_rots_t, root_positions_t)
        if hasattr(skeleton, "global_rot_offsets"):
            offsets = skeleton.global_rot_offsets.to(dtype=torch.float32)
            global_rots_t = torch.einsum("T N m n, N o n -> T N m o", global_rots_t, offsets)
            local_rots_t = skeleton.global_rots_to_local_rots(global_rots_t)
        global_rots_t, joints_pos_t, _ = skeleton.fk(local_rots_t, root_positions_t)
    fps = 1.0 / max(float(bvh.frame_time), 1.0e-6)
    return skeleton.cpu(), joints_pos_t.detach().cpu(), global_rots_t.detach().cpu(), fps


def _load_bvh_frames_with_ardy_python(bvh_path: str | Path) -> tuple[list[dict], float]:
    helper_python = Path(os.environ.get("ARDY_TORCH_PYTHON", str(DEFAULT_ARDY_TORCH_PYTHON))).expanduser()
    if not helper_python.exists():
        raise RuntimeError(
            "BVH playback needs torch. Set ARDY_TORCH_PYTHON to a Python executable with torch installed."
        )
    if not BVH_FRAME_HELPER.exists():
        raise RuntimeError(f"BVH helper not found: {BVH_FRAME_HELPER}")

    env = dict(os.environ)
    repo_paths = [str(REPO_ROOT), str(ARDY_WORKSPACE_ROOT)]
    current_pythonpath = env.get("PYTHONPATH", "")
    if current_pythonpath:
        repo_paths.append(current_pythonpath)
    env["PYTHONPATH"] = os.pathsep.join(repo_paths)
    cmd = [
        str(helper_python),
        str(BVH_FRAME_HELPER),
        "--bvh",
        str(Path(bvh_path).expanduser()),
    ]
    print(f"[ARDY Newton Viewer] BVH helper command: {' '.join(cmd)}", flush=True)
    proc = subprocess.run(
        cmd,
        cwd=str(REPO_ROOT),
        env=env,
        text=True,
        capture_output=True,
        timeout=180.0,
        check=False,
    )
    if proc.stderr.strip():
        print(proc.stderr.strip(), flush=True)
    if proc.returncode != 0:
        detail = proc.stderr.strip() or proc.stdout.strip() or f"exit code {proc.returncode}"
        raise RuntimeError(f"BVH helper failed: {detail}")
    try:
        result = json.loads(proc.stdout)
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"BVH helper returned invalid JSON: {exc}") from exc
    frames = result.get("frames")
    fps = float(result.get("fps", 30.0))
    if not isinstance(frames, list) or not frames:
        raise RuntimeError("BVH helper returned no frames")
    return frames, fps


def _make_file_playback_frames(
    *,
    bvh_path: str,
    csv_path: str,
    mode: str,
) -> tuple[list[dict], float]:
    mode = mode.lower()
    bvh_path = _clean_pasted_path(bvh_path)
    csv_path = _clean_pasted_path(csv_path)
    if mode == "both":
        paired_bvh = _matching_bvh_for_csv(csv_path) if csv_path else ""
        paired_csv = _matching_csv_for_bvh(bvh_path) if bvh_path else ""
        if paired_bvh and Path(paired_bvh).resolve() != Path(bvh_path).expanduser().resolve():
            print(
                f"[ARDY Newton Viewer] Play Both pairing: using BVH sidecar {paired_bvh} for CSV {csv_path}",
                flush=True,
            )
            bvh_path = paired_bvh
        elif paired_csv and Path(paired_csv).resolve() != Path(csv_path).expanduser().resolve():
            print(
                f"[ARDY Newton Viewer] Play Both pairing: using CSV sidecar {paired_csv} for BVH {bvh_path}",
                flush=True,
            )
            csv_path = paired_csv
    use_bvh = mode in {"bvh", "both"} and bool(bvh_path.strip())
    use_csv = mode in {"csv", "both"} and bool(csv_path.strip())
    if not use_bvh and not use_csv:
        raise ValueError("Set CSV path, BVH path, or both.")

    fps = 30.0
    soma_skeleton = None
    soma_skin = None
    joints_pos = None
    joints_rot = None
    bvh_frames = None
    if use_bvh:
        try:
            from ardy.viz.soma_skin import SOMASkin

            soma_skeleton, joints_pos, joints_rot, fps = _load_soma_bvh_motion(bvh_path.strip())
            soma_skin = SOMASkin(soma_skeleton)
        except ModuleNotFoundError as exc:
            if exc.name != "torch":
                raise
            print(
                "[ARDY Newton Viewer] RTX Python has no torch; loading BVH through ARDY helper",
                flush=True,
            )
            bvh_frames, fps = _load_bvh_frames_with_ardy_python(bvh_path.strip())
            print(
                f"[ARDY Newton Viewer] BVH helper loaded {len(bvh_frames)} frames at {fps:.2f} FPS",
                flush=True,
            )

    t3_rows = None
    if use_csv:
        t3_rows = _read_t3_csv_rows(csv_path.strip())
        if not use_bvh:
            fps = _csv_fps(t3_rows)

    bvh_count = len(bvh_frames) if bvh_frames is not None else int(joints_pos.shape[0]) if joints_pos is not None else 0
    csv_count = len(t3_rows) if t3_rows is not None else 0
    frame_count = max(bvh_count, csv_count)
    faces = soma_skin.faces.detach().cpu().numpy().astype(int).tolist() if soma_skin is not None else None
    print(
        "[ARDY Newton Viewer] file playback sources: "
        f"mode={mode} bvh={Path(bvh_path).name if use_bvh else 'none'}({bvh_count} frames) "
        f"csv={Path(csv_path).name if use_csv else 'none'}({csv_count} rows)",
        flush=True,
    )
    frames = []
    for frame_idx in range(frame_count):
        payload = {
            "show_soma_mesh": bool(use_bvh),
            "show_t3_robot": bool(use_csv),
            "t3_row": None,
            "fps": float(fps),
            "frame_idx": int(frame_idx),
        }
        if use_bvh:
            human_idx = min(frame_idx, bvh_count - 1)
            if bvh_frames is not None:
                payload.update(
                    {
                        key: value
                        for key, value in bvh_frames[human_idx].items()
                        if key not in {"frame_idx", "fps", "t3_row", "show_t3_robot", "status"}
                    }
                )
            else:
                soma_vertices = soma_skin.skin(
                    joints_rot[human_idx : human_idx + 1],
                    joints_pos[human_idx : human_idx + 1],
                    rot_is_global=True,
                )[0].detach().cpu().numpy()
                payload.update(
                    {
                        "soma_joint_names": soma_skeleton.bone_order_names,
                        "soma_joint_parents": soma_skeleton.joint_parents.detach().cpu().numpy().astype(int).tolist(),
                        "soma_joints_pos": joints_pos[human_idx].numpy().astype(float).tolist(),
                        "soma_joints_rot": joints_rot[human_idx].numpy().astype(float).tolist(),
                        "soma_mesh_vertices": soma_vertices.astype(float).tolist(),
                        "soma_mesh_faces": faces if frame_idx < 10 or frame_idx % 30 == 0 else None,
                        "soma_root_pos": joints_pos[human_idx, 0].numpy().astype(float).tolist(),
                    }
                )
        if use_csv:
            robot_idx = min(frame_idx, csv_count - 1)
            payload["t3_row"] = t3_rows[robot_idx]
        frames.append(payload)
    if frames:
        first = frames[0]
        last = frames[-1]
        first_t3 = first.get("t3_row") or {}
        last_t3 = last.get("t3_row") or {}
        print(
            "[ARDY Newton Viewer] file playback roots: "
            f"soma_first={first.get('soma_root_pos')} soma_last={last.get('soma_root_pos')} "
            f"t3_first=({first_t3.get('root_translateX', first_t3.get('root_x_m'))}, "
            f"{first_t3.get('root_translateY', first_t3.get('root_y_m'))}, "
            f"yaw={first_t3.get('root_rotateZ', first_t3.get('root_yaw_deg'))}) "
            f"t3_last=({last_t3.get('root_translateX', last_t3.get('root_x_m'))}, "
            f"{last_t3.get('root_translateY', last_t3.get('root_y_m'))}, "
            f"yaw={last_t3.get('root_rotateZ', last_t3.get('root_yaw_deg'))})",
            flush=True,
        )
    return frames, fps


def _fresh_pick_feedback(row, received_s, now=None):
    now = time.monotonic() if now is None else now
    if not isinstance(row, dict) or received_s <= 0 or not 0 <= now - received_s <= T3_FEEDBACK_ACTIVE_SECONDS:
        return None
    values = np.asarray(row.get("joint_cfg", []), dtype=float)
    if not values.size or not np.isfinite(values).all():
        return None
    return dict(row)


def _pick_assignments(targets, grips):
    """Use both arms in each pair, minimizing total reach from the starting pose."""
    result = []
    for start in range(0, len(targets), 2):
        pair = targets[start:start + 2]
        if len(pair) == 1:
            result.append(min(grips, key=lambda side: np.linalg.norm(pair[0] - grips[side])))
        else:
            cost = lambda sides: sum(np.linalg.norm(p - grips[side]) for p, side in zip(pair, sides))
            result.extend(min((("left", "right"), ("right", "left")), key=cost))
    return result


def _pick_robot_grips(newton, wp, joints):
    builder = newton.ModelBuilder()
    builder.add_urdf(str(LOCAL_T3_URDF), floating=False, collapse_fixed_joints=False)
    for i, label in enumerate(builder.joint_label):
        name = str(label).rsplit("/", 1)[-1]
        if name in joints:
            builder.joint_q[builder.joint_q_start[i]] = joints[name]
        elif name in T3_LOADED_ARM_POSE:
            builder.joint_q[builder.joint_q_start[i]] = T3_LOADED_ARM_POSE[name]
    model = builder.finalize()
    state = model.state()
    newton.eval_fk(model, model.joint_q, model.joint_qd, state)
    poses = state.body_q.numpy()
    return {side: np.asarray(wp.transform_point(wp.transform(*poses[next(
        i for i, label in enumerate(model.body_label) if str(label).endswith(f"/{side}_gripper_base")
    )]), wp.vec3(0, 0, .11))) for side in ("left", "right")}


def _merge_pick_pair(first, second):
    """Both plans share a frozen base/torso seed; merge only the second arm."""
    if len(first) != len(second):
        raise ValueError("Dual-arm plans must have equal durations")
    frames = []
    for a, b in zip(first, second):
        frame = dict(a)
        row = dict(a["t3_row"])
        other = b["t3_row"]
        side = other["demo_pick_hand"]
        joints = dict(zip(row["joint_names"], row["joint_cfg"]))
        joints.update((name, value) for name, value in zip(other["joint_names"], other["joint_cfg"]) if name.startswith(side + "_"))
        row["joint_cfg"] = [joints[name] for name in row["joint_names"]]
        row["demo_pick_hands"] = [row["demo_pick_hand"], side]
        row["demo_bottle_indices"] = [
            row.get("demo_bottle_index"),
            other.get("demo_bottle_index"),
        ]
        frame["t3_row"] = row
        frame["status"] = "T3 dual-arm pick, place and return"
        frames.append(frame)
    return frames


def _validate_pick_clearance(newton, wp, frames, obstacles):
    """Conservative swept mesh bounds for both arms versus each other/table/tray.

    This intentionally rejects ambiguous near contacts rather than claiming mesh
    bounds prove a safe physical motion. Check every command before any ROS send.
    """
    builder = newton.ModelBuilder()
    builder.add_urdf(str(LOCAL_T3_URDF), floating=False, collapse_fixed_joints=False)
    model = builder.finalize()
    state = model.state()
    coords = {str(label).rsplit("/", 1)[-1]: int(builder.joint_q_start[i])
              for i, label in enumerate(builder.joint_label)}
    def self_checked_link(label: str) -> bool:
        return any(token in label for token in (
            "_link3", "_link4", "_link5", "_link6", "_link7", "_gripper"
        ))

    def obstacle_checked_link(label: str) -> bool:
        return any(token in label for token in (
            "_link6", "_link7", "_gripper_link"
        ))

    geometry = []
    for i, body in enumerate(builder.shape_body):
        if body < 0:
            continue
        label = str(builder.body_label[body]).rsplit("/", 1)[-1]
        side = next((s for s in ("left", "right") if label.startswith(s + "_") and "wheel" not in label), None)
        if side is None:
            continue
        bounds = _shape_local_bounds(newton, int(builder.shape_type[i]), np.asarray(builder.shape_scale[i]), builder.shape_source[i])
        if bounds is not None:
            corners = _transform_points_np(np.asarray(builder.shape_transform[i]), _bounds_corners(*bounds))
            geometry.append((body, side, label, corners, self_checked_link(label), obstacle_checked_link(label)))
    previous = None
    q = model.joint_q.numpy().copy()
    for frame in frames:
        row = frame["t3_row"]
        for name, value in zip(row["joint_names"], row["joint_cfg"]):
            if name in coords:
                q[coords[name]] = value
        if not np.isfinite(q).all():
            raise ValueError("Non-finite pick joint target")
        newton.eval_fk(model, wp.array(q, dtype=wp.float32), model.joint_qd, state)
        poses = state.body_q.numpy()
        bounds = []
        for body, side, label, corners, _, _ in geometry:
            points = _transform_points_np(poses[body], corners)
            bounds.append((points.min(axis=0), points.max(axis=0)))
        swept = bounds if previous is None else [(np.minimum(a[0], b[0]), np.maximum(a[1], b[1])) for a, b in zip(previous, bounds)]
        def overlaps(a, b):
            return bool(np.all(a[1] > b[0] - .003) and np.all(a[0] < b[1] + .003))
        for i, (_, side, label, _, check_self, check_obstacle) in enumerate(geometry):
            for obstacle in obstacles:
                if check_obstacle and overlaps(swept[i], obstacle):
                    raise ValueError(f"Pick clearance blocked: {label} near table/tray at frame {row['frame_idx']}")
            for j in range(i):
                if check_self and geometry[j][4] and geometry[j][1] != side and overlaps(swept[i], swept[j]):
                    raise ValueError(f"Pick clearance blocked: arms overlap at frame {row['frame_idx']}")
        previous = bounds


def _make_t3_demo_pick_frames(
    newton,
    wp,
    bottle_position,
    *,
    fps: float = 60.0,
    initial_joints=None,
    root_pose=(0.0, 0.0, 0.0),
    place_position=None,
    hand_side: str = "left",
    reference_motion_csv: str | os.PathLike | None = None,
    reference_strength: float = 0.0,
) -> tuple[list[dict], float]:
    import newton.ik as ik

    hand_side = "left" if str(hand_side).lower().startswith("left") else "right"
    target_bottle = np.asarray(bottle_position, dtype=np.float32)
    if not np.isfinite(fps) or not 60 <= fps <= 120:
        raise ValueError("Pick FPS must be between 60 and 120")
    if target_bottle.shape != (3,) or not np.isfinite(target_bottle).all():
        raise ValueError("Invalid bottle target")
    reference_strength = float(reference_strength)
    if not np.isfinite(reference_strength):
        reference_strength = 0.0
    reference_strength = float(np.clip(reference_strength, 0.0, 0.85))
    reference_motion = _load_t3_reference_motion_csv(reference_motion_csv) if reference_motion_csv else None

    builder = newton.ModelBuilder()
    builder.add_urdf(
        str(LOCAL_T3_URDF),
        floating=False,
        collapse_fixed_joints=False,
        enable_self_collisions=False,
    )
    arm_mask = np.zeros(builder.joint_dof_count, dtype=bool)
    finger_coords: list[tuple[int, int, str]] = []
    joint_names_by_coord: list[tuple[str, int]] = []
    for joint_idx, label in enumerate(builder.joint_label):
        name = str(label).rsplit("/", 1)[-1]
        q_start = int(builder.joint_q_start[joint_idx])
        qd_start = int(builder.joint_qd_start[joint_idx])
        dof_dim = builder.joint_dof_dim[joint_idx]
        try:
            dof_count = int(sum(dof_dim))
        except TypeError:
            dof_count = int(dof_dim)
        if q_start < len(builder.joint_q) and dof_count > 0:
            joint_names_by_coord.append((name, q_start))
        if initial_joints and name in initial_joints and q_start < len(builder.joint_q):
            builder.joint_q[q_start] = initial_joints[name]
        if name in T3_LOADED_ARM_POSE and not (initial_joints and name in initial_joints) and q_start < len(builder.joint_q):
            builder.joint_q[q_start] = T3_LOADED_ARM_POSE[name]
        if name.startswith(f"{hand_side}_joint") and name[-1:] in set("1234567"):
            arm_mask[qd_start : qd_start + dof_count] = True
        if name.startswith(("left_gripper_joint", "right_gripper_joint")) and q_start < len(builder.joint_q):
            if name in T3_LOADED_ARM_POSE and not (initial_joints and name in initial_joints):
                builder.joint_q[q_start] = T3_LOADED_ARM_POSE[name]
            elif not (initial_joints and name in initial_joints):
                builder.joint_q[q_start] = 0.05 if name.endswith("1") else -0.05
            if name.startswith(f"{hand_side}_"):
                finger_coords.append((q_start, qd_start, name))

    model = builder.finalize()
    joint_coord_by_name = dict(joint_names_by_coord)
    wrist = next(i for i, name in enumerate(model.body_label) if str(name).endswith(f"/{hand_side}_gripper_base"))
    grip_offset = wp.vec3(0.0, 0.0, 0.11)
    q = wp.array(model.joint_q, shape=(1, model.joint_coord_count))
    feedback_seeded = bool(initial_joints)
    feedback_q = q.numpy().reshape(-1).copy()
    grasp_point = target_bottle.copy()
    initial_state = model.state()
    newton.eval_fk(model, q.flatten(), model.joint_qd, initial_state)
    current_grip = np.asarray(wp.transform_point(wp.transform(*initial_state.body_q.numpy()[wrist]), grip_offset), dtype=np.float32)
    table_clearance_z = max(float(grasp_point[2]) + 0.18, 1.12)
    departure = np.array(
        [
            min(float(current_grip[0]) - 0.04, 0.02),
            float(current_grip[1]),
            max(0.92, float(current_grip[2]) + 0.30),
        ],
        dtype=np.float32,
    )
    approach = grasp_point + np.array([-0.14, 0.0, table_clearance_z - float(grasp_point[2])], dtype=np.float32)
    pregrasp = grasp_point + np.array([-0.08, 0.0, 0.12], dtype=np.float32)
    retract = grasp_point + np.array([-0.16, 0.0, table_clearance_z - float(grasp_point[2])], dtype=np.float32)
    pos_obj = ik.IKObjectivePosition(wrist, grip_offset, wp.array([wp.vec3(pregrasp)], dtype=wp.vec3))
    rot_obj = ik.IKObjectiveRotation(
        wrist,
        wp.quat_identity(),
        wp.array([wp.vec4(0.0, np.sqrt(0.5), 0.0, np.sqrt(0.5))], dtype=wp.vec4),
        weight=0.2,
    )
    ik_solver = ik.IKSolver(
        model,
        1,
        [
            pos_obj,
            rot_obj,
            ik.IKObjectiveJointLimit(model.joint_limit_lower, model.joint_limit_upper, weight=10.0),
        ],
        jacobian_mode=ik.IKJacobianType.ANALYTIC,
        joint_dof_mask=wp.array(arm_mask, dtype=wp.bool),
    )
    lift = grasp_point + np.array([0.0, 0.0, 0.32], dtype=np.float32)
    if place_position is not None:
        place_point = np.asarray(place_position, dtype=np.float32).copy()
    else:
        place_point = grasp_point + np.array([0.0, 0.34, 0.0], dtype=np.float32)
        place_point[2] = grasp_point[2]
    above_place = place_point + np.array([0.0, 0.0, 0.30], dtype=np.float32)
    # Match the validated t3_pick_place timing, with an extra high departure
    # waypoint so folded hands clear the table edge before moving forward.
    times = np.array([0, 1, 2, 3, 4, 5, 7, 9, 10, 12, 14, 15, 17], dtype=np.float32)
    points = np.array(
        [
            current_grip,
            departure,
            approach,
            pregrasp,
            grasp_point,
            grasp_point,
            lift,
            above_place,
            place_point,
            place_point,
            above_place,
            departure,
            retract,
        ],
        dtype=np.float32,
    )

    lower = model.joint_limit_lower.numpy()
    upper = model.joint_limit_upper.numpy()
    frame_count = int(np.ceil(float(times[-1]) * fps)) + 1
    frames: list[dict] = []
    max_ik_error = 0.0
    return_q = None
    departure_q = None
    reference_active_joints: list[tuple[str, int, float]] = []
    reference_active_end = 0.0
    if reference_motion is not None and reference_strength > 0.0:
        reference_active_end = min(2.4, 1.0 + float(reference_motion["duration"]))
        for name in ("waist_yaw_joint", "waist_roll_joint", "waist_pitch_joint"):
            if name in reference_motion["joint_values"] and name in joint_coord_by_name:
                reference_active_joints.append((name, joint_coord_by_name[name], 0.35))
        for index in range(1, 8):
            name = f"{hand_side}_joint{index}"
            if name in reference_motion["joint_values"] and name in joint_coord_by_name:
                reference_active_joints.append((name, joint_coord_by_name[name], 1.0))
        if reference_active_joints:
            print(
                "[ARDY Newton Viewer] T3 demo pick reference guidance enabled: "
                f"{Path(reference_motion['path']).name}, hand={hand_side}, "
                f"strength={reference_strength:.2f}, joints={len(reference_active_joints)}",
                flush=True,
            )
    for frame_idx in range(frame_count):
        next_solver_q = None
        t = frame_idx / float(fps)
        segment = min(max(int(np.searchsorted(times, t, side="right") - 1), 0), len(times) - 2)
        u = float(np.clip((t - float(times[segment])) / float(times[segment + 1] - times[segment]), 0, 1))
        u = u * u * (3.0 - 2.0 * u)
        target = (1.0 - u) * points[segment] + u * points[segment + 1]
        if t < 1.0:
            if departure_q is None:
                search_q = feedback_q.copy()
                for name, coord in joint_names_by_coord:
                    if name.startswith(f"{hand_side}_joint"):
                        search_q[coord] = 0.0
                q.assign(search_q.reshape(1, -1))
                pos_obj.set_target_positions(wp.array([wp.vec3(departure)], dtype=wp.vec3))
                ik_solver.step(q, q, iterations=200)
                departure_q = q.numpy().reshape(-1).copy()
            q_np = (1.0 - u) * feedback_q + u * departure_q
        elif t > 15.0:
            q_np = (1.0 - u) * return_q + u * feedback_q
        else:
            pos_obj.set_target_positions(wp.array([wp.vec3(target)], dtype=wp.vec3))
            ik_solver.step(q, q, iterations=40)
            q_np = q.numpy().reshape(-1).copy()
            base_ik_q = q_np.copy()
            reference_applied = False
            if reference_active_joints and 1.0 <= t <= reference_active_end:
                reference_elapsed = t - 1.0
                ramp_in = np.clip(reference_elapsed / 0.75, 0.0, 1.0)
                ramp_out = np.clip((reference_active_end - t) / 0.75, 0.0, 1.0)
                fade = float(min(ramp_in, ramp_out))
                fade = fade * fade * (3.0 - 2.0 * fade)
                if fade > 0.0:
                    reference_applied = True
                    ref_joints = _sample_t3_reference_joints(reference_motion, reference_elapsed)
                    for _ in range(2):
                        for name, coord, joint_scale in reference_active_joints:
                            if name not in ref_joints:
                                continue
                            alpha = reference_strength * joint_scale * fade
                            q_np[coord] = (1.0 - alpha) * q_np[coord] + alpha * ref_joints[name]
                        q.assign(q_np.reshape(1, -1))
                        pos_obj.set_target_positions(wp.array([wp.vec3(target)], dtype=wp.vec3))
                        ik_solver.step(q, q, iterations=25)
                        q_np = q.numpy().reshape(-1).copy()
            newton.eval_fk(model, q.flatten(), model.joint_qd, initial_state)
            reached = np.asarray(wp.transform_point(wp.transform(*initial_state.body_q.numpy()[wrist]), grip_offset))
            error = float(np.linalg.norm(reached - target))
            max_ik_error = max(max_ik_error, error)
            precise_phase = (3.7 <= t <= 5.3) or (9.7 <= t <= 12.3)
            error_limit = 0.025 if precise_phase else (0.20 if t >= 14.0 else 0.12)
            if reference_applied and error > error_limit:
                q_np = base_ik_q.copy()
                q.assign(q_np.reshape(1, -1))
                pos_obj.set_target_positions(wp.array([wp.vec3(target)], dtype=wp.vec3))
                ik_solver.step(q, q, iterations=40)
                q_np = q.numpy().reshape(-1).copy()
                newton.eval_fk(model, q.flatten(), model.joint_qd, initial_state)
                reached = np.asarray(wp.transform_point(wp.transform(*initial_state.body_q.numpy()[wrist]), grip_offset))
                error = float(np.linalg.norm(reached - target))
                max_ik_error = max(max_ik_error, error)
            elif reference_applied:
                next_solver_q = base_ik_q.copy()
            if error > error_limit or not np.isfinite(q_np).all():
                raise ValueError(f"{hand_side} target unreachable at {t:.2f}s ({error:.3f} m error); adjust bottle/tray sliders")
            return_q = q_np.copy()
        closure = np.clip(t - 4.0, 0.0, 1.0) if t < 10.3 else max(0.0, 1.0 - (t - 10.3))
        open_half_aperture = T3_GRIPPER_MAX_APERTURE_M * 0.5
        grasp_half_aperture = T3_GRIPPER_BOTTLE_GRASP_APERTURE_M * 0.5
        for coord, dof, name in finger_coords:
            sign = 1.0 if name.endswith("1") else -1.0
            half_aperture = grasp_half_aperture + (open_half_aperture - grasp_half_aperture) * (1.0 - closure)
            opening = sign * half_aperture
            if t < 1.0:
                opening = (1.0 - u) * feedback_q[coord] + u * sign * open_half_aperture
            elif t > 15.0:
                opening = (1.0 - u) * sign * open_half_aperture + u * feedback_q[coord]
            q_np[coord] = np.clip(opening, lower[dof], upper[dof])
            if next_solver_q is not None:
                next_solver_q[coord] = q_np[coord]
        q.assign(q_np.reshape(1, -1))
        row = {
            "root_x_m": float(root_pose[0]),
            "root_y_m": float(root_pose[1]),
            "root_yaw_rad": float(root_pose[2]),
            "fps": float(fps),
            "frame_idx": int(frame_idx),
            "debug_demo_pick": True,
            "kinematic_t3_demo_pick": True,
            "demo_pick_hand": hand_side,
            "demo_place_position": place_point.astype(float).tolist(),
            "demo_pick_reference_motion": str(reference_motion["path"]) if reference_active_joints else None,
            "demo_pick_reference_strength": float(reference_strength) if reference_active_joints else 0.0,
            "joint_names": [],
            "joint_cfg": [],
        }
        for name, coord in joint_names_by_coord:
            value = float(q_np[coord])
            row["joint_names"].append(name)
            row["joint_cfg"].append(value)
        frames.append(
            {
                "show_soma_mesh": False,
                "show_t3_robot": True,
                "t3_row": row,
                "fps": float(fps),
                "frame_idx": int(frame_idx),
                "kinematic_t3_demo_pick": True,
                "demo_pick_hand": hand_side,
                "demo_place_position": place_point.astype(float).tolist(),
                "demo_pick_reference_motion": str(reference_motion["path"]) if reference_active_joints else None,
                "demo_pick_reference_strength": float(reference_strength) if reference_active_joints else 0.0,
                "status": f"T3 demo pick frame {frame_idx}/{frame_count - 1}",
            }
        )
        if next_solver_q is not None:
            q.assign(next_solver_q.reshape(1, -1))
    print(
        "[ARDY Newton Viewer] generated T3 demo pick playback: "
        f"{len(frames)} frames, hand={hand_side}, fixed-base pick, place and return, "
        f"feedback_seed={'yes' if feedback_seeded else 'no'}, "
        f"reference={'yes' if reference_active_joints else 'no'}, max_ik_error={max_ik_error:.3f}m",
        flush=True,
    )
    return frames, float(fps)


def _densify_t3_demo_pick_frames(frames: list[dict], fps: float, repeat: int) -> tuple[list[dict], float]:
    repeat = max(1, int(repeat))
    if repeat <= 1 or not frames:
        return frames, float(fps)
    dense_frames: list[dict] = []
    dense_fps = float(fps) * repeat
    for frame in frames:
        for _ in range(repeat):
            frame_copy = dict(frame)
            row = dict(frame_copy.get("t3_row", {})) if isinstance(frame_copy.get("t3_row"), dict) else {}
            new_index = len(dense_frames)
            row["fps"] = dense_fps
            row["frame_idx"] = new_index
            frame_copy["t3_row"] = row
            frame_copy["fps"] = dense_fps
            frame_copy["frame_idx"] = new_index
            frame_copy["status"] = f"T3 demo pick frame {new_index}/{len(frames) * repeat - 1}"
            dense_frames.append(frame_copy)
    return dense_frames, dense_fps


def _make_t3_loaded_pose_row(*, frame_idx: int = 0, fps: float = 60.0) -> dict:
    return {
        "root_x_m": 0.0,
        "root_y_m": 0.0,
        "root_yaw_rad": 0.0,
        "fps": float(fps),
        "frame_idx": int(frame_idx),
        "joint_names": list(T3_LOADED_ARM_POSE.keys()),
        "joint_cfg": [float(value) for value in T3_LOADED_ARM_POSE.values()],
    }


def _apply_t3_loaded_pose_to_builder(builder, joint_start: int, joint_end: int) -> None:
    for joint_idx in range(int(joint_start), int(joint_end)):
        name = str(builder.joint_label[joint_idx]).rsplit("/", 1)[-1]
        if name not in T3_LOADED_ARM_POSE:
            continue
        q_start = int(builder.joint_q_start[joint_idx])
        if q_start < len(builder.joint_q):
            builder.joint_q[q_start] = float(T3_LOADED_ARM_POSE[name])


_T3_REFERENCE_MOTION_CACHE: dict[str, dict] = {}


def _load_t3_reference_motion_csv(path: str | os.PathLike | None) -> dict | None:
    if not path:
        return None
    ref_path = Path(path).expanduser()
    cache_key = str(ref_path)
    if cache_key in _T3_REFERENCE_MOTION_CACHE:
        return _T3_REFERENCE_MOTION_CACHE[cache_key]
    if not ref_path.is_file():
        raise FileNotFoundError(f"T3 reference motion CSV not found: {ref_path}")

    with ref_path.open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    if not rows:
        raise ValueError(f"T3 reference motion CSV is empty: {ref_path}")

    columns = set(rows[0])
    joint_columns = [column for column in T3_ROW_TO_JOINT if column in columns]
    if not joint_columns:
        raise ValueError(f"T3 reference motion CSV has no recognized T3 joint columns: {ref_path}")

    times = []
    joint_values = {T3_ROW_TO_JOINT[column]: [] for column in joint_columns}
    for index, row in enumerate(rows):
        if "time_s" in row and str(row["time_s"]).strip():
            time_s = float(row["time_s"])
        elif "Frame" in row and str(row["Frame"]).strip():
            time_s = float(row["Frame"]) / 30.0
        else:
            time_s = index / 30.0
        times.append(time_s)
        for column in joint_columns:
            joint_name = T3_ROW_TO_JOINT[column]
            value = float(row[column])
            if joint_name not in T3_LINEAR_JOINTS:
                value = math.radians(value)
            joint_values[joint_name].append(value)

    order = np.argsort(np.asarray(times, dtype=np.float64))
    times_np = np.asarray(times, dtype=np.float32)[order]
    if len(times_np) < 2 or not np.isfinite(times_np).all() or float(times_np[-1]) <= float(times_np[0]):
        raise ValueError(f"T3 reference motion CSV needs at least two increasing finite time samples: {ref_path}")
    values_np = {
        joint: np.asarray(values, dtype=np.float32)[order]
        for joint, values in joint_values.items()
        if np.isfinite(np.asarray(values, dtype=np.float32)).all()
    }
    reference = {
        "path": str(ref_path),
        "times": times_np,
        "joint_values": values_np,
        "duration": float(times_np[-1] - times_np[0]),
    }
    _T3_REFERENCE_MOTION_CACHE[cache_key] = reference
    print(
        "[ARDY Newton Viewer] loaded T3 reference motion: "
        f"{ref_path} ({len(times_np)} frames, {reference['duration']:.2f}s, {len(values_np)} joints)",
        flush=True,
    )
    return reference


def _sample_t3_reference_joints(reference: dict, elapsed_s: float) -> dict[str, float]:
    times = reference["times"]
    sample_t = float(times[0]) + float(np.clip(elapsed_s, 0.0, reference["duration"]))
    return {
        joint: float(np.interp(sample_t, times, values))
        for joint, values in reference["joint_values"].items()
    }


T3_EXPORT_DOF_COLUMNS = (
    "left_wheel_joint_dof",
    "right_wheel_joint_dof",
    "telescopic_lift_joint_dof",
    "waist_roll_joint_dof",
    "waist_pitch_joint_dof",
    "head_pitch_joint_dof",
    "head_yaw_joint_dof",
    "right_joint1_dof",
    "right_joint2_dof",
    "right_joint3_dof",
    "right_joint4_dof",
    "right_joint5_dof",
    "right_joint6_dof",
    "right_joint7_dof",
    "right_gripper_joint1_dof",
    "right_gripper_joint2_dof",
    "left_joint1_dof",
    "left_joint2_dof",
    "left_joint3_dof",
    "left_joint4_dof",
    "left_joint5_dof",
    "left_joint6_dof",
    "left_joint7_dof",
    "left_gripper_joint1_dof",
    "left_gripper_joint2_dof",
)

T3_EXPORT_JOINT_TO_DOF = {joint: column for column, joint in T3_ROW_TO_JOINT.items()}
T3_EXPORT_JOINT_TO_DOF.update(
    {
        "left_wheel_joint": "left_wheel_joint_dof",
        "right_wheel_joint": "right_wheel_joint_dof",
    }
)


def _format_t3_csv_value(column: str, value) -> str:
    if column in {"frame_idx", "gripper_mode"}:
        return str(value)
    numeric = float(value)
    if "gripper_joint" in column:
        # AGX validates total width as abs(joint1) + abs(joint2) <= 0.1.
        # Raw float32 values such as 0.050000000745 can export as a width of
        # 0.10000000149, so clamp and round each finger to the reference CSV
        # convention.
        numeric = float(np.clip(numeric, -0.05, 0.05))
        return f"{numeric:.6f}"
    if column == "telescopic_lift_joint_dof":
        numeric = float(np.clip(numeric, T3_LIFT_MIN_M, T3_LIFT_MAX_M))
        return f"{numeric:.6f}"
    if column in {"fps", "root_x_m", "root_y_m", "root_yaw_rad", "time_s"}:
        return f"{numeric:.9f}".rstrip("0").rstrip(".")
    return f"{numeric:.9f}".rstrip("0").rstrip(".")


def _export_latest_t3_motion_csv(frames: list[dict], output_path: str | Path | None = None) -> Path:
    if not frames:
        raise ValueError("no played T3 motion frames to export")
    path = Path(output_path) if output_path is not None else REPO_ROOT / "assets" / "latest_played_motion_gripper_aperture_m.csv"
    path = path.expanduser().resolve()
    path.parent.mkdir(parents=True, exist_ok=True)
    header = ["frame_idx", "time_s", "fps", "gripper_mode", "root_x_m", "root_y_m", "root_yaw_rad", *T3_EXPORT_DOF_COLUMNS]
    rows = []
    for out_idx, frame in enumerate(frames):
        row = frame.get("t3_row") if isinstance(frame, dict) else None
        if not isinstance(row, dict):
            continue
        fps = float(row.get("fps", frame.get("fps", 60.0) if isinstance(frame, dict) else 60.0) or 60.0)
        frame_idx = int(row.get("frame_idx", frame.get("frame_idx", out_idx) if isinstance(frame, dict) else out_idx))
        out = {column: 0.0 for column in header}
        out["frame_idx"] = frame_idx
        out["time_s"] = float(row.get("time_s", frame_idx / max(fps, 1.0e-6)))
        out["fps"] = fps
        out["gripper_mode"] = str(row.get("gripper_mode", "joint_m_signed_width_sum"))
        out["root_x_m"] = float(row.get("root_x_m", row.get("root_translateX", 0.0)))
        out["root_y_m"] = float(row.get("root_y_m", row.get("root_translateY", 0.0)))
        out["root_yaw_rad"] = float(row.get("root_yaw_rad", math.radians(float(row.get("root_rotateZ", 0.0)))))
        if "joint_names" in row and "joint_cfg" in row:
            for joint_name, value in zip(row.get("joint_names", []), row.get("joint_cfg", [])):
                joint_name = str(joint_name)
                column = T3_EXPORT_JOINT_TO_DOF.get(joint_name)
                if column not in out:
                    continue
                value = float(value)
                out[column] = value if joint_name in T3_LINEAR_JOINTS else math.degrees(value)
        else:
            for column in T3_EXPORT_DOF_COLUMNS:
                if column not in row:
                    continue
                joint_name = T3_ROW_TO_JOINT.get(column)
                value = float(row.get(column, 0.0))
                out[column] = value if joint_name in T3_LINEAR_JOINTS else value
        # Final safety clamp for paired grippers before formatting.
        for side in ("left", "right"):
            c1 = f"{side}_gripper_joint1_dof"
            c2 = f"{side}_gripper_joint2_dof"
            j1 = float(np.clip(out.get(c1, 0.0), -0.05, 0.05))
            j2 = float(np.clip(out.get(c2, 0.0), -0.05, 0.05))
            width = abs(j1) + abs(j2)
            if width > T3_GRIPPER_MAX_APERTURE_M:
                scale = T3_GRIPPER_MAX_APERTURE_M / max(width, 1.0e-9)
                j1 *= scale
                j2 *= scale
            out[c1] = round(j1, 6)
            out[c2] = round(j2, 6)
        rows.append(out)
    if not rows:
        raise ValueError("latest frames did not contain T3 rows")
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=header)
        writer.writeheader()
        for row in rows:
            writer.writerow({column: _format_t3_csv_value(column, row[column]) for column in header})
    return path


def _load_cached_t3_demo_pick_frames(bottle_position) -> tuple[list[dict], float] | None:
    if not T3_DEMO_PICK_CACHE_JSON.exists():
        return None
    try:
        payload = json.loads(T3_DEMO_PICK_CACHE_JSON.read_text())
        frames_in = payload.get("frames") or []
        demo_bottle = np.asarray(payload.get("demo_bottle", [0.50, -0.28, 0.86]), dtype=np.float64)
        target_bottle = np.asarray(bottle_position, dtype=np.float64)
        root_offset_xy = target_bottle[:2] - demo_bottle[:2]
        lift_delta = float(target_bottle[2] - demo_bottle[2])
        fps = float(payload.get("fps", 10.0))
        frames: list[dict] = []
        for frame in frames_in:
            frame_copy = dict(frame)
            row_in = frame_copy.get("t3_row") if isinstance(frame_copy.get("t3_row"), dict) else {}
            row = dict(row_in)
            row["root_x_m"] = float(row.get("root_x_m", 0.0)) + float(root_offset_xy[0])
            row["root_y_m"] = float(row.get("root_y_m", 0.0)) + float(root_offset_xy[1])
            row["fps"] = fps
            row["debug_demo_pick"] = True
            joint_names = [str(name) for name in row.get("joint_names", [])]
            joint_cfg = [float(value) for value in row.get("joint_cfg", [])]
            try:
                lift_index = joint_names.index("telescopic_lift_joint")
            except ValueError:
                lift_index = -1
            if 0 <= lift_index < len(joint_cfg):
                joint_cfg[lift_index] = float(np.clip(joint_cfg[lift_index] + lift_delta, T3_LIFT_MIN_M, T3_LIFT_MAX_M))
            row["joint_names"] = joint_names
            row["joint_cfg"] = joint_cfg
            frame_copy["t3_row"] = row
            frame_copy["fps"] = fps
            frame_copy["debug_demo_pick"] = True
            frames.append(frame_copy)
        print(
            "[ARDY Newton Viewer] loaded cached T3 demo pick playback: "
            f"{len(frames)} frames, root_offset=({root_offset_xy[0]:.3f},{root_offset_xy[1]:.3f}), "
            f"lift_delta={lift_delta:.3f}",
            flush=True,
        )
        return frames, fps
    except Exception as exc:
        print(f"[ARDY Newton Viewer] cached T3 demo pick unavailable: {exc}", flush=True)
        return None


def _ui_input_text(ui, label: str, value: str) -> str:
    try:
        changed, new_value = ui.input_text(label, value, 2048)
        return _clean_pasted_path(new_value) if changed else value
    except Exception:
        try:
            changed, new_value = ui.input_text(label, value)
            return _clean_pasted_path(new_value) if changed else value
        except Exception:
            ui.text(f"{label}:")
            ui.text(value if value else "(set ARDY_NEWTON_FILE_* env var)")
            return value


def _browse_playback_file(title: str, filetypes: tuple[tuple[str, str], ...]) -> str:
    try:
        import tkinter as tk
        from tkinter import filedialog

        root = tk.Tk()
        root.withdraw()
        root.attributes("-topmost", True)
        path = filedialog.askopenfilename(
            title=title,
            initialdir=str(DOWNLOADS_ROOT),
            filetypes=filetypes,
        )
        root.destroy()
        return _clean_pasted_path(path)
    except Exception as exc:
        print(f"[ARDY Newton Viewer] file picker failed: {exc}", flush=True)
        return ""


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="ARDY native Newton retarget viewer")
    parser.add_argument(
        "--viewer",
        choices=("gl", "rtx"),
        default=os.environ.get("ARDY_NEWTON_VIEWER", "gl").lower(),
        help="Newton viewer backend.",
    )
    parser.add_argument(
        "--background-usd",
        default=os.environ.get("ARDY_NEWTON_BACKGROUND_USD"),
        help="USD/USDA scene referenced as a visual background. Used by RTX when supported.",
    )
    parser.add_argument(
        "--camera-preset",
        choices=CAMERA_PRESET_CHOICES,
        default=os.environ.get("ARDY_NEWTON_CAMERA_PRESET", "saved_origin_back").lower(),
        help="Initial camera preset.",
    )
    parser.add_argument(
        "--rtx-environment",
        choices=("default", "studio", "none"),
        default=os.environ.get("ARDY_NEWTON_RTX_ENVIRONMENT", "studio").lower(),
        help="ViewerRTX lighting environment.",
    )
    parser.add_argument(
        "--floor-z",
        type=float,
        default=float(os.environ["ARDY_NEWTON_FLOOR_Z"]) if "ARDY_NEWTON_FLOOR_Z" in os.environ else None,
        help="Newton floor height used to align streamed SOMA/T3 meshes to the ground plane.",
    )
    parser.add_argument(
        "--pick-object-position",
        type=float,
        nargs=3,
        default=_env_vec3("ARDY_NEWTON_PICK_OBJECT_POSITION", (0.55, -0.75, 0.32)),
        metavar=("X", "Y", "Z"),
        help="Initial pick object center position in Newton coordinates.",
    )
    parser.add_argument(
        "--pick-object-size",
        type=float,
        default=float(os.environ.get("ARDY_NEWTON_PICK_OBJECT_SIZE", "0.12")),
        help="Pick object cube side length in meters.",
    )
    parser.add_argument(
        "--pick-object-push-mass-limit-kg",
        type=float,
        default=float(os.environ.get("ARDY_NEWTON_PICK_OBJECT_PUSH_MASS_LIMIT_KG", str(PICK_OBJECT_PUSH_MASS_LIMIT_KG))),
        help="Objects at or below this mass can be pushed by streamed actors; heavier objects block them.",
    )
    parser.add_argument(
        "--physics-test-shapes",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_PHYSICS_TEST_SHAPES", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Add the falling dynamic shapes from Newton's basic_shapes example.",
    )
    parser.add_argument(
        "--pick-table-physics",
        dest="pick_table_physics",
        action="store_true",
        default=_env_bool("ARDY_NEWTON_PICK_TABLE_PHYSICS", True),
        help="Add shared pick-table table collider and dynamic bottle physics independent of the background USD.",
    )
    parser.add_argument(
        "--no-pick-table-physics",
        dest="pick_table_physics",
        action="store_false",
        help="Disable pick-table table collider and dynamic bottle physics.",
    )
    parser.add_argument(
        "--pick-table-physics-backend",
        choices=("mujoco", "mujoco-gpu", "mujoco-cpu", "xpbd"),
        default=os.environ.get("ARDY_NEWTON_PICK_TABLE_PHYSICS_BACKEND", "mujoco-cpu").lower(),
        help="Physics backend for pick-table bottles. MuJoCo matches the validated T3 pick-place demo.",
    )
    parser.add_argument(
        "--physics-substeps",
        type=int,
        default=int(os.environ.get("ARDY_NEWTON_PHYSICS_SUBSTEPS", "16")),
        help="Physics substeps per rendered frame for pick-table bottle simulation.",
    )
    parser.add_argument(
        "--debug-pick-physics-substeps",
        type=int,
        default=int(os.environ.get("ARDY_NEWTON_DEBUG_PICK_PHYSICS_SUBSTEPS", "4")),
        help="Physics substeps used only while the built-in T3 demo pick playback is active.",
    )
    parser.add_argument(
        "--t3-demo-pick-reference-csv",
        default=os.environ.get(T3_DEMO_PICK_REFERENCE_CSV_ENV),
        help="Optional Kimodo/T3 CSV trajectory used as a soft reference style prior for generated T3 demo picks.",
    )
    parser.add_argument(
        "--t3-demo-pick-reference-strength",
        type=float,
        default=float(os.environ.get(T3_DEMO_PICK_REFERENCE_STRENGTH_ENV, "0.35")),
        help="How strongly generated T3 demo picks are blended toward the reference CSV posture prior, from 0 to 0.85.",
    )
    parser.add_argument(
        "--real-gripper-collision",
        action="store_true",
        default=_env_bool("ARDY_NEWTON_REAL_GRIPPER_COLLISION", True),
        help="Keep real right-gripper collision shapes active for bottle grasp debugging. Costs more FPS.",
    )
    parser.add_argument(
        "--no-real-gripper-collision",
        dest="real_gripper_collision",
        action="store_false",
        help="Use hidden lightweight gripper proxies only.",
    )
    parser.add_argument(
        "--record-video",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_RECORD_VIDEO", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Save rendered RTX frames and encode them into an MP4 when the viewer closes.",
    )
    parser.add_argument(
        "--record-output",
        default=os.environ.get("ARDY_NEWTON_RECORD_OUTPUT"),
        help="MP4 output path for --record-video.",
    )
    parser.add_argument(
        "--record-fps",
        type=float,
        default=float(os.environ.get("ARDY_NEWTON_RECORD_FPS", "10")),
        help="Capture FPS for --record-video.",
    )
    parser.add_argument(
        "--record-seconds-per-view",
        type=float,
        default=float(os.environ.get("ARDY_NEWTON_RECORD_SECONDS_PER_VIEW", "3")),
        help="Seconds recorded before cycling to the next camera preset.",
    )
    parser.add_argument(
        "--record-views",
        default=os.environ.get("ARDY_NEWTON_RECORD_VIEWS", ",".join(DEFAULT_RECORD_VIEWS)),
        help="Comma-separated views to cycle while recording; default manual records the current camera.",
    )
    parser.add_argument(
        "--playback-mode",
        choices=("realtime", "exact"),
        default=os.environ.get("ARDY_NEWTON_PLAYBACK_MODE", "exact").lower(),
        help="realtime uses the newest frame to match ARDY speed; exact renders every frame in order.",
    )
    parser.add_argument(
        "--viewer-width",
        type=int,
        default=int(os.environ.get("ARDY_NEWTON_VIEWER_WIDTH", "1180")),
        help="Native Newton viewer window width in pixels.",
    )
    parser.add_argument(
        "--viewer-height",
        type=int,
        default=int(os.environ.get("ARDY_NEWTON_VIEWER_HEIGHT", "720")),
        help="Native Newton viewer window height in pixels.",
    )
    parser.add_argument(
        "--headless",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_HEADLESS", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Run ViewerRTX without opening a window.",
    )
    parser.add_argument(
        "--num-frames",
        type=int,
        default=int(os.environ.get("ARDY_NEWTON_NUM_FRAMES", "0")),
        help="Stop after this many rendered frames in headless mode; 0 means run until closed.",
    )
    parser.add_argument(
        "--file-csv",
        default=os.environ.get("ARDY_NEWTON_FILE_CSV_PATH", ""),
        help="T3 CSV path preloaded into the native viewer File Playback panel.",
    )
    parser.add_argument(
        "--file-bvh",
        default=os.environ.get("ARDY_NEWTON_FILE_BVH_PATH", ""),
        help="SOMA BVH path preloaded into the native viewer File Playback panel.",
    )
    parser.add_argument(
        "--websocket-server",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_WEBSOCKET_SERVER", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Accept live ARDY frame payloads over a websocket instead of requiring stdin ownership.",
    )
    parser.add_argument(
        "--websocket-host",
        default=os.environ.get("ARDY_NEWTON_WEBSOCKET_HOST", "127.0.0.1"),
        help="Host/interface for --websocket-server.",
    )
    parser.add_argument(
        "--websocket-port",
        type=int,
        default=int(os.environ.get("ARDY_NEWTON_WEBSOCKET_PORT", "8765")),
        help="Port for --websocket-server.",
    )
    parser.add_argument(
        "--render-source",
        choices=("auto", RENDER_SOURCE_WEBSOCKET, RENDER_SOURCE_SIMULATION),
        default=os.environ.get("ARDY_NEWTON_RENDER_SOURCE", "auto").strip().lower(),
        help=(
            "Initial viewer data source. 'websocket' renders live received frames; "
            "'simulation' renders local IK picks and CSV/BVH playback; 'auto' uses "
            "websocket when --websocket-server is enabled."
        ),
    )
    parser.add_argument(
        "--ros-enabled",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_ROS_ENABLED", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Publish viewer T3 frames to ROS in real time.",
    )
    parser.add_argument(
        "--ros-dry-run",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_ROS_DRY_RUN", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Validate and print ROS payloads without importing ROS or publishing.",
    )
    parser.add_argument(
        "--ros-mode",
        choices=("robot", "robot_lift", "base_lift", "full"),
        default=os.environ.get("ARDY_NEWTON_ROS_MODE", "full").strip().lower(),
        help="Which T3 data the viewer should route to ROS.",
    )
    parser.add_argument(
        "--ros-feedback-enabled",
        dest="ros_feedback_enabled",
        action="store_true",
        default=_env_bool("ARDY_NEWTON_ROS_FEEDBACK_ENABLED", True),
        help="Subscribe to T3 feedback JointState topics and use them as the live initial pose.",
    )
    parser.add_argument(
        "--no-ros-feedback",
        dest="ros_feedback_enabled",
        action="store_false",
        help="Disable direct T3 feedback JointState subscriptions inside the viewer.",
    )
    parser.add_argument(
        "--right-feedback-topic",
        default=os.environ.get("ARDY_NEWTON_RIGHT_FEEDBACK_TOPIC", "/right_arm/feedback/joint_states"),
        help="Right arm feedback JointState topic used for initial-pose seeding and the green ghost overlay.",
    )
    parser.add_argument(
        "--left-feedback-topic",
        default=os.environ.get("ARDY_NEWTON_LEFT_FEEDBACK_TOPIC", "/left_arm/feedback/joint_states"),
        help="Left arm feedback JointState topic used for initial-pose seeding and the green ghost overlay.",
    )
    parser.add_argument(
        "--ovstream-webrtc",
        action="store_true",
        default=os.environ.get("ARDY_NEWTON_OVSTREAM_WEBRTC", "").strip().lower() in {"1", "true", "yes", "on"},
        help="Stream ViewerRTX output to a browser with ovstream WebRTC.",
    )
    parser.add_argument(
        "--ovstream-port",
        type=int,
        action="append",
        default=None,
        help="WebRTC signaling port for --ovstream-webrtc. May be passed multiple times.",
    )
    parser.add_argument(
        "--ovstream-stream-port",
        type=int,
        action="append",
        default=None,
        help="WebRTC media stream port for --ovstream-webrtc. May be passed multiple times.",
    )
    args = parser.parse_args()
    args.pick_object = "none"
    if args.pick_table_physics_backend == "mujoco":
        args.pick_table_physics_backend = "mujoco-cpu"
    args.ovstream_port = _resolve_repeated_ports(
        args.ovstream_port,
        os.environ.get("ARDY_NEWTON_OVSTREAM_PORT"),
        49100,
    )
    args.ovstream_stream_port = _resolve_repeated_ports(
        args.ovstream_stream_port,
        os.environ.get("ARDY_NEWTON_OVSTREAM_STREAM_PORT"),
        47998,
        count=len(args.ovstream_port),
    )
    return args


def _resolve_repeated_ports(
    cli_values: list[int] | None,
    env_value: str | None,
    default: int,
    count: int | None = None,
) -> list[int]:
    values = list(cli_values or [])
    if not values and env_value:
        for part in re.split(r"[\s,]+", env_value.strip()):
            if part:
                values.append(int(part))
    if not values:
        values = [int(default)]
    if count is not None and len(values) < count:
        next_port = int(values[-1])
        while len(values) < count:
            next_port += 1
            values.append(next_port)
    return values[:count] if count is not None else values



class OvstreamWebRtcBridge:
    def __init__(self, viewer, wp, port: int, stream_port: int, camera_preset: str):
        self.viewer = viewer
        self.wp = wp
        self.port = int(port)
        self.stream_port = int(stream_port)
        self.camera_preset = camera_preset
        self.enabled = False
        self.server = None
        self.stream_buf = None
        self.width = 0
        self.height = 0
        self.frame_count = 0
        self.drop_count = 0
        self.client_connected = False
        self._last_disconnect_time = 0.0
        self.status = "ovstream stopped"
        self._ovstream = None
        self._ovrtx_device = None
        self._draw_stream = None
        self._draw_event = None
        self._swap_kernel = None
        self._copy_rgba_kernel = None
        self._copy_vec4ub_kernel = None
        self._first_stream_logged = False
        self._first_error_logged = False
        self._first_pixel_logged = False
        self._input_count = 0
        self._left_button = False
        self._last_mouse_x = None
        self._last_mouse_y = None
        self._orbit_target = np.array([0.0, 0.0, 0.8], dtype=np.float64)
        self._orbit_radius = None
        self._orbit_theta = None
        self._orbit_phi = None

    def start(self) -> None:
        if self.enabled:
            return
        try:
            import ovstream
            from ovrtx import Device
        except Exception as exc:
            self.status = f"ovstream unavailable: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            return
        if not hasattr(self.viewer, "_render_products"):
            self.status = "ovstream requires ViewerRTX render products"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            return
        self._ovstream = ovstream
        self._ovrtx_device = Device
        self._swap_kernel = _ovstream_swap_rb_kernel(self.wp)
        self._copy_rgba_kernel = _ovstream_copy_rgba_to_bgra_kernel(self.wp)
        self._copy_vec4ub_kernel = _ovstream_copy_vec4ub_to_bgra_kernel(self.wp)
        try:
            ovstream.initialize()
            self.server = ovstream.Server(ovstream.ServerType.WEBRTC)

            def on_connection(connected):
                self.client_connected = bool(connected)
                if self.client_connected:
                    self.status = f"ovstream client connected on {self.port}"
                    self.drop_count = 0
                else:
                    self._last_disconnect_time = time.monotonic()
                    self.status = f"ovstream waiting for client on {self.port}"
                print(
                    f"[ARDY Newton Viewer] ovstream WebRTC client {'connected' if connected else 'disconnected'} "
                    f"on {self.port}",
                    flush=True,
                )

            self.server.on_connection = on_connection
            self.server.on_input = self._on_input
            self.enabled = True
            self.status = "ovstream waiting for first RTX frame"
            print(
                f"[ARDY Newton Viewer] ovstream WebRTC enabled; signaling port will be {self.port}, media port {self.stream_port}",
                flush=True,
            )
        except Exception as exc:
            self.status = f"ovstream start failed: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            self.close()

    def _ensure_orbit_camera_state(self) -> None:
        if self._orbit_radius is not None:
            return
        position, _pitch, _yaw, _fov = _camera_values(self.viewer)
        offset = position - self._orbit_target
        radius = float(np.linalg.norm(offset))
        if radius < 1.0e-4:
            radius = 4.0
            offset = np.array([0.0, -radius, 0.8], dtype=np.float64)
        horizontal = max(float(np.hypot(offset[0], offset[1])), 1.0e-6)
        self._orbit_radius = max(0.5, radius)
        self._orbit_theta = float(math.atan2(offset[1], offset[0]))
        self._orbit_phi = float(math.atan2(offset[2], horizontal))

    def _apply_orbit_camera(self) -> None:
        self._ensure_orbit_camera_state()
        phi = max(math.radians(-75.0), min(math.radians(75.0), float(self._orbit_phi)))
        radius = max(0.5, float(self._orbit_radius))
        theta = float(self._orbit_theta)
        cos_phi = math.cos(phi)
        position = self._orbit_target + np.array(
            [
                radius * cos_phi * math.cos(theta),
                radius * cos_phi * math.sin(theta),
                radius * math.sin(phi),
            ],
            dtype=np.float64,
        )
        if position[2] < 0.1:
            position[2] = 0.1
        _set_camera_look_at(self.viewer, self.wp, position, self._orbit_target)

    def _reset_orbit_camera(self) -> None:
        _set_camera_by_name(self.viewer, self.wp, self.camera_preset)
        self._orbit_radius = None
        self._orbit_theta = None
        self._orbit_phi = None

    def _on_input(self, event) -> None:
        try:
            self._input_count += 1
            if self._input_count <= 5:
                print(f"[ARDY Newton Viewer] ovstream input {event.type.name}", flush=True)
            if event.type == self._ovstream.InputEventType.MOUSE:
                mouse = event.mouse
                if mouse.type == self._ovstream.MouseEventType.BUTTON:
                    if mouse.data == self._ovstream.MouseButton.LEFT:
                        self._left_button = mouse.button_state == self._ovstream.KeyState.DOWN
                        self._last_mouse_x = mouse.x
                        self._last_mouse_y = mouse.y
                        self._ensure_orbit_camera_state()
                elif mouse.type == self._ovstream.MouseEventType.MOVE:
                    if self._left_button and self._last_mouse_x is not None and self._last_mouse_y is not None:
                        self._ensure_orbit_camera_state()
                        dx = float(mouse.x - self._last_mouse_x)
                        dy = float(mouse.y - self._last_mouse_y)
                        self._orbit_theta -= dx * 0.005
                        self._orbit_phi += dy * 0.005
                        self._apply_orbit_camera()
                    self._last_mouse_x = mouse.x
                    self._last_mouse_y = mouse.y
                elif mouse.type == self._ovstream.MouseEventType.WHEEL:
                    self._ensure_orbit_camera_state()
                    self._orbit_radius = max(0.5, float(self._orbit_radius) - float(mouse.scroll_y) * 0.25)
                    self._apply_orbit_camera()
            elif event.type == self._ovstream.InputEventType.KEYBOARD:
                if event.keyboard.key_state == self._ovstream.KeyState.DOWN:
                    self._reset_orbit_camera()
        except Exception as exc:
            print(f"[ARDY Newton Viewer] ovstream input failed: {exc}", flush=True)

    def stream_latest(self) -> None:
        if not self.enabled or self._ovstream is None:
            return
        products = getattr(self.viewer, "_render_products", None)
        if products is None:
            return
        if self.server is None:
            return
        if not self.client_connected and self.stream_buf is not None:
            self.status = f"ovstream waiting for client on {self.port}"
            return
        try:
            for _pname, product in products.items():
                for frame in product.frames:
                    render_var = frame.render_vars.get("LdrColor")
                    if render_var is None:
                        continue
                    with render_var.map(device=self._ovrtx_device.CUDA) as mapping:
                        tensor_obj = getattr(mapping, "tensor", None)
                        source = None
                        if tensor_obj is not None:
                            try:
                                source = self.wp.from_dlpack(tensor_obj)
                            except Exception:
                                source = None
                        if source is None:
                            source = self.wp.from_dlpack(mapping, dtype=self.wp.vec4ub)
                        if source.ndim == 3 and source.shape[2] == 4 and source.dtype == self.wp.uint8:
                            height, source_width = int(source.shape[0]), int(source.shape[1])
                            stream_width = _ovstream_encoder_safe_width(source_width)
                            self._ensure_started(stream_width, height)
                            self.wp.launch(
                                self._copy_rgba_kernel,
                                dim=(self.width, self.height),
                                inputs=[source, self.stream_buf],
                                device="cuda:0",
                            )
                        elif source.ndim == 2 and source.dtype == self.wp.vec4ub:
                            height, source_width = int(source.shape[0]), int(source.shape[1])
                            stream_width = _ovstream_encoder_safe_width(source_width)
                            self._ensure_started(stream_width, height)
                            self.wp.launch(
                                self._copy_vec4ub_kernel,
                                dim=(self.width, self.height),
                                inputs=[source, self.stream_buf],
                                device="cuda:0",
                            )
                        else:
                            self.status = f"ovstream unexpected frame shape/dtype: {source.shape} {source.dtype}"
                            if not self._first_error_logged:
                                print(f"[ARDY Newton Viewer] {self.status}", flush=True)
                                self._first_error_logged = True
                            return
                        self.wp.synchronize_device("cuda:0")
                    if not self._first_pixel_logged:
                        sample = self.stream_buf.numpy()
                        mean = float(np.mean(sample[:, :, :3]))
                        std = float(np.std(sample[:, :, :3]))
                        alpha_mean = float(np.mean(sample[:, :, 3]))
                        self.status = (
                            f"ovstream buffer {self.width}x{self.height} "
                            f"rgb_mean={mean:.2f} rgb_std={std:.2f} alpha_mean={alpha_mean:.2f}"
                        )
                        print(f"[ARDY Newton Viewer] {self.status}", flush=True)
                        self._first_pixel_logged = True
                    if not self.client_connected:
                        if time.monotonic() - self._last_disconnect_time < 0.5:
                            self.status = f"ovstream reconnect settling on {self.port}"
                        else:
                            self.status = f"ovstream ready on {self.port}; waiting for client"
                        return
                    self._draw_stream.record_event(self._draw_event)
                    video_frame = self._ovstream.VideoFrame.from_cuda_array(
                        self.stream_buf,
                        sync=self._ovstream.CudaSync(
                            stream=self._draw_stream.cuda_stream,
                            wait_event=self._draw_event.cuda_event,
                        ),
                    )
                    try:
                        self.server.stream_video(video_frame)
                    except self._ovstream.OvstreamError as exc:
                        self.drop_count += 1
                        message = str(exc)
                        self.status = f"ovstream stream_video failed: {message} drops={self.drop_count}"
                        if self.client_connected or "no client connected" not in message.lower():
                            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
                        return
                    self.frame_count += 1
                    self.status = f"ovstream WebRTC {self.width}x{self.height} frames={self.frame_count} drops={self.drop_count}"
                    if not self._first_stream_logged:
                        print(f"[ARDY Newton Viewer] {self.status}", flush=True)
                        self._first_stream_logged = True
                    return
        except Exception as exc:
            self.status = f"ovstream stream failed: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            self.enabled = False

    def _ensure_started(self, width: int, height: int) -> None:
        if self.server is None:
            raise RuntimeError("ovstream server was not created")
        if self.stream_buf is not None and self.width == width and self.height == height:
            return
        if self.stream_buf is not None:
            raise RuntimeError(
                f"ovstream frame size changed from {self.width}x{self.height} to {width}x{height}"
            )
        self.width = width
        self.height = height
        self.stream_buf = self.wp.zeros((height, width, 4), dtype=self.wp.uint8, device="cuda:0")
        self._draw_stream = self.wp.get_stream("cuda:0")
        self._draw_event = self.wp.Event(device="cuda:0")
        cuda_context = int(self.wp.get_device("cuda:0").context)
        cfg = self._ovstream.ServerConfig(
            width=width,
            height=height,
            cuda_device=0,
            cuda_context=cuda_context,
        )
        cfg.webrtc_signal_port = self.port
        cfg.stream_port = self.stream_port
        self.server.start(cfg)
        print(
            f"[ARDY Newton Viewer] ovstream WebRTC signal port {self.port}, media port {self.stream_port}; "
            f"open ovstream-src/examples/webrtc_client/index.html and connect to 127.0.0.1:{self.port}",
            flush=True,
        )

    def close(self) -> None:
        if self.server is not None:
            try:
                self.server.stop()
            except Exception:
                pass
            try:
                self.server.close()
            except Exception:
                pass
            self.server = None
        if self._ovstream is not None:
            try:
                self._ovstream.shutdown()
            except Exception:
                pass
        self.enabled = False
        self.status = "ovstream stopped"


def _ovstream_swap_rb_kernel(wp):
    @wp.kernel
    def swap_rb(buf: wp.array3d(dtype=wp.uint8)):
        x, y = wp.tid()
        r = buf[y, x, 0]
        b = buf[y, x, 2]
        buf[y, x, 0] = b
        buf[y, x, 2] = r
        buf[y, x, 3] = wp.uint8(255)

    return swap_rb


def _ovstream_encoder_safe_width(width: int) -> int:
    safe_width = int(width) - (int(width) % 8)
    return max(8, safe_width)


def _ovstream_copy_rgba_to_bgra_kernel(wp):
    @wp.kernel
    def copy_rgba_to_bgra(src: wp.array3d(dtype=wp.uint8), dst: wp.array3d(dtype=wp.uint8)):
        x, y = wp.tid()
        dst[y, x, 0] = src[y, x, 2]
        dst[y, x, 1] = src[y, x, 1]
        dst[y, x, 2] = src[y, x, 0]
        dst[y, x, 3] = wp.uint8(255)

    return copy_rgba_to_bgra


def _ovstream_copy_vec4ub_to_bgra_kernel(wp):
    @wp.kernel
    def copy_vec4ub_to_bgra(src: wp.array2d(dtype=wp.vec4ub), dst: wp.array3d(dtype=wp.uint8)):
        x, y = wp.tid()
        rgba = src[y, x]
        dst[y, x, 0] = rgba[2]
        dst[y, x, 1] = rgba[1]
        dst[y, x, 2] = rgba[0]
        dst[y, x, 3] = wp.uint8(255)

    return copy_vec4ub_to_bgra


def _create_viewer(newton, args: argparse.Namespace):
    width = max(320, int(args.viewer_width))
    height = max(240, int(args.viewer_height))
    if args.headless and args.viewer != "rtx":
        raise RuntimeError("--headless is currently supported only with --viewer rtx")
    if args.viewer == "rtx":
        try:
            viewer = newton.viewer.ViewerRTX(
                width=width,
                height=height,
                vsync=True,
                environment=args.rtx_environment,
                async_rendering=True,
                headless=bool(args.headless),
                num_frames=int(args.num_frames) if int(args.num_frames) > 0 else None,
            )
            _wrap_rtx_init_logging(viewer)
            return viewer
        except ImportError as exc:
            raise RuntimeError(
                "Newton RTX viewer dependencies are missing. Install/sync Newton with its rtx extra "
                "(for example: cd /home/jony/Downloads/newton/repos/newton && uv sync --extra rtx) "
                "or launch ARDY with --newton-viewer gl."
            ) from exc
    return newton.viewer.ViewerGL(width=width, height=height, vsync=True)


def _wrap_rtx_init_logging(viewer) -> None:
    init_ovrtx = getattr(viewer, "_init_ovrtx", None)
    if init_ovrtx is None:
        return

    def logged_init_ovrtx():
        print("[ARDY Newton Viewer] RTX init: exporting/opening USD in OVRTX", flush=True)
        start = time.monotonic()
        try:
            return init_ovrtx()
        finally:
            elapsed = time.monotonic() - start
            has_window = bool(getattr(viewer, "_window", None) is not None)
            phase = getattr(viewer, "_phase", None)
            print(
                f"[ARDY Newton Viewer] RTX init: returned after {elapsed:.2f}s "
                f"(window_created={has_window}, phase={phase})",
                flush=True,
            )

    viewer._init_ovrtx = logged_init_ovrtx


def _add_background_usd(viewer, background_usd: str | None) -> None:
    if not background_usd:
        return
    path = Path(background_usd).expanduser().resolve()
    if not path.is_file():
        raise FileNotFoundError(f"Background USD not found: {path}")
    if hasattr(viewer, "add_background_usd"):
        viewer.add_background_usd(str(path))
        print(f"[ARDY Newton Viewer] referenced background USD: {path}", flush=True)
        return
    if hasattr(viewer, "stage"):
        try:
            from pxr import UsdGeom

            bg_prim = viewer.stage.DefinePrim("/root/background")
            bg_prim.GetReferences().AddReference(str(path))
            if hasattr(viewer, "_ensure_scopes_for_path"):
                viewer._ensure_scopes_for_path(viewer.stage, "/root/background")
            print(f"[ARDY Newton Viewer] referenced background USD: {path}", flush=True)
            return
        except Exception as exc:
            raise RuntimeError(f"Failed to attach background USD {path}: {exc}") from exc
    print("[ARDY Newton Viewer] background USD ignored because this viewer has no USD stage", flush=True)


def _infer_background_floor_z(background_usd: str | None) -> float | None:
    if not background_usd:
        return None
    path = Path(background_usd).expanduser().resolve()
    if not path.is_file():
        return None
    try:
        from pxr import Usd, UsdGeom

        stage = Usd.Stage.Open(str(path))
        if stage is None:
            return None
        purposes = [UsdGeom.Tokens.default_, UsdGeom.Tokens.render, UsdGeom.Tokens.proxy]
        cache = UsdGeom.BBoxCache(Usd.TimeCode.Default(), purposes, useExtentsHint=True)
        candidates: list[tuple[float, float, str]] = []
        for prim in stage.Traverse():
            prim_path = str(prim.GetPath()).lower()
            if "ceiling" in prim_path or not any(
                token in prim_path for token in ("floor", "ground", "carpet", "rug", "tile", "plane")
            ):
                continue
            if not prim.IsA(UsdGeom.Boundable):
                continue
            box = cache.ComputeWorldBound(prim).ComputeAlignedBox()
            mins = box.GetMin()
            maxs = box.GetMax()
            min_z = float(mins[2])
            max_z = float(maxs[2])
            if not np.isfinite(min_z) or not np.isfinite(max_z):
                continue
            size_x = float(maxs[0] - mins[0])
            size_y = float(maxs[1] - mins[1])
            thickness = max_z - min_z
            if size_x < 1.0 or size_y < 1.0 or thickness < 0.0 or thickness > 0.5 or max_z > 1.0:
                continue
            area = size_x * size_y
            candidates.append((max_z, area, str(prim.GetPath())))
        if not candidates:
            return None
        # Prefer the highest broad floor surface; wrappers and structural slabs
        # can sit below the visible walkable finish.
        floor_z, area, prim_path = max(candidates, key=lambda item: (round(item[0], 4), item[1]))
        print(
            f"[ARDY Newton Viewer] inferred background floor_z={floor_z:.3f} from {prim_path}",
            flush=True,
        )
        return float(floor_z)
    except Exception as exc:
        print(f"[ARDY Newton Viewer] could not infer background floor height: {exc}", flush=True)
        return None


def _resolve_floor_z(args: argparse.Namespace) -> float:
    if args.floor_z is not None:
        return float(args.floor_z)
    inferred = _infer_background_floor_z(args.background_usd)
    if inferred is not None:
        args.floor_z = inferred
        return inferred
    args.floor_z = 0.0
    print("[ARDY Newton Viewer] using default floor_z=0.000", flush=True)
    return 0.0


def _set_camera_preset(viewer, wp, preset: str) -> None:
    position, pitch, yaw = CAMERA_PRESETS.get(preset, CAMERA_PRESETS["default"])
    viewer.set_camera(wp.vec3(*position), pitch, yaw)


def _set_camera_look_at(viewer, wp, position: np.ndarray, target: np.ndarray) -> None:
    position = np.asarray(position, dtype=np.float64)
    target = np.asarray(target, dtype=np.float64)
    direction = target - position
    horizontal = float(np.linalg.norm(direction[:2]))
    if horizontal < 1.0e-6:
        horizontal = 1.0e-6
    yaw = math.degrees(math.atan2(float(direction[1]), float(direction[0])))
    pitch = math.degrees(math.atan2(float(direction[2]), horizontal))
    viewer.set_camera(wp.vec3(float(position[0]), float(position[1]), float(position[2])), pitch, yaw)


def _set_fixed_record_shot(viewer, wp, name: str) -> None:
    position, target, fov = FIXED_RECORD_SHOTS[name]
    if hasattr(viewer, "camera") and hasattr(viewer.camera, "fov"):
        viewer.camera.fov = min(float(getattr(viewer.camera, "fov", fov)), float(fov))
    _set_camera_look_at(viewer, wp, np.asarray(position, dtype=np.float64), np.asarray(target, dtype=np.float64))


def _set_direct_camera_shot(viewer, wp, name: str) -> None:
    position, pitch, yaw, fov = DIRECT_CAMERA_SHOTS[name]
    if hasattr(viewer, "camera") and hasattr(viewer.camera, "fov"):
        viewer.camera.fov = float(fov)
    viewer.set_camera(wp.vec3(float(position[0]), float(position[1]), float(position[2])), float(pitch), float(yaw))


def _set_camera_by_name(viewer, wp, name: str) -> None:
    if name in DIRECT_CAMERA_SHOTS:
        _set_direct_camera_shot(viewer, wp, name)
    else:
        _set_camera_preset(viewer, wp, name)


def _camera_values(viewer) -> tuple[np.ndarray, float, float, float]:
    camera = getattr(viewer, "camera", None)
    pos = getattr(camera, "pos", (0.0, 0.0, 0.0))
    try:
        position = np.array([float(pos[0]), float(pos[1]), float(pos[2])], dtype=np.float64)
    except Exception:
        position = np.zeros(3, dtype=np.float64)
    pitch = float(getattr(camera, "pitch", 0.0))
    yaw = float(getattr(camera, "yaw", 0.0))
    fov = float(getattr(camera, "fov", 0.0))
    return position, pitch, yaw, fov


def _camera_preset_line(viewer, name: str = "manual_saved") -> str:
    position, pitch, yaw, fov = _camera_values(viewer)
    return (
        f'"{name}": '
        f'(({position[0]:.3f}, {position[1]:.3f}, {position[2]:.3f}), '
        f"{pitch:.3f}, {yaw:.3f}),  # fov={fov:.3f}"
    )


def _print_camera_values(viewer) -> None:
    position, pitch, yaw, fov = _camera_values(viewer)
    print(
        "[ARDY Newton Viewer] camera "
        f"pos=({position[0]:.3f}, {position[1]:.3f}, {position[2]:.3f}) "
        f"pitch={pitch:.3f} yaw={yaw:.3f} fov={fov:.3f}",
        flush=True,
    )
    print(f"[ARDY Newton Viewer] camera preset: {_camera_preset_line(viewer)}", flush=True)


def _record_view_names(raw_views: str | None) -> list[str]:
    views = []
    for item in (raw_views or "").split(","):
        name = item.strip().lower()
        if (
            name == "manual"
            or name in DIRECT_CAMERA_SHOTS
            or name in FIXED_RECORD_SHOTS
            or name in CAMERA_PRESETS
            or name in RECORD_VIEW_OFFSETS
        ) and name not in views:
            views.append(name)
    return views or list(DEFAULT_RECORD_VIEWS)


def _default_record_output() -> Path:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return REPO_ROOT / ".cache" / "t3_live" / "recordings" / f"ardy_newton_rtx_{timestamp}.mp4"


class RtxVideoRecorder:
    def __init__(self, viewer, wp, args: argparse.Namespace):
        self.viewer = viewer
        self.wp = wp
        self.enabled = bool(args.record_video and args.viewer == "rtx")
        self.fps = max(0.25, float(args.record_fps))
        self.seconds_per_view = max(0.1, float(args.record_seconds_per_view))
        self.views = _record_view_names(args.record_views)
        self.output_path = Path(args.record_output).expanduser() if args.record_output else _default_record_output()
        self.frames_dir = self.output_path.with_suffix("") / "frames"
        self.frame_count = 0
        self._last_capture_time = 0.0
        self._current_view = None
        self._error = None
        self._finalized = False
        if self.enabled:
            self.frames_dir.mkdir(parents=True, exist_ok=True)
            print(
                "[ARDY Newton Viewer] recording enabled: "
                f"output={self.output_path}, fps={self.fps:g}, views={','.join(self.views)}",
                flush=True,
            )

    def begin_frame(self, target: np.ndarray | None = None) -> None:
        if not self.enabled:
            return
        frames_per_view = max(1, int(round(self.fps * self.seconds_per_view)))
        view = self.views[(self.frame_count // frames_per_view) % len(self.views)]
        if view == "manual":
            return
        if view in DIRECT_CAMERA_SHOTS:
            if view != self._current_view:
                _set_direct_camera_shot(self.viewer, self.wp, view)
                self._current_view = view
            return
        if view in FIXED_RECORD_SHOTS:
            if view != self._current_view:
                _set_fixed_record_shot(self.viewer, self.wp, view)
                self._current_view = view
            return
        if view in RECORD_VIEW_OFFSETS:
            target_np = np.asarray(target if target is not None else (0.0, 0.0, 1.0), dtype=np.float64)
            camera_offset, target_offset = RECORD_VIEW_OFFSETS[view]
            camera_position = target_np + np.asarray(camera_offset, dtype=np.float64)
            look_target = target_np + np.asarray(target_offset, dtype=np.float64)
            if hasattr(self.viewer, "camera") and hasattr(self.viewer.camera, "fov"):
                self.viewer.camera.fov = float(RECORD_VIEW_FOV.get(view, 45.0))
            _set_camera_look_at(self.viewer, self.wp, camera_position, look_target)
            self._current_view = view
            return
        if view != self._current_view:
            _set_camera_preset(self.viewer, self.wp, view)
            self._current_view = view

    def maybe_capture(self, now: float) -> None:
        if not self.enabled or self._error is not None:
            return
        interval = 1.0 / self.fps
        if self.frame_count > 0 and now - self._last_capture_time < interval:
            return
        frame_path = self.frames_dir / f"frame_{self.frame_count:06d}.png"
        try:
            if hasattr(self.viewer, "_capture_screenshot_pixels"):
                pixels = self.viewer._capture_screenshot_pixels()
                if float(np.mean(pixels)) < 2.0 or float(np.std(pixels)) < 1.0:
                    return
                from PIL import Image

                Image.fromarray(pixels).save(frame_path)
            else:
                self.viewer.save_screenshot(str(frame_path))
        except Exception as exc:
            self._error = f"recording failed while saving frame {self.frame_count}: {exc}"
            print(f"[ARDY Newton Viewer] {self._error}", flush=True)
            return
        self._last_capture_time = now
        self.frame_count += 1

    def status(self) -> str:
        if not self.enabled:
            return ""
        if self._error is not None:
            return self._error
        return f"Recording {self.frame_count} frames -> {self.output_path.name}"

    def finalize(self) -> None:
        if not self.enabled:
            return
        if self._finalized:
            return
        self._finalized = True
        if self.frame_count <= 0:
            print("[ARDY Newton Viewer] recording skipped: no frames captured", flush=True)
            return
        self.output_path.parent.mkdir(parents=True, exist_ok=True)
        cmd = [
            "ffmpeg",
            "-y",
            "-framerate",
            f"{self.fps:g}",
            "-i",
            str(self.frames_dir / "frame_%06d.png"),
            "-c:v",
            "libx264",
            "-pix_fmt",
            "yuv420p",
            "-movflags",
            "+faststart",
            str(self.output_path),
        ]
        print(f"[ARDY Newton Viewer] encoding video with ffmpeg: {self.output_path}", flush=True)
        try:
            completed = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, check=False)
        except FileNotFoundError:
            print(
                f"[ARDY Newton Viewer] ffmpeg not found; PNG frames are in {self.frames_dir}",
                flush=True,
            )
            return
        if completed.returncode != 0:
            tail = "\n".join(completed.stdout.splitlines()[-20:])
            print(
                f"[ARDY Newton Viewer] ffmpeg failed ({completed.returncode}); PNG frames are in {self.frames_dir}\n{tail}",
                flush=True,
            )
            return
        print(
            f"[ARDY Newton Viewer] recorded {self.frame_count} frames to {self.output_path}",
            flush=True,
        )


def _tx_position(tx) -> np.ndarray:
    return np.array([float(tx.p[0]), float(tx.p[1]), float(tx.p[2])], dtype=np.float64)


def _tx_quat(tx) -> np.ndarray:
    return np.array([float(tx.q[0]), float(tx.q[1]), float(tx.q[2]), float(tx.q[3])], dtype=np.float64)


def _tx_array_parts(tx: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    tx = np.asarray(tx, dtype=np.float64)
    return tx[0:3], tx[3:7]


def _make_tx(wp, position: np.ndarray, quat_xyzw: np.ndarray):
    return wp.transform(
        wp.vec3(float(position[0]), float(position[1]), float(position[2])),
        wp.quat(float(quat_xyzw[0]), float(quat_xyzw[1]), float(quat_xyzw[2]), float(quat_xyzw[3])),
    )


def _tx_to_numpy(tx) -> np.ndarray:
    return np.array([tx.p[0], tx.p[1], tx.p[2], tx.q[0], tx.q[1], tx.q[2], tx.q[3]], dtype=np.float32)


def _ardy_position_to_newton(position: np.ndarray) -> np.ndarray:
    return np.asarray(position, dtype=np.float64) @ ARDY_Y_UP_TO_NEWTON_Z_UP.T


def _ardy_wxyz_to_newton_xyzw(wxyz: np.ndarray) -> np.ndarray:
    wxyz = np.asarray(wxyz, dtype=np.float64)
    if wxyz.shape[0] != 4:
        return np.array([0.0, 0.0, 0.0, 1.0], dtype=np.float64)
    ardy_xyzw = np.array([wxyz[1], wxyz[2], wxyz[3], wxyz[0]], dtype=np.float64)
    ardy_rot = Rotation.from_quat(ardy_xyzw).as_matrix()
    newton_rot = ARDY_Y_UP_TO_NEWTON_Z_UP @ ardy_rot @ ARDY_Y_UP_TO_NEWTON_Z_UP.T
    return Rotation.from_matrix(newton_rot).as_quat()


def _apply_tx_to_points(tx, points: np.ndarray) -> np.ndarray:
    rot = Rotation.from_quat(_tx_quat(tx))
    return (rot.apply(points.astype(np.float64)) + _tx_position(tx)).astype(np.float32)


def _transform_points_np(tx: np.ndarray, points: np.ndarray) -> np.ndarray:
    position, quat = _tx_array_parts(tx)
    return Rotation.from_quat(quat).apply(points) + position


def _mul_transform_np(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    a_pos, a_quat = _tx_array_parts(a)
    b_pos, b_quat = _tx_array_parts(b)
    a_rot = Rotation.from_quat(a_quat)
    pos = a_pos + a_rot.apply(b_pos)
    quat = (a_rot * Rotation.from_quat(b_quat)).as_quat()
    return np.concatenate([pos, quat])


def _lift_csv_value_to_extension_m(value: float) -> float:
    value = float(value)
    if value <= T3_LIFT_MAX_M:
        return float(np.clip(value, T3_LIFT_MIN_M, T3_LIFT_MAX_M))
    return float(np.clip((value - T3_LIFT_DISPLAY_BASE_CM) / 100.0, T3_LIFT_MIN_M, T3_LIFT_MAX_M))


def _shape_local_bounds(newton, shape_type: int, scale: np.ndarray, source) -> tuple[np.ndarray, np.ndarray] | None:
    scale = np.abs(np.asarray(scale, dtype=np.float64))
    if int(shape_type) in (int(newton.GeoType.MESH), int(newton.GeoType.CONVEX_MESH)):
        if not hasattr(source, "vertices"):
            return None
        vertices = np.asarray(source.vertices, dtype=np.float64)
        if vertices.size == 0:
            return None
        points = vertices * scale
        return np.min(points, axis=0), np.max(points, axis=0)
    if int(shape_type) == int(newton.GeoType.BOX):
        half_extents = scale[:3]
    elif int(shape_type) == int(newton.GeoType.SPHERE):
        radius = float(scale[0])
        half_extents = np.array([radius, radius, radius], dtype=np.float64)
    elif int(shape_type) == int(newton.GeoType.ELLIPSOID):
        half_extents = scale[:3]
    elif int(shape_type) == int(newton.GeoType.CAPSULE):
        radius = float(scale[0])
        half_height = float(scale[1])
        half_extents = np.array([radius, radius, half_height + radius], dtype=np.float64)
    elif int(shape_type) == int(newton.GeoType.CYLINDER):
        radius = float(max(scale[0], scale[2]))
        half_extents = np.array([radius, radius, float(scale[1])], dtype=np.float64)
    else:
        return None
    return -half_extents, half_extents


def _bounds_corners(mins: np.ndarray, maxs: np.ndarray) -> np.ndarray:
    return np.array(
        [
            [mins[0], mins[1], mins[2]],
            [mins[0], mins[1], maxs[2]],
            [mins[0], maxs[1], mins[2]],
            [mins[0], maxs[1], maxs[2]],
            [maxs[0], mins[1], mins[2]],
            [maxs[0], mins[1], maxs[2]],
            [maxs[0], maxs[1], mins[2]],
            [maxs[0], maxs[1], maxs[2]],
        ],
        dtype=np.float64,
    )


def _robot_shape_bounds(
    newton,
    model,
    state,
    shape_count: int | None = None,
    *,
    require_collision: bool = False,
    body_suffixes: tuple[str, ...] | None = None,
) -> tuple[np.ndarray, np.ndarray] | None:
    body_q = state.body_q.numpy()
    shape_body = model.shape_body.numpy() if hasattr(model.shape_body, "numpy") else model.shape_body
    shape_transform = model.shape_transform.numpy() if hasattr(model.shape_transform, "numpy") else model.shape_transform
    shape_scale = model.shape_scale.numpy() if hasattr(model.shape_scale, "numpy") else model.shape_scale
    shape_type = model.shape_type.numpy() if hasattr(model.shape_type, "numpy") else model.shape_type
    shape_flags = model.shape_flags.numpy() if hasattr(model.shape_flags, "numpy") else model.shape_flags

    point_values = []
    for shape_idx in range(model.shape_count if shape_count is None else min(shape_count, model.shape_count)):
        body_idx = int(shape_body[shape_idx])
        if body_idx < 0:
            continue
        if body_suffixes is not None:
            body_label = str(model.body_label[body_idx]).rsplit("/", 1)[-1]
            if body_label not in body_suffixes:
                continue
        if require_collision and not (int(shape_flags[shape_idx]) & int(newton.ShapeFlags.COLLIDE_SHAPES)):
            continue
        local_bounds = _shape_local_bounds(
            newton,
            int(shape_type[shape_idx]),
            np.asarray(shape_scale[shape_idx], dtype=np.float64),
            model.shape_source[shape_idx],
        )
        if local_bounds is None:
            continue
        shape_world_tx = _mul_transform_np(
            np.asarray(body_q[body_idx], dtype=np.float64),
            np.asarray(shape_transform[shape_idx], dtype=np.float64),
        )
        points = _bounds_corners(*local_bounds)
        point_values.append(_transform_points_np(shape_world_tx, points))

    if not point_values:
        return None
    all_points = np.concatenate(point_values, axis=0)
    return np.min(all_points, axis=0), np.max(all_points, axis=0)


def _body_shape_bounds(
    newton,
    model,
    state,
    body_idx: int,
    shape_count: int | None = None,
) -> tuple[np.ndarray, np.ndarray] | None:
    if body_idx < 0:
        return None
    body_q = state.body_q.numpy()
    shape_body = model.shape_body.numpy() if hasattr(model.shape_body, "numpy") else model.shape_body
    shape_transform = model.shape_transform.numpy() if hasattr(model.shape_transform, "numpy") else model.shape_transform
    shape_scale = model.shape_scale.numpy() if hasattr(model.shape_scale, "numpy") else model.shape_scale
    shape_type = model.shape_type.numpy() if hasattr(model.shape_type, "numpy") else model.shape_type

    point_values = []
    for shape_idx in range(model.shape_count if shape_count is None else min(shape_count, model.shape_count)):
        if int(shape_body[shape_idx]) != int(body_idx):
            continue
        local_bounds = _shape_local_bounds(
            newton,
            int(shape_type[shape_idx]),
            np.asarray(shape_scale[shape_idx], dtype=np.float64),
            model.shape_source[shape_idx],
        )
        if local_bounds is None:
            continue
        shape_world_tx = _mul_transform_np(
            np.asarray(body_q[body_idx], dtype=np.float64),
            np.asarray(shape_transform[shape_idx], dtype=np.float64),
        )
        point_values.append(_transform_points_np(shape_world_tx, _bounds_corners(*local_bounds)))
    if not point_values:
        return None
    all_points = np.concatenate(point_values, axis=0)
    return np.min(all_points, axis=0), np.max(all_points, axis=0)


def _bounds_overlap_xy(bounds: tuple[np.ndarray, np.ndarray], center: list[float], size: float) -> bool:
    mins, maxs = bounds
    half = float(size) * 0.5
    return (
        maxs[0] >= float(center[0]) - half
        and mins[0] <= float(center[0]) + half
        and maxs[1] >= float(center[1]) - half
        and mins[1] <= float(center[1]) + half
    )


def _support_height_for_bounds(
    bounds: tuple[np.ndarray, np.ndarray] | None,
    floor_z: float,
) -> float | None:
    if bounds is None:
        return None
    mins, _ = bounds
    return float(floor_z) - float(mins[2])


def _push_pick_object_from_bounds(
    actor_bounds: tuple[np.ndarray, np.ndarray] | None,
    pick_position: list[float],
    pick_size: float,
    pick_visible: bool,
    pick_pushable: bool,
    floor_z: float,
) -> bool:
    if not pick_visible or not pick_pushable or actor_bounds is None:
        return False
    if not _bounds_overlap_xy(actor_bounds, pick_position, pick_size):
        return False

    actor_mins, actor_maxs = actor_bounds
    half = float(pick_size) * 0.5
    cube_mins = np.array([float(pick_position[0]) - half, float(pick_position[1]) - half], dtype=np.float64)
    cube_maxs = np.array([float(pick_position[0]) + half, float(pick_position[1]) + half], dtype=np.float64)
    actor_xy_min = actor_mins[:2]
    actor_xy_max = actor_maxs[:2]
    actor_center = (actor_xy_min + actor_xy_max) * 0.5
    cube_center = np.array([float(pick_position[0]), float(pick_position[1])], dtype=np.float64)

    overlaps = np.array(
        [
            min(actor_xy_max[0] - cube_mins[0], cube_maxs[0] - actor_xy_min[0]),
            min(actor_xy_max[1] - cube_mins[1], cube_maxs[1] - actor_xy_min[1]),
        ],
        dtype=np.float64,
    )
    axis = int(np.argmin(overlaps))
    direction = 1.0 if cube_center[axis] >= actor_center[axis] else -1.0
    if abs(cube_center[axis] - actor_center[axis]) < 1.0e-6:
        direction = 1.0
    pick_position[axis] += direction * (float(overlaps[axis]) + 0.015)
    pick_position[2] = max(float(pick_position[2]), float(floor_z) + half)
    return True


def _actor_separation_from_pick_object(
    actor_bounds: tuple[np.ndarray, np.ndarray] | None,
    pick_position: list[float],
    pick_size: float,
    pick_visible: bool,
    pick_pushable: bool,
) -> np.ndarray:
    if not pick_visible or pick_pushable or actor_bounds is None:
        return np.zeros(2, dtype=np.float64)
    if not _bounds_overlap_xy(actor_bounds, pick_position, pick_size):
        return np.zeros(2, dtype=np.float64)

    actor_mins, actor_maxs = actor_bounds
    half = float(pick_size) * 0.5
    cube_mins = np.array([float(pick_position[0]) - half, float(pick_position[1]) - half], dtype=np.float64)
    cube_maxs = np.array([float(pick_position[0]) + half, float(pick_position[1]) + half], dtype=np.float64)
    actor_xy_min = actor_mins[:2]
    actor_xy_max = actor_maxs[:2]
    actor_center = (actor_xy_min + actor_xy_max) * 0.5
    cube_center = np.array([float(pick_position[0]), float(pick_position[1])], dtype=np.float64)
    overlaps = np.array(
        [
            min(actor_xy_max[0] - cube_mins[0], cube_maxs[0] - actor_xy_min[0]),
            min(actor_xy_max[1] - cube_mins[1], cube_maxs[1] - actor_xy_min[1]),
        ],
        dtype=np.float64,
    )
    axis = int(np.argmin(overlaps))
    direction = 1.0 if actor_center[axis] >= cube_center[axis] else -1.0
    if abs(actor_center[axis] - cube_center[axis]) < 1.0e-6:
        direction = -1.0
    correction = np.zeros(2, dtype=np.float64)
    correction[axis] = direction * (float(overlaps[axis]) + 0.015)
    return correction


def _actor_separation_from_aabb(
    actor_bounds: tuple[np.ndarray, np.ndarray] | None,
    obstacle_bounds: tuple[np.ndarray, np.ndarray],
    margin: float = 0.02,
    check_z: bool = True,
) -> np.ndarray:
    if actor_bounds is None:
        return np.zeros(2, dtype=np.float64)
    actor_mins, actor_maxs = actor_bounds
    obstacle_mins, obstacle_maxs = obstacle_bounds
    if (
        actor_maxs[0] <= obstacle_mins[0]
        or actor_mins[0] >= obstacle_maxs[0]
        or actor_maxs[1] <= obstacle_mins[1]
        or actor_mins[1] >= obstacle_maxs[1]
        or (check_z and actor_maxs[2] <= obstacle_mins[2])
        or (check_z and actor_mins[2] >= obstacle_maxs[2])
    ):
        return np.zeros(2, dtype=np.float64)

    overlaps = np.array(
        [
            min(actor_maxs[0] - obstacle_mins[0], obstacle_maxs[0] - actor_mins[0]),
            min(actor_maxs[1] - obstacle_mins[1], obstacle_maxs[1] - actor_mins[1]),
        ],
        dtype=np.float64,
    )
    actor_center = (actor_mins[:2] + actor_maxs[:2]) * 0.5
    obstacle_center = (obstacle_mins[:2] + obstacle_maxs[:2]) * 0.5
    axis = int(np.argmin(overlaps))
    direction = 1.0 if actor_center[axis] >= obstacle_center[axis] else -1.0
    if abs(actor_center[axis] - obstacle_center[axis]) < 1.0e-6:
        direction = 1.0
    correction = np.zeros(2, dtype=np.float64)
    correction[axis] = direction * (float(overlaps[axis]) + float(margin))
    return correction


def _background_table_blockers(
    background_usd: str | None,
    force_pick_table: bool = False,
) -> list[tuple[np.ndarray, np.ndarray]]:
    path = Path(background_usd).expanduser().resolve() if background_usd else None
    use_pick_table = bool(force_pick_table or (path is not None and path.name == "table_bottles_preview.usda"))
    if not use_pick_table:
        return []
    scene = _load_pick_table_scene()
    table = scene.get("table") if scene else None
    if isinstance(table, dict):
        center = np.asarray(table.get("center", (0.0, -0.75, 0.375)), dtype=np.float64)
        size = np.asarray(table.get("size", (1.8, 0.9, 0.75)), dtype=np.float64)
        if center.shape == (3,) and size.shape == (3,) and np.all(np.isfinite(center)) and np.all(np.isfinite(size)):
            mins = center - size * 0.5
            maxs = center + size * 0.5
            print(
                "[ARDY Newton Viewer] table blocker bounds from pick table scene: "
                f"min=({mins[0]:.2f},{mins[1]:.2f},{mins[2]:.2f}) "
                f"max=({maxs[0]:.2f},{maxs[1]:.2f},{maxs[2]:.2f})",
                flush=True,
            )
            return [(mins, maxs)]
    if path is None:
        return []
    try:
        from pxr import Usd, UsdGeom

        stage = Usd.Stage.Open(str(path))
        table_prim = stage.GetPrimAtPath("/World/Table") if stage is not None else None
        if table_prim is None or not table_prim.IsValid():
            return []
        cache = UsdGeom.BBoxCache(
            Usd.TimeCode.Default(),
            [UsdGeom.Tokens.default_, UsdGeom.Tokens.render, UsdGeom.Tokens.proxy],
            useExtentsHint=True,
        )
        box = cache.ComputeWorldBound(table_prim).ComputeAlignedBox()
        mins = np.array(box.GetMin(), dtype=np.float64)
        maxs = np.array(box.GetMax(), dtype=np.float64)
        if not np.all(np.isfinite(mins)) or not np.all(np.isfinite(maxs)):
            return []
        margin = np.array([0.0, 0.0, 0.0], dtype=np.float64)
        mins -= margin
        maxs += margin
        print(
            "[ARDY Newton Viewer] table blocker bounds from USD: "
            f"min=({mins[0]:.2f},{mins[1]:.2f},{mins[2]:.2f}) "
            f"max=({maxs[0]:.2f},{maxs[1]:.2f},{maxs[2]:.2f})",
            flush=True,
        )
        return [(mins, maxs)]
    except Exception as exc:
        print(f"[ARDY Newton Viewer] table blocker disabled: could not read USD table bounds: {exc}", flush=True)
        return []


def _load_pick_table_scene() -> dict:
    try:
        with PICK_TABLE_SCENE_JSON.open("r", encoding="utf-8") as file:
            data = json.load(file)
        return data if isinstance(data, dict) else {}
    except Exception:
        return {}


def _is_table_bottle_preview(background_usd: str | None) -> bool:
    if not background_usd:
        return False
    return Path(background_usd).expanduser().name == "table_bottles_preview.usda"


def _use_pick_table_physics(args: argparse.Namespace) -> bool:
    return bool(args.pick_table_physics or _is_table_bottle_preview(args.background_usd))


def _interactive_bottle_spawn_positions(
    obstacle_bounds: list[tuple[np.ndarray, np.ndarray]] | None,
) -> list[tuple[float, float, float]]:
    scene = _load_pick_table_scene()
    bottles = scene.get("bottles") if scene else None
    if isinstance(bottles, list):
        positions = []
        for bottle in bottles:
            if not isinstance(bottle, dict):
                continue
            center = bottle.get("center")
            if isinstance(center, list | tuple) and len(center) == 3:
                positions.append((float(center[0]), float(center[1]), float(center[2])))
        if positions:
            return positions
    table_top_z = None
    if obstacle_bounds:
        table_top_z = max(float(maxs[2]) for _, maxs in obstacle_bounds)
    z = (
        float(table_top_z) + INTERACTIVE_BOTTLE_HALF_HEIGHT
        if table_top_z is not None
        else 0.898
    )
    return [(float(x), float(y), z) for x, y, _ in INTERACTIVE_BOTTLE_POSITIONS]


def _table_top_z(obstacle_bounds: list[tuple[np.ndarray, np.ndarray]] | None) -> float | None:
    if not obstacle_bounds:
        return None
    try:
        return max(float(maxs[2]) for _, maxs in obstacle_bounds)
    except Exception:
        return None


def _clamp_bottle_position_to_table(position, table_top_z: float | None) -> np.ndarray:
    pos = np.asarray(position, dtype=np.float64).copy()
    if table_top_z is not None:
        pos[2] = max(float(pos[2]), float(table_top_z) + INTERACTIVE_BOTTLE_HALF_HEIGHT)
    return pos


def _move_interactive_bottle(
    wp,
    model,
    state,
    state_next,
    joint_q_start,
    bottle_body_indices: list[int],
    bottle_positions: list[np.ndarray],
    held_bottles: dict[int, dict],
    bottle_idx: int,
    position,
    table_top_z: float | None = None,
) -> None:
    if bottle_idx < 0 or bottle_idx >= len(bottle_body_indices):
        return
    position = _clamp_bottle_position_to_table(position, table_top_z)
    bottle_positions[bottle_idx] = position
    held_bottles.pop(bottle_idx, None)
    _set_free_body_pose(wp, model, state, joint_q_start, bottle_body_indices[bottle_idx], position)
    _set_free_body_pose(wp, model, state_next, joint_q_start, bottle_body_indices[bottle_idx], position)


def _table_guard_lift_for_bounds(
    actor_bounds: tuple[np.ndarray, np.ndarray] | None,
    obstacle_bounds: list[tuple[np.ndarray, np.ndarray]] | None,
) -> float:
    if actor_bounds is None or not obstacle_bounds:
        return 0.0
    actor_mins, actor_maxs = actor_bounds
    lift = 0.0
    for obstacle_mins, obstacle_maxs in obstacle_bounds:
        if (
            actor_maxs[0] <= obstacle_mins[0]
            or actor_mins[0] >= obstacle_maxs[0]
            or actor_maxs[1] <= obstacle_mins[1]
            or actor_mins[1] >= obstacle_maxs[1]
            or actor_mins[2] >= obstacle_maxs[2]
        ):
            continue
        lift = max(lift, float(obstacle_maxs[2] - actor_mins[2]) + INTERACTIVE_TABLE_CONTACT_MARGIN_M)
    return lift


def _guard_t3_hand_bodies_from_obstacles(
    wp,
    newton,
    model,
    state,
    t3_shape_count: int,
    obstacle_bounds: list[tuple[np.ndarray, np.ndarray]] | None,
) -> int:
    if not obstacle_bounds:
        return 0
    corrections = 0
    for suffix in T3_TABLE_GUARD_BODY_SUFFIXES:
        body_idx = _body_index_by_suffix(model, suffix)
        if body_idx is None:
            continue
        body_bounds = _body_shape_bounds(newton, model, state, body_idx, t3_shape_count)
        lift = _table_guard_lift_for_bounds(body_bounds, obstacle_bounds)
        if lift <= 0.0:
            continue
        pose = _body_pose_by_suffix(model, state, suffix)
        if pose is None:
            continue
        position, quat = pose
        guarded_position = np.asarray(position, dtype=np.float64).copy()
        guarded_position[2] += float(lift)
        _set_body_pose(wp, state, body_idx, guarded_position, quat)
        corrections += 1
    return corrections


def _add_table_physics_colliders(newton, wp, builder, obstacle_bounds: list[tuple[np.ndarray, np.ndarray]]) -> int:
    if not obstacle_bounds:
        return 0
    cfg = newton.ModelBuilder.ShapeConfig(
        density=0.0,
        mu=0.9,
        ke=8.0e4,
        kd=2.0e3,
        kf=2.0e3,
        mu_torsional=0.04,
        mu_rolling=0.02,
        is_visible=False,
        has_shape_collision=True,
    )
    count = 0
    for table_idx, (mins, maxs) in enumerate(obstacle_bounds, start=1):
        center = (np.asarray(mins, dtype=np.float64) + np.asarray(maxs, dtype=np.float64)) * 0.5
        half = (np.asarray(maxs, dtype=np.float64) - np.asarray(mins, dtype=np.float64)) * 0.5
        top_z = float(maxs[2])
        builder.add_shape_box(
            -1,
            xform=wp.transform(
                wp.vec3(float(center[0]), float(center[1]), top_z - 0.005),
                wp.quat_identity(),
            ),
            hx=max(0.01, float(half[0])),
            hy=max(0.01, float(half[1])),
            hz=0.005,
            cfg=cfg,
            label=f"interactive_table_top_collider_{table_idx}",
        )
        count += 1
    return count


def _default_place_box_position(table_top_z: float | None) -> np.ndarray:
    top_z = float(table_top_z) if table_top_z is not None else 0.90
    return np.array(
        [
            PLACE_BOX_DEFAULT_XY[0],
            PLACE_BOX_DEFAULT_XY[1],
            top_z + PLACE_BOX_HALF_EXTENTS_M[2],
        ],
        dtype=np.float64,
    )


def _place_box_bottle_center(position, half_extents=PLACE_BOX_HALF_EXTENTS_M) -> np.ndarray:
    pos = np.asarray(position, dtype=np.float64).copy()
    pos[2] = float(pos[2]) + float(half_extents[2]) + INTERACTIVE_BOTTLE_HALF_HEIGHT + 0.07
    return pos


def _add_place_box(newton, wp, builder, enabled: bool, position) -> str | None:
    if not enabled:
        return None
    cfg = newton.ModelBuilder.ShapeConfig(
        density=0.0,
        mu=1.0,
        ke=1.0e5,
        kd=1.0e3,
        kf=1.0e3,
        restitution=0.0,
        mu_torsional=0.02,
        mu_rolling=0.01,
        is_visible=True,
        has_shape_collision=True,
    )
    pos = np.asarray(position, dtype=np.float64)
    body = builder.add_body(
        xform=wp.transform(wp.vec3(float(pos[0]), float(pos[1]), float(pos[2])), wp.quat_identity()),
        mass=0.0,
        is_kinematic=True,
        label="place_box_target",
    )
    tray_color = (0.12, 0.42, 0.64)
    builder.add_shape_box(
        body,
        hx=PLACE_BOX_HALF_EXTENTS_M[0],
        hy=PLACE_BOX_HALF_EXTENTS_M[1],
        hz=PLACE_BOX_HALF_EXTENTS_M[2],
        cfg=cfg,
        color=tray_color,
        label="place_tray_floor",
    )
    for index, dx in enumerate((-PLACE_BOX_HALF_EXTENTS_M[0], PLACE_BOX_HALF_EXTENTS_M[0]), start=1):
        builder.add_shape_box(
            body,
            xform=wp.transform(wp.vec3(float(dx), 0.0, 0.055), wp.quat_identity()),
            hx=0.008,
            hy=PLACE_BOX_HALF_EXTENTS_M[1] + 0.008,
            hz=0.065,
            cfg=cfg,
            color=tray_color,
            label=f"place_tray_side_x_{index}",
        )
    for index, dy in enumerate((-PLACE_BOX_HALF_EXTENTS_M[1], PLACE_BOX_HALF_EXTENTS_M[1]), start=1):
        builder.add_shape_box(
            body,
            xform=wp.transform(wp.vec3(0.0, float(dy), 0.055), wp.quat_identity()),
            hx=PLACE_BOX_HALF_EXTENTS_M[0],
            hy=0.008,
            hz=0.065,
            cfg=cfg,
            color=tray_color,
            label=f"place_tray_side_y_{index}",
        )
    return "place_box_target_free_joint"


def _world_point_to_staged_local(point, root_pose) -> np.ndarray:
    point = np.asarray(point, dtype=np.float64)
    root_x, root_y, root_yaw = (float(root_pose[0]), float(root_pose[1]), float(root_pose[2]))
    dx = float(point[0]) - root_x
    dy = float(point[1]) - root_y
    c = math.cos(-root_yaw)
    s = math.sin(-root_yaw)
    return np.array([c * dx - s * dy, s * dx + c * dy, float(point[2])], dtype=np.float64)


def _t3_root_pose_from_row(row: dict | None) -> tuple[float, float, float]:
    if not isinstance(row, dict):
        return (0.0, 0.0, 0.0)
    if "root_x_m" in row or "root_y_m" in row:
        return (
            float(row.get("root_x_m", 0.0) or 0.0),
            float(row.get("root_y_m", 0.0) or 0.0),
            float(row.get("root_yaw_rad", math.radians(float(row.get("root_rotateZ", 0.0) or 0.0))) or 0.0),
        )
    if "root_translateX" in row or "root_translateY" in row:
        return (
            float(row.get("root_translateX", 0.0) or 0.0) / 100.0,
            float(row.get("root_translateY", 0.0) or 0.0) / 100.0,
            math.radians(float(row.get("root_rotateZ", 0.0) or 0.0)),
        )
    return (0.0, 0.0, 0.0)


def _nearest_t3_hand_for_local_target(local_target) -> str:
    target = np.asarray(local_target, dtype=np.float64)
    return "left" if float(target[1]) >= 0.0 else "right"


def _staged_fixed_base_root_for_target(target_in_robot_space, preferred_hand: str = "right") -> tuple[float, float, float]:
    target = np.asarray(target_in_robot_space, dtype=np.float64)
    preferred_hand = str(preferred_hand).lower()
    if preferred_hand.startswith("left"):
        hand_y = 0.28
    elif preferred_hand.startswith("right"):
        hand_y = -0.28
    else:
        hand_y = 0.0
    desired_local_target = np.array(
        [0.50, hand_y, max(0.45, float(target[2]))],
        dtype=np.float64,
    )
    target_heading = math.atan2(float(target[1]), float(target[0]))
    local_pick_heading = math.atan2(float(desired_local_target[1]), float(desired_local_target[0]))
    job_yaw = target_heading - local_pick_heading
    cos_yaw = math.cos(job_yaw)
    sin_yaw = math.sin(job_yaw)
    staged_local_xy = np.array(
        [
            cos_yaw * desired_local_target[0] - sin_yaw * desired_local_target[1],
            sin_yaw * desired_local_target[0] + cos_yaw * desired_local_target[1],
        ],
        dtype=np.float64,
    )
    return (
        float(target[0] - staged_local_xy[0]),
        float(target[1] - staged_local_xy[1]),
        float(job_yaw),
    )


def _staged_local_to_world_point(local_point, root_pose) -> np.ndarray:
    point = np.asarray(local_point, dtype=np.float64)
    root_x, root_y, root_yaw = (float(root_pose[0]), float(root_pose[1]), float(root_pose[2]))
    c = math.cos(root_yaw)
    s = math.sin(root_yaw)
    return np.array(
        [
            root_x + c * float(point[0]) - s * float(point[1]),
            root_y + s * float(point[0]) + c * float(point[1]),
            float(point[2]),
        ],
        dtype=np.float64,
    )


def _add_pick_table_visual_shapes(newton, wp, builder, enabled: bool) -> int:
    if not enabled:
        return 0
    scene = _load_pick_table_scene()
    table = scene.get("table") if scene else None
    if not isinstance(table, dict):
        return 0
    center = np.asarray(table.get("center", (0.0, -0.75, 0.375)), dtype=np.float64)
    size = np.asarray(table.get("size", (1.8, 0.9, 0.75)), dtype=np.float64)
    if center.shape != (3,) or size.shape != (3,):
        return 0
    top_z = float(table.get("top_z", center[2] + size[2] * 0.5))
    top_thickness = float(table.get("top_thickness", 0.05))
    cfg = newton.ModelBuilder.ShapeConfig(
        density=0.0,
        mu=0.9,
        ke=8.0e4,
        kd=2.0e3,
        kf=2.0e3,
        is_visible=True,
        has_shape_collision=False,
    )
    color = tuple(float(value) / 255.0 for value in table.get("color", (235, 238, 240)))
    builder.add_shape_box(
        -1,
        xform=wp.transform(wp.vec3(float(center[0]), float(center[1]), top_z - top_thickness * 0.5), wp.quat_identity()),
        hx=float(size[0]) * 0.5,
        hy=float(size[1]) * 0.5,
        hz=top_thickness * 0.5,
        cfg=cfg,
        color=color,
        label="pick_table_visual_top",
    )
    leg_size = 0.045
    leg_height = max(float(size[2]) - top_thickness, 0.05)
    half_x = float(size[0]) * 0.5 - leg_size * 1.5
    half_y = float(size[1]) * 0.5 - leg_size * 1.5
    for index, (x_offset, y_offset) in enumerate(
        ((-half_x, -half_y), (-half_x, half_y), (half_x, -half_y), (half_x, half_y)),
        start=1,
    ):
        builder.add_shape_box(
            -1,
            xform=wp.transform(
                wp.vec3(float(center[0] + x_offset), float(center[1] + y_offset), leg_height * 0.5),
                wp.quat_identity(),
            ),
            hx=leg_size * 0.5,
            hy=leg_size * 0.5,
            hz=leg_height * 0.5,
            cfg=cfg,
            color=(0.34, 0.38, 0.42),
            label=f"pick_table_visual_leg_{index}",
        )
    return 5


def _add_interactive_bottles(newton, wp, builder, enabled: bool, bottle_positions) -> list[str]:
    if not enabled:
        return []
    bottle_volume = (
        math.pi * INTERACTIVE_BOTTLE_RADIUS**2 * (INTERACTIVE_BOTTLE_HALF_HEIGHT * 2.0)
        + math.pi * 0.013**2 * 0.030
        + math.pi * 0.015**2 * 0.008
    )
    cfg = newton.ModelBuilder.ShapeConfig(
        # Match /home/jony/Downloads/t3_pick_place/example.py: a light
        # plastic bottle with stiff MuJoCo contacts. Softer contacts made the
        # jaws visually penetrate before the solver produced a stable pinch.
        density=250.0,
        mu=1.2,
        ke=1.0e5,
        kd=1.0e3,
        kf=1.0e3,
        restitution=0.0,
        mu_torsional=0.01,
        mu_rolling=0.005,
    )
    joint_names = []
    for index, pos in enumerate(bottle_positions, start=1):
        body = builder.add_body(
            xform=wp.transform(wp.vec3(float(pos[0]), float(pos[1]), float(pos[2])), wp.quat_identity()),
            label=f"interactive_water_bottle_{index}",
        )
        builder.add_shape_cylinder(
            body,
            radius=INTERACTIVE_BOTTLE_RADIUS,
            half_height=INTERACTIVE_BOTTLE_HALF_HEIGHT,
            cfg=cfg,
            color=(0.38, 0.72, 0.96),
            label=f"interactive_water_bottle_{index}_body",
        )
        builder.add_shape_cylinder(
            body,
            xform=wp.transform(wp.vec3(0.0, 0.0, -0.020), wp.quat_identity()),
            radius=INTERACTIVE_BOTTLE_RADIUS * 1.015,
            half_height=0.025,
            cfg=cfg,
            color=(0.03, 0.18, 0.42),
            label=f"interactive_water_bottle_{index}_label",
        )
        builder.add_shape_cylinder(
            body,
            xform=wp.transform(wp.vec3(0.0, 0.0, INTERACTIVE_BOTTLE_HALF_HEIGHT + 0.015), wp.quat_identity()),
            radius=0.013,
            half_height=0.015,
            cfg=cfg,
            color=(0.78, 0.92, 1.00),
            label=f"interactive_water_bottle_{index}_neck",
        )
        builder.add_shape_cylinder(
            body,
            xform=wp.transform(wp.vec3(0.0, 0.0, INTERACTIVE_BOTTLE_HALF_HEIGHT + 0.034), wp.quat_identity()),
            radius=0.015,
            half_height=0.004,
            cfg=cfg,
            color=(0.04, 0.34, 0.88),
            label=f"interactive_water_bottle_{index}_cap",
        )
        joint_names.append(f"interactive_water_bottle_{index}")
    return joint_names


def _body_pose_by_suffix(model, state, suffix: str) -> tuple[np.ndarray, np.ndarray] | None:
    body_q = state.body_q.numpy()
    for body_idx, label in enumerate(model.body_label):
        body_label = str(label).rsplit("/", 1)[-1]
        if body_label == suffix:
            body_pose = np.asarray(body_q[body_idx], dtype=np.float64)
            return body_pose[0:3], body_pose[3:7]
    return None


def _body_center_by_suffix(model, state, suffix: str) -> np.ndarray | None:
    pose = _body_pose_by_suffix(model, state, suffix)
    return None if pose is None else pose[0]


def _body_index_by_suffix(model, suffix: str) -> int | None:
    for body_idx, label in enumerate(model.body_label):
        body_label = str(label).rsplit("/", 1)[-1]
        if body_label == suffix:
            return int(body_idx)
    return None


def _set_body_pose(wp, state, body_idx: int, position, quat=None, zero_velocity: bool = True) -> None:
    if body_idx < 0:
        return
    pos = np.asarray(position, dtype=np.float64)
    q = np.asarray(quat if quat is not None else [0.0, 0.0, 0.0, 1.0], dtype=np.float64)
    body_q = state.body_q.numpy().copy()
    body_q[body_idx] = np.array([pos[0], pos[1], pos[2], q[0], q[1], q[2], q[3]], dtype=np.float32)
    wp.copy(state.body_q, wp.array(body_q, dtype=wp.transform), 0, 0, len(body_q))
    if zero_velocity and getattr(state, "body_qd", None) is not None:
        body_qd = state.body_qd.numpy().copy()
        body_qd[body_idx] = np.zeros(6, dtype=np.float32)
        wp.copy(state.body_qd, wp.array(body_qd, dtype=wp.spatial_vector), 0, 0, len(body_qd))


def _set_free_body_pose(
    wp,
    model,
    state,
    joint_q_start,
    body_idx: int,
    position,
    quat=None,
    zero_velocity: bool = True,
) -> None:
    _set_body_pose(wp, state, body_idx, position, quat, zero_velocity)
    if body_idx < 0:
        return
    body_label = str(model.body_label[body_idx]).rsplit("/", 1)[-1]
    q_start = joint_q_start.get(f"{body_label}_free_joint")
    if q_start is None:
        return
    pos = np.asarray(position, dtype=np.float64)
    q = np.asarray(quat if quat is not None else [0.0, 0.0, 0.0, 1.0], dtype=np.float64)
    joint_q = model.joint_q.numpy().copy()
    joint_q[q_start : q_start + 7] = np.array([pos[0], pos[1], pos[2], q[0], q[1], q[2], q[3]], dtype=np.float32)
    wp.copy(model.joint_q, wp.array(joint_q, dtype=wp.float32), 0, 0, len(joint_q))


def _joint_scalar(model, joint_q_start, joint_name: str) -> float:
    start = joint_q_start.get(joint_name)
    if start is None:
        return 0.0
    return float(model.joint_q.numpy()[start])


def _set_gripper_aperture_in_q(q: np.ndarray, joint_q_start, side: str, aperture: float) -> None:
    aperture = float(np.clip(aperture, 0.0, T3_GRIPPER_MAX_APERTURE_M))
    joint1_start = joint_q_start.get(f"{side}_gripper_joint1")
    joint2_start = joint_q_start.get(f"{side}_gripper_joint2")
    if joint1_start is not None:
        q[joint1_start] = aperture * 0.5
    if joint2_start is not None:
        q[joint2_start] = -aperture * 0.5


def _gripper_state(model, state, joint_q_start, side: str) -> dict | None:
    base = _body_center_by_suffix(model, state, f"{side}_gripper_base")
    finger1 = _body_center_by_suffix(model, state, f"{side}_gripper_link1")
    finger2 = _body_center_by_suffix(model, state, f"{side}_gripper_link2")
    if base is None or finger1 is None or finger2 is None:
        return None
    aperture = abs(_joint_scalar(model, joint_q_start, f"{side}_gripper_joint1")) + abs(
        _joint_scalar(model, joint_q_start, f"{side}_gripper_joint2")
    )
    return {
        "side": side,
        "base": base,
        "center": (finger1 + finger2) * 0.5,
        "finger1": finger1,
        "finger2": finger2,
        "aperture": aperture,
    }


def _bottle_inside_gripper(bottle_pos: np.ndarray, gripper: dict) -> bool:
    center = np.asarray(gripper["center"], dtype=np.float64)
    base = np.asarray(gripper["base"], dtype=np.float64)
    # The hand must be around the bottle, not just brushing it from far away.
    return (
        float(np.linalg.norm((bottle_pos - center)[:2])) <= INTERACTIVE_BOTTLE_INSERT_DISTANCE_M
        and abs(float(bottle_pos[2] - center[2])) <= 0.18
        and float(np.linalg.norm((bottle_pos - base)[:2])) <= 0.22
    )


def _gripper_aperture_min_for_bottles(
    model,
    state,
    joint_q_start,
    bottle_positions: list[np.ndarray],
    held_bottles: dict[int, dict],
) -> dict[str, float]:
    aperture_min: dict[str, float] = {}
    for side in T3_GRIPPER_SIDES:
        gripper = _gripper_state(model, state, joint_q_start, side)
        if gripper is None:
            continue
        if any(str(hold.get("side")) == side for hold in held_bottles.values()) or any(
            _bottle_inside_gripper(np.asarray(position, dtype=np.float64), gripper)
            for position in bottle_positions
        ):
            aperture_min[side] = T3_GRIPPER_BOTTLE_GRASP_APERTURE_M
    return aperture_min


def _enforce_gripper_bottle_aperture(
    wp,
    newton,
    model,
    state,
    joint_q_start,
    bottle_positions: list[np.ndarray],
    held_bottles: dict[int, dict],
    body_flag_filter=None,
) -> bool:
    aperture_min = _gripper_aperture_min_for_bottles(
        model,
        state,
        joint_q_start,
        bottle_positions,
        held_bottles,
    )
    if not aperture_min:
        return False
    q = model.joint_q.numpy().copy()
    changed = False
    for side, aperture in aperture_min.items():
        joint1_start = joint_q_start.get(f"{side}_gripper_joint1")
        joint2_start = joint_q_start.get(f"{side}_gripper_joint2")
        current_aperture = 0.0
        if joint1_start is not None:
            current_aperture += abs(float(q[joint1_start]))
        if joint2_start is not None:
            current_aperture += abs(float(q[joint2_start]))
        if current_aperture < T3_GRIPPER_OPEN_APERTURE_M and current_aperture < float(aperture):
            _set_gripper_aperture_in_q(q, joint_q_start, side, float(aperture))
            changed = True
    if not changed:
        return False
    wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    if body_flag_filter is None:
        newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
    else:
        newton.eval_fk(model, model.joint_q, model.joint_qd, state, None, body_flag_filter=body_flag_filter)
    return True


def _auto_pick_gripper_apertures(
    model,
    state,
    joint_q_start,
    bottle_positions: list[np.ndarray],
    held_bottles: dict[int, dict],
) -> dict[str, float]:
    apertures: dict[str, float] = {}
    for side in T3_GRIPPER_SIDES:
        gripper = _gripper_state(model, state, joint_q_start, side)
        if gripper is None:
            continue
        center = np.asarray(gripper["center"], dtype=np.float64)
        if any(str(hold.get("side")) == side for hold in held_bottles.values()):
            apertures[side] = T3_GRIPPER_BOTTLE_GRASP_APERTURE_M
            continue
        bottle_distances = [
            (
                float(np.linalg.norm((np.asarray(position, dtype=np.float64) - center)[:2])),
                abs(float(np.asarray(position, dtype=np.float64)[2] - center[2])),
                np.asarray(position, dtype=np.float64),
            )
            for position in bottle_positions
        ]
        if any(_bottle_inside_gripper(position, gripper) for _, _, position in bottle_distances):
            apertures[side] = T3_GRIPPER_BOTTLE_GRASP_APERTURE_M
        elif any(
            xy_distance <= INTERACTIVE_BOTTLE_APPROACH_DISTANCE_M and z_distance <= 0.28
            for xy_distance, z_distance, _ in bottle_distances
        ):
            apertures[side] = T3_GRIPPER_MAX_APERTURE_M
    return apertures


def _table_pick_gripper_apertures(table_pick: dict | None, frame_idx: int) -> dict[str, float]:
    if not isinstance(table_pick, dict):
        return {}
    phases = table_pick.get("phases")
    if not isinstance(phases, dict):
        return {}
    try:
        pregrasp = int(phases.get("pregrasp", phases.get("reach", 0)))
        open_frame = int(phases.get("open", pregrasp))
        close_start = int(phases["gripper_close_start"])
        close_end = int(phases["gripper_close_end"])
        closed = float(table_pick.get("closed_aperture", T3_GRIPPER_CLOSED_APERTURE_M))
    except Exception:
        return {}

    def smooth(a: int, b: int) -> float:
        span = max(1, int(b) - int(a))
        u = float(np.clip((int(frame_idx) - int(a)) / span, 0.0, 1.0))
        return u * u * (3.0 - 2.0 * u)

    maximum = T3_GRIPPER_MAX_APERTURE_M
    if int(frame_idx) < close_start:
        aperture = maximum * smooth(pregrasp, open_frame)
    else:
        aperture = maximum + (closed - maximum) * smooth(close_start, close_end)
    return {"right": float(np.clip(aperture, 0.0, T3_GRIPPER_MAX_APERTURE_M))}


def _apply_gripper_apertures(
    wp,
    newton,
    model,
    state,
    joint_q_start,
    apertures: dict[str, float],
    body_flag_filter=None,
) -> bool:
    if not apertures:
        return False
    q = model.joint_q.numpy().copy()
    for side, aperture in apertures.items():
        _set_gripper_aperture_in_q(q, joint_q_start, side, aperture)
    wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    if body_flag_filter is None:
        newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
    else:
        newton.eval_fk(model, model.joint_q, model.joint_qd, state, None, body_flag_filter=body_flag_filter)
    return True


def _update_interactive_bottles(
    wp,
    model,
    state,
    state_next,
    joint_q_start,
    bottle_body_indices: list[int],
    bottle_positions: list[np.ndarray],
    held_bottles: dict[int, dict],
    gripper_grasp_state: dict[str, dict],
    table_top_z: float | None = None,
) -> None:
    # Bottle poses and velocities belong exclusively to the physics solver.
    # The gripper influences bottles only through contact geometry, friction,
    # and the configured physics backend. No motion-playback latch/attachment.
    held_bottles.clear()
    gripper_grasp_state.clear()
    if not bottle_body_indices:
        return
    body_q = state.body_q.numpy()
    for bottle_idx, body_idx in enumerate(bottle_body_indices):
        bottle_positions[bottle_idx] = np.array(body_q[body_idx][0:3], dtype=np.float64, copy=True)


def _reset_interactive_bottles(
    wp,
    model,
    state,
    state_next,
    joint_q_start,
    bottle_body_indices: list[int],
    spawn_positions,
    bottle_positions: list[np.ndarray],
    held_bottles: dict[int, dict],
    gripper_grasp_state: dict[str, dict],
) -> None:
    held_bottles.clear()
    gripper_grasp_state.clear()
    for bottle_idx, body_idx in enumerate(bottle_body_indices):
        if bottle_idx >= len(spawn_positions):
            break
        position = np.asarray(spawn_positions[bottle_idx], dtype=np.float64)
        bottle_positions[bottle_idx] = position
        _set_free_body_pose(wp, model, state, joint_q_start, body_idx, position)
        _set_free_body_pose(wp, model, state_next, joint_q_start, body_idx, position)
    print(f"[ARDY Newton Viewer] reset {len(bottle_body_indices)} bottle position(s)", flush=True)


def _copy_t3_joint_targets_from_q(model, control, q: np.ndarray) -> None:
    if control is None or not hasattr(control, "joint_target_q"):
        return
    try:
        targets = control.joint_target_q.numpy()
        q_starts = model.joint_q_start.numpy()
        target_starts = model.joint_target_q_start.numpy()
    except Exception:
        return
    joint_count = len(q_starts)
    for joint_idx in range(joint_count):
        q_start = int(q_starts[joint_idx])
        q_end = int(q_starts[joint_idx + 1]) if joint_idx + 1 < joint_count else len(q)
        q_count = max(0, q_end - q_start)
        target_start = int(target_starts[joint_idx])
        if q_count <= 0 or target_start < 0:
            continue
        # Floating/free roots have 7 q coords but no matching 7-slot position
        # target in the legacy MuJoCo target layout. The base is locked as a
        # kinematic body and is updated from joint_q, so skip it here.
        if q_count > 1:
            continue
        if target_start >= len(targets) or q_start >= len(q):
            continue
        targets[target_start] = float(q[q_start])
    control.joint_target_q.assign(targets)


def _row_uses_normalized_grippers(row: dict) -> bool:
    mode = str(row.get("gripper_mode") or row.get("gripper_range") or "").strip().lower()
    return mode in {
        "normalized",
        "normalized_0_closed_1_open",
        "0_closed_1_open",
        "0close_1open",
    }


def _row_uses_aperture_grippers(row: dict) -> bool:
    mode = str(row.get("gripper_mode") or row.get("gripper_range") or "").strip().lower()
    return mode in {
        "aperture",
        "aperture_m",
        "aperture_m_0_closed_0p1_open",
        "0_closed_0p1_open",
        "0close_0p1open",
    }


def _normalized_gripper_value_to_joint(joint_name: str, value: float) -> float:
    normalized = float(np.clip(value, 0.0, 1.0))
    half_open = T3_GRIPPER_MAX_APERTURE_M * 0.5
    sign = -1.0 if joint_name.endswith("joint2") else 1.0
    return sign * normalized * half_open


def _aperture_gripper_value_to_joint(joint_name: str, value: float) -> float:
    aperture = float(np.clip(value, 0.0, T3_GRIPPER_MAX_APERTURE_M))
    sign = -1.0 if joint_name.endswith("joint2") else 1.0
    return sign * aperture * 0.5


def _apply_t3_row(
    wp,
    newton,
    model,
    state,
    default_q,
    joint_q_start,
    row,
    offset_tx,
    floor_z,
    t3_shape_count,
    pick_position,
    pick_size,
    pick_visible,
    pick_pushable,
    body_flag_filter=None,
    obstacle_bounds: list[tuple[np.ndarray, np.ndarray]] | None = None,
    table_guard_enabled: bool = True,
    gripper_override: dict[str, float] | None = None,
    gripper_aperture_min: dict[str, float] | None = None,
    control=None,
    target_only: bool = False,
    root_q_start: int = 0,
    apply_stiff_posture: bool = True,
    calculate_bounds: bool = True,
    preserve_body_indices: list[int] | tuple[int, ...] | None = None,
):
    # Start from the live model coordinates so dynamic/free bodies such as
    # moved bottles keep their current poses. The T3 row then overwrites only
    # robot root/joint coordinates. Starting from default_q reset bottles to
    # their spawn positions whenever Play T3 Demo Pick applied frame 0.
    try:
        q = model.joint_q.numpy().copy()
    except Exception:
        q = default_q.copy()
    preserved_body_indices = [int(index) for index in (preserve_body_indices or ()) if int(index) >= 0]
    preserved_body_q = None
    preserved_body_qd = None
    if preserved_body_indices:
        body_q = state.body_q.numpy()
        preserved_body_q = np.array(body_q[preserved_body_indices], dtype=np.float32, copy=True)
        if getattr(state, "body_qd", None) is not None:
            body_qd = state.body_qd.numpy()
            preserved_body_qd = np.array(body_qd[preserved_body_indices], dtype=np.float32, copy=True)

    def eval_robot_fk() -> None:
        if body_flag_filter is None:
            newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
        else:
            newton.eval_fk(model, model.joint_q, model.joint_qd, state, None, body_flag_filter=body_flag_filter)
        # Robot FK operates on the assembled model and can otherwise overwrite
        # dynamic scene bodies with stale joint coordinates. Bottle transforms
        # and velocities belong to the live physics state and must survive IK.
        if preserved_body_q is not None:
            body_q = state.body_q.numpy().copy()
            body_q[preserved_body_indices] = preserved_body_q
            wp.copy(state.body_q, wp.array(body_q, dtype=wp.transform), 0, 0, len(body_q))
        if preserved_body_qd is not None:
            body_qd = state.body_qd.numpy().copy()
            body_qd[preserved_body_indices] = preserved_body_qd
            wp.copy(state.body_qd, wp.array(body_qd, dtype=wp.spatial_vector), 0, 0, len(body_qd))
    live_root_pos = np.zeros(3, dtype=np.float64)
    live_root_quat = np.array([0.0, 0.0, 0.0, 1.0], dtype=np.float64)
    live_root_yaw_rad = 0.0
    if row is not None:
        if "root_x_m" in row and "root_y_m" in row:
            live_root_pos = np.array(
                [float(row.get("root_x_m", 0.0)), float(row.get("root_y_m", 0.0)), 0.0],
                dtype=np.float64,
            )
            if "root_yaw_rad" in row:
                live_root_yaw_rad = float(row.get("root_yaw_rad", 0.0))
            else:
                live_root_yaw_rad = math.radians(float(row.get("root_rotateZ", 0.0)))
            live_root_quat = Rotation.from_euler("z", live_root_yaw_rad, degrees=False).as_quat()
        elif "root_translateX" in row and "root_translateY" in row:
            live_root_pos = np.array(
                [
                    float(row.get("root_translateX", 0.0)) / 100.0,
                    float(row.get("root_translateY", 0.0)) / 100.0,
                    0.0,
                ],
                dtype=np.float64,
            )
            live_root_yaw_rad = math.radians(float(row.get("root_rotateZ", 0.0)))
            live_root_quat = Rotation.from_euler("z", live_root_yaw_rad, degrees=False).as_quat()
        elif "viser_root_position" in row:
            live_root_pos = _ardy_position_to_newton(row["viser_root_position"])
            live_root_yaw_rad = float(row.get("root_yaw_rad", 0.0))
            live_root_quat = Rotation.from_euler("z", live_root_yaw_rad, degrees=False).as_quat()

        if "joint_names" in row and "joint_cfg" in row:
            for joint_name, value in zip(row.get("joint_names", []), row.get("joint_cfg", [])):
                start = joint_q_start.get(str(joint_name))
                if start is not None:
                    q[start] = float(value)
        else:
            normalized_grippers = _row_uses_normalized_grippers(row)
            aperture_grippers = _row_uses_aperture_grippers(row)
            for row_key, joint_name in T3_ROW_TO_JOINT.items():
                if joint_name in T3_STIFF_POSTURE_JOINTS:
                    continue
                start = joint_q_start.get(joint_name)
                if start is None or row_key not in row:
                    continue
                value = float(row[row_key])
                if joint_name == "telescopic_lift_joint":
                    value = _lift_csv_value_to_extension_m(value)
                elif normalized_grippers and "gripper_joint" in joint_name:
                    value = _normalized_gripper_value_to_joint(joint_name, value)
                elif aperture_grippers and "gripper_joint" in joint_name:
                    value = _aperture_gripper_value_to_joint(joint_name, value)
                q[start] = value if joint_name in T3_LINEAR_JOINTS else math.radians(value)
            for row_key, joint_name in (
                ("left_wheel_angle_rad", "left_wheel_joint"),
                ("right_wheel_angle_rad", "right_wheel_joint"),
            ):
                start = joint_q_start.get(joint_name)
                if start is not None and row_key in row:
                    q[start] = float(row[row_key])

        if apply_stiff_posture and not row.get("debug_demo_pick"):
            for joint_name in T3_STIFF_POSTURE_JOINTS:
                start = joint_q_start.get(joint_name)
                if start is not None:
                    q[start] = 0.0

    if gripper_override:
        for side in T3_GRIPPER_SIDES:
            aperture = float(
                np.clip(
                    gripper_override.get(side, T3_GRIPPER_DEFAULT_APERTURE_M),
                    0.0,
                    T3_GRIPPER_MAX_APERTURE_M,
                )
            )
            _set_gripper_aperture_in_q(q, joint_q_start, side, aperture)

    if gripper_aperture_min:
        for side, aperture_min in gripper_aperture_min.items():
            joint1_start = joint_q_start.get(f"{side}_gripper_joint1")
            joint2_start = joint_q_start.get(f"{side}_gripper_joint2")
            current_aperture = 0.0
            if joint1_start is not None:
                current_aperture += abs(float(q[joint1_start]))
            if joint2_start is not None:
                current_aperture += abs(float(q[joint2_start]))
            if current_aperture < T3_GRIPPER_OPEN_APERTURE_M and current_aperture < float(aperture_min):
                _set_gripper_aperture_in_q(q, joint_q_start, side, float(aperture_min))

    live_root_tx = _make_tx(wp, live_root_pos, live_root_quat)
    root_tx = wp.mul(offset_tx, live_root_tx)
    root_q_start = int(root_q_start)
    q[root_q_start : root_q_start + 7] = _tx_to_numpy(root_tx)
    q[root_q_start + 2] = float(floor_z)
    if control is not None:
        _copy_t3_joint_targets_from_q(model, control, q)
    if target_only:
        current_q = model.joint_q.numpy().copy()
        current_q[root_q_start : root_q_start + 7] = q[root_q_start : root_q_start + 7]
        wp.copy(model.joint_q, wp.array(current_q, dtype=wp.float32), 0, 0, len(current_q))
        eval_robot_fk()
        return _make_tx(wp, q[root_q_start : root_q_start + 3], q[root_q_start + 3 : root_q_start + 7]), _robot_shape_bounds(newton, model, state, t3_shape_count)
    wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    eval_robot_fk()
    if table_guard_enabled and obstacle_bounds:
        guard_bounds = _robot_shape_bounds(
            newton,
            model,
            state,
            t3_shape_count,
            body_suffixes=T3_TABLE_GUARD_BODY_SUFFIXES,
        )
        table_lift = _table_guard_lift_for_bounds(guard_bounds, obstacle_bounds)
        if table_lift > 0.0:
            q[root_q_start + 2] = float(floor_z) + min(table_lift, 0.45)
            wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
            eval_robot_fk()
    bounds = _robot_shape_bounds(newton, model, state, t3_shape_count) if calculate_bounds or table_guard_enabled else None
    correction = np.zeros(2, dtype=np.float64)
    if table_guard_enabled:
        support_bounds = _robot_shape_bounds(
            newton,
            model,
            state,
            t3_shape_count,
            body_suffixes=T3_GROUND_SUPPORT_BODY_SUFFIXES,
        )
        correction += _actor_separation_from_pick_object(bounds, pick_position, pick_size, pick_visible, pick_pushable)
        for obstacle in obstacle_bounds or []:
            correction += _actor_separation_from_aabb(support_bounds, obstacle, margin=0.0, check_z=False)
    if np.any(correction):
        q[root_q_start] += correction[0]
        q[root_q_start + 1] += correction[1]
        wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
        eval_robot_fk()
        bounds = _robot_shape_bounds(newton, model, state, t3_shape_count)
    return _make_tx(wp, q[root_q_start : root_q_start + 3], q[root_q_start + 3 : root_q_start + 7]), bounds


def _t3_initial_joints_from_feedback(row: dict | None) -> dict[str, float]:
    if not isinstance(row, dict):
        return {}
    names = row.get("joint_names")
    values = row.get("joint_cfg")
    if not isinstance(names, list) or not isinstance(values, list):
        return {}
    return {
        str(name): float(value)
        for name, value in zip(names, values)
        if str(name) in set(T3_ROW_TO_JOINT.values()) and np.isfinite(float(value))
    }


def _feedback_row_on_fixed_loaded_t3(feedback_row: dict) -> dict:
    row = _make_t3_loaded_pose_row(
        frame_idx=int(feedback_row.get("frame_idx", 0) or 0),
        fps=float(feedback_row.get("fps", 60.0) or 60.0),
    )
    joint_values = dict(zip(row["joint_names"], row["joint_cfg"]))
    for name, value in zip(feedback_row.get("joint_names", []), feedback_row.get("joint_cfg", [])):
        name = str(name)
        if name.startswith(("left_joint", "right_joint", "left_gripper_joint", "right_gripper_joint")):
            joint_values[name] = float(value)

    row["joint_names"] = list(joint_values.keys())
    row["joint_cfg"] = [float(value) for value in joint_values.values()]
    return row


def _hide_t3_feedback_ghost(
    wp,
    newton,
    model,
    state,
    root_q_start: int,
    preserve_body_indices: list[int] | tuple[int, ...] | None = None,
) -> None:
    try:
        preserved_indices = [int(index) for index in (preserve_body_indices or ()) if int(index) >= 0]
        preserved_q = (
            np.array(state.body_q.numpy()[preserved_indices], dtype=np.float32, copy=True)
            if preserved_indices
            else None
        )
        preserved_qd = (
            np.array(state.body_qd.numpy()[preserved_indices], dtype=np.float32, copy=True)
            if preserved_indices and getattr(state, "body_qd", None) is not None
            else None
        )
        q = model.joint_q.numpy().copy()
        root_q_start = int(root_q_start)
        q[root_q_start : root_q_start + 7] = np.array([0.0, 0.0, -100.0, 0.0, 0.0, 0.0, 1.0], dtype=np.float32)
        wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
        newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
        if preserved_q is not None:
            body_q = state.body_q.numpy().copy()
            body_q[preserved_indices] = preserved_q
            wp.copy(state.body_q, wp.array(body_q, dtype=wp.transform), 0, 0, len(body_q))
        if preserved_qd is not None:
            body_qd = state.body_qd.numpy().copy()
            body_qd[preserved_indices] = preserved_qd
            wp.copy(state.body_qd, wp.array(body_qd, dtype=wp.spatial_vector), 0, 0, len(body_qd))
    except Exception:
        return


def _add_pick_object(newton, wp, builder, args: argparse.Namespace) -> tuple[str | None, float]:
    if args.pick_object == "none":
        return None, 0.0

    size = max(0.02, float(args.pick_object_size))
    hx = hy = hz = size * 0.5
    position = np.asarray(args.pick_object_position, dtype=np.float64)
    if position.shape[0] != 3:
        position = np.array([0.55, -0.75, float(args.floor_z) + hz], dtype=np.float64)
    if position[2] <= float(args.floor_z):
        position[2] = float(args.floor_z) + hz

    body = builder.add_body(
        xform=wp.transform(wp.vec3(float(position[0]), float(position[1]), float(position[2])), wp.quat_identity()),
        is_kinematic=True,
        label="ardy_pick_object",
    )
    builder.add_shape_box(
        body,
        hx=hx,
        hy=hy,
        hz=hz,
        cfg=newton.ModelBuilder.ShapeConfig(density=PICK_OBJECT_DENSITY_KG_M3, mu=1.0, ke=5.0e4, kd=1.0e3),
        color=(0.92, 0.24, 0.12),
        label="ardy_pick_cube",
    )
    return "ardy_pick_object_free_joint", size


def _hidden_collider_cfg(newton):
    return newton.ModelBuilder.ShapeConfig(
        density=0.0,
        mu=0.75,
        ke=8.0e4,
        kd=7.0e3,
        kf=1.2e3,
        restitution=0.0,
        mu_torsional=0.04,
        mu_rolling=0.06,
        is_visible=False,
        has_shape_collision=True,
    )


def _hidden_gripper_rubber_cfg(newton):
    return newton.ModelBuilder.ShapeConfig(
        density=0.0,
        mu=T3_GRIPPER_RUBBER_FRICTION,
        ke=1.0e5,
        kd=1.0e3,
        kf=1.0e3,
        restitution=0.0,
        mu_torsional=0.01,
        mu_rolling=0.005,
        is_visible=False,
        has_shape_collision=True,
    )


def _visible_gripper_rubber_cfg(newton):
    return newton.ModelBuilder.ShapeConfig(
        density=0.0,
        mu=T3_GRIPPER_RUBBER_FRICTION,
        ke=1.0e5,
        kd=1.0e3,
        kf=1.0e3,
        restitution=0.0,
        mu_torsional=0.01,
        mu_rolling=0.005,
        is_visible=True,
        has_shape_collision=True,
    )


def _is_gripper_contact_suffix(suffix: str) -> bool:
    return "gripper" in str(suffix)


def _disable_shape_collision(newton, builder, start: int, end: int) -> None:
    collide_bit = int(newton.ShapeFlags.COLLIDE_SHAPES)
    for shape_idx in range(start, end):
        builder.shape_flags[shape_idx] = int(builder.shape_flags[shape_idx]) & ~collide_bit


def _disable_shape_collision_except_body_suffixes(
    newton,
    builder,
    start: int,
    end: int,
    keep_suffixes: set[str],
) -> None:
    collide_bit = int(newton.ShapeFlags.COLLIDE_SHAPES)
    for shape_idx in range(start, end):
        body_idx = int(builder.shape_body[shape_idx])
        body_suffix = str(builder.body_label[body_idx]).rsplit("/", 1)[-1] if body_idx >= 0 else ""
        if body_suffix in keep_suffixes:
            builder.shape_flags[shape_idx] = int(builder.shape_flags[shape_idx]) | collide_bit
        else:
            builder.shape_flags[shape_idx] = int(builder.shape_flags[shape_idx]) & ~collide_bit


def _disable_shape_collision_except_shape_labels(
    newton,
    builder,
    start: int,
    end: int,
    keep_labels: set[str],
) -> None:
    collide_bit = int(newton.ShapeFlags.COLLIDE_SHAPES)
    for shape_idx in range(start, end):
        shape_label = str(builder.shape_label[shape_idx]).rsplit("/", 1)[-1]
        if shape_label in keep_labels:
            builder.shape_flags[shape_idx] = int(builder.shape_flags[shape_idx]) | collide_bit
        else:
            builder.shape_flags[shape_idx] = int(builder.shape_flags[shape_idx]) & ~collide_bit


def _add_hidden_actor_colliders(newton, wp, builder, floor_z: float) -> tuple[str, list[str]]:
    cfg = _hidden_collider_cfg(newton)
    robot_body = builder.add_body(
        xform=wp.transform(wp.vec3(0.0, 0.0, float(floor_z) + 0.85), wp.quat_identity()),
        mass=48.0,
        is_kinematic=True,
        label="hidden_robot_solid",
    )
    builder.add_shape_box(
        robot_body,
        hx=0.45,
        hy=0.38,
        hz=0.85,
        cfg=cfg,
        label="hidden_robot_solid_box",
    )

    human_body = builder.add_body(
        xform=wp.transform(wp.vec3(0.0, 0.0, float(floor_z) + 0.9), wp.quat_identity()),
        mass=70.0,
        is_kinematic=True,
        label="hidden_soma_solid",
    )
    builder.add_shape_capsule(
        human_body,
        radius=0.28,
        half_height=0.75,
        cfg=cfg,
        label="hidden_soma_solid_capsule",
    )
    return "hidden_robot_solid_free_joint", "hidden_soma_solid_free_joint"


def _add_visible_t3_gripper_rubber_pads(newton, wp, builder, body_start: int, body_end: int) -> int:
    cfg = _visible_gripper_rubber_cfg(newton)
    count = 0
    for body_idx in range(int(body_start), int(body_end)):
        suffix = str(builder.body_label[body_idx]).rsplit("/", 1)[-1]
        if suffix not in {"left_gripper_link1", "left_gripper_link2", "right_gripper_link1", "right_gripper_link2"}:
            continue
        builder.add_shape_box(
            body_idx,
            xform=wp.transform(wp.vec3(0.0, -0.032, 0.0), wp.quat_identity()),
            hx=T3_GRIPPER_PAD_HALF_EXTENTS_M[0],
            hy=T3_GRIPPER_PAD_HALF_EXTENTS_M[1],
            hz=T3_GRIPPER_PAD_HALF_EXTENTS_M[2],
            cfg=cfg,
            color=(0.10, 0.12, 0.14),
            label=f"{suffix}_visible_rubber_pad",
        )
        count += 1
    return count


def _add_hidden_t3_bottle_colliders(newton, wp, builder) -> dict[str, str]:
    """Add the fingertip contact pads needed for bottle picking."""
    gripper_cfg = _hidden_gripper_rubber_cfg(newton)
    joint_names: dict[str, str] = {}
    for suffix in tuple(T3_PICK_CONTACT_BODY_SUFFIXES):
        body = builder.add_body(
            xform=wp.transform(wp.vec3(0.0, 0.0, -100.0), wp.quat_identity()),
            mass=0.2,
            is_kinematic=True,
            label=f"hidden_t3_bottle_collision_{suffix}",
        )
        builder.add_shape_box(
            body,
            xform=wp.transform(wp.vec3(0.0, -0.032, 0.0), wp.quat_identity()),
            hx=T3_GRIPPER_PAD_HALF_EXTENTS_M[0],
            hy=T3_GRIPPER_PAD_HALF_EXTENTS_M[1],
            hz=T3_GRIPPER_PAD_HALF_EXTENTS_M[2],
            cfg=gripper_cfg,
            color=(0.10, 0.12, 0.14),
            label=f"hidden_t3_bottle_collision_{suffix}_rubber_pad",
        )
        joint_names[suffix] = f"hidden_t3_bottle_collision_{suffix}_free_joint"
    return joint_names


def _configure_mujoco_pick_contacts(builder, bottle_body_labels: list[str]) -> None:
    condim = getattr(builder, "custom_attributes", {}).get("mujoco:condim")
    if condim is None:
        return
    bottle_labels = set(bottle_body_labels)
    values = dict(getattr(condim, "values", {}) or {})
    for shape_idx, body_idx in enumerate(builder.shape_body):
        if body_idx < 0:
            continue
        label = str(builder.body_label[body_idx]).rsplit("/", 1)[-1]
        if "gripper" in label or label in bottle_labels:
            values[shape_idx] = 6
    condim.values = values


def _configure_t3_pick_actuators(newton, builder, joint_start: int, joint_end: int) -> None:
    for joint_idx in range(int(joint_start), int(joint_end)):
        label = str(builder.joint_label[joint_idx]).rsplit("/", 1)[-1]
        qd_start = int(builder.joint_qd_start[joint_idx])
        dof_dim = builder.joint_dof_dim[joint_idx]
        try:
            dof_count = int(sum(dof_dim))
        except TypeError:
            dof_count = int(dof_dim)
        qd_end = qd_start + dof_count
        q_start = int(builder.joint_q_start[joint_idx])
        for dof in range(qd_start, qd_end):
            builder.joint_target_mode[dof] = int(newton.JointTargetMode.POSITION)
            builder.joint_target_ke[dof] = 2000.0
            builder.joint_target_kd[dof] = 80.0
            builder.joint_effort_limit[dof] = 100.0
            builder.joint_velocity_limit[dof] = 3.0
        if label == "telescopic_lift_joint":
            for dof in range(qd_start, qd_end):
                builder.joint_target_ke[dof] = 100000.0
                builder.joint_target_kd[dof] = 2000.0
                builder.joint_effort_limit[dof] = 1000.0
                builder.joint_velocity_limit[dof] = 0.25
        if label.startswith(("left_gripper_joint", "right_gripper_joint")):
            for dof in range(qd_start, qd_end):
                builder.joint_target_ke[dof] = 1000.0
                builder.joint_target_kd[dof] = 20.0
                builder.joint_effort_limit[dof] = 10.0
                builder.joint_velocity_limit[dof] = 0.25
            if q_start < len(builder.joint_q):
                builder.joint_q[q_start] = 0.05 if label.endswith("1") else -0.05


def _ensure_positive_joint_effort_limits(builder, joint_start: int, joint_end: int, minimum: float = 1.0) -> None:
    for joint_idx in range(int(joint_start), int(joint_end)):
        qd_start = int(builder.joint_qd_start[joint_idx])
        dof_dim = builder.joint_dof_dim[joint_idx]
        try:
            dof_count = int(sum(dof_dim))
        except TypeError:
            dof_count = int(dof_dim)
        for dof in range(qd_start, qd_start + dof_count):
            if dof < len(builder.joint_effort_limit) and float(builder.joint_effort_limit[dof]) <= 0.0:
                builder.joint_effort_limit[dof] = float(minimum)


def _is_t3_feedback_visual_body(body_suffix: str) -> bool:
    return (
        body_suffix.startswith(T3_FEEDBACK_VISUAL_BODY_PREFIXES)
        and "wheel" not in body_suffix
        and any(marker in body_suffix for marker in T3_FEEDBACK_VISUAL_BODY_MARKERS)
    )


def _configure_t3_feedback_visual_shapes(newton, builder, shape_start: int, shape_end: int, brightness: float = 0.4) -> None:
    visible_bit = int(newton.ShapeFlags.VISIBLE)
    collide_bit = int(newton.ShapeFlags.COLLIDE_SHAPES)
    brightness = float(np.clip(brightness, 0.0, 1.0))
    color = tuple(float(channel) * brightness for channel in T3_FEEDBACK_GHOST_COLOR)
    for shape_idx in range(int(shape_start), int(shape_end)):
        body_idx = int(builder.shape_body[shape_idx])
        body_suffix = str(builder.body_label[body_idx]).rsplit("/", 1)[-1] if body_idx >= 0 else ""
        if _is_t3_feedback_visual_body(body_suffix):
            builder.shape_flags[shape_idx] = (int(builder.shape_flags[shape_idx]) | visible_bit) & ~collide_bit
            builder.shape_color[shape_idx] = color
            scale = np.asarray(builder.shape_scale[shape_idx], dtype=np.float32)
            builder.shape_scale[shape_idx] = tuple((scale * T3_FEEDBACK_GHOST_SCALE).astype(float).tolist())
        else:
            builder.shape_flags[shape_idx] = int(builder.shape_flags[shape_idx]) & ~(visible_bit | collide_bit)


def _set_shape_range_instance_visibility(viewer, visible: bool, shape_start: int, shape_end: int) -> None:
    pending = getattr(viewer, "_pending_instance_visibility", None)
    shape_instances = getattr(viewer, "_shape_instances", None)
    if pending is None or not shape_instances:
        return
    start = int(shape_start)
    end = int(shape_end)
    for shapes in shape_instances.values():
        model_shapes = getattr(shapes, "model_shapes", None)
        if model_shapes is None:
            continue
        try:
            if not any(start <= int(shape_idx) < end for shape_idx in model_shapes):
                continue
        except TypeError:
            continue
        name = viewer._qualify(shapes.name) if hasattr(viewer, "_qualify") else shapes.name
        pending[name] = bool(visible)


def _set_shape_range_color(model, wp, shape_start: int, shape_end: int, color: tuple[float, float, float]) -> None:
    if model is None or getattr(model, "shape_color", None) is None:
        return
    try:
        colors = model.shape_color.numpy().copy()
        colors[int(shape_start) : int(shape_end)] = np.asarray(color, dtype=np.float32)
        wp.copy(model.shape_color, wp.array(colors, dtype=wp.vec3), 0, 0, len(colors))
    except Exception:
        return


def _push_shape_range_display_color(viewer, wp, shape_start: int, shape_end: int, color: tuple[float, float, float]) -> None:
    shape_instances = getattr(viewer, "_shape_instances", None)
    if not shape_instances:
        return
    color_value = tuple(float(v) for v in color)
    rtx = getattr(viewer, "_rtx", None)
    for shapes in shape_instances.values():
        model_shapes = list(getattr(shapes, "model_shapes", []) or [])
        if not model_shapes:
            continue
        try:
            local_indices = [
                idx
                for idx, shape_idx in enumerate(model_shapes)
                if int(shape_start) <= int(shape_idx) < int(shape_end)
            ]
        except TypeError:
            continue
        if not local_indices:
            continue
        paths = getattr(viewer, "_instance_prim_paths", {}).get(
            viewer._qualify(shapes.name) if hasattr(viewer, "_qualify") else shapes.name
        )
        if not paths:
            paths = getattr(viewer, "_instance_prim_paths", {}).get(shapes.name)
        target_paths = [paths[idx] for idx in local_indices if idx < len(paths)] if paths else []
        if rtx is not None and target_paths:
            for attr_name in ("primvars:displayColor", "displayColor"):
                try:
                    rtx.write_attribute(
                        prim_paths=target_paths,
                        attribute_name=attr_name,
                        tensor=[color_value] * len(target_paths),
                    )
                    break
                except Exception:
                    continue
        try:
            colors = shapes.colors.numpy().copy()
            for idx in local_indices:
                if idx < len(colors):
                    colors[idx] = color_value
            shapes.colors.assign(wp.array(colors, dtype=wp.vec3, device=shapes.colors.device))
            shapes.colors_changed = True
        except Exception:
            pass


def _joint_q_start_map_for_range(model, joint_start: int, joint_end: int) -> dict[str, int]:
    labels = list(getattr(model, "joint_label", []))
    starts = model.joint_q_start.numpy() if hasattr(model.joint_q_start, "numpy") else model.joint_q_start
    return {
        str(labels[idx]).rsplit("/", 1)[-1]: int(starts[idx])
        for idx in range(int(joint_start), min(int(joint_end), len(labels)))
    }


def _feedback_row_from_joint_states(right_msg, left_msg) -> dict | None:
    if right_msg is None and left_msg is None:
        return None
    joint_names: list[str] = []
    joint_cfg: list[float] = []

    def add_side(side: str, msg) -> None:
        if msg is None:
            return
        by_name = {
            str(name).rsplit("/", 1)[-1]: float(position)
            for name, position in zip(getattr(msg, "name", []), getattr(msg, "position", []))
        }
        positions = list(getattr(msg, "position", []))
        for index in range(1, 8):
            candidates = (f"{side}_joint{index}", f"joint{index}", f"joint_{index}")
            value = next((by_name[name] for name in candidates if name in by_name), None)
            if value is None and len(positions) >= index:
                value = float(positions[index - 1])
            if value is None:
                continue
            joint_names.append(f"{side}_joint{index}")
            joint_cfg.append(float(value))
        for local_name in ("gripper_joint1", "gripper_joint2"):
            value = by_name.get(f"{side}_{local_name}", by_name.get(local_name))
            if value is None:
                continue
            joint_names.append(f"{side}_{local_name}")
            joint_cfg.append(float(value))

    add_side("right", right_msg)
    add_side("left", left_msg)
    if not joint_names:
        return None
    return {
        "joint_names": joint_names,
        "joint_cfg": joint_cfg,
        "feedback_stamp_s": time.time(),
        "root_x_m": 0.0,
        "root_y_m": 0.0,
        "root_yaw_rad": 0.0,
    }


class T3RosFeedbackListener:
    def __init__(self, enabled: bool, right_topic: str, left_topic: str) -> None:
        self.enabled = bool(enabled)
        self.right_topic = str(right_topic)
        self.left_topic = str(left_topic)
        self.status = "ROS feedback disabled" if not self.enabled else "ROS feedback not started"
        self.latest_row: dict | None = None
        self.latest_motion_s = 0.0
        self.latest_receive_s = 0.0
        self._last_values: np.ndarray | None = None
        self._right_msg = None
        self._left_msg = None
        self._side_receive_s = {"left": 0.0, "right": 0.0}
        self._rclpy = None
        self._node = None
        self._process: subprocess.Popen[str] | None = None
        self._stop = threading.Event()
        self._thread: threading.Thread | None = None

    def start(self) -> None:
        if not self.enabled:
            return
        try:
            import rclpy
            from rclpy.node import Node
            from sensor_msgs.msg import JointState
        except Exception as exc:
            self.status = f"ROS feedback unavailable: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            self._start_stream_helper()
            return
        try:
            if not rclpy.ok():
                rclpy.init(args=None)
            self._rclpy = rclpy
            self._node = Node("ardy_newton_t3_feedback_listener")
            self._node.create_subscription(JointState, self.right_topic, lambda msg: self._update("right", msg), 10)
            self._node.create_subscription(JointState, self.left_topic, lambda msg: self._update("left", msg), 10)
            self._thread = threading.Thread(target=self._spin, name="t3-ros-feedback-listener", daemon=True)
            self._thread.start()
            self.status = f"ROS feedback listening: {self.right_topic}, {self.left_topic}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
        except Exception as exc:
            self.status = f"ROS feedback failed: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            self._start_stream_helper()

    def close(self) -> None:
        self._stop.set()
        if self._thread is not None:
            self._thread.join(timeout=1.0)
        if self._node is not None:
            try:
                self._node.destroy_node()
            except Exception:
                pass
        process = self._process
        self._process = None
        if process is not None and process.poll() is None:
            try:
                if process.stdin is not None:
                    process.stdin.close()
            except Exception:
                pass
            process.terminate()
            try:
                process.wait(timeout=1.0)
            except subprocess.TimeoutExpired:
                process.kill()

    def _start_stream_helper(self) -> None:
        script = ARDY_WORKSPACE_ROOT / "scripts" / "stream_t3_robot_sync.sh"
        if not script.is_file():
            self.status = f"ROS feedback helper missing: {script}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            return
        env = os.environ.copy()
        env["ARDY_T3_DRY_RUN"] = "1"
        env["ARDY_T3_REQUIRE_ARMS"] = "0"
        env["ARDY_T3_REQUIRE_BASE"] = "0"
        env["ARDY_T3_REQUIRE_LIFT"] = "0"
        env["ARDY_T3_SUBSCRIBER_WAIT"] = "0"
        env.setdefault("ROS_LOG_DIR", "/tmp/ardy_ros_logs")
        cmd = [
            str(script),
            "--right-feedback-topic",
            self.right_topic,
            "--left-feedback-topic",
            self.left_topic,
        ]
        try:
            self._process = subprocess.Popen(
                cmd,
                cwd=str(ARDY_WORKSPACE_ROOT),
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1,
                env=env,
            )
        except Exception as exc:
            self.status = f"ROS feedback helper failed: {exc}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)
            return
        self.status = f"ROS feedback helper listening: {self.right_topic}, {self.left_topic}"
        print(f"[ARDY Newton Viewer] {self.status}", flush=True)
        self._thread = threading.Thread(target=self._watch_stream_helper, name="t3-ros-feedback-helper", daemon=True)
        self._thread.start()

    def _watch_stream_helper(self) -> None:
        process = self._process
        if process is None or process.stdout is None:
            return
        for line in process.stdout:
            clean = line.rstrip()
            if clean.startswith("[FEEDBACK]"):
                try:
                    payload = json.loads(clean[len("[FEEDBACK]") :].strip())
                except json.JSONDecodeError:
                    continue
                if isinstance(payload, dict):
                    self._update_row(payload, source="helper")
                continue
            if clean.startswith("[READY]"):
                self.status = f"ROS feedback helper ready: {self.right_topic}, {self.left_topic}"
            elif clean.startswith("[ERROR]") or clean.startswith("[FEEDBACK ERROR]"):
                self.status = clean
            print(f"[ARDY Newton Viewer ROS Feedback] {clean}", flush=True)
        if not self._stop.is_set():
            code = process.poll()
            self.status = f"ROS feedback helper exited: {code}"
            print(f"[ARDY Newton Viewer] {self.status}", flush=True)

    def _spin(self) -> None:
        while not self._stop.is_set() and self._rclpy is not None and self._node is not None:
            try:
                self._rclpy.spin_once(self._node, timeout_sec=0.05)
            except Exception as exc:
                self.status = f"ROS feedback spin failed: {exc}"
                print(f"[ARDY Newton Viewer] {self.status}", flush=True)
                return

    def _update(self, side: str, msg) -> None:
        if side == "right":
            self._right_msg = msg
        else:
            self._left_msg = msg
        now = time.monotonic()
        self._side_receive_s[side] = now
        row = _feedback_row_from_joint_states(
            self._right_msg if now - self._side_receive_s["right"] <= T3_FEEDBACK_ACTIVE_SECONDS else None,
            self._left_msg if now - self._side_receive_s["left"] <= T3_FEEDBACK_ACTIVE_SECONDS else None,
        )
        if row is None:
            return
        self._update_row(row, source="rclpy")

    def _update_row(self, row: dict, *, source: str) -> None:
        values = np.asarray(row.get("joint_cfg", []), dtype=np.float64)
        self.latest_receive_s = time.monotonic()
        if self._last_values is None or values.shape != self._last_values.shape:
            self.latest_motion_s = time.monotonic()
        elif values.size and float(np.max(np.abs(values - self._last_values))) > T3_FEEDBACK_MOVE_EPS_RAD:
            self.latest_motion_s = time.monotonic()
        self._last_values = values
        self.latest_row = row
        self.status = f"ROS feedback ok ({source}): {len(values)} joints"


def _reset_physics_solver_state(physics_solver, state) -> None:
    if physics_solver is None:
        return
    reset = getattr(physics_solver, "reset", None)
    if callable(reset):
        reset(state)


def _add_physics_test_shapes(newton, wp, builder, floor_z: float) -> tuple[int, int]:
    from pxr import Usd
    from newton.usd import get_mesh

    drop_z = float(floor_z) + 2.0
    x = 0.0
    first_body = builder.body_count

    builder.default_shape_cfg.mu = 1.0
    builder.default_shape_cfg.mu_torsional = 0.01
    builder.default_shape_cfg.mu_rolling = 3.0e-3

    body_sphere = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, -2.0, drop_z), q=wp.quat_identity()),
        label="physics_test_sphere",
    )
    builder.add_shape_sphere(body_sphere, radius=0.5)

    body_ellipsoid = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, -6.0, drop_z), q=wp.quat_identity()),
        label="physics_test_ellipsoid",
    )
    builder.add_shape_ellipsoid(body_ellipsoid, rx=0.5, ry=0.5, rz=0.25)

    body_capsule = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, 0.0, drop_z), q=wp.quat_identity()),
        label="physics_test_capsule",
    )
    builder.add_shape_capsule(body_capsule, radius=0.3, half_height=0.7)

    body_cylinder = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, -4.0, drop_z), q=wp.quat_identity()),
        label="physics_test_cylinder",
    )
    builder.add_shape_cylinder(body_cylinder, radius=0.4, half_height=0.6)

    body_box = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, 2.0, drop_z), q=wp.quat_identity()),
        label="physics_test_box",
    )
    builder.add_shape_box(body_box, hx=0.5, hy=0.35, hz=0.25)

    bunny_candidates = [
        Path(newton.__file__).resolve().parent / "examples" / "assets" / "bunny.usd",
        REPO_ROOT / "deps" / "newton" / "newton" / "examples" / "assets" / "bunny.usd",
    ]
    for site_packages in Path(sys.prefix).glob("lib/python*/site-packages"):
        bunny_candidates.append(site_packages / "newton" / "examples" / "assets" / "bunny.usd")
    bunny_path = next((path for path in bunny_candidates if path.is_file()), None)
    if bunny_path is None:
        searched = ", ".join(str(path) for path in bunny_candidates)
        raise FileNotFoundError(f"Could not find Newton bunny.usd asset; searched: {searched}")
    usd_stage = Usd.Stage.Open(str(bunny_path))
    demo_mesh = get_mesh(usd_stage.GetPrimAtPath("/root/bunny"))
    body_mesh = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, 4.0, drop_z - 0.5), q=wp.quat(0.5, 0.5, 0.5, 0.5)),
        label="physics_test_mesh",
    )
    builder.add_shape_mesh(body_mesh, mesh=demo_mesh)

    body_cone = builder.add_body(
        xform=wp.transform(p=wp.vec3(x, 6.0, drop_z), q=wp.quat_identity()),
        label="physics_test_cone",
    )
    builder.add_shape_cone(body_cone, radius=0.45, half_height=0.6)
    return 7, first_body


def _set_kinematic_free_joint_pose(wp, newton, model, state, joint_q_start, joint_name: str | None, position) -> None:
    if not joint_name:
        return
    start = joint_q_start.get(joint_name)
    if start is None:
        return
    q = model.joint_q.numpy().copy()
    if isinstance(position, tuple) and len(position) == 2:
        pos = np.asarray(position[0], dtype=np.float64)
        quat = np.asarray(position[1], dtype=np.float64)
    else:
        pos = np.asarray(position, dtype=np.float64)
        quat = np.array([0.0, 0.0, 0.0, 1.0], dtype=np.float64)
    q[start : start + 7] = np.array([pos[0], pos[1], pos[2], quat[0], quat[1], quat[2], quat[3]], dtype=np.float32)
    wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    newton.eval_fk(model, model.joint_q, model.joint_qd, state, None, body_flag_filter=int(newton.BodyFlags.KINEMATIC))


def _quat_conjugate_np(quat: np.ndarray) -> np.ndarray:
    q = np.asarray(quat, dtype=np.float64)
    return np.array([-q[0], -q[1], -q[2], q[3]], dtype=np.float64)


def _quat_multiply_np(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    ax, ay, az, aw = np.asarray(a, dtype=np.float64)
    bx, by, bz, bw = np.asarray(b, dtype=np.float64)
    return np.array(
        [
            aw * bx + ax * bw + ay * bz - az * by,
            aw * by - ax * bz + ay * bw + az * bx,
            aw * bz + ax * by - ay * bx + az * bw,
            aw * bw - ax * bx - ay * by - az * bz,
        ],
        dtype=np.float64,
    )


def _quat_angular_velocity_np(prev_quat: np.ndarray, quat: np.ndarray, dt: float) -> np.ndarray:
    if dt <= 1.0e-6:
        return np.zeros(3, dtype=np.float64)
    q0 = np.asarray(prev_quat, dtype=np.float64)
    q1 = np.asarray(quat, dtype=np.float64)
    if float(np.dot(q0, q1)) < 0.0:
        q1 = -q1
    delta = _quat_multiply_np(q1, _quat_conjugate_np(q0))
    norm = float(np.linalg.norm(delta))
    if norm > 1.0e-8:
        delta = delta / norm
    angle = 2.0 * math.atan2(float(np.linalg.norm(delta[:3])), float(np.clip(delta[3], -1.0, 1.0)))
    if angle > math.pi:
        angle -= 2.0 * math.pi
    axis_norm = float(np.linalg.norm(delta[:3]))
    if axis_norm <= 1.0e-8:
        return np.zeros(3, dtype=np.float64)
    return delta[:3] / axis_norm * (angle / dt)


def _pose_position_quat_np(pose: object) -> tuple[np.ndarray, np.ndarray]:
    if isinstance(pose, tuple) and len(pose) == 2:
        pos = np.asarray(pose[0], dtype=np.float64)
        quat = np.asarray(pose[1], dtype=np.float64)
    else:
        pos = np.asarray(pose, dtype=np.float64)
        quat = np.array([0.0, 0.0, 0.0, 1.0], dtype=np.float64)
    return pos, quat


def _set_kinematic_free_joint_poses(wp, newton, model, state, joint_q_start, poses: dict[str, object]) -> None:
    if not poses:
        return
    q = model.joint_q.numpy().copy()
    body_q = state.body_q.numpy().copy()
    changed = False
    body_changed = False
    for joint_name, pose in poses.items():
        pos, quat = _pose_position_quat_np(pose)
        pose_q = np.array([pos[0], pos[1], pos[2], quat[0], quat[1], quat[2], quat[3]], dtype=np.float32)
        start = joint_q_start.get(joint_name)
        if start is not None:
            q[start : start + 7] = pose_q
            changed = True
        body_suffix = str(joint_name).removesuffix("_free_joint")
        body_idx = _body_index_by_suffix(model, body_suffix)
        if body_idx is not None:
            # Hidden proxy joints are disabled in the assembled viewer model.
            # Write body_q directly so contact shapes are definitely co-located
            # with the rendered gripper/robot before collision detection.
            body_q[body_idx] = pose_q
            body_changed = True
    if changed:
        wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
        newton.eval_fk(model, model.joint_q, model.joint_qd, state, None, body_flag_filter=int(newton.BodyFlags.KINEMATIC))
    if body_changed:
        wp.copy(state.body_q, wp.array(body_q, dtype=wp.transform), 0, 0, len(body_q))


def _set_kinematic_body_velocities_for_poses(
    wp,
    model,
    state,
    poses: dict[str, object],
    previous_poses: dict[str, tuple[np.ndarray, np.ndarray]],
    dt: float,
) -> None:
    if not poses or dt <= 1.0e-6 or getattr(state, "body_qd", None) is None:
        previous_poses.clear()
        for joint_name, pose in poses.items():
            previous_poses[joint_name] = _pose_position_quat_np(pose)
        return
    body_qd = state.body_qd.numpy().copy()
    changed = False
    for joint_name, pose in poses.items():
        body_suffix = str(joint_name).removesuffix("_free_joint")
        body_idx = _body_index_by_suffix(model, body_suffix)
        pos, quat = _pose_position_quat_np(pose)
        previous = previous_poses.get(joint_name)
        previous_poses[joint_name] = (pos.copy(), quat.copy())
        if body_idx is None or previous is None:
            continue
        prev_pos, prev_quat = previous
        linear = (pos - prev_pos) / float(dt)
        angular = _quat_angular_velocity_np(prev_quat, quat, float(dt))
        linear = np.clip(linear, -4.0, 4.0)
        angular = np.clip(angular, -12.0, 12.0)
        body_qd[body_idx] = np.array(
            [angular[0], angular[1], angular[2], linear[0], linear[1], linear[2]],
            dtype=np.float32,
        )
        changed = True
    if changed:
        wp.copy(state.body_qd, wp.array(body_qd, dtype=wp.spatial_vector), 0, 0, len(body_qd))


def _set_kinematic_body_velocities_for_suffixes(
    wp,
    model,
    state,
    suffixes: tuple[str, ...],
    previous_poses: dict[str, tuple[np.ndarray, np.ndarray]],
    dt: float,
) -> None:
    if not suffixes or dt <= 1.0e-6 or getattr(state, "body_qd", None) is None:
        previous_poses.clear()
        for suffix in suffixes:
            pose = _body_pose_by_suffix(model, state, suffix)
            if pose is not None:
                previous_poses[suffix] = (pose[0].copy(), pose[1].copy())
        return
    body_qd = state.body_qd.numpy().copy()
    changed = False
    for suffix in suffixes:
        body_idx = _body_index_by_suffix(model, suffix)
        pose = _body_pose_by_suffix(model, state, suffix)
        if body_idx is None or pose is None:
            continue
        pos, quat = pose
        previous = previous_poses.get(suffix)
        previous_poses[suffix] = (pos.copy(), quat.copy())
        if previous is None:
            continue
        prev_pos, prev_quat = previous
        linear = np.clip((pos - prev_pos) / float(dt), -4.0, 4.0)
        angular = np.clip(_quat_angular_velocity_np(prev_quat, quat, float(dt)), -12.0, 12.0)
        body_qd[body_idx] = np.array(
            [angular[0], angular[1], angular[2], linear[0], linear[1], linear[2]],
            dtype=np.float32,
        )
        changed = True
    if changed:
        wp.copy(state.body_qd, wp.array(body_qd, dtype=wp.spatial_vector), 0, 0, len(body_qd))


def _contact_count_for_bottle_gripper(model, contacts, bottle_body_indices: list[int], bottle_index: int = 0) -> int:
    if not bottle_body_indices or contacts is None:
        return 0
    try:
        target_body = int(bottle_body_indices[min(max(0, int(bottle_index)), len(bottle_body_indices) - 1)])
        shape_body = model.shape_body.numpy() if hasattr(model.shape_body, "numpy") else model.shape_body
        shape_labels = [str(label) for label in getattr(model, "shape_label", [])]
        contact_shape0 = contacts.shape0.numpy()
        contact_shape1 = contacts.shape1.numpy()
    except Exception:
        return 0
    count = 0
    for shape0, shape1 in zip(contact_shape0, contact_shape1):
        s0 = int(shape0)
        s1 = int(shape1)
        if s0 < 0 or s1 < 0 or s0 >= len(shape_body) or s1 >= len(shape_body):
            continue
        b0 = int(shape_body[s0])
        b1 = int(shape_body[s1])
        if b0 != target_body and b1 != target_body:
            continue
        other_shape = s1 if b0 == target_body else s0
        other_label = shape_labels[other_shape] if other_shape < len(shape_labels) else ""
        if "hidden_t3_bottle_collision_right_gripper" in other_label or "rubber_pad" in other_label:
            count += 1
    return count


def _mujoco_contact_count_for_bottle_gripper(solver, bottle_index: int = 0) -> int:
    try:
        mj_model = solver.mj_model
        mj_data = solver.mj_data
        body_names = [mj_model.body(i).name for i in range(mj_model.nbody)]
        target_body_name = f"interactive_water_bottle_{min(max(0, int(bottle_index)), 999) + 1}"
    except Exception:
        return 0
    count = 0
    for contact_idx in range(int(getattr(mj_data, "ncon", 0))):
        try:
            geom0, geom1 = mj_data.contact[contact_idx].geom
            body0 = int(mj_model.geom_bodyid[int(geom0)])
            body1 = int(mj_model.geom_bodyid[int(geom1)])
            name0 = body_names[body0]
            name1 = body_names[body1]
        except Exception:
            continue
        bottle0 = name0 == target_body_name
        bottle1 = name1 == target_body_name
        if not (bottle0 or bottle1):
            continue
        other = name1 if bottle0 else name0
        if "right_gripper_link" in other or "hidden_t3_bottle_collision_right_gripper" in other:
            count += 1
    return count


def _step_physics_test(newton, wp, viewer, solver, collision_pipeline, contacts, state, state_next, control, dt: float):
    state.clear_forces()
    viewer.apply_forces(state)
    if solver.__class__.__name__ == "SolverMuJoCo":
        solver.step(state, state_next, control, None, dt)
    else:
        collision_pipeline.collide(state, contacts)
        solver.step(state, state_next, control, contacts, dt)
    return state_next, state


def _set_pick_object_pose(wp, newton, model, state, joint_q_start, pick_joint_name, position):
    if not pick_joint_name:
        return
    start = joint_q_start.get(pick_joint_name)
    if start is None:
        return
    q = model.joint_q.numpy().copy()
    pos = np.asarray(position, dtype=np.float64)
    q[start : start + 7] = np.array([pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, 1.0], dtype=np.float32)
    wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)


def _warm_rtx_frame(viewer, ovstream_bridges, state, time_s: float) -> None:
    if not hasattr(viewer, "_render_product_path"):
        return
    try:
        for warm_idx in range(2):
            viewer.begin_frame(time_s)
            viewer.log_state(state)
            viewer.end_frame()
            for ovstream_bridge in ovstream_bridges:
                ovstream_bridge.stream_latest()
            print(f"[ARDY Newton Viewer] RTX warm frame {warm_idx + 1}/2 complete", flush=True)
    except Exception as exc:
        print(f"[ARDY Newton Viewer] RTX warm frame failed: {exc}", flush=True)


def _set_non_ground_instance_visibility(viewer, newton, visible: bool) -> None:
    pending = getattr(viewer, "_pending_instance_visibility", None)
    shape_instances = getattr(viewer, "_shape_instances", None)
    if pending is None or not shape_instances:
        return
    for shapes in shape_instances.values():
        if int(getattr(shapes, "geo_type", -1)) == int(newton.GeoType.PLANE):
            continue
        name = viewer._qualify(shapes.name) if hasattr(viewer, "_qualify") else shapes.name
        pending[name] = bool(visible)


def _set_ground_instance_visibility(viewer, newton, visible: bool) -> None:
    pending = getattr(viewer, "_pending_instance_visibility", None)
    shape_instances = getattr(viewer, "_shape_instances", None)
    if pending is None or not shape_instances:
        return
    for shapes in shape_instances.values():
        if int(getattr(shapes, "geo_type", -1)) != int(newton.GeoType.PLANE):
            continue
        name = viewer._qualify(shapes.name) if hasattr(viewer, "_qualify") else shapes.name
        pending[name] = bool(visible)


def _register_soma_mesh_placeholder(viewer, wp) -> tuple[object | None, str]:
    return None, "SOMA placeholder skipped: using bundled NumPy skin data"


def _ensure_soma_mesh_tracking(viewer) -> None:
    mesh_paths = getattr(viewer, "_mesh_prim_paths", None)
    if not isinstance(mesh_paths, dict) or not hasattr(viewer, "_qualify") or not hasattr(viewer, "_get_path"):
        return
    mesh_name = viewer._qualify("/ardy_live_soma_mesh")
    mesh_paths.setdefault(mesh_name, viewer._get_path(mesh_name))


def _force_update_soma_mesh_points(viewer, points_np: np.ndarray) -> bool:
    points_np = np.asarray(points_np, dtype=np.float32)
    if points_np.ndim != 2 or points_np.shape[1] != 3:
        return False
    if not hasattr(viewer, "_qualify") or not hasattr(viewer, "_get_path"):
        return False
    mesh_name = viewer._qualify("/ardy_live_soma_mesh")
    prim_path = viewer._get_path(mesh_name)
    mesh_paths = getattr(viewer, "_mesh_prim_paths", None)
    if isinstance(mesh_paths, dict):
        prim_path = mesh_paths.setdefault(mesh_name, prim_path)
    meshes = getattr(viewer, "_meshes", None)
    if isinstance(meshes, dict) and mesh_name in meshes:
        try:
            meshes[mesh_name].GetPointsAttr().Set(points_np, getattr(viewer, "_frame_index", 0))
            meshes[mesh_name].GetVisibilityAttr().Set("inherited", getattr(viewer, "_frame_index", 0))
        except Exception:
            pass
    rtx = getattr(viewer, "_rtx", None)
    if rtx is None or not hasattr(viewer, "_make_point3f_dltensor"):
        pending = getattr(viewer, "_pending_mesh_points", None)
        if isinstance(pending, dict):
            pending[mesh_name] = points_np
        return False
    try:
        rtx.write_array_attribute(
            prim_paths=[prim_path],
            attribute_name="points",
            tensors=[viewer._make_point3f_dltensor(points_np)],
        )
        return True
    except Exception as exc:
        pending = getattr(viewer, "_pending_mesh_points", None)
        if isinstance(pending, dict):
            pending[mesh_name] = points_np
        print(f"[ARDY Newton Viewer] direct SOMA mesh update failed: {exc}", flush=True)
        return False


def _ensure_runtime_soma_mesh(viewer, points_np: np.ndarray, faces_np: np.ndarray | None) -> str | None:
    rtx = getattr(viewer, "_rtx", None)
    if rtx is None or faces_np is None:
        return None
    points_np = np.asarray(points_np, dtype=np.float32)
    faces_np = np.asarray(faces_np, dtype=np.int32).reshape(-1)
    if points_np.ndim != 2 or points_np.shape[1] != 3 or faces_np.size == 0:
        return None
    mesh_path = "/root/ardy_live_soma_runtime/mesh"
    if getattr(viewer, "_ardy_soma_runtime_mesh_ready", False):
        return mesh_path
    try:
        from pxr import Gf as _Gf
        from pxr import Sdf as _Sdf
        from pxr import Usd as _Usd
        from pxr import UsdGeom as _UsdGeom
        from pxr import UsdShade as _UsdShade
    except Exception as exc:
        print(f"[ARDY Newton Viewer] runtime SOMA USD unavailable: {exc}", flush=True)
        return None

    try:
        stage = _Usd.Stage.CreateInMemory()
        root = _UsdGeom.Xform.Define(stage, "/soma")
        stage.SetDefaultPrim(root.GetPrim())
        mesh = _UsdGeom.Mesh.Define(stage, "/soma/mesh")
        mesh.GetFaceVertexCountsAttr().Set([3] * (faces_np.size // 3))
        mesh.GetFaceVertexIndicesAttr().Set(faces_np.astype(np.uint32))
        mesh.GetPointsAttr().Set(points_np)
        mesh.GetDisplayColorAttr().Set([_Gf.Vec3f(0.58, 0.59, 0.57)])
        mesh.GetVisibilityAttr().Set("inherited")

        mat_path = "/soma/Materials/soma_body"
        material = _UsdShade.Material.Define(stage, mat_path)
        surface = _UsdShade.Shader.Define(stage, f"{mat_path}/PreviewSurface")
        surface.CreateIdAttr("UsdPreviewSurface")
        surface.CreateInput("diffuseColor", _Sdf.ValueTypeNames.Color3f).Set(_Gf.Vec3f(0.58, 0.59, 0.57))
        surface.CreateInput("roughness", _Sdf.ValueTypeNames.Float).Set(0.46)
        surface.CreateInput("metallic", _Sdf.ValueTypeNames.Float).Set(0.0)
        material.CreateSurfaceOutput().ConnectToSource(surface.ConnectableAPI(), "surface")
        _UsdShade.MaterialBindingAPI.Apply(mesh.GetPrim())
        _UsdShade.MaterialBindingAPI(mesh).Bind(material)

        handle = rtx.add_usd_reference_from_string(
            stage.GetRootLayer().ExportToString(),
            prefix_path="/root/ardy_live_soma_runtime",
        )
        viewer._ardy_soma_runtime_mesh_handle = handle
        viewer._ardy_soma_runtime_mesh_ready = True
        print(
            f"[ARDY Newton Viewer] runtime SOMA mesh added: {len(points_np)} verts, {faces_np.size // 3} tris",
            flush=True,
        )
        return mesh_path
    except Exception as exc:
        print(f"[ARDY Newton Viewer] runtime SOMA mesh add failed: {exc}", flush=True)
        return None


def _update_runtime_soma_mesh(viewer, points_np: np.ndarray, faces_np: np.ndarray | None) -> bool:
    # Use one live SOMA mesh path only. The RTX runtime USD path can leave a
    # stale bind-pose mesh behind while the live logged mesh keeps updating.
    return False


class SomaMeshReconstructor:
    def __init__(self):
        self.ready = False
        self.status = "SOMA local skin not initialized"
        self._torch = None
        self._skins = {}
        self.faces = None
        self.parent_indices = None
        self.bind_vertices = None
        self.bind_rig_transform_inv = None
        self.lbs_indices = None
        self.lbs_weights = None
        self.vertex_h = None
        try:
            skin_data_path = REPO_ROOT / "assets" / "soma" / "somaskel77" / "skin_standard.npz"
            skin_data = np.load(skin_data_path)
            self.bind_vertices = np.asarray(skin_data["bind_vertices"], dtype=np.float32)
            self.faces = np.asarray(skin_data["faces"], dtype=np.int32).reshape(-1)
            self.bind_rig_transform_inv = np.linalg.inv(
                np.asarray(skin_data["bind_rig_transform"], dtype=np.float32)
            ).astype(np.float32)
            self.lbs_indices = np.asarray(skin_data["lbs_indices"], dtype=np.int32)
            self.lbs_weights = np.asarray(skin_data["lbs_weights"], dtype=np.float32)
            self.vertex_h = np.concatenate(
                [self.bind_vertices, np.ones((self.bind_vertices.shape[0], 1), dtype=np.float32)],
                axis=1,
            )
            parent_indices = [-1] * int(len(skin_data["rig_joint_names"]))
            for parent, child in np.asarray(skin_data["rig_joint_connections"], dtype=np.int32):
                if 0 <= int(child) < len(parent_indices):
                    parent_indices[int(child)] = int(parent)
            self.parent_indices = parent_indices
            self.ready = True
            self.status = (
                f"SOMA NumPy skin ready: joints=77, {len(self.bind_vertices)} verts, "
                f"{self.faces.size // 3} tris"
            )
            return
        except Exception as exc:
            self.status = f"SOMA NumPy skin unavailable: {exc}"
        try:
            import torch

            from ardy.skeleton import SOMASkeleton30, SOMASkeleton77
            from ardy.viz.soma_skin import SOMASkin

            self._torch = torch
            for skeleton_cls in (SOMASkeleton30, SOMASkeleton77):
                skeleton = skeleton_cls(load=True)
                skin = SOMASkin(skeleton)
                self._skins[int(skeleton.nbjoints)] = skin
            skin77 = self._skins[77]
            self.faces = skin77.faces.detach().cpu().numpy().astype(np.int32).reshape(-1)
            self.parent_indices = skin77.skeleton_skin.joint_parents.detach().cpu().numpy().astype(np.int32).tolist()
            self.ready = True
            self.status = (
                f"SOMA local skin ready: joints={sorted(self._skins)}, {len(skin77.bind_vertices)} verts, "
                f"{self.faces.size // 3} tris"
            )
        except Exception as exc:
            self.status = f"SOMA local skin unavailable: {exc}"

    def vertices_from_frame(self, frame) -> np.ndarray | None:
        if self.ready and self.bind_vertices is not None:
            return self._numpy_vertices_from_frame(frame)
        if not self.ready or self._torch is None or not self._skins:
            return None
        joints_pos = np.asarray(frame.get("soma_joints_pos"), dtype=np.float32)
        joints_rot = np.asarray(frame.get("soma_joints_rot"), dtype=np.float32)
        if joints_pos.ndim != 2 or joints_pos.shape[1] != 3:
            self.status = f"SOMA local skin missing joint positions: shape={joints_pos.shape}"
            return None
        if joints_rot.ndim != 3 or joints_rot.shape[1:] != (3, 3):
            self.status = f"SOMA local skin missing joint rotations: shape={joints_rot.shape}"
            return None
        skin = self._skins.get(int(joints_pos.shape[0]))
        if skin is None:
            self.status = f"SOMA local skin unsupported joint count: {joints_pos.shape[0]}"
            return None
        try:
            torch = self._torch
            vertices = skin.skin(
                torch.as_tensor(joints_rot[None], dtype=torch.float32),
                torch.as_tensor(joints_pos[None], dtype=torch.float32),
                rot_is_global=True,
            )[0]
            self.status = f"SOMA local skin ok: joints={joints_pos.shape[0]}, verts={vertices.shape[0]}"
            return vertices.detach().cpu().numpy().astype(np.float32)
        except Exception as exc:
            self.status = f"SOMA local skin failed: {exc}"
            return None

    def _numpy_vertices_from_frame(self, frame) -> np.ndarray | None:
        joints_pos = np.asarray(frame.get("soma_joints_pos"), dtype=np.float32)
        joints_rot = np.asarray(frame.get("soma_joints_rot"), dtype=np.float32)
        if joints_pos.shape != (77, 3):
            self.status = f"SOMA NumPy skin needs 77 joint positions: shape={joints_pos.shape}"
            return None
        if joints_rot.shape != (77, 3, 3):
            self.status = f"SOMA NumPy skin needs 77 joint rotations: shape={joints_rot.shape}"
            return None
        try:
            posed_transform = np.broadcast_to(np.eye(4, dtype=np.float32), (77, 4, 4)).copy()
            posed_transform[:, :3, :3] = joints_rot
            posed_transform[:, :3, 3] = joints_pos
            affine = (posed_transform @ self.bind_rig_transform_inv)[:, :3, :]
            transforms = affine[self.lbs_indices]
            skinned = np.einsum("vkir,vr->vki", transforms, self.vertex_h, optimize=True)
            vertices = (skinned * self.lbs_weights[:, :, None]).sum(axis=1).astype(np.float32)
            self.status = f"SOMA NumPy skin ok: joints=77, verts={vertices.shape[0]}"
            return vertices
        except Exception as exc:
            self.status = f"SOMA NumPy skin failed: {exc}"
            return None


def _soma_mesh_vertices_for_newton(
    frame,
    offset_tx,
    floor_z,
    pick_position,
    pick_size,
    pick_visible,
    pick_pushable,
    obstacle_bounds: list[tuple[np.ndarray, np.ndarray]] | None = None,
    reconstructor: SomaMeshReconstructor | None = None,
):
    vertices = np.asarray(frame.get("soma_mesh_vertices"), dtype=np.float32)
    used_payload_vertices = vertices.ndim == 2 and vertices.shape[1] == 3
    if vertices.ndim != 2 or vertices.shape[1] != 3:
        vertices = reconstructor.vertices_from_frame(frame) if reconstructor is not None else None
    if vertices is None or vertices.ndim != 2 or vertices.shape[1] != 3:
        return None
    if not used_payload_vertices:
        soma_offset = np.asarray(frame.get("soma_offset", [0.0, 0.0, 0.0]), dtype=np.float32)
        if soma_offset.shape == (3,):
            vertices = vertices + soma_offset[None, :]
    newton_vertices = vertices @ ARDY_Y_UP_TO_NEWTON_Z_UP.T
    bounds = (np.min(newton_vertices, axis=0), np.max(newton_vertices, axis=0))
    lift = _support_height_for_bounds(bounds, floor_z)
    if lift is not None:
        newton_vertices[:, 2] += lift
    bounds = (np.min(newton_vertices, axis=0), np.max(newton_vertices, axis=0))
    correction = _actor_separation_from_pick_object(bounds, pick_position, pick_size, pick_visible, pick_pushable)
    for obstacle in obstacle_bounds or []:
        correction += _actor_separation_from_aabb(bounds, obstacle, margin=0.0, check_z=False)
    if np.any(correction):
        newton_vertices[:, 0] += correction[0]
        newton_vertices[:, 1] += correction[1]
        bounds = (np.min(newton_vertices, axis=0), np.max(newton_vertices, axis=0))
    transformed = _apply_tx_to_points(offset_tx, newton_vertices)
    if transformed.ndim == 2 and transformed.shape[1] == 3 and transformed.size:
        transformed = transformed.copy()
        transformed[:, 2] += float(floor_z) - float(np.min(transformed[:, 2]))
        bounds = (np.min(transformed, axis=0), np.max(transformed, axis=0))
        correction = np.zeros(2, dtype=np.float64)
        for obstacle in obstacle_bounds or []:
            correction += _actor_separation_from_aabb(bounds, obstacle, margin=0.0, check_z=False)
        if np.any(correction):
            transformed[:, 0] += correction[0]
            transformed[:, 1] += correction[1]
    return transformed


def _soma_live_floor_transform_for_newton(wp, frame):
    root = np.asarray(frame.get("soma_root_pos", [0.0, 0.0, 0.0]), dtype=np.float64)
    root_pos = _ardy_position_to_newton(root)
    vertices = np.asarray(frame.get("soma_mesh_vertices"), dtype=np.float32)
    if vertices.ndim == 2 and vertices.shape[1] == 3:
        newton_vertices = vertices @ ARDY_Y_UP_TO_NEWTON_Z_UP.T
        root_pos[2] = float(np.min(newton_vertices[:, 2]))
    else:
        root_pos[2] = 0.0
    return wp.transform(wp.vec3(float(root_pos[0]), float(root_pos[1]), float(root_pos[2])), wp.quat_identity())


def _soma_joint_points_for_newton(frame, offset_tx):
    joints = np.asarray(frame.get("soma_joints_pos"), dtype=np.float32)
    if joints.ndim != 2 or joints.shape[1] != 3:
        return None
    return _apply_tx_to_points(offset_tx, joints @ ARDY_Y_UP_TO_NEWTON_Z_UP.T)


def _soma_bone_segments_for_newton(frame, offset_tx):
    joints = _soma_joint_points_for_newton(frame, offset_tx)
    if joints is None:
        return None, None
    parents = frame.get("soma_joint_parents")
    if parents is None:
        return None, None
    try:
        parent_indices = np.asarray(parents, dtype=np.int32).reshape(-1)
    except Exception:
        return None, None
    count = min(len(parent_indices), len(joints))
    starts = []
    ends = []
    for idx in range(count):
        parent = int(parent_indices[idx])
        if parent < 0 or parent >= count:
            continue
        starts.append(joints[parent])
        ends.append(joints[idx])
    if not starts:
        return None, None
    return np.asarray(starts, dtype=np.float32), np.asarray(ends, dtype=np.float32)


def main() -> None:
    print(f"[ARDY Newton Viewer] starting with {sys.executable}", flush=True)
    args = _parse_args()
    if args.viewer == "rtx":
        os.environ.setdefault("PYOPENGL_PLATFORM", "glx")
        os.environ.setdefault("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
        os.environ.setdefault("__NV_PRIME_RENDER_OFFLOAD", "1")
        os.environ.setdefault("OVRTX_SKIP_USD_CHECK", "1")
    _setup_paths()

    import newton
    import warp as wp

    print(
        "[ARDY Newton Viewer] parsed config: "
        f"viewer={args.viewer}, background_usd={args.background_usd or 'none'}, "
        f"camera={args.camera_preset}, rtx_environment={args.rtx_environment}, "
        f"newton={getattr(newton, '__version__', 'unknown')}",
        flush=True,
    )

    try:
        from viewer_compat import enable_cpu_pinned_fallback
    except Exception:
        enable_cpu_pinned_fallback = lambda _viewer: None
    try:
        from cpu_robot_mesh_renderer import CpuRobotMeshRenderer
    except Exception:
        CpuRobotMeshRenderer = None

    frame_queue_size = 4 if args.playback_mode == "exact" else 240
    frame_queue: queue.Queue = queue.Queue(maxsize=frame_queue_size)
    threading.Thread(target=_reader, args=(frame_queue, args.playback_mode), daemon=True).start()
    ws_receiver = NativeWebSocketReceiver(args.websocket_host, args.websocket_port, frame_queue, args.playback_mode)
    if args.websocket_server:
        ws_receiver.start()
    t3_feedback_listener = T3RosFeedbackListener(
        bool(args.ros_feedback_enabled),
        str(args.right_feedback_topic),
        str(args.left_feedback_topic),
    )
    t3_feedback_listener.start()
    atexit.register(t3_feedback_listener.close)
    t3_ros_route = T3RosRoute(enabled=bool(args.ros_enabled), dry_run=bool(args.ros_dry_run), mode=str(args.ros_mode))
    if t3_ros_route.enabled:
        try:
            t3_ros_route.connect()
        except Exception as exc:
            t3_ros_route.last_error = str(exc)
            t3_ros_route.status = f"ROS route failed: {exc}"
            print(f"[ARDY Newton Viewer] {t3_ros_route.status}", flush=True)
    atexit.register(t3_ros_route.disconnect)

    print(f"[ARDY Newton Viewer] creating Viewer{args.viewer.upper()}", flush=True)
    viewer = _create_viewer(newton, args)
    enable_cpu_pinned_fallback(viewer)
    viewer.vsync = True
    if hasattr(viewer, "_render_left_panel"):
        viewer._render_left_panel = lambda: None
    if hasattr(viewer, "_render_stats_overlay"):
        viewer._render_stats_overlay = lambda: None
    if hasattr(viewer, "renderer"):
        viewer.renderer.set_title("ARDY Live Retarget")
        if args.viewer != "rtx":
            viewer.renderer.draw_sky = False
            viewer.renderer.draw_shadows = True

    recorder = RtxVideoRecorder(viewer, wp, args)
    atexit.register(recorder.finalize)
    ovstream_bridges = [
        OvstreamWebRtcBridge(viewer, wp, port, stream_port, args.camera_preset)
        for port, stream_port in zip(args.ovstream_port, args.ovstream_stream_port)
    ]
    if args.ovstream_webrtc:
        for ovstream_bridge in ovstream_bridges:
            ovstream_bridge.start()
    for ovstream_bridge in ovstream_bridges:
        atexit.register(ovstream_bridge.close)
    show_human_mesh = True
    show_t3_robot = True
    show_t3_feedback_ghost = True
    t3_feedback_ghost_brightness = 0.40
    show_gizmos = args.viewer != "rtx"
    latest_frame = {
        "show_soma_mesh": False,
        "show_t3_robot": True,
        "fps": 60.0,
        "frame_idx": 0,
        "t3_row": _make_t3_loaded_pose_row(frame_idx=0, fps=60.0),
        "status": "T3 ready",
    }
    fixed_t3_base_root = (0.0, 0.0, 0.0)
    latest_t3_feedback_row: dict | None = None
    latest_status = "T3 ready"
    floor_z = _resolve_floor_z(args)
    pick_table_physics_enabled = _use_pick_table_physics(args)
    background_obstacle_bounds = _background_table_blockers(
        args.background_usd,
        force_pick_table=pick_table_physics_enabled,
    )
    table_top_z_value = _table_top_z(background_obstacle_bounds)
    place_box_position = _default_place_box_position(table_top_z_value)
    place_box_spawn_position = place_box_position.copy()
    if background_obstacle_bounds:
        print("[ARDY Newton Viewer] background table blocker active for robot base/wheels", flush=True)
    show_contacts = False
    pick_object_visible = args.pick_object != "none"
    pick_object_position = list(args.pick_object_position)
    pick_object_size = max(0.02, float(args.pick_object_size))
    pick_object_mass_kg = PICK_OBJECT_DENSITY_KG_M3 * pick_object_size**3
    pick_object_push_mass_limit_kg = max(0.0, float(args.pick_object_push_mass_limit_kg))
    pick_object_pushable = args.pick_object != "none" and pick_object_mass_kg <= pick_object_push_mass_limit_kg
    manual_gripper_enabled = False
    manual_gripper_left_aperture = T3_GRIPPER_DEFAULT_APERTURE_M
    manual_gripper_right_aperture = T3_GRIPPER_DEFAULT_APERTURE_M
    auto_gripper_enabled = pick_table_physics_enabled
    selected_bottle_index = 2  # Right bottle is the default target for the right arm.
    hand_guard_corrections = 0
    soma_offset_tx = wp.transform_identity()
    t3_offset_tx = wp.transform_identity()
    t3_live_root_tx = wp.transform_identity()
    soma_live_gizmo_tx = wp.transform_identity()
    soma_gizmo_tx = wp.transform_identity()
    t3_gizmo_tx = wp.transform_identity()
    recorder_target = np.array([0.0, 0.0, floor_z + 0.8], dtype=np.float64)
    file_csv_path = str(getattr(args, "file_csv", "") or "").strip() or _latest_t3_csv_path()
    file_bvh_path = str(getattr(args, "file_bvh", "") or "").strip() or _latest_soma_bvh_path()
    file_playback_frames: list[dict] = []
    file_playback_index = 0
    file_playback_next_time = time.monotonic()
    file_playback_active = False
    file_playback_status = "file playback idle"
    demo_pick_job_token = 0
    demo_pick_requested = False
    pick_motion_fps = T3_DEMO_PICK_FPS
    physics_solver = None
    websocket_enabled = bool(args.websocket_server)
    render_source = (
        RENDER_SOURCE_WEBSOCKET
        if args.render_source == "auto" and websocket_enabled
        else RENDER_SOURCE_SIMULATION
        if args.render_source == "auto"
        else str(args.render_source)
    )
    soma_mesh_status = "SOMA mesh not registered"
    soma_skin_status = "SOMA local skin not initialized"
    soma_vertex_count = 0
    soma_triangle_count = 0
    soma_mesh_logged = False
    soma_skeleton_logged = False
    current_frame_idx = 0
    queued_frames = 0
    current_source_fps = 0.0
    current_render_fps = 0.0
    soma_mesh_source = "none"
    soma_faces = None
    soma_indices_wp, soma_mesh_status = _register_soma_mesh_placeholder(viewer, wp)
    print(f"[ARDY Newton Viewer] {soma_mesh_status}", flush=True)
    if soma_indices_wp is not None:
        try:
            soma_triangle_count = int(soma_indices_wp.shape[0]) // 3
        except Exception:
            soma_triangle_count = 0
    soma_reconstructor = SomaMeshReconstructor()
    soma_skin_status = soma_reconstructor.status
    print(f"[ARDY Newton Viewer] {soma_skin_status}", flush=True)
    if soma_indices_wp is None and soma_reconstructor.faces is not None:
        soma_indices_wp = wp.array(soma_reconstructor.faces, dtype=wp.int32)
        soma_triangle_count = int(soma_reconstructor.faces.size // 3)
        soma_mesh_status = f"SOMA faces from local skin: {soma_triangle_count} tris"
    if soma_indices_wp is not None and soma_reconstructor.bind_vertices is not None:
        placeholder_vertices = np.asarray(soma_reconstructor.bind_vertices, dtype=np.float32) @ ARDY_Y_UP_TO_NEWTON_Z_UP.T
        if placeholder_vertices.ndim == 2 and placeholder_vertices.shape[1] == 3 and placeholder_vertices.size:
            placeholder_vertices = placeholder_vertices.copy()
            placeholder_vertices[:, 2] += float(floor_z) - float(np.min(placeholder_vertices[:, 2])) - 1000.0
            viewer.log_mesh(
                "/ardy_live_soma_mesh",
                wp.array(placeholder_vertices, dtype=wp.vec3),
                soma_indices_wp,
                backface_culling=False,
            )
            soma_mesh_status = f"SOMA live mesh prim ready: {soma_triangle_count} tris"

    def send_t3_row_to_ros(row, *, frame_idx: int, fps: float, source: str = "viewer") -> None:
        if not isinstance(row, dict):
            return
        if not t3_ros_route.enabled:
            if source.startswith("demo_pick") or source == "incoming_frame":
                t3_ros_route.status = "ROS route disabled; pick frame not sent"
            return
        try:
            gripper_override = (
                {
                    "left": manual_gripper_left_aperture,
                    "right": manual_gripper_right_aperture,
                }
                if manual_gripper_enabled
                else None
            )
            t3_ros_route.send_row(
                row,
                frame_idx=int(row.get("frame_idx", frame_idx)),
                fps=float(row.get("fps", fps)),
                gripper_override=gripper_override,
            )
            if source == "demo_pick_start":
                print(
                    "[ARDY Newton Viewer] ROS pick route active: "
                    f"mode={t3_ros_route.mode} dry_run={t3_ros_route.dry_run} "
                    f"frame={t3_ros_route.last_frame_idx}",
                    flush=True,
                )
        except Exception as exc:
            t3_ros_route.last_error = str(exc)
            t3_ros_route.status = f"ROS send failed: {exc}"
            print(f"[ARDY Newton Viewer] {t3_ros_route.status} ({source})", flush=True)

    def start_t3_demo_pick_playback(
        requested_bottle_index=None,
        *,
        source: str = "ui",
        hand_side: str = "left",
        pick_all: bool = False,
        pick_count: int = 1,
    ) -> bool:
        nonlocal file_playback_frames, file_playback_index, file_playback_next_time
        nonlocal file_playback_active, file_playback_status, show_human_mesh, show_t3_robot
        nonlocal manual_gripper_enabled, selected_bottle_index, demo_pick_job_token
        nonlocal latest_frame, latest_t3_feedback_row, current_frame_idx, current_source_fps
        nonlocal render_source
        if not bottle_body_indices:
            file_playback_status = "T3 demo pick failed: no interactive bottles"
            print(f"[ARDY Newton Viewer] {file_playback_status}", flush=True)
            return False
        try:
            requested_hand_side = str(hand_side).strip().lower()
            auto_hand = requested_hand_side in {"auto", "nearest", "near"}
            hand_side = "left" if requested_hand_side.startswith("left") else "right"
            if requested_bottle_index is not None and not pick_all:
                selected_bottle_index = int(requested_bottle_index)
            selected_bottle_index = min(max(0, int(selected_bottle_index)), len(bottle_body_indices) - 1)
            if pick_count not in (1, 2):
                raise ValueError("pick_count must be 1 or 2")
            bottle_indices = list(range(len(bottle_body_indices))) if pick_all else [selected_bottle_index]
            if not pick_all and pick_count == 2:
                bottle_indices += [i for i in range(len(bottle_body_indices)) if i != selected_bottle_index][:1]
            if len(bottle_indices) < pick_count:
                raise ValueError("Not enough bottles on the table")
            # Read the live bottle pose; starting a motion must never reset a bottle.
            state_body_q = state.body_q.numpy()
            for bottle_idx, body_idx in enumerate(bottle_body_indices):
                if bottle_idx < len(bottle_positions):
                    bottle_positions[bottle_idx] = np.array(state_body_q[body_idx, :3], dtype=np.float64, copy=True)
            def on_table(index):
                pos = bottle_positions[index]
                return any(np.all(pos[:2] >= lo[:2] + INTERACTIVE_BOTTLE_RADIUS)
                           and np.all(pos[:2] <= hi[:2] - INTERACTIVE_BOTTLE_RADIUS)
                           and abs(pos[2] - hi[2] - INTERACTIVE_BOTTLE_HALF_HEIGHT) <= .035
                           for lo, hi in background_obstacle_bounds) and not (
                               np.all(np.abs(pos[:2] - place_box_position[:2]) < np.asarray(PLACE_BOX_HALF_EXTENTS_M[:2]) + INTERACTIVE_BOTTLE_RADIUS))
            if pick_all:
                bottle_indices = [i for i in bottle_indices if on_table(i)]
            elif pick_count == 2:
                bottle_indices = [selected_bottle_index] + [i for i in range(len(bottle_body_indices)) if i != selected_bottle_index and on_table(i)][:1]
            if not bottle_indices or any(not on_table(i) for i in bottle_indices) or (not pick_all and len(bottle_indices) != pick_count):
                raise ValueError("Select upright bottles resting on the table, outside the tray")
            targets_in_robot_space = [
                np.asarray(
                    wp.transform_point(wp.transform_inverse(t3_offset_tx), wp.vec3(state_body_q[bottle_body_indices[index], :3])),
                    dtype=np.float64,
                )
                for index in bottle_indices
            ]
            # Keep the robot root exactly where the viewer loaded it. The pick
            # scene is arranged into this fixed workspace instead of moving the
            # base to chase each object.
            job_root = fixed_t3_base_root
            job_targets = [
                _world_point_to_staged_local(target_in_robot_space, job_root)
                for target_in_robot_space in targets_in_robot_space
            ]
            place_in_robot_space_base = _world_point_to_staged_local(
                np.asarray(
                    wp.transform_point(wp.transform_inverse(t3_offset_tx), wp.vec3(_place_box_bottle_center(place_box_position))),
                    dtype=np.float64,
                ),
                job_root,
            )
            feedback_row_for_seed = _fresh_pick_feedback(
                t3_feedback_listener.latest_row, t3_feedback_listener.latest_receive_s,
            )
            job_joints = _t3_initial_joints_from_feedback(feedback_row_for_seed)
            grips = _pick_robot_grips(newton, wp, job_joints)
            job_hands = _pick_assignments(job_targets, grips) if auto_hand or len(job_targets) > 1 else [hand_side]
            print(
                "[ARDY Newton Viewer] T3 demo pick initial feedback: "
                f"{len(job_joints)} joint(s) from latest frame",
                flush=True,
            )
            demo_pick_job_token += 1
            job_token = demo_pick_job_token
            job_fps = pick_motion_fps
            render_source = RENDER_SOURCE_SIMULATION
            file_playback_active = False
            file_playback_index = 0
            show_human_mesh = False
            show_t3_robot = True
            manual_gripper_enabled = False
            file_playback_status = (
                f"generating T3 fixed-base pick from {source}: "
                f"{len(bottle_indices)} bottle(s) at {job_fps:.1f} FPS"
            )
            print(f"[ARDY Newton Viewer] {file_playback_status}", flush=True)
            frames = []
            demo_fps = job_fps
            seed_joints = dict(job_joints)
            parts = []
            for sequence_idx, (job_bottle_index, job_target, job_hand) in enumerate(zip(bottle_indices, job_targets, job_hands)):
                place_local = place_in_robot_space_base.copy()
                # Separate tray slots along X; arm sides keep separate Y lanes.
                place_local[0] += .08 * (sequence_idx // 2)
                place_local[1] += .14 if job_hand == "left" else -.14
                part_frames, demo_fps = _make_t3_demo_pick_frames(
                    newton,
                    wp,
                    job_target,
                    fps=job_fps,
                    initial_joints=seed_joints,
                    root_pose=job_root,
                    place_position=place_local,
                    hand_side=job_hand,
                    reference_motion_csv=args.t3_demo_pick_reference_csv,
                    reference_strength=args.t3_demo_pick_reference_strength,
                )
                for part_frame in part_frames:
                    frame = dict(part_frame)
                    row = dict(frame.get("t3_row", {})) if isinstance(frame.get("t3_row"), dict) else {}
                    new_frame_idx = len(frames)
                    row["frame_idx"] = new_frame_idx
                    row["demo_bottle_index"] = job_bottle_index
                    row["demo_pick_hand"] = job_hand
                    frame["frame_idx"] = new_frame_idx
                    frame["t3_row"] = row
                    frame["demo_bottle_index"] = job_bottle_index
                    frame["demo_pick_hand"] = job_hand
                    frame["status"] = (
                        f"T3 {job_hand} pick bottle {job_bottle_index + 1} "
                        f"frame {new_frame_idx}"
                    )
                    if feedback_row_for_seed is not None:
                        frame["t3_feedback_row"] = feedback_row_for_seed
                    frames.append(frame)
                parts.append(frames[-len(part_frames):])
                final_row = frames[-1].get("t3_row") if frames and isinstance(frames[-1].get("t3_row"), dict) else None
                if isinstance(final_row, dict):
                    seed_joints = _t3_initial_joints_from_feedback(final_row)
            # Obstacles transformed into the same fixed robot coordinate system.
            obstacle_world = list(background_obstacle_bounds)
            tray_body = _body_index_by_suffix(model, "place_box_target")
            if tray_body is not None:
                poses = state.body_q.numpy()
                for i, body in enumerate(model.shape_body.numpy()):
                    if body != tray_body:
                        continue
                    tx = _mul_transform_np(poses[body], model.shape_transform.numpy()[i])
                    scale = model.shape_scale.numpy()[i]
                    points = _transform_points_np(tx, _bounds_corners(-scale, scale))
                    obstacle_world.append((points.min(axis=0), points.max(axis=0)))
            obstacles = []
            for lo, hi in obstacle_world:
                corners = [_world_point_to_staged_local(np.asarray(wp.transform_point(
                    wp.transform_inverse(t3_offset_tx), wp.vec3(point))), job_root) for point in _bounds_corners(lo, hi)]
                obstacles.append((np.min(corners, axis=0), np.max(corners, axis=0)))
            combined = []
            for i in range(0, len(parts), 2):
                batch = _merge_pick_pair(parts[i], parts[i+1]) if i+1 < len(parts) else parts[i]
                try:
                    _validate_pick_clearance(newton, wp, batch, obstacles)
                except ValueError:
                    # Stagger the two arms if simultaneous motion lacks clearance.
                    if i+1 >= len(parts):
                        raise
                    batch = parts[i] + parts[i+1]
                    _validate_pick_clearance(newton, wp, batch, obstacles)
                combined.extend(batch)
            frames = combined
            for index, frame in enumerate(frames):
                frame["frame_idx"] = frame["t3_row"]["frame_idx"] = index
            if not frames:
                raise ValueError("No valid pick motion")
            file_playback_frames = frames
            latest_frame = frames[0] if frames else None
            current_frame_idx = int(latest_frame.get("frame_idx", 0)) if latest_frame is not None else -1
            current_source_fps = float(demo_fps)
            first_row = latest_frame.get("t3_row") if isinstance(latest_frame, dict) else None
            if isinstance(first_row, dict):
                _apply_t3_row(
                    wp,
                    newton,
                    model,
                    state,
                    default_q,
                    joint_q_start,
                    first_row,
                    t3_offset_tx,
                    floor_z,
                    t3_shape_count,
                    pick_object_position,
                    pick_object_size,
                    pick_object_visible,
                    pick_object_pushable,
                    None,
                    background_obstacle_bounds,
                    False,
                    calculate_bounds=False,
                    preserve_body_indices=bottle_body_indices,
                )
                _apply_t3_row(
                    wp,
                    newton,
                    model,
                    state_next,
                    default_q,
                    joint_q_start,
                    first_row,
                    t3_offset_tx,
                    floor_z,
                    t3_shape_count,
                    pick_object_position,
                    pick_object_size,
                    pick_object_visible,
                    pick_object_pushable,
                    None,
                    background_obstacle_bounds,
                    False,
                    calculate_bounds=False,
                    preserve_body_indices=bottle_body_indices,
                )
                _copy_t3_joint_targets_from_q(model, control, model.joint_q.numpy())
                _reset_physics_solver_state(physics_solver, state)
                send_t3_row_to_ros(first_row, frame_idx=current_frame_idx, fps=demo_fps, source="demo_pick_start")
            file_playback_index = 1 if len(frames) > 1 else 0
            file_playback_next_time = time.monotonic()
            file_playback_active = len(frames) > 1
            file_playback_status = (
                f"playing fixed-base pick: {len(bottle_indices)} bottle(s), "
                f"{len(file_playback_frames)} frames at {demo_fps:.1f} FPS"
            )
            print(f"[ARDY Newton Viewer] {file_playback_status}", flush=True)
            return True
        except Exception as exc:
            file_playback_active = False
            file_playback_status = f"T3 demo pick failed: {exc}"
            print(f"[ARDY Newton Viewer] {file_playback_status}", flush=True)
            return False

    def gui(ui):
        nonlocal pick_motion_fps
        nonlocal show_human_mesh, show_t3_robot, show_gizmos, soma_offset_tx, t3_offset_tx
        nonlocal show_t3_feedback_ghost, t3_feedback_ghost_brightness
        nonlocal floor_z
        nonlocal show_contacts, pick_object_visible, pick_object_pushable, pick_object_position
        nonlocal file_csv_path, file_bvh_path, file_playback_frames, file_playback_index
        nonlocal file_playback_next_time, file_playback_active, file_playback_status
        nonlocal websocket_enabled
        nonlocal render_source
        nonlocal manual_gripper_enabled, manual_gripper_left_aperture, manual_gripper_right_aperture
        nonlocal auto_gripper_enabled
        nonlocal selected_bottle_index
        nonlocal hand_guard_corrections
        nonlocal demo_pick_requested
        ui.set_next_window_pos(ui.ImVec2(16, 16))
        ui.set_next_window_size(ui.ImVec2(340, 560))
        ui.set_next_window_bg_alpha(0.82)
        flags = ui.WindowFlags_.no_collapse.value | ui.WindowFlags_.no_resize.value
        ui.begin("ARDY Newton Retarget", flags=flags)
        ui.text("SOMA mesh -> Newton IK -> T3 robot")
        render_source_index = 0 if render_source == RENDER_SOURCE_WEBSOCKET else 1
        ui.set_next_item_width(190)
        source_changed, render_source_index = ui.combo(
            "Render Source",
            render_source_index,
            RENDER_SOURCE_LABELS,
        )
        if source_changed:
            render_source = (
                RENDER_SOURCE_WEBSOCKET
                if render_source_index == 0
                else RENDER_SOURCE_SIMULATION
            )
            if render_source == RENDER_SOURCE_WEBSOCKET:
                if not websocket_enabled:
                    websocket_enabled = True
                    ws_receiver.start()
                file_playback_active = False
                file_playback_status = "simulation paused; rendering WebSocket frames"
            else:
                while True:
                    try:
                        frame_queue.get_nowait()
                    except queue.Empty:
                        break
                file_playback_status = "simulation selected; choose an IK pick or file motion"
        if render_source == RENDER_SOURCE_WEBSOCKET:
            ui.text("Live WebSocket SOMA/T3 frames are rendered.")
        else:
            ui.text("All local IK picks and motion playback are rendered.")
        _, show_human_mesh = ui.checkbox("Show SOMA Mesh", show_human_mesh)
        _, show_t3_robot = ui.checkbox("Show T3 Robot", show_t3_robot)
        _, show_t3_feedback_ghost = ui.checkbox("Show Feedback Hands", show_t3_feedback_ghost)
        ui.set_next_item_width(120)
        _, t3_feedback_ghost_brightness = ui.slider_float(
            "Feedback Brightness",
            float(t3_feedback_ghost_brightness),
            0.05,
            1.0,
            "%.2f",
        )
        _, show_gizmos = ui.checkbox("Show Gizmos", show_gizmos)
        ui.same_line()
        if ui.button("Reset"):
            show_gizmos = True
            soma_offset_tx = wp.transform_identity()
            t3_offset_tx = wp.transform_identity()
        ui.separator()
        if ui.collapsing_header("File Playback", flags=ui.TreeNodeFlags_.default_open):
            ui.set_next_item_width(300)
            file_csv_path = _ui_input_text(ui, "CSV Path", file_csv_path)
            ui.set_next_item_width(300)
            file_bvh_path = _ui_input_text(ui, "BVH Path", file_bvh_path)
            if ui.button("Use Latest CSV"):
                latest_csv = _latest_t3_csv_path()
                file_csv_path = latest_csv or file_csv_path
                file_playback_status = f"CSV: {Path(file_csv_path).name}" if file_csv_path else "no CSV found"
            ui.same_line()
            if ui.button("Use Latest BVH"):
                latest_bvh = _latest_soma_bvh_path()
                file_bvh_path = latest_bvh or file_bvh_path
                file_playback_status = f"BVH: {Path(file_bvh_path).name}" if file_bvh_path else "no BVH found"
            if ui.button("Load CSV Path File"):
                path_from_file = _read_path_file("rtx_csv_path.txt")
                file_csv_path = path_from_file or file_csv_path
                file_playback_status = f"CSV: {Path(file_csv_path).name}" if path_from_file else "no rtx_csv_path.txt"
            ui.same_line()
            if ui.button("Load BVH Path File"):
                path_from_file = _read_path_file("rtx_bvh_path.txt")
                file_bvh_path = path_from_file or file_bvh_path
                file_playback_status = f"BVH: {Path(file_bvh_path).name}" if path_from_file else "no rtx_bvh_path.txt"
            if ui.button("Browse CSV"):
                selected_csv = _browse_playback_file("Select T3 CSV", (("CSV files", "*.csv"), ("All files", "*")))
                if selected_csv:
                    file_csv_path = selected_csv
                    paired_bvh = _matching_bvh_for_csv(file_csv_path)
                    if paired_bvh:
                        file_bvh_path = paired_bvh
                    file_playback_status = f"CSV: {Path(file_csv_path).name}"
            ui.same_line()
            if ui.button("Browse BVH"):
                selected_bvh = _browse_playback_file(
                    "Select SOMA BVH",
                    (("BVH files", "*.bvh *.soma.bvh"), ("All files", "*")),
                )
                if selected_bvh:
                    file_bvh_path = selected_bvh
                    paired_csv = _matching_csv_for_bvh(file_bvh_path)
                    if paired_csv:
                        file_csv_path = paired_csv
                    file_playback_status = f"BVH: {Path(file_bvh_path).name}"
            if file_csv_path:
                ui.text(f"CSV: {Path(file_csv_path).name}")
            if file_bvh_path:
                ui.text(f"BVH: {Path(file_bvh_path).name}")

            def start_file_mode(mode: str) -> None:
                nonlocal file_csv_path, file_bvh_path
                nonlocal file_playback_frames, file_playback_index, file_playback_next_time
                nonlocal file_playback_active, file_playback_status
                nonlocal render_source
                try:
                    render_source = RENDER_SOURCE_SIMULATION
                    file_playback_status = f"loading {mode}"
                    file_csv_path = str(_resolve_playback_path(file_csv_path, (".csv",))) if file_csv_path else ""
                    file_bvh_path = (
                        str(_resolve_playback_path(file_bvh_path, (".soma.bvh", ".bvh"))) if file_bvh_path else ""
                    )
                    if mode in {"both", "bvh"} and not file_bvh_path and file_csv_path:
                        file_bvh_path = _matching_bvh_for_csv(file_csv_path)
                    if mode in {"both", "csv"} and not file_csv_path and file_bvh_path:
                        file_csv_path = _matching_csv_for_bvh(file_bvh_path)
                    file_playback_frames, source_fps = _make_file_playback_frames(
                        bvh_path=file_bvh_path,
                        csv_path=file_csv_path,
                        mode=mode,
                    )
                    file_playback_index = 0
                    file_playback_next_time = time.monotonic()
                    file_playback_active = True
                    file_playback_status = f"playing {mode}: {len(file_playback_frames)} frames at {source_fps:.2f} FPS"
                    print(f"[ARDY Newton Viewer] {file_playback_status}", flush=True)
                except Exception as exc:
                    file_playback_active = False
                    if "No module named 'torch'" in str(exc):
                        file_playback_status = "BVH needs torch in RTX Python; CSV-only works"
                    else:
                        file_playback_status = f"{mode} failed: {exc}"
                    print(f"[ARDY Newton Viewer] file playback failed: {exc}", flush=True)

            if ui.button("Play CSV"):
                start_file_mode("csv")
            ui.same_line()
            if ui.button("Play BVH"):
                start_file_mode("bvh")
            ui.same_line()
            if ui.button("Play Both"):
                start_file_mode("both")
            if ui.button("Stop File"):
                file_playback_active = False
                file_playback_status = "file playback stopped"
                try:
                    t3_ros_route.send_stop(current_frame_idx)
                except Exception as exc:
                    t3_ros_route.last_error = str(exc)
                    t3_ros_route.status = f"ROS stop failed: {exc}"
                    print(f"[ARDY Newton Viewer] {t3_ros_route.status}", flush=True)
            ui.text(file_playback_status[:180])
        ui.separator()
        if ui.collapsing_header("WebSocket Control", flags=ui.TreeNodeFlags_.default_open):
            changed, websocket_enabled = ui.checkbox("Enable WebSocket", websocket_enabled)
            if changed:
                if websocket_enabled:
                    ws_receiver.start()
                else:
                    ws_receiver.stop()
            ui.text(f"URL: ws://{args.websocket_host}:{int(args.websocket_port)}")
            ui.text(ws_receiver.status[:180])
            if websocket_enabled and render_source != RENDER_SOURCE_WEBSOCKET:
                ui.text("Connected; live frames are ignored in Simulation mode.")
        ui.separator()
        if ui.collapsing_header("ROS Control", flags=ui.TreeNodeFlags_.default_open):
            changed, ros_enabled = ui.checkbox("Send T3 to ROS", bool(t3_ros_route.enabled))
            if changed:
                try:
                    t3_ros_route.set_enabled(ros_enabled)
                except Exception as exc:
                    t3_ros_route.last_error = str(exc)
                    t3_ros_route.status = f"ROS route failed: {exc}"
                    print(f"[ARDY Newton Viewer] {t3_ros_route.status}", flush=True)
            changed, ros_dry_run = ui.checkbox("ROS Dry Run", bool(t3_ros_route.dry_run))
            if changed:
                was_enabled = bool(t3_ros_route.enabled)
                if t3_ros_route.connected:
                    t3_ros_route.disconnect()
                t3_ros_route.dry_run = bool(ros_dry_run)
                if was_enabled:
                    try:
                        t3_ros_route.set_enabled(True)
                    except Exception as exc:
                        t3_ros_route.last_error = str(exc)
                        t3_ros_route.status = f"ROS route failed: {exc}"
                        print(f"[ARDY Newton Viewer] {t3_ros_route.status}", flush=True)
            if ui.button("Robot"):
                t3_ros_route.mode = "robot"
            ui.same_line()
            if ui.button("Robot+Lift"):
                t3_ros_route.mode = "robot_lift"
            if ui.button("Base+Lift"):
                t3_ros_route.mode = "base_lift"
            ui.same_line()
            if ui.button("Full T3"):
                t3_ros_route.mode = "full"
            if ui.button("Connect ROS"):
                try:
                    t3_ros_route.set_enabled(True)
                except Exception as exc:
                    t3_ros_route.last_error = str(exc)
                    t3_ros_route.status = f"ROS route failed: {exc}"
                    print(f"[ARDY Newton Viewer] {t3_ros_route.status}", flush=True)
            ui.same_line()
            if ui.button("Disconnect ROS"):
                t3_ros_route.set_enabled(False)
            if ui.button("Send Current"):
                current_row = latest_frame.get("t3_row") if isinstance(latest_frame, dict) else None
                send_t3_row_to_ros(current_row, frame_idx=current_frame_idx, fps=current_source_fps or 60.0, source="ui")
            ui.text(f"Mode: {t3_ros_route.mode}")
            ui.text(f"Sent: {t3_ros_route.frames_sent} frame(s), last {t3_ros_route.last_frame_idx}")
            ui.text(t3_ros_route.status[:180])
            if t3_ros_route.last_error:
                ui.text(t3_ros_route.last_error[:180])
        ui.separator()
        if ui.collapsing_header("SOMA Debug", flags=ui.TreeNodeFlags_.default_open):
            lag_frames = max(0, int(ws_receiver.last_frame_idx) - int(current_frame_idx))
            ui.text(f"Rendered frame: {current_frame_idx}")
            ui.text(f"WS last frame: {ws_receiver.last_frame_idx}")
            ui.text(f"Lag frames: {lag_frames}")
            ui.text(f"Queue: {queued_frames}")
            ui.text(f"Source FPS: {current_source_fps:.1f}")
            ui.text(f"Render FPS: {current_render_fps:.1f}")
            ui.text(f"WS frames: {ws_receiver.frames_received}")
            ui.text(f"WS bytes: {ws_receiver.last_payload_bytes}")
            ui.text(f"Verts: {soma_vertex_count}")
            ui.text(f"Tris: {soma_triangle_count}")
            ui.text(f"Logged: {soma_mesh_logged}")
            ui.text(f"Skeleton: {soma_skeleton_logged}")
            ui.text(f"Source: {soma_mesh_source}")
            ui.text(soma_mesh_status[:180])
            ui.text(soma_skin_status[:180])
        ui.separator()
        if ui.collapsing_header("Camera", flags=ui.TreeNodeFlags_.default_open):
            camera_position, camera_pitch, camera_yaw, camera_fov = _camera_values(viewer)
            ui.text(
                f"Pos: {camera_position[0]:.3f}, {camera_position[1]:.3f}, {camera_position[2]:.3f}"
            )
            ui.text(f"Pitch/Yaw/FOV: {camera_pitch:.2f}, {camera_yaw:.2f}, {camera_fov:.1f}")
            if ui.button("Print Camera"):
                _print_camera_values(viewer)
            if ui.button("Front"):
                _set_camera_preset(viewer, wp, "front")
            ui.same_line()
            if ui.button("Back"):
                _set_camera_preset(viewer, wp, "back")
            ui.same_line()
            if ui.button("Left"):
                _set_camera_preset(viewer, wp, "left")
            ui.same_line()
            if ui.button("Right"):
                _set_camera_preset(viewer, wp, "right")
            if ui.button("Top"):
                _set_camera_preset(viewer, wp, "top")
            ui.same_line()
            if ui.button("Lobby"):
                _set_camera_preset(viewer, wp, "lobby")
            if ui.button("Diagonal"):
                _set_fixed_record_shot(viewer, wp, "diagonal")
            ui.same_line()
            if ui.button("Straight"):
                _set_fixed_record_shot(viewer, wp, "straight")
            if ui.button("Wide"):
                _set_fixed_record_shot(viewer, wp, "lobby_wide")
            ui.same_line()
            if ui.button("Mirror"):
                _set_fixed_record_shot(viewer, wp, "mirror_side")
            ui.same_line()
            if ui.button("Hall"):
                _set_fixed_record_shot(viewer, wp, "hall_long")
            if ui.button("Window"):
                _set_fixed_record_shot(viewer, wp, "window_long")
            ui.same_line()
            if ui.button("Window Zoom"):
                _set_fixed_record_shot(viewer, wp, "window_zoom")
            if ui.button("Close"):
                _set_fixed_record_shot(viewer, wp, "front_close")
            ui.same_line()
            if ui.button("Close Zoom"):
                _set_fixed_record_shot(viewer, wp, "front_zoom")
            if ui.button("Top Close"):
                _set_fixed_record_shot(viewer, wp, "top_close")
            ui.same_line()
            if ui.button("Top Zoom"):
                _set_fixed_record_shot(viewer, wp, "top_zoom")
            if ui.collapsing_header("Saved", flags=ui.TreeNodeFlags_.default_open):
                if ui.button("S Diag"):
                    _set_direct_camera_shot(viewer, wp, "saved_diagonal")
                ui.same_line()
                if ui.button("S Right"):
                    _set_direct_camera_shot(viewer, wp, "saved_full_right")
                ui.same_line()
                if ui.button("S Grass"):
                    _set_direct_camera_shot(viewer, wp, "saved_grass")
                if ui.button("S Left"):
                    _set_direct_camera_shot(viewer, wp, "saved_straight_left")
                ui.same_line()
                if ui.button("S Back"):
                    _set_direct_camera_shot(viewer, wp, "saved_straight_left_back")
                ui.same_line()
                if ui.button("S Front"):
                    _set_direct_camera_shot(viewer, wp, "saved_front")
                if ui.button("S Lobby"):
                    _set_direct_camera_shot(viewer, wp, "saved_full_lobby_diagonal")
                ui.same_line()
                if ui.button("S Origin"):
                    _set_direct_camera_shot(viewer, wp, "saved_origin_back")
                if ui.button("S Top L"):
                    _set_direct_camera_shot(viewer, wp, "saved_top_left")
                ui.same_line()
                if ui.button("S Top O"):
                    _set_direct_camera_shot(viewer, wp, "saved_origin_top")
        ui.separator()
        if ui.collapsing_header("Placement", flags=ui.TreeNodeFlags_.default_open):
            ui.text(f"Floor Z: {floor_z:.3f}")
            if background_obstacle_bounds:
                ui.text(f"Hand/table guards: {hand_guard_corrections}")
            if place_box_joint_name:
                ui.text("All demo picks place onto this box.")
                current_place_box = place_box_position.copy()
                edited_place_box = current_place_box.copy()
                ui.set_next_item_width(96)
                _, edited_place_box[0] = ui.slider_float("Box X", float(edited_place_box[0]), -1.25, 1.25, "%.3f")
                ui.set_next_item_width(96)
                _, edited_place_box[1] = ui.slider_float("Box Y", float(edited_place_box[1]), -1.25, 1.25, "%.3f")
                ui.set_next_item_width(96)
                box_z_min = (float(table_top_z_value) + PLACE_BOX_HALF_EXTENTS_M[2]) if table_top_z_value is not None else 0.0
                _, edited_place_box[2] = ui.slider_float("Box Z", float(edited_place_box[2]), box_z_min, 1.35, "%.3f")
                if not np.allclose(edited_place_box, current_place_box, atol=1.0e-5):
                    place_box_position[:] = edited_place_box
                    _set_kinematic_free_joint_pose(
                        wp,
                        newton,
                        model,
                        state,
                        scene_joint_q_start,
                        place_box_joint_name,
                        place_box_position,
                    )
                    _set_kinematic_free_joint_pose(
                        wp,
                        newton,
                        model,
                        state_next,
                        scene_joint_q_start,
                        place_box_joint_name,
                        place_box_position,
                    )
                    _reset_physics_solver_state(physics_solver, state)
                place_center = _place_box_bottle_center(place_box_position)
                ui.text(f"Bottle place center: ({place_center[0]:.2f}, {place_center[1]:.2f}, {place_center[2]:.2f})")
        ui.separator()
        if bottle_body_indices and ui.collapsing_header("Bottle Physics", flags=ui.TreeNodeFlags_.default_open):
            ui.text(f"Bottles: {len(bottle_body_indices)}")
            _, show_contacts = ui.checkbox("Show Contacts", show_contacts)
            selected_bottle_index = min(max(0, int(selected_bottle_index)), len(bottle_body_indices) - 1)
            ui.text(f"Selected: Bottle {selected_bottle_index + 1}")
            if ui.button("Prev Bottle"):
                selected_bottle_index = (selected_bottle_index - 1) % len(bottle_body_indices)
            ui.same_line()
            if ui.button("Next Bottle"):
                selected_bottle_index = (selected_bottle_index + 1) % len(bottle_body_indices)
            current_bottle_pos = bottle_positions[selected_bottle_index].copy()
            edited_bottle_pos = current_bottle_pos.copy()
            ui.set_next_item_width(96)
            _, edited_bottle_pos[0] = ui.slider_float("Bottle X", float(edited_bottle_pos[0]), -1.25, 1.25, "%.3f")
            ui.set_next_item_width(96)
            _, edited_bottle_pos[1] = ui.slider_float("Bottle Y", float(edited_bottle_pos[1]), -1.25, 1.25, "%.3f")
            ui.set_next_item_width(96)
            z_min = float(table_top_z_value) + INTERACTIVE_BOTTLE_HALF_HEIGHT if table_top_z_value is not None else -0.25
            _, edited_bottle_pos[2] = ui.slider_float("Bottle Z", float(edited_bottle_pos[2]), z_min, 1.45, "%.3f")
            if not np.allclose(edited_bottle_pos, current_bottle_pos, atol=1.0e-5):
                _move_interactive_bottle(
                    wp,
                    model,
                    state,
                    state_next,
                    scene_joint_q_start,
                    bottle_body_indices,
                    bottle_positions,
                    held_bottles,
                    selected_bottle_index,
                    edited_bottle_pos,
                    table_top_z_value,
                )
                _reset_physics_solver_state(physics_solver, state)
            if ui.button("-X"):
                edited_bottle_pos[0] -= 0.01
                _move_interactive_bottle(
                    wp,
                    model,
                    state,
                    state_next,
                    scene_joint_q_start,
                    bottle_body_indices,
                    bottle_positions,
                    held_bottles,
                    selected_bottle_index,
                    edited_bottle_pos,
                    table_top_z_value,
                )
                _reset_physics_solver_state(physics_solver, state)
            ui.same_line()
            if ui.button("+X"):
                edited_bottle_pos[0] += 0.01
                _move_interactive_bottle(
                    wp,
                    model,
                    state,
                    state_next,
                    scene_joint_q_start,
                    bottle_body_indices,
                    bottle_positions,
                    held_bottles,
                    selected_bottle_index,
                    edited_bottle_pos,
                    table_top_z_value,
                )
                _reset_physics_solver_state(physics_solver, state)
            ui.same_line()
            if ui.button("-Y"):
                edited_bottle_pos[1] -= 0.01
                _move_interactive_bottle(
                    wp,
                    model,
                    state,
                    state_next,
                    scene_joint_q_start,
                    bottle_body_indices,
                    bottle_positions,
                    held_bottles,
                    selected_bottle_index,
                    edited_bottle_pos,
                    table_top_z_value,
                )
                _reset_physics_solver_state(physics_solver, state)
            ui.same_line()
            if ui.button("+Y"):
                edited_bottle_pos[1] += 0.01
                _move_interactive_bottle(
                    wp,
                    model,
                    state,
                    state_next,
                    scene_joint_q_start,
                    bottle_body_indices,
                    bottle_positions,
                    held_bottles,
                    selected_bottle_index,
                    edited_bottle_pos,
                    table_top_z_value,
                )
                _reset_physics_solver_state(physics_solver, state)
            ui.text("Bottles move through gravity and contact only.")
            if ui.button("Reset Bottles + Box"):
                _reset_interactive_bottles(
                    wp,
                    model,
                    state,
                    state_next,
                    scene_joint_q_start,
                    bottle_body_indices,
                    bottle_spawn_positions,
                    bottle_positions,
                    held_bottles,
                    gripper_grasp_state,
                )
                place_box_position[:] = place_box_spawn_position
                _set_kinematic_free_joint_pose(
                    wp,
                    newton,
                    model,
                    state,
                    scene_joint_q_start,
                    place_box_joint_name,
                    place_box_position,
                )
                _set_kinematic_free_joint_pose(
                    wp,
                    newton,
                    model,
                    state_next,
                    scene_joint_q_start,
                    place_box_joint_name,
                    place_box_position,
                )
                _reset_physics_solver_state(physics_solver, state)
            _, pick_motion_fps = ui.slider_float("Pick FPS", pick_motion_fps, 60.0, 120.0, "%.0f")
            if ui.button("Pick Two (Both Arms)"):
                start_t3_demo_pick_playback(source="ui_two", hand_side="auto", pick_count=2)
            if ui.button("Pick Selected Auto"):
                start_t3_demo_pick_playback(source="ui_selected_auto", hand_side="auto", pick_all=False)
            ui.same_line()
            if ui.button("Pick All Auto"):
                start_t3_demo_pick_playback(source="ui_all_auto", hand_side="auto", pick_all=True)
            if ui.button("Export Latest Motion CSV"):
                try:
                    export_path = _export_latest_t3_motion_csv(file_playback_frames)
                    file_playback_status = f"exported CSV: {export_path.name}"
                    print(f"[ARDY Newton Viewer] exported latest T3 motion CSV: {export_path}", flush=True)
                except Exception as exc:
                    file_playback_status = f"CSV export failed: {exc}"
                    print(f"[ARDY Newton Viewer] CSV export failed: {exc}", flush=True)
        ui.separator()
        if ui.collapsing_header("Manual Grippers", flags=ui.TreeNodeFlags_.default_open):
            _, manual_gripper_enabled = ui.checkbox("Override Grippers", manual_gripper_enabled)
            _, auto_gripper_enabled = ui.checkbox("Auto Pick Grippers", auto_gripper_enabled)
            ui.set_next_item_width(140)
            _, manual_gripper_left_aperture = ui.slider_float(
                "Left Open m",
                manual_gripper_left_aperture,
                0.0,
                T3_GRIPPER_MAX_APERTURE_M,
                "%.3f",
            )
            ui.set_next_item_width(140)
            _, manual_gripper_right_aperture = ui.slider_float(
                "Right Open m",
                manual_gripper_right_aperture,
                0.0,
                T3_GRIPPER_MAX_APERTURE_M,
                "%.3f",
            )
            if ui.button("Open Both"):
                manual_gripper_enabled = True
                manual_gripper_left_aperture = T3_GRIPPER_MAX_APERTURE_M
                manual_gripper_right_aperture = T3_GRIPPER_MAX_APERTURE_M
                current_row = latest_frame.get("t3_row") if isinstance(latest_frame, dict) else None
                send_t3_row_to_ros(current_row, frame_idx=current_frame_idx, fps=current_source_fps or 60.0, source="open_grippers")
            ui.same_line()
            if ui.button("Close Both"):
                manual_gripper_enabled = True
                manual_gripper_left_aperture = 0.0
                manual_gripper_right_aperture = 0.0
                current_row = latest_frame.get("t3_row") if isinstance(latest_frame, dict) else None
                send_t3_row_to_ros(current_row, frame_idx=current_frame_idx, fps=current_source_fps or 60.0, source="close_grippers")
        if args.pick_object != "none" and ui.collapsing_header("Pick Object", flags=ui.TreeNodeFlags_.default_open):
            ui.text(f"Cube mass: {pick_object_mass_kg:.2f} kg")
            ui.text(f"Push limit: {pick_object_push_mass_limit_kg:.1f} kg")
            ui.text(f"Density: {PICK_OBJECT_DENSITY_KG_M3:.0f} kg/m^3")
            _, pick_object_visible = ui.checkbox("Show Pick Object", pick_object_visible)
            _, show_contacts = ui.checkbox("Show Contacts", show_contacts)
            _, pick_object_pushable = ui.checkbox("Pushable Object", pick_object_pushable)
            ui.set_next_item_width(86)
            _, pick_object_position[0] = ui.slider_float("Object X", pick_object_position[0], -2.5, 2.5, "%.3f")
            ui.set_next_item_width(86)
            _, pick_object_position[1] = ui.slider_float("Object Y", pick_object_position[1], -2.5, 2.5, "%.3f")
            ui.set_next_item_width(86)
            _, pick_object_position[2] = ui.slider_float("Object Z", pick_object_position[2], -0.5, 2.0, "%.3f")
            if ui.button("Place On Floor"):
                pick_object_position[2] = floor_z + pick_object_size * 0.5
        ui.separator()
        ui.text(latest_status)
        ui.text(t3_feedback_listener.status)
        record_status = recorder.status()
        if record_status:
            ui.text(record_status)
        ui.end()

    if hasattr(viewer, "register_ui_callback"):
        viewer.register_ui_callback(gui, position="free")

    builder = newton.ModelBuilder()
    if str(args.pick_table_physics_backend).startswith("mujoco"):
        try:
            newton.solvers.SolverMuJoCo.register_custom_attributes(builder)
        except Exception as exc:
            print(f"[ARDY Newton Viewer] MuJoCo contact attributes unavailable: {exc}", flush=True)
    builder.add_ground_plane(height=float(floor_z))
    t3_urdf = LOCAL_T3_URDF
    if not t3_urdf.exists():
        raise FileNotFoundError(f"Local T3 URDF not found: {t3_urdf}")
    t3_body_start = builder.body_count
    t3_shape_start = builder.shape_count
    t3_joint_start = len(builder.joint_enabled)
    builder.add_urdf(str(t3_urdf), floating=True, scale=1.0)
    t3_joint_end = len(builder.joint_enabled)
    _apply_t3_loaded_pose_to_builder(builder, t3_joint_start, t3_joint_end)
    t3_body_end = builder.body_count
    visible_gripper_pad_count = _add_visible_t3_gripper_rubber_pads(newton, wp, builder, t3_body_start, t3_body_end)
    t3_shape_end = builder.shape_count
    if str(args.pick_table_physics_backend).startswith("mujoco"):
        _ensure_positive_joint_effort_limits(builder, t3_joint_start, t3_joint_end, minimum=1.0)
    t3_shape_count = t3_shape_end
    t3_feedback_body_start = builder.body_count
    t3_feedback_shape_start = builder.shape_count
    t3_feedback_joint_start = len(builder.joint_enabled)
    builder.add_urdf(str(t3_urdf), floating=True, scale=1.0)
    t3_feedback_joint_end = len(builder.joint_enabled)
    _apply_t3_loaded_pose_to_builder(builder, t3_feedback_joint_start, t3_feedback_joint_end)
    t3_feedback_body_end = builder.body_count
    t3_feedback_shape_end = builder.shape_count
    _configure_t3_feedback_visual_shapes(
        newton,
        builder,
        t3_feedback_shape_start,
        t3_feedback_shape_end,
        t3_feedback_ghost_brightness,
    )
    if str(args.pick_table_physics_backend).startswith("mujoco"):
        _ensure_positive_joint_effort_limits(builder, t3_feedback_joint_start, t3_feedback_joint_end, minimum=1.0)
    for body_idx in range(t3_feedback_body_start, t3_feedback_body_end):
        builder.body_flags[body_idx] = int(newton.BodyFlags.KINEMATIC)
    for joint_idx in range(t3_feedback_joint_start, t3_feedback_joint_end):
        builder.joint_enabled[joint_idx] = False
    pick_joint_name, pick_object_size = _add_pick_object(newton, wp, builder, args)
    bottle_spawn_positions = _interactive_bottle_spawn_positions(background_obstacle_bounds)
    pick_table_visual_count = _add_pick_table_visual_shapes(
        newton,
        wp,
        builder,
        pick_table_physics_enabled and not _is_table_bottle_preview(args.background_usd),
    )
    table_collider_count = _add_table_physics_colliders(newton, wp, builder, background_obstacle_bounds)
    place_box_joint_name = _add_place_box(newton, wp, builder, pick_table_physics_enabled, place_box_position)
    bottle_body_labels = _add_interactive_bottles(
        newton,
        wp,
        builder,
        pick_table_physics_enabled,
        bottle_spawn_positions,
    )
    physics_scene_active = bool(args.physics_test_shapes or bottle_body_labels)
    physics_test_shape_count = 0
    hidden_robot_joint_name = None
    hidden_soma_joint_name = None
    hidden_t3_bottle_joint_names: dict[str, str] = {}
    t3_contact_shape_labels = {
        "left_gripper_link1_visible_rubber_pad",
        "left_gripper_link2_visible_rubber_pad",
        "right_gripper_link1_visible_rubber_pad",
        "right_gripper_link2_visible_rubber_pad",
    }
    if physics_scene_active:
        if str(args.pick_table_physics_backend).startswith("mujoco"):
            builder.body_flags[t3_body_start] = int(newton.BodyFlags.KINEMATIC)
            builder.joint_enabled[t3_joint_start] = False
            _configure_t3_pick_actuators(newton, builder, t3_joint_start + 1, t3_joint_end)
        else:
            for body_idx in range(t3_body_start, t3_body_end):
                builder.body_flags[body_idx] = int(newton.BodyFlags.KINEMATIC)
            for joint_idx in range(t3_joint_start, t3_joint_end):
                builder.joint_enabled[joint_idx] = False
        if args.real_gripper_collision:
            _disable_shape_collision_except_body_suffixes(
                newton,
                builder,
                t3_shape_start,
                t3_shape_end,
                T3_PICK_CONTACT_BODY_SUFFIXES,
            )
        else:
            # Keep the visible hand rubber pads as the physical
            # contact geometry. This makes what the user sees match what
            # MuJoCo solves, and avoids the old invisible-proxy mismatch where
            # the rendered rubber could pass through the bottle with zero
            # reported grip contacts.
            _disable_shape_collision_except_shape_labels(
                newton,
                builder,
                t3_shape_start,
                t3_shape_end,
                t3_contact_shape_labels,
            )
    if str(args.pick_table_physics_backend).startswith("mujoco"):
        _configure_mujoco_pick_contacts(builder, bottle_body_labels)
    if args.physics_test_shapes:
        hidden_joint_start = len(builder.joint_enabled)
        hidden_robot_joint_name, hidden_soma_joint_name = _add_hidden_actor_colliders(newton, wp, builder, floor_z)
        for joint_idx in range(hidden_joint_start, len(builder.joint_enabled)):
            builder.joint_enabled[joint_idx] = False
        physics_test_shape_count, _ = _add_physics_test_shapes(newton, wp, builder, floor_z)
    model = builder.finalize()
    state = model.state()
    state_next = model.state()
    control = model.control()
    newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
    newton.eval_fk(model, model.joint_q, model.joint_qd, state_next, None)
    bottle_body_indices = [
        body_idx
        for label in bottle_body_labels
        if (body_idx := _body_index_by_suffix(model, label)) is not None
    ]
    bottle_positions = [np.asarray(pos, dtype=np.float64) for pos in bottle_spawn_positions[: len(bottle_body_indices)]]
    held_bottles: dict[int, dict] = {}
    gripper_grasp_state: dict[str, dict] = {}
    hidden_t3_previous_poses: dict[str, tuple[np.ndarray, np.ndarray]] = {}
    visible_t3_gripper_previous_poses: dict[str, tuple[np.ndarray, np.ndarray]] = {}
    default_q = model.joint_q.numpy().copy()
    joint_q_start = _joint_q_start_map_for_range(model, t3_joint_start, t3_joint_end)
    scene_joint_q_start = _joint_q_start_map_for_range(model, 0, len(model.joint_label))
    t3_feedback_joint_q_start = _joint_q_start_map_for_range(
        model,
        t3_feedback_joint_start,
        t3_feedback_joint_end,
    )
    t3_feedback_root_q_start = int(model.joint_q_start.numpy()[t3_feedback_joint_start])
    viewer.set_model(model)
    _ensure_soma_mesh_tracking(viewer)
    _add_background_usd(viewer, args.background_usd)
    viewer.set_world_offsets([0, 0, 0])
    _set_camera_by_name(viewer, wp, args.camera_preset)
    collision_pipeline = newton.CollisionPipeline(model)
    contacts = collision_pipeline.contacts()
    physics_solver = None
    physics_backend_status = "disabled"
    if physics_scene_active:
        backend = str(args.pick_table_physics_backend)
        if backend.startswith("mujoco"):
            try:
                physics_solver = newton.solvers.SolverMuJoCo(
                    model,
                    njmax=2048,
                    nconmax=512,
                    use_mujoco_cpu=backend == "mujoco-cpu",
                    use_mujoco_contacts=True,
                    solver="newton",
                    integrator="implicitfast",
                    cone="elliptic",
                    iterations=100,
                    ls_iterations=50,
                    impratio=100,
                    enable_multiccd=True,
                )
                physics_solver.reset(state)
                physics_backend_status = backend
            except Exception as exc:
                detail = traceback.format_exc(limit=6)
                raise RuntimeError(
                    "MuJoCo pick physics was requested but could not start. "
                    "The viewer will not fall back to XPBD because XPBD is too slow and less realistic for this pick scene.\n"
                    f"{detail}"
                ) from exc
        else:
            physics_solver = newton.solvers.SolverXPBD(model, iterations=12)
            physics_backend_status = "xpbd"
    physics_substeps = max(1, int(args.physics_substeps))
    if physics_backend_status.startswith("mujoco") and bottle_body_labels:
        physics_substeps = max(16, physics_substeps)
    t3_fk_body_filter = int(newton.BodyFlags.KINEMATIC) if physics_scene_active else None
    mujoco_actuated_t3 = physics_backend_status.startswith("mujoco")
    if args.physics_test_shapes:
        print(
            "[ARDY Newton Viewer] physics test shapes: "
            f"{physics_test_shape_count} dynamic objects, hidden robot/SOMA hard colliders on",
            flush=True,
        )
    else:
        print("[ARDY Newton Viewer] physics test shapes: disabled", flush=True)
    if bottle_body_indices:
        print(
            "[ARDY Newton Viewer] interactive bottle physics: "
            f"{len(bottle_body_indices)} dynamic bottles at {INTERACTIVE_BOTTLE_MASS_KG:.2f} kg each, "
            f"{table_collider_count} hidden table collider(s), "
            f"place_box=({'on' if place_box_joint_name else 'off'}), "
            f"{pick_table_visual_count} pick-table visual shape(s), {visible_gripper_pad_count} visible rubber pad(s), "
            "visible right rubber pads are MuJoCo contact geometry, "
            f"backend={physics_backend_status}, substeps={physics_substeps}",
            flush=True,
        )

    cpu_robot_mesh_renderer = None
    if CpuRobotMeshRenderer is not None and isinstance(viewer, newton.viewer.ViewerGL) and not viewer.device.is_cuda:
        cpu_robot_mesh_renderer = CpuRobotMeshRenderer(viewer, model)

    time_s = 0.0
    first_end_frame = True
    requested_close = False
    next_frame_time = time.monotonic()
    last_perf_report = next_frame_time
    rendered_frames = 0
    perf_prepare_s = 0.0
    perf_physics_s = 0.0
    perf_render_s = 0.0
    perf_stream_s = 0.0
    perf_last_substeps = physics_substeps
    perf_bottle_gripper_contacts = 0
    last_feedback_values: np.ndarray | None = None
    last_feedback_motion_s = 0.0
    last_feedback_ghost_color: tuple[float, float, float] | None = None
    feedback_ghost_was_active: bool | None = None
    last_t3_pose_key: tuple | None = None
    if args.viewer == "rtx":
        _warm_rtx_frame(viewer, ovstream_bridges, state, time_s)
        first_end_frame = False
        next_frame_time = time.monotonic()
        last_perf_report = next_frame_time
    print("[ARDY Newton Viewer] ready for live frames", flush=True)
    while viewer.is_running() and not requested_close:
        loop_start = time.monotonic()
        prepare_t0 = time.perf_counter()
        queued_frames = frame_queue.qsize()
        soma_live_gizmo_tx = wp.transform_identity()
        if isinstance(t3_feedback_listener.latest_row, dict):
            latest_t3_feedback_row = t3_feedback_listener.latest_row
        if demo_pick_requested:
            demo_pick_requested = False
            print("[ARDY Newton Viewer] starting in-scene T3 pick from main loop", flush=True)
            start_t3_demo_pick_playback(source="ui", hand_side="auto")
            next_frame_time = time.monotonic()
        incoming_frame = None
        if render_source == RENDER_SOURCE_SIMULATION:
            # Keep live senders responsive without allowing queued live frames
            # to replace the currently selected local simulation motion.
            while True:
                try:
                    frame_queue.get_nowait()
                except queue.Empty:
                    break
        if (
            render_source == RENDER_SOURCE_SIMULATION
            and file_playback_active
            and file_playback_frames
        ):
            now_for_file = time.monotonic()
            if now_for_file >= file_playback_next_time:
                incoming_frame = file_playback_frames[file_playback_index]
                file_playback_index += 1
                source_fps = float(incoming_frame.get("fps", 30.0))
                file_playback_next_time = now_for_file + 1.0 / max(source_fps, 1.0e-3)
                if file_playback_index >= len(file_playback_frames):
                    file_playback_active = False
                    file_playback_status = f"file playback complete ({len(file_playback_frames)} frames)"
                else:
                    file_playback_status = (
                        f"file frame {file_playback_index}/{len(file_playback_frames) - 1}"
                    )
            else:
                pass
        elif render_source == RENDER_SOURCE_WEBSOCKET:
            incoming_frame = _get_next_frame(frame_queue, args.playback_mode)
        if incoming_frame is not None:
            latest_frame = incoming_frame
            command = str(latest_frame.get("command") or latest_frame.get("type") or "").strip().lower()
            if t3_ros_route.handle_command(latest_frame):
                continue
            if command == "close":
                requested_close = True
                continue
            if command in {"play_t3_demo_pick", "play_t3_pick_demo", "debug_t3_pick"}:
                print("[ARDY Newton Viewer] starting in-scene T3 pick from websocket", flush=True)
                requested_pick_count = 1
                try:
                    requested_pick_count = int(latest_frame.get("pick_count", 1))
                except Exception:
                    requested_pick_count = 1
                start_t3_demo_pick_playback(
                    requested_bottle_index=latest_frame.get("bottle_index"), source="websocket", hand_side="auto",
                    pick_count=requested_pick_count, pick_all=bool(latest_frame.get("pick_all", False)),
                )
                continue
            current_frame_idx = int(latest_frame.get("frame_idx", -1))
            if "show_soma_mesh" in latest_frame:
                show_human_mesh = bool(latest_frame["show_soma_mesh"])
            if "show_t3_robot" in latest_frame:
                show_t3_robot = bool(latest_frame["show_t3_robot"])
            if not isinstance(t3_feedback_listener.latest_row, dict) and isinstance(latest_frame.get("t3_feedback_row"), dict):
                latest_t3_feedback_row = latest_frame["t3_feedback_row"]
            frame_vertices = np.asarray(latest_frame.get("soma_mesh_vertices"), dtype=np.float32)
            if frame_vertices.ndim == 2 and frame_vertices.shape[1] == 3:
                soma_vertex_count = int(frame_vertices.shape[0])
                soma_mesh_source = "websocket vertices"
            elif latest_frame.get("soma_joints_pos") is not None and latest_frame.get("soma_joints_rot") is not None:
                soma_mesh_source = "local skin pending"
            else:
                soma_vertex_count = 0
                soma_mesh_source = "no SOMA payload"
            if "show_soma_mesh" in latest_frame or "show_t3_robot" in latest_frame:
                latest_status = latest_frame.get("status") or f"file Newton frame {int(latest_frame.get('frame_idx', 0))}"
            else:
                latest_status = f"live Newton frame {int(latest_frame.get('frame_idx', 0))}"
            incoming_t3_row = latest_frame.get("t3_row") if isinstance(latest_frame.get("t3_row"), dict) else None
            send_t3_row_to_ros(
                incoming_t3_row,
                frame_idx=current_frame_idx,
                fps=float(latest_frame.get("fps", current_source_fps or 60.0)),
                source="incoming_frame",
            )

        t3_row_payload = None
        debug_demo_pick = False
        kinematic_t3_demo_pick = False
        actuated_t3_demo = False
        table_pick_gripper_override = None

        if latest_frame is not None:
            t3_bounds = None
            soma_live_gizmo_tx = _soma_live_floor_transform_for_newton(wp, latest_frame)
            table_pick = latest_frame.get("table_pick")
            t3_row_payload = latest_frame.get("t3_row") if isinstance(latest_frame.get("t3_row"), dict) else None
            debug_demo_pick = bool(
                latest_frame.get("debug_demo_pick")
                or (isinstance(t3_row_payload, dict) and t3_row_payload.get("debug_demo_pick"))
            )
            kinematic_t3_demo_pick = bool(
                latest_frame.get("kinematic_t3_demo_pick")
                or (isinstance(t3_row_payload, dict) and t3_row_payload.get("kinematic_t3_demo_pick"))
            )
            actuated_t3_demo = bool(
                debug_demo_pick
                and not kinematic_t3_demo_pick
                and mujoco_actuated_t3
                and t3_row_payload is not None
            )
            row_frame_idx = (
                int(t3_row_payload.get("frame_idx", current_frame_idx))
                if isinstance(t3_row_payload, dict)
                else int(current_frame_idx)
            )
            demo_gripper_aperture_min = None
            table_pick_gripper_override = _table_pick_gripper_apertures(table_pick, current_frame_idx)
            if latest_frame.get("soma_mesh_faces") is not None:
                soma_faces = np.asarray(latest_frame["soma_mesh_faces"], dtype=np.int32).reshape(-1)
                soma_indices_wp = wp.array(soma_faces, dtype=wp.int32)
                soma_triangle_count = int(soma_faces.size // 3)
                soma_mesh_status = f"SOMA faces received: {soma_triangle_count} tris"
            elif soma_indices_wp is None and soma_reconstructor.faces is not None:
                soma_indices_wp = wp.array(soma_reconstructor.faces, dtype=wp.int32)
                soma_triangle_count = int(soma_reconstructor.faces.size // 3)
                soma_mesh_status = f"SOMA faces from local skin: {soma_triangle_count} tris"
            pose_gripper_override = (
                {
                    "left": manual_gripper_left_aperture,
                    "right": manual_gripper_right_aperture,
                }
                if manual_gripper_enabled
                else table_pick_gripper_override
                if table_pick_gripper_override
                else None
            )
            t3_pose_key = (
                id(t3_row_payload),
                row_frame_idx,
                tuple(np.asarray(_tx_to_numpy(t3_offset_tx), dtype=np.float64).tolist()),
                float(floor_z),
                bool(manual_gripper_enabled),
                float(manual_gripper_left_aperture),
                float(manual_gripper_right_aperture),
                tuple(sorted((pose_gripper_override or {}).items())),
            )
            update_t3_pose = physics_scene_active or t3_pose_key != last_t3_pose_key
            if update_t3_pose:
                t3_live_root_tx, t3_bounds = _apply_t3_row(
                    wp,
                    newton,
                    model,
                    state,
                    default_q,
                    joint_q_start,
                    t3_row_payload,
                    t3_offset_tx,
                    floor_z,
                    t3_shape_count,
                    pick_object_position,
                    pick_object_size,
                    pick_object_visible,
                    pick_object_pushable,
                    t3_fk_body_filter if actuated_t3_demo and row_frame_idx > 0 else None,
                    background_obstacle_bounds,
                    False,
                    pose_gripper_override,
                    demo_gripper_aperture_min,
                    control if actuated_t3_demo else None,
                    actuated_t3_demo and row_frame_idx > 0,
                    calculate_bounds=bool(recorder.enabled or pick_object_visible),
                    preserve_body_indices=bottle_body_indices,
                )
                last_t3_pose_key = t3_pose_key
            else:
                t3_bounds = None
            if (
                auto_gripper_enabled
                and not manual_gripper_enabled
                and not table_pick_gripper_override
                and not debug_demo_pick
            ):
                _apply_gripper_apertures(
                    wp,
                    newton,
                    model,
                    state,
                    joint_q_start,
                    _auto_pick_gripper_apertures(
                        model,
                        state,
                        joint_q_start,
                        bottle_positions,
                        held_bottles,
                    ),
                    t3_fk_body_filter,
                )
            _update_interactive_bottles(
                wp,
                model,
                state,
                state_next,
                joint_q_start,
                bottle_body_indices,
                bottle_positions,
                held_bottles,
                gripper_grasp_state,
                table_top_z_value,
            )
            if not table_pick_gripper_override and not debug_demo_pick:
                _enforce_gripper_bottle_aperture(
                    wp,
                    newton,
                    model,
                    state,
                    joint_q_start,
                    bottle_positions,
                    held_bottles,
                    t3_fk_body_filter,
                )
            hand_guard_corrections = _guard_t3_hand_bodies_from_obstacles(
                wp,
                newton,
                model,
                state,
                t3_shape_count,
                background_obstacle_bounds,
            )
            if hidden_robot_joint_name:
                t3_root_pos = _tx_position(t3_live_root_tx)
                _set_kinematic_free_joint_pose(
                    wp,
                    newton,
                    model,
                    state,
                    scene_joint_q_start,
                    hidden_robot_joint_name,
                    (float(t3_root_pos[0]), float(t3_root_pos[1]), float(t3_root_pos[2]) + 0.85),
                )
            if hidden_soma_joint_name:
                soma_points_for_collision = _soma_joint_points_for_newton(latest_frame, soma_offset_tx)
                if soma_points_for_collision is not None and soma_points_for_collision.size:
                    mins = np.min(soma_points_for_collision, axis=0)
                    maxs = np.max(soma_points_for_collision, axis=0)
                    _set_kinematic_free_joint_pose(
                        wp,
                        newton,
                        model,
                        state,
                        scene_joint_q_start,
                        hidden_soma_joint_name,
                        (
                            float((mins[0] + maxs[0]) * 0.5),
                            float((mins[1] + maxs[1]) * 0.5),
                            float(floor_z) + 0.9,
                        ),
                    )
            _push_pick_object_from_bounds(
                t3_bounds,
                pick_object_position,
                pick_object_size,
                pick_object_visible,
                pick_object_pushable,
                floor_z,
            )
            if physics_scene_active:
                hidden_t3_poses = {}
                for suffix, joint_name in hidden_t3_bottle_joint_names.items():
                    pose = _body_pose_by_suffix(model, state, suffix)
                    if pose is None:
                        continue
                    center, quat = pose
                    # Keep contact geometry aligned with the rendered robot, including
                    # open fingers. Lagging proxies can support objects in empty space.
                    hidden_t3_poses[joint_name] = (center, quat)
                _set_kinematic_free_joint_poses(wp, newton, model, state, scene_joint_q_start, hidden_t3_poses)
                hidden_t3_dt = 1.0 / max(
                    float(latest_frame.get("fps", current_source_fps or 60.0)) if latest_frame is not None else 60.0,
                    1.0e-3,
                )
                _set_kinematic_body_velocities_for_poses(
                    wp,
                    model,
                    state,
                    hidden_t3_poses,
                    hidden_t3_previous_poses,
                    hidden_t3_dt,
                )
                _set_kinematic_body_velocities_for_suffixes(
                    wp,
                    model,
                    state,
                    tuple(T3_PICK_CONTACT_BODY_SUFFIXES),
                    visible_t3_gripper_previous_poses,
                    hidden_t3_dt,
                )
            if t3_bounds is not None:
                mins, maxs = t3_bounds
                recorder_target = np.array(
                    [
                        float((mins[0] + maxs[0]) * 0.5),
                        float((mins[1] + maxs[1]) * 0.5),
                        float(min(maxs[2] - 0.35, floor_z + 1.05)),
                    ],
                    dtype=np.float64,
                )

        run_physics_step = (
            physics_solver is not None
            and (t3_row_payload is None or debug_demo_pick)
            and (not debug_demo_pick or incoming_frame is not None or not file_playback_active)
        )
        if run_physics_step:
            physics_t0 = time.perf_counter()
            physics_frame_fps = float(latest_frame.get("fps", current_source_fps or 60.0)) if latest_frame is not None else 60.0
            active_physics_substeps = physics_substeps
            frame_t3_row = latest_frame.get("t3_row") if isinstance(latest_frame.get("t3_row"), dict) else None
            perf_last_substeps = active_physics_substeps
            physics_dt = (1.0 / max(physics_frame_fps, 1.0e-3)) / active_physics_substeps
            for _ in range(active_physics_substeps):
                state, state_next = _step_physics_test(
                    newton,
                    wp,
                    viewer,
                    physics_solver,
                    collision_pipeline,
                    contacts,
                    state,
                    state_next,
                    control,
                    physics_dt,
                )
            if physics_solver.__class__.__name__ == "SolverMuJoCo":
                contact_bottle_index = (
                    int(frame_t3_row.get("demo_bottle_index", selected_bottle_index))
                    if isinstance(frame_t3_row, dict)
                    else selected_bottle_index
                )
                perf_bottle_gripper_contacts = _mujoco_contact_count_for_bottle_gripper(
                    physics_solver, contact_bottle_index
                )
            else:
                contact_bottle_index = (
                    int(frame_t3_row.get("demo_bottle_index", selected_bottle_index))
                    if isinstance(frame_t3_row, dict)
                    else selected_bottle_index
                )
                perf_bottle_gripper_contacts = _contact_count_for_bottle_gripper(
                    model, contacts, bottle_body_indices, contact_bottle_index
                )
            perf_physics_s += time.perf_counter() - physics_t0
        if run_physics_step and latest_frame is not None and t3_row_payload is not None and not actuated_t3_demo:
            # Physics advances bottle/table contacts, but the demo robot is
            # kinematic. Re-apply the current T3 row after the solver so the
            # rendered robot matches the playing frame instead of a stale/home
            # pose written by the physics backend.
            t3_live_root_tx, t3_bounds = _apply_t3_row(
                wp,
                newton,
                model,
                state,
                default_q,
                joint_q_start,
                t3_row_payload,
                t3_offset_tx,
                floor_z,
                t3_shape_count,
                pick_object_position,
                pick_object_size,
                pick_object_visible,
                pick_object_pushable,
                None,
                background_obstacle_bounds,
                False,
                {
                    "left": manual_gripper_left_aperture,
                    "right": manual_gripper_right_aperture,
                }
                if manual_gripper_enabled
                else table_pick_gripper_override
                if table_pick_gripper_override
                else None,
                demo_gripper_aperture_min,
                calculate_bounds=bool(recorder.enabled or pick_object_visible),
                preserve_body_indices=bottle_body_indices,
            )
            _apply_t3_row(
                wp,
                newton,
                model,
                state_next,
                default_q,
                joint_q_start,
                t3_row_payload,
                t3_offset_tx,
                floor_z,
                t3_shape_count,
                pick_object_position,
                pick_object_size,
                pick_object_visible,
                pick_object_pushable,
                None,
                background_obstacle_bounds,
                False,
                {
                    "left": manual_gripper_left_aperture,
                    "right": manual_gripper_right_aperture,
                }
                if manual_gripper_enabled
                else table_pick_gripper_override
                if table_pick_gripper_override
                else None,
                demo_gripper_aperture_min,
                calculate_bounds=False,
                preserve_body_indices=bottle_body_indices,
            )
        _update_interactive_bottles(
            wp,
            model,
            state,
            state_next,
            joint_q_start,
            bottle_body_indices,
            bottle_positions,
            held_bottles,
            gripper_grasp_state,
            table_top_z_value,
        )

        grip = _gripper_state(model, state, joint_q_start, "right")
        if grip is not None and table_top_z_value is not None and latest_frame is not None:
            table_bounds = next(
                (bounds for bounds in background_obstacle_bounds if abs(float(bounds[1][2]) - table_top_z_value) < 0.001),
                None,
            )
            if table_bounds is not None:
                ws_receiver.pick_scene = {
                    "type": "pick_scene",
                    "ready": True,
                    "frame_idx": current_frame_idx,
                    "bottles": [
                        {
                            "index": i,
                            "position": np.asarray(position, dtype=float).tolist(),
                            "radius": INTERACTIVE_BOTTLE_RADIUS * 1.015,
                        }
                        for i, position in enumerate(bottle_positions)
                    ],
                    "table_bounds": [np.asarray(x, dtype=float).tolist() for x in table_bounds],
                    "right_gripper": {
                        key: value.tolist() if isinstance(value, np.ndarray) else value
                        for key, value in grip.items()
                    },
                    "robot_offset": _tx_to_numpy(t3_offset_tx).tolist(),
                    "blocked": "",
                }
                ws_receiver.pick_scene_time = time.monotonic()

        recorder.begin_frame(recorder_target)
        viewer.begin_frame(time_s)
        if show_gizmos:
            soma_gizmo_tx = wp.mul(soma_offset_tx, soma_live_gizmo_tx)
            t3_gizmo_tx = wp.mul(t3_offset_tx, t3_live_root_tx)
            viewer.log_gizmo("human_offset", soma_gizmo_tx)
            viewer.log_gizmo("robot_offset0", t3_gizmo_tx)
        if latest_frame is not None and soma_indices_wp is not None:
            soma_vertices = _soma_mesh_vertices_for_newton(
                latest_frame,
                soma_offset_tx,
                floor_z,
                pick_object_position,
                pick_object_size,
                pick_object_visible,
                pick_object_pushable,
                background_obstacle_bounds,
                soma_reconstructor,
            )
            if soma_vertices is not None:
                soma_vertex_count = int(soma_vertices.shape[0])
                if soma_mesh_source == "local skin pending":
                    soma_mesh_source = "local skin"
                if show_human_mesh:
                    _push_pick_object_from_bounds(
                        (np.min(soma_vertices, axis=0), np.max(soma_vertices, axis=0)),
                        pick_object_position,
                        pick_object_size,
                        pick_object_visible,
                        pick_object_pushable,
                        floor_z,
                    )
                else:
                    soma_vertices = soma_vertices.copy()
                    soma_vertices[:, 2] -= 1000.0
                if show_human_mesh and soma_vertices.ndim == 2 and soma_vertices.shape[1] == 3 and soma_vertices.size:
                    soma_vertices = soma_vertices.copy()
                    soma_vertices[:, 2] += float(floor_z) - float(np.min(soma_vertices[:, 2]))
                runtime_mesh_updated = _update_runtime_soma_mesh(
                    viewer,
                    soma_vertices,
                    soma_faces if soma_faces is not None else soma_reconstructor.faces,
                )
                direct_mesh_updated = False
                if not runtime_mesh_updated:
                    viewer.log_mesh(
                        "/ardy_live_soma_mesh",
                        wp.array(soma_vertices, dtype=wp.vec3),
                        soma_indices_wp,
                        backface_culling=False,
                    )
                    direct_mesh_updated = _force_update_soma_mesh_points(viewer, soma_vertices)
                soma_mesh_logged = True
                soma_mesh_status = (
                    f"SOMA mesh logged: {soma_vertex_count} verts, {soma_triangle_count} tris, "
                    f"{soma_mesh_source}, direct={direct_mesh_updated}, runtime={runtime_mesh_updated}"
                )
            else:
                soma_mesh_logged = False
                soma_mesh_status = (
                    "SOMA mesh missing vertices; "
                    f"source={soma_mesh_source}; local_skin={soma_reconstructor.status}"
                )
        if latest_frame is not None:
            pick_position = (
                pick_object_position
                if pick_object_visible
                else (pick_object_position[0], pick_object_position[1], -100.0)
            )
            _set_pick_object_pose(wp, newton, model, state, scene_joint_q_start, pick_joint_name, pick_position)
            if show_contacts:
                collision_pipeline.collide(state, contacts)
        feedback_row_payload = latest_t3_feedback_row if isinstance(latest_t3_feedback_row, dict) else None
        feedback_values = (
            np.asarray(feedback_row_payload.get("joint_cfg", []), dtype=np.float64)
            if feedback_row_payload is not None
            else np.asarray([], dtype=np.float64)
        )
        if feedback_values.size:
            if last_feedback_values is None or feedback_values.shape != last_feedback_values.shape:
                last_feedback_motion_s = time.monotonic()
            elif float(np.max(np.abs(feedback_values - last_feedback_values))) > T3_FEEDBACK_MOVE_EPS_RAD:
                last_feedback_motion_s = time.monotonic()
            last_feedback_values = feedback_values.copy()
        if t3_feedback_listener.latest_motion_s > 0.0:
            last_feedback_motion_s = max(last_feedback_motion_s, float(t3_feedback_listener.latest_motion_s))
        feedback_fresh = (
            t3_feedback_listener.latest_receive_s > 0.0
            and time.monotonic() - float(t3_feedback_listener.latest_receive_s) <= T3_FEEDBACK_ACTIVE_SECONDS
        )
        feedback_ghost_active = (
            show_t3_feedback_ghost
            and feedback_row_payload is not None
            and feedback_values.size > 0
            and feedback_fresh
        )
        if feedback_ghost_active:
            feedback_overlay_row = _feedback_row_on_fixed_loaded_t3(feedback_row_payload)
            feedback_brightness = float(np.clip(t3_feedback_ghost_brightness, 0.05, 1.0))
            feedback_color = tuple(float(channel) * feedback_brightness for channel in T3_FEEDBACK_GHOST_COLOR)
            if feedback_color != last_feedback_ghost_color:
                _set_shape_range_color(
                    model,
                    wp,
                    t3_feedback_shape_start,
                    t3_feedback_shape_end,
                    feedback_color,
                )
                _push_shape_range_display_color(
                    viewer,
                    wp,
                    t3_feedback_shape_start,
                    t3_feedback_shape_end,
                    feedback_color,
                )
                last_feedback_ghost_color = feedback_color
            _apply_t3_row(
                wp,
                newton,
                model,
                state,
                default_q,
                t3_feedback_joint_q_start,
                feedback_overlay_row,
                t3_offset_tx,
                floor_z,
                t3_feedback_shape_end,
                pick_object_position,
                pick_object_size,
                False,
                False,
                None,
                None,
                False,
                None,
                None,
                None,
                False,
                t3_feedback_root_q_start,
                False,
                calculate_bounds=False,
                preserve_body_indices=bottle_body_indices,
            )
            feedback_ghost_was_active = True
        else:
            if feedback_ghost_was_active is not False:
                _hide_t3_feedback_ghost(
                    wp,
                    newton,
                    model,
                    state,
                    t3_feedback_root_q_start,
                    bottle_body_indices,
                )
            feedback_ghost_was_active = False
        _set_non_ground_instance_visibility(viewer, newton, show_t3_robot)
        _set_shape_range_instance_visibility(
            viewer,
            feedback_ghost_active,
            t3_feedback_shape_start,
            t3_feedback_shape_end,
        )
        _set_ground_instance_visibility(viewer, newton, not bool(args.background_usd))
        viewer.log_state(state)
        if show_t3_robot and cpu_robot_mesh_renderer is not None and t3_row_payload is None:
            cpu_robot_mesh_renderer.draw(state)
        if show_contacts and latest_frame is not None:
            viewer.log_contacts(contacts, state)
        if first_end_frame:
            print("[ARDY Newton Viewer] first end_frame: entering", flush=True)
        render_t0 = time.perf_counter()
        perf_prepare_s += render_t0 - prepare_t0
        viewer.end_frame()
        perf_render_s += time.perf_counter() - render_t0
        stream_t0 = time.perf_counter()
        for ovstream_bridge in ovstream_bridges:
            ovstream_bridge.stream_latest()
        perf_stream_s += time.perf_counter() - stream_t0
        if first_end_frame:
            print("[ARDY Newton Viewer] first end_frame: complete", flush=True)
            first_end_frame = False
            next_frame_time = time.monotonic()
        recorder.maybe_capture(time.monotonic())
        if latest_frame is not None and show_gizmos:
            soma_offset_tx = wp.mul(soma_gizmo_tx, wp.transform_inverse(soma_live_gizmo_tx))
            t3_offset_tx = wp.mul(t3_gizmo_tx, wp.transform_inverse(t3_live_root_tx))

        fps = float(latest_frame.get("fps", 60.0)) if latest_frame is not None else 60.0
        current_source_fps = fps
        frame_period = 1.0 / max(fps, 1.0e-3)
        time_s += frame_period
        rendered_frames += 1
        now = time.monotonic()
        if now - last_perf_report >= 1.0:
            actual_fps = rendered_frames / max(now - last_perf_report, 1.0e-6)
            current_render_fps = actual_fps
            lag_frames = max(0, int(ws_receiver.last_frame_idx) - int(current_frame_idx))
            skin_status_suffix = (
                f" soma_skin='{soma_reconstructor.status}'"
                if soma_mesh_source != "websocket vertices"
                else ""
            )
            print(
                "[ARDY Newton Viewer] playback "
                f"mode={args.playback_mode} source_fps={fps:.1f} render_fps={actual_fps:.1f} "
                f"current_frame={current_frame_idx} queued={frame_queue.qsize()} lag_frames={lag_frames} "
                f"ws_frames={ws_receiver.frames_received} ws_last={ws_receiver.last_frame_idx} "
                f"ws_bytes={ws_receiver.last_payload_bytes} "
                f"physics_backend={physics_backend_status} substeps={perf_last_substeps}/{physics_substeps} "
                f"prepare_ms={perf_prepare_s * 1000.0 / max(rendered_frames, 1):.1f} "
                f"physics_ms={perf_physics_s * 1000.0 / max(rendered_frames, 1):.1f} "
                f"grip_contacts={perf_bottle_gripper_contacts} "
                f"render_ms={perf_render_s * 1000.0 / max(rendered_frames, 1):.1f} "
                f"stream_ms={perf_stream_s * 1000.0 / max(rendered_frames, 1):.1f} "
                f"soma_verts={soma_vertex_count} soma_tris={soma_triangle_count} "
                f"mesh_logged={soma_mesh_logged} skeleton_logged={soma_skeleton_logged} "
                f"soma_source={soma_mesh_source} soma_status='{soma_mesh_status}' "
                f"ovstream='{'; '.join(bridge.status for bridge in ovstream_bridges)}'"
                f"{skin_status_suffix}",
                flush=True,
            )
            rendered_frames = 0
            perf_prepare_s = 0.0
            perf_physics_s = 0.0
            perf_render_s = 0.0
            perf_stream_s = 0.0
            last_perf_report = now
        next_frame_time = max(next_frame_time + frame_period, loop_start + frame_period)
        if frame_queue.empty():
            sleep_time = next_frame_time - time.monotonic()
            if sleep_time > 0.0:
                time.sleep(min(sleep_time, frame_period))

    recorder.finalize()
    for ovstream_bridge in ovstream_bridges:
        ovstream_bridge.close()
    viewer.close()


if __name__ == "__main__":
    main()
