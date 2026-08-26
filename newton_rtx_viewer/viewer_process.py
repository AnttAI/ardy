#!/usr/bin/env python3
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Native Newton viewer fed by ARDY live SOMA/T3 frames on stdin."""

from __future__ import annotations

import argparse
import base64
import csv
import hashlib
import json
import math
import os
import queue
import socket
import struct
import subprocess
import sys
import threading
import time
from datetime import datetime
from pathlib import Path

import numpy as np
from scipy.spatial.transform import Rotation


REPO_ROOT = Path(os.environ.get("ARDY_REPO_ROOT", "/home/jony/Downloads/ardy")).expanduser().resolve()
SOMA_RETARGETER_ROOT = Path("/home/jony/Downloads/soma-retargeter")
SOMA_RETARGETER_APP = SOMA_RETARGETER_ROOT / "app"
DEFAULT_T3_URDF = Path("/home/jony/Downloads/kimodo/robot_demo_outputs/t3_robot/T3.urdf")
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
    "follow": ((0.0, -3.2, 1.45), (0.0, 0.0, 0.75)),
    "orbit_front": ((0.0, -3.0, 1.55), (0.0, 0.0, 0.85)),
    "orbit_left": ((-2.8, -0.35, 1.50), (0.0, 0.0, 0.80)),
    "orbit_right": ((2.8, -0.35, 1.50), (0.0, 0.0, 0.80)),
    "orbit_back": ((0.0, 3.0, 1.55), (0.0, 0.0, 0.85)),
    "hero": ((-2.2, -2.4, 1.65), (0.0, 0.0, 0.90)),
    "top_follow": ((0.0, -0.15, 6.0), (0.0, 0.0, 0.0)),
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
    "saved_front": ((0.384, -4.188, 1.619), -11.72, 92.77, 31.0),
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


def _env_vec3(name: str, default: tuple[float, float, float]) -> tuple[float, float, float]:
    raw = os.environ.get(name)
    if not raw:
        return default
    try:
        values = tuple(float(part.strip()) for part in raw.replace(",", " ").split())
    except ValueError:
        return default
    return values if len(values) == 3 else default


def _setup_paths() -> None:
    for path in (REPO_ROOT, SOMA_RETARGETER_APP, SOMA_RETARGETER_ROOT):
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


def _read_t3_csv_rows(path: str | Path) -> list[dict[str, float | str]]:
    csv_path = Path(path).expanduser()
    with csv_path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames is None:
            raise ValueError(f"T3 CSV has no header: {csv_path}")
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
    for pattern in patterns:
        all_files.extend(path for path in Path(REPO_ROOT).glob(pattern) if path.is_file())
    return str(max(all_files, key=lambda path: path.stat().st_mtime)) if all_files else ""


def _latest_t3_csv_path() -> str:
    return _latest_file(
        (
            ".cache/t3_live/full/*.csv",
            "outputs/t3_hardware_logs/*.csv",
            "outputs/t3_hardware_csv_segments/*.csv",
            ".cache/export/*.csv",
        )
    )


def _latest_soma_bvh_path() -> str:
    return _latest_file(
        (
            ".cache/t3_live/full/*.soma.bvh",
            "outputs/t3_hardware_logs/*.soma.bvh",
            ".cache/export/*.bvh",
        )
    )


def _matching_bvh_for_csv(csv_path: str | Path) -> str:
    path = Path(csv_path).expanduser()
    candidate = path.with_suffix(".soma.bvh")
    return str(candidate) if candidate.is_file() else ""


def _matching_csv_for_bvh(bvh_path: str | Path) -> str:
    path = Path(bvh_path).expanduser()
    name = path.name
    if name.endswith(".soma.bvh"):
        candidate = path.with_name(name[: -len(".soma.bvh")] + ".csv")
    elif name.endswith(".bvh"):
        candidate = path.with_suffix(".csv")
    else:
        candidate = path.with_suffix(".csv")
    return str(candidate) if candidate.is_file() else ""


def _read_path_file(filename: str) -> str:
    path = REPO_ROOT / ".cache" / "t3_live" / filename
    try:
        value = path.read_text(encoding="utf-8").strip().splitlines()[0].strip()
    except Exception:
        return ""
    return value


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
    repo_path = str(REPO_ROOT)
    current_pythonpath = env.get("PYTHONPATH", "")
    env["PYTHONPATH"] = f"{repo_path}{os.pathsep}{current_pythonpath}" if current_pythonpath else repo_path
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
    bvh_path = str(bvh_path or "").strip()
    csv_path = str(csv_path or "").strip()
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


def _ui_input_text(ui, label: str, value: str) -> str:
    try:
        changed, new_value = ui.input_text(label, value, 2048)
        return str(new_value) if changed else value
    except Exception:
        try:
            changed, new_value = ui.input_text(label, value)
            return str(new_value) if changed else value
        except Exception:
            ui.text(f"{label}:")
            ui.text(value if value else "(set ARDY_NEWTON_FILE_* env var)")
            return value


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
        "--pick-object",
        choices=PICK_OBJECT_CHOICES,
        default=os.environ.get("ARDY_NEWTON_PICK_OBJECT", "cube").lower(),
        help="Add a Newton collision object to touch/pick in the viewer.",
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
    return parser.parse_args()


def _create_viewer(newton, args: argparse.Namespace):
    width = max(320, int(args.viewer_width))
    height = max(240, int(args.viewer_height))
    if args.viewer == "rtx":
        try:
            viewer = newton.viewer.ViewerRTX(
                width=width,
                height=height,
                vsync=True,
                environment=args.rtx_environment,
                async_rendering=True,
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
            if "ceiling" in prim_path or not any(token in prim_path for token in ("floor", "ground", "carpet", "rug", "tile")):
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
):
    q = default_q.copy()
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
            for row_key, joint_name in T3_ROW_TO_JOINT.items():
                if joint_name in T3_STIFF_POSTURE_JOINTS:
                    continue
                start = joint_q_start.get(joint_name)
                if start is None or row_key not in row:
                    continue
                value = float(row[row_key])
                if joint_name == "telescopic_lift_joint":
                    value = _lift_csv_value_to_extension_m(value)
                q[start] = value if joint_name in T3_LINEAR_JOINTS else math.radians(value)
            for row_key, joint_name in (
                ("left_wheel_angle_rad", "left_wheel_joint"),
                ("right_wheel_angle_rad", "right_wheel_joint"),
            ):
                start = joint_q_start.get(joint_name)
                if start is not None and row_key in row:
                    q[start] = float(row[row_key])

    live_root_tx = _make_tx(wp, live_root_pos, live_root_quat)
    root_tx = wp.mul(offset_tx, live_root_tx)
    q[0:7] = _tx_to_numpy(root_tx)
    q[2] = float(floor_z)
    wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
    bounds = _robot_shape_bounds(newton, model, state, t3_shape_count)
    correction = _actor_separation_from_pick_object(bounds, pick_position, pick_size, pick_visible, pick_pushable)
    if np.any(correction):
        q[0] += correction[0]
        q[1] += correction[1]
        q[2] = float(floor_z)
        wp.copy(model.joint_q, wp.array(q, dtype=wp.float32), 0, 0, len(q))
    newton.eval_fk(model, model.joint_q, model.joint_qd, state, None)
    return _make_tx(wp, q[0:3], q[3:7]), _robot_shape_bounds(newton, model, state, t3_shape_count)


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
    mesh_path = _ensure_runtime_soma_mesh(viewer, points_np, faces_np)
    rtx = getattr(viewer, "_rtx", None)
    if mesh_path is None or rtx is None or not hasattr(viewer, "_make_point3f_dltensor"):
        return False
    try:
        rtx.write_array_attribute(
            prim_paths=[mesh_path],
            attribute_name="points",
            tensors=[viewer._make_point3f_dltensor(np.asarray(points_np, dtype=np.float32))],
        )
        return True
    except Exception as exc:
        print(f"[ARDY Newton Viewer] runtime SOMA mesh update failed: {exc}", flush=True)
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
    if np.any(correction):
        newton_vertices[:, 0] += correction[0]
        newton_vertices[:, 1] += correction[1]
    transformed = _apply_tx_to_points(offset_tx, newton_vertices)
    if transformed.ndim == 2 and transformed.shape[1] == 3 and transformed.size:
        transformed = transformed.copy()
        transformed[:, 2] += float(floor_z) - float(np.min(transformed[:, 2]))
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
    show_human_mesh = True
    show_t3_robot = True
    show_gizmos = args.viewer != "rtx"
    latest_frame = None
    latest_status = "waiting for live SOMA frame"
    floor_z = _resolve_floor_z(args)
    show_contacts = False
    pick_object_visible = args.pick_object != "none"
    pick_object_position = list(args.pick_object_position)
    pick_object_size = max(0.02, float(args.pick_object_size))
    pick_object_mass_kg = PICK_OBJECT_DENSITY_KG_M3 * pick_object_size**3
    pick_object_push_mass_limit_kg = max(0.0, float(args.pick_object_push_mass_limit_kg))
    pick_object_pushable = args.pick_object != "none" and pick_object_mass_kg <= pick_object_push_mass_limit_kg
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
    websocket_enabled = bool(args.websocket_server)
    soma_mesh_status = "SOMA mesh not registered"
    soma_skin_status = "SOMA local skin not initialized"
    soma_vertex_count = 0
    soma_triangle_count = 0
    soma_mesh_logged = False
    soma_skeleton_logged = False
    current_frame_idx = -1
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

    def gui(ui):
        nonlocal show_human_mesh, show_t3_robot, show_gizmos, soma_offset_tx, t3_offset_tx
        nonlocal floor_z
        nonlocal show_contacts, pick_object_visible, pick_object_pushable, pick_object_position
        nonlocal file_csv_path, file_bvh_path, file_playback_frames, file_playback_index
        nonlocal file_playback_next_time, file_playback_active, file_playback_status
        nonlocal websocket_enabled
        ui.set_next_window_pos(ui.ImVec2(16, 16))
        ui.set_next_window_size(ui.ImVec2(340, 560))
        ui.set_next_window_bg_alpha(0.82)
        flags = ui.WindowFlags_.no_collapse.value | ui.WindowFlags_.no_resize.value
        ui.begin("ARDY Newton Retarget", flags=flags)
        ui.text("SOMA mesh -> Newton IK -> T3 robot")
        _, show_human_mesh = ui.checkbox("Show SOMA Mesh", show_human_mesh)
        _, show_t3_robot = ui.checkbox("Show T3 Robot", show_t3_robot)
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
            if file_csv_path:
                ui.text(f"CSV: {Path(file_csv_path).name}")
            if file_bvh_path:
                ui.text(f"BVH: {Path(file_bvh_path).name}")

            def start_file_mode(mode: str) -> None:
                nonlocal file_playback_frames, file_playback_index, file_playback_next_time
                nonlocal file_playback_active, file_playback_status
                try:
                    file_playback_status = f"loading {mode}"
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
            ui.set_next_item_width(120)
            _, floor_z = ui.slider_float("Floor Z", floor_z, -2.0, 2.0, "%.3f")
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
        record_status = recorder.status()
        if record_status:
            ui.text(record_status)
        ui.end()

    if hasattr(viewer, "register_ui_callback"):
        viewer.register_ui_callback(gui, position="free")

    builder = newton.ModelBuilder()
    builder.add_ground_plane()
    t3_urdf = LOCAL_T3_URDF if LOCAL_T3_URDF.exists() else DEFAULT_T3_URDF
    builder.add_urdf(str(t3_urdf), floating=True, scale=1.0)
    t3_shape_count = builder.shape_count
    pick_joint_name, pick_object_size = _add_pick_object(newton, wp, builder, args)
    model = builder.finalize()
    state = model.state()
    default_q = model.joint_q.numpy().copy()
    joint_q_start = {
        label.rsplit("/", 1)[-1]: int(start)
        for label, start in zip(model.joint_label, model.joint_q_start.numpy())
    }
    viewer.set_model(model)
    _ensure_soma_mesh_tracking(viewer)
    _add_background_usd(viewer, args.background_usd)
    viewer.set_world_offsets([0, 0, 0])
    _set_camera_by_name(viewer, wp, args.camera_preset)
    collision_pipeline = newton.CollisionPipeline(model)
    contacts = collision_pipeline.contacts()

    cpu_robot_mesh_renderer = None
    if CpuRobotMeshRenderer is not None and isinstance(viewer, newton.viewer.ViewerGL) and not viewer.device.is_cuda:
        cpu_robot_mesh_renderer = CpuRobotMeshRenderer(viewer, model)

    time_s = 0.0
    first_end_frame = True
    requested_close = False
    next_frame_time = time.monotonic()
    last_perf_report = next_frame_time
    rendered_frames = 0
    print("[ARDY Newton Viewer] ready for live frames", flush=True)
    while viewer.is_running() and not requested_close:
        loop_start = time.monotonic()
        queued_frames = frame_queue.qsize()
        soma_live_gizmo_tx = wp.transform_identity()
        t3_live_root_tx = wp.transform_identity()
        incoming_frame = _get_next_frame(frame_queue, args.playback_mode)
        if incoming_frame is None and file_playback_active and file_playback_frames:
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
        if incoming_frame is not None:
            latest_frame = incoming_frame
            if latest_frame.get("command") == "close":
                requested_close = True
                continue
            current_frame_idx = int(latest_frame.get("frame_idx", -1))
            if "show_t3_robot" in latest_frame:
                show_t3_robot = bool(latest_frame["show_t3_robot"])
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

        if latest_frame is not None:
            t3_bounds = None
            soma_live_gizmo_tx = _soma_live_floor_transform_for_newton(wp, latest_frame)
            if latest_frame.get("soma_mesh_faces") is not None:
                soma_faces = np.asarray(latest_frame["soma_mesh_faces"], dtype=np.int32).reshape(-1)
                soma_indices_wp = wp.array(soma_faces, dtype=wp.int32)
                soma_triangle_count = int(soma_faces.size // 3)
                soma_mesh_status = f"SOMA faces received: {soma_triangle_count} tris"
            elif soma_indices_wp is None and soma_reconstructor.faces is not None:
                soma_indices_wp = wp.array(soma_reconstructor.faces, dtype=wp.int32)
                soma_triangle_count = int(soma_reconstructor.faces.size // 3)
                soma_mesh_status = f"SOMA faces from local skin: {soma_triangle_count} tris"
            t3_live_root_tx, t3_bounds = _apply_t3_row(
                wp,
                newton,
                model,
                state,
                default_q,
                joint_q_start,
                latest_frame.get("t3_row"),
                t3_offset_tx,
                floor_z,
                t3_shape_count,
                pick_object_position,
                pick_object_size,
                pick_object_visible,
                pick_object_pushable,
            )
            _push_pick_object_from_bounds(
                t3_bounds,
                pick_object_position,
                pick_object_size,
                pick_object_visible,
                pick_object_pushable,
                floor_z,
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
            _set_pick_object_pose(wp, newton, model, state, joint_q_start, pick_joint_name, pick_position)
            if show_contacts:
                collision_pipeline.collide(state, contacts)
        _set_non_ground_instance_visibility(viewer, newton, show_t3_robot)
        viewer.log_state(state)
        if show_t3_robot and cpu_robot_mesh_renderer is not None:
            cpu_robot_mesh_renderer.draw(state)
        if show_contacts and latest_frame is not None:
            viewer.log_contacts(contacts, state)
        if first_end_frame:
            print("[ARDY Newton Viewer] first end_frame: entering", flush=True)
        viewer.end_frame()
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
                f"soma_verts={soma_vertex_count} soma_tris={soma_triangle_count} "
                f"mesh_logged={soma_mesh_logged} skeleton_logged={soma_skeleton_logged} "
                f"soma_source={soma_mesh_source} soma_status='{soma_mesh_status}'"
                f"{skin_status_suffix}",
                flush=True,
            )
            rendered_frames = 0
            last_perf_report = now
        next_frame_time = max(next_frame_time + frame_period, loop_start + frame_period)
        if frame_queue.empty():
            sleep_time = next_frame_time - time.monotonic()
            if sleep_time > 0.0:
                time.sleep(min(sleep_time, frame_period))

    recorder.finalize()
    viewer.close()


if __name__ == "__main__":
    main()
