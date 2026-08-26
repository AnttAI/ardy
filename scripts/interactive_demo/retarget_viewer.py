# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Stream ARDY live retarget frames to one native Newton viewer process."""

from __future__ import annotations

import json
import math
import os
import queue
import select
import socket
import struct
import csv
import threading
import time
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import urlparse

import numpy as np
import torch
from scipy.spatial.transform import Rotation

from ardy.data_processing.bvh import Bvh
from ardy.skeleton import SOMASkeleton77
from ardy.viz.soma_skin import SOMASkin


@dataclass
class RetargetViewerPose:
    soma_joints_pos: torch.Tensor
    soma_joints_rot: torch.Tensor
    core_joints_pos: torch.Tensor
    core_joints_rot: torch.Tensor
    t3_row: dict[str, float] | None
    t3_state_row: dict | None
    root_velocity: torch.Tensor | np.ndarray | None
    soma_offset: torch.Tensor | np.ndarray | tuple[float, float, float] | None
    fps: float
    frame_idx: int
    accurate_ready_until: int


class WebSocketFrameSender:
    def __init__(self, url: str):
        parsed = urlparse(url if "://" in url else f"ws://{url}")
        if parsed.scheme not in {"ws", ""}:
            raise ValueError(f"Only ws:// URLs are supported: {url}")
        self.host = parsed.hostname or "127.0.0.1"
        self.port = int(parsed.port or 8765)
        self.path = parsed.path or "/"
        if parsed.query:
            self.path = f"{self.path}?{parsed.query}"
        self.url = f"ws://{self.host}:{self.port}{self.path}"
        self._sock: socket.socket | None = None

    @property
    def connected(self) -> bool:
        sock = self._sock
        if sock is None:
            return False
        try:
            readable, _, _ = select.select([sock], [], [], 0.0)
            if not readable:
                return True
            peek_flags = getattr(socket, "MSG_PEEK", 0) | getattr(socket, "MSG_DONTWAIT", 0)
            data = sock.recv(2, peek_flags)
            if not data or data.startswith(b"\x88"):
                self.close()
                return False
        except BlockingIOError:
            return True
        except OSError:
            self.close()
            return False
        return True

    def connect(self) -> None:
        self.close()
        sock = socket.create_connection((self.host, self.port), timeout=3.0)
        key = os.urandom(16)
        import base64

        ws_key = base64.b64encode(key).decode("ascii")
        request = (
            f"GET {self.path} HTTP/1.1\r\n"
            f"Host: {self.host}:{self.port}\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {ws_key}\r\n"
            "Sec-WebSocket-Version: 13\r\n\r\n"
        )
        sock.sendall(request.encode("ascii"))
        response = b""
        while b"\r\n\r\n" not in response:
            chunk = sock.recv(4096)
            if not chunk:
                raise ConnectionError("empty websocket handshake response")
            response += chunk
            if len(response) > 65536:
                raise ConnectionError("websocket handshake response too large")
        if b" 101 " not in response.split(b"\r\n", 1)[0]:
            raise ConnectionError(response.decode("latin1", errors="replace").split("\r\n", 1)[0])
        sock.settimeout(None)
        self._sock = sock

    def send_json(self, payload: dict) -> None:
        if self._sock is None:
            self.connect()
        assert self._sock is not None
        data = json.dumps(payload, separators=(",", ":")).encode("utf-8")
        header = bytearray([0x81])
        if len(data) < 126:
            header.append(0x80 | len(data))
        elif len(data) <= 0xFFFF:
            header.append(0x80 | 126)
            header.extend(struct.pack("!H", len(data)))
        else:
            header.append(0x80 | 127)
            header.extend(struct.pack("!Q", len(data)))
        mask = os.urandom(4)
        masked = bytes(byte ^ mask[idx % 4] for idx, byte in enumerate(data))
        try:
            self._sock.sendall(bytes(header) + mask + masked)
        except OSError:
            self.close()
            raise

    def close(self) -> None:
        sock = self._sock
        self._sock = None
        if sock is None:
            return
        try:
            sock.close()
        except OSError:
            pass


class LiveWebSocketFrameSender:
    """Background sender for live frames.

    delivery="latest" keeps Viser playback independent by replacing stale RTX
    frames. delivery="all" preserves every frame and may backpressure playback.
    """

    def __init__(self, url: str, delivery: str = "latest"):
        self.url = url
        self.delivery = delivery if delivery in {"all", "latest"} else "latest"
        self._condition = threading.Condition()
        self._pending_payload: dict | None = None
        self._payload_queue: queue.Queue[dict] = queue.Queue(maxsize=1)
        self._closed = False
        self._thread: threading.Thread | None = None
        self._sender: WebSocketFrameSender | None = None
        self._status = "websocket starting"
        self._last_sent_frame_idx = -1
        self._replaced_frames = 0

    @property
    def status(self) -> str:
        return self._status

    @property
    def last_sent_frame_idx(self) -> int:
        return self._last_sent_frame_idx

    @property
    def replaced_frames(self) -> int:
        return self._replaced_frames

    @property
    def connected(self) -> bool:
        return self._sender is not None and self._sender.connected

    def start(self) -> None:
        if self._thread is not None and self._thread.is_alive():
            return
        self._closed = False
        self._thread = threading.Thread(target=self._run, name="ardy-newton-ws-sender", daemon=True)
        self._thread.start()

    def submit_live(self, payload: dict) -> None:
        self.start()
        if self.delivery == "all":
            self._payload_queue.put(payload)
            return
        with self._condition:
            if self._pending_payload is not None:
                self._replaced_frames += 1
            self._pending_payload = payload
            self._condition.notify()

    def close(self) -> None:
        with self._condition:
            self._closed = True
            self._pending_payload = None
            self._condition.notify()
        while True:
            try:
                self._payload_queue.get_nowait()
            except queue.Empty:
                break
        if self._thread is not None and self._thread.is_alive():
            self._thread.join(timeout=1.0)
        self._thread = None
        if self._sender is not None:
            self._sender.close()
            self._sender = None
        self._status = "websocket closed"

    def _run(self) -> None:
        while True:
            if self.delivery == "all":
                if self._closed:
                    return
                try:
                    payload = self._payload_queue.get(timeout=0.5)
                except queue.Empty:
                    continue
            else:
                with self._condition:
                    while self._pending_payload is None and not self._closed:
                        self._condition.wait(timeout=0.5)
                    if self._closed:
                        return
                    payload = self._pending_payload
                    self._pending_payload = None
            if payload is None:
                continue
            while not self._closed:
                try:
                    if self._sender is None or not self._sender.connected:
                        self._sender = WebSocketFrameSender(self.url)
                        self._sender.connect()
                        print(f"[ARDY Newton Sender] websocket connected: {self._sender.url}", flush=True)
                    self._sender.send_json(payload)
                    self._last_sent_frame_idx = int(payload.get("frame_idx", -1))
                    self._status = f"websocket connected: sent frame {self._last_sent_frame_idx}"
                    break
                except (BrokenPipeError, ConnectionError, OSError) as exc:
                    if self._sender is not None:
                        self._sender.close()
                        self._sender = None
                    self._status = f"websocket disconnected: {exc}"
                    if self.delivery == "latest":
                        break
                    time.sleep(0.1)


class SomaT3RetargetViewer:
    """Stream live/file retarget payloads to an independently launched RTX viewer."""

    def __init__(
        self,
        client,
        client_id: int,
        core_skeleton,
        soma_skeleton,
        viewer_backend: str = "gl",
        background_usd: str | None = None,
        camera_preset: str = "saved_origin_back",
        rtx_environment: str = "studio",
        newton_pythonpath: str | None = None,
        viewer_python: str | None = None,
        websocket_enabled: bool = False,
        websocket_url: str = "ws://127.0.0.1:8765",
        websocket_payload: str = "joints",
        websocket_delivery: str = "latest",
    ):
        self.client = client
        self.client_id = client_id
        self.core_skeleton = core_skeleton
        self.soma_joint_names = list(getattr(soma_skeleton, "bone_order_names", []))
        self.viewer_backend = (viewer_backend or "gl").lower()
        self.background_usd = background_usd
        self.camera_preset = (camera_preset or "default").lower()
        self.rtx_environment = (rtx_environment or "studio").lower()
        self.newton_pythonpath = newton_pythonpath
        self.viewer_python = viewer_python
        self.websocket_enabled = True
        self.websocket_url = websocket_url or "ws://127.0.0.1:8765"
        self.websocket_payload = (websocket_payload or "joints").strip().lower()
        if self.websocket_payload not in {"joints", "vertices"}:
            self.websocket_payload = "joints"
        self.websocket_delivery = (websocket_delivery or "latest").strip().lower()
        if self.websocket_delivery not in {"all", "latest"}:
            self.websocket_delivery = "latest"
        self.visible = False
        self._last_error: str | None = None
        self._soma_skin = SOMASkin(soma_skeleton) if self.websocket_payload == "vertices" else None
        self._soma_joint_parents = (
            soma_skeleton.joint_parents.detach().cpu().numpy().astype(int).tolist()
            if hasattr(soma_skeleton, "joint_parents")
            else None
        )
        self._sent_soma_faces = False
        self._soma_faces_send_count = 0
        self._file_thread: threading.Thread | None = None
        self._file_stop_event = threading.Event()
        self._file_playback_active = False
        self._file_playback_status = "idle"
        self._ws_sender: LiveWebSocketFrameSender | None = None
        self._last_send_report_time = 0.0

    @property
    def file_playback_status(self) -> str:
        return self._file_playback_status

    def open(self) -> None:
        self.visible = True
        self._last_error = None
        if self._ws_sender is None:
            self._ws_sender = LiveWebSocketFrameSender(self.websocket_url, delivery=self.websocket_delivery)
            self._ws_sender.start()

    def update(self, pose: RetargetViewerPose) -> str:
        if self._file_playback_active:
            return self._file_playback_status
        if not self.visible:
            return "Newton viewer closed"
        if self._ws_sender is None:
            self._ws_sender = LiveWebSocketFrameSender(self.websocket_url, delivery=self.websocket_delivery)
            self._ws_sender.start()

        soma_offset = np.zeros(3, dtype=np.float32)
        if pose.soma_offset is not None:
            soma_offset = np.asarray(
                pose.soma_offset.detach().cpu().numpy() if isinstance(pose.soma_offset, torch.Tensor) else pose.soma_offset,
                dtype=np.float32,
            )
        displayed_soma_joints_pos = pose.soma_joints_pos + torch.as_tensor(
            soma_offset,
            dtype=pose.soma_joints_pos.dtype,
            device=pose.soma_joints_pos.device,
        )

        soma_root = displayed_soma_joints_pos[0].detach().cpu().numpy()

        t3_row = pose.t3_state_row if pose.t3_state_row is not None else pose.t3_row

        send_soma_faces = False
        soma_mesh_vertices_payload = None
        soma_mesh_faces_payload = None
        if self.websocket_payload == "vertices":
            assert self._soma_skin is not None
            send_soma_faces = self._soma_faces_send_count < 10 or int(pose.frame_idx) % 30 == 0
            soma_vertices = self._soma_skin.skin(
                pose.soma_joints_rot[None],
                displayed_soma_joints_pos[None],
                rot_is_global=True,
            )[0].detach().cpu().numpy()
            soma_mesh_vertices_payload = soma_vertices.astype(float).tolist()
            soma_mesh_faces_payload = (
                self._soma_skin.faces.detach().cpu().numpy().astype(int).tolist() if send_soma_faces else None
            )

        payload = {
            "soma_joint_names": self.soma_joint_names,
            "soma_joint_parents": self._soma_joint_parents,
            "soma_joints_pos": pose.soma_joints_pos.detach().cpu().numpy().astype(float).tolist(),
            "soma_joints_rot": pose.soma_joints_rot.detach().cpu().numpy().astype(float).tolist(),
            "soma_mesh_vertices": soma_mesh_vertices_payload,
            "soma_mesh_faces": soma_mesh_faces_payload,
            "soma_root_pos": soma_root.astype(float).tolist(),
            "soma_offset": soma_offset.astype(float).tolist(),
            "t3_row": t3_row,
            "fps": float(pose.fps),
            "frame_idx": int(pose.frame_idx),
        }
        self._send_payload(payload)
        now = time.monotonic()
        if now - self._last_send_report_time >= 1.0:
            faces_count = len(payload["soma_mesh_faces"]) // 3 if payload["soma_mesh_faces"] is not None else 0
            verts_count = len(payload["soma_mesh_vertices"]) if payload["soma_mesh_vertices"] is not None else 0
            replaced = self._ws_sender.replaced_frames if self._ws_sender is not None else 0
            print(
                "[ARDY Newton Sender] "
                f"live_frame={int(pose.frame_idx)} "
                f"payload={self.websocket_payload} "
                f"delivery={self.websocket_delivery} "
                f"soma_verts={verts_count} "
                f"soma_tris={faces_count} "
                f"has_t3={t3_row is not None} "
                f"replaced={replaced} "
                "transport=websocket",
                flush=True,
            )
            self._last_send_report_time = now
        self._sent_soma_faces = True
        if send_soma_faces and self._soma_faces_send_count < 10:
            self._soma_faces_send_count += 1

        if t3_row is None:
            return f"RTX websocket live queued: warming frame {pose.frame_idx}"
        return f"RTX websocket live queued: frame {pose.frame_idx}"

    def play_files(
        self,
        *,
        bvh_path: str | Path | None = None,
        csv_path: str | Path | None = None,
        mode: str = "both",
    ) -> str:
        self.open()
        if self._last_error is not None:
            return self._last_error
        if self._ws_sender is None:
            return "Newton websocket not available"

        mode = mode.lower()
        use_bvh = mode in {"bvh", "both"} and bool(str(bvh_path or "").strip())
        use_csv = mode in {"csv", "both"} and bool(str(csv_path or "").strip())
        if not use_bvh and not use_csv:
            return "Set the CSV path, BVH path, or both."

        try:
            soma_skeleton = None
            soma_skin = None
            joints_pos = None
            joints_rot = None
            fps = 30.0
            if use_bvh:
                soma_skeleton, joints_pos, joints_rot, fps = _load_soma_bvh_motion(str(bvh_path).strip())
                soma_skin = SOMASkin(soma_skeleton)

            t3_rows = None
            if use_csv:
                t3_rows = _read_t3_csv_rows(str(csv_path).strip())
                if not use_bvh:
                    fps = _csv_fps(t3_rows)
        except Exception as exc:
            self._file_playback_status = f"file load failed: {exc}"
            return self._file_playback_status

        self._file_stop_event.set()
        if self._file_thread is not None and self._file_thread.is_alive():
            self._file_thread.join(timeout=1.0)
        self._file_stop_event = threading.Event()
        self._file_playback_active = True
        self._file_playback_status = "starting file playback"
        self._file_thread = threading.Thread(
            target=self._feed_file_frames,
            args=(soma_skeleton, soma_skin, joints_pos, joints_rot, t3_rows, fps),
            daemon=True,
        )
        self._file_thread.start()
        return self._file_playback_status

    def stop_file_playback(self) -> None:
        self._file_stop_event.set()
        self._file_playback_active = False
        self._file_playback_status = "file playback stopped"

    def _send_payload(self, payload: dict) -> None:
        if self._ws_sender is None:
            self._ws_sender = LiveWebSocketFrameSender(self.websocket_url, delivery=self.websocket_delivery)
        self._ws_sender.submit_live(payload)

    def _feed_file_frames(
        self,
        soma_skeleton: SOMASkeleton77 | None,
        soma_skin: SOMASkin | None,
        joints_pos: torch.Tensor | None,
        joints_rot: torch.Tensor | None,
        t3_rows: list[dict[str, float | str]] | None,
        fps: float,
    ) -> None:
        has_bvh = soma_skeleton is not None and soma_skin is not None and joints_pos is not None and joints_rot is not None
        has_csv = t3_rows is not None and len(t3_rows) > 0
        faces = soma_skin.faces.detach().cpu().numpy().astype(int).tolist() if has_bvh else None
        bvh_frame_count = int(joints_pos.shape[0]) if has_bvh else 0
        csv_frame_count = len(t3_rows) if has_csv else 0
        frame_count = max(bvh_frame_count, csv_frame_count)
        period = 1.0 / max(float(fps), 1.0e-3)
        try:
            for frame_idx in range(frame_count):
                if self._file_stop_event.is_set():
                    break
                if self._ws_sender is None:
                    raise RuntimeError("Newton websocket unavailable")
                payload = {
                    "show_soma_mesh": bool(has_bvh),
                    "show_t3_robot": bool(has_csv),
                    "t3_row": None,
                    "fps": float(fps),
                    "frame_idx": int(frame_idx),
                }
                if has_bvh:
                    human_idx = min(frame_idx, bvh_frame_count - 1)
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
                if has_csv:
                    robot_idx = min(frame_idx, csv_frame_count - 1)
                    payload["t3_row"] = t3_rows[robot_idx]
                self._send_payload(payload)
                self._file_playback_status = f"file frame {frame_idx}/{frame_count - 1}"
                time.sleep(period)
            self._file_playback_status = f"file playback complete ({frame_count} frames)"
        except Exception as exc:
            self._file_playback_status = f"file stream failed: {exc}"
        finally:
            self._file_playback_active = False

    def set_visible(self, visible: bool) -> None:
        self.visible = bool(visible)
        if visible:
            self.open()
        else:
            self.close_websocket()

    def clear(self) -> None:
        self.visible = False
        self._last_error = None
        self.stop_file_playback()
        self.close_websocket()

    def close_websocket(self) -> None:
        if self._ws_sender is not None:
            self._ws_sender.close()
            self._ws_sender = None


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


def _csv_fps(rows: list[dict[str, float | str]], default: float = 30.0) -> float:
    times = [float(row["time_s"]) for row in rows if isinstance(row.get("time_s"), (int, float))]
    if len(times) < 2:
        return default
    deltas = np.diff(np.asarray(times, dtype=np.float64))
    deltas = deltas[deltas > 1.0e-6]
    if deltas.size == 0:
        return default
    return float(np.clip(1.0 / float(np.median(deltas)), 1.0, 240.0))


def _apply_differential_drive_root(rows: list[dict[str, float | str]]) -> None:
    if not rows or not all(any(key in row for key in ("forward_velocity_m_s", "yaw_rate_rad_s")) for row in rows):
        return
    fps = _csv_fps(rows)
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


def _load_soma_bvh_motion(path: str | Path) -> tuple[SOMASkeleton77, torch.Tensor, torch.Tensor, float]:
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
