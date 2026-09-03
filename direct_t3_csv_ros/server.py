#!/usr/bin/env python3
"""Browser UI backend for playing T3 CSV files directly to ROS 2."""

from __future__ import annotations

import csv
import json
import os
import queue
import sys
import threading
import time
from dataclasses import dataclass, field
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse


HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))


ROBOT_JOINT_NAMES = [f"joint{i}" for i in range(1, 8)]
RIGHT_COLUMNS = [f"right_joint{i}_dof" for i in range(1, 8)]
LEFT_COLUMNS = [f"left_joint{i}_dof" for i in range(1, 8)]
UPLOAD_DIR = HERE / "uploads"
DEFAULT_CSV = HERE / "client_0_gen_23_full.csv"

os.environ.setdefault("ARDY_ROS_DOMAIN_ID", os.environ.get("KIMODO_ROS_DOMAIN_ID", "10"))
os.environ.setdefault("ARDY_ROS_LOCALHOST_ONLY", os.environ.get("KIMODO_ROS_LOCALHOST_ONLY", "0"))


def _json_default(value):
    if isinstance(value, Path):
        return str(value)
    return value


def _float_text(value: object, default: float = 0.0) -> float:
    text = str(value if value is not None else "").strip()
    if not text:
        return default
    return float(text)


def parse_multipart_upload(headers, body: bytes) -> tuple[str, bytes, dict[str, str]]:
    content_type = headers.get("Content-Type", "")
    marker = "boundary="
    if marker not in content_type:
        raise ValueError("Upload request is missing multipart boundary")
    boundary = content_type.split(marker, 1)[1].strip().strip('"')
    boundary_bytes = ("--" + boundary).encode("utf-8")
    fields: dict[str, str] = {}
    filename = "uploaded_t3.csv"
    file_bytes: bytes | None = None

    for part in body.split(boundary_bytes):
        part = part.strip(b"\r\n")
        if not part or part == b"--":
            continue
        if part.endswith(b"--"):
            part = part[:-2].strip(b"\r\n")
        header_blob, separator, value = part.partition(b"\r\n\r\n")
        if not separator:
            continue
        part_headers = header_blob.decode("utf-8", errors="replace").split("\r\n")
        disposition = ""
        for line in part_headers:
            if line.lower().startswith("content-disposition:"):
                disposition = line
                break
        params: dict[str, str] = {}
        for item in disposition.split(";"):
            if "=" not in item:
                continue
            key, raw_value = item.strip().split("=", 1)
            params[key] = raw_value.strip().strip('"')
        name = params.get("name", "")
        if params.get("filename"):
            filename = Path(params["filename"]).name
            file_bytes = value
        elif name:
            fields[name] = value.decode("utf-8", errors="replace").strip()

    if file_bytes is None:
        raise ValueError("Upload request did not include a CSV file")
    return filename, file_bytes, fields


def read_csv(path: Path) -> tuple[list[dict[str, str]], list[str]]:
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames is None:
            raise ValueError(f"{path} has no CSV header")
        rows = [dict(row) for row in reader]
        fieldnames = list(reader.fieldnames)
    if not rows:
        raise ValueError(f"{path} has no rows")
    return rows, fieldnames


def split_segments(rows: list[dict[str, str]]) -> list[list[dict[str, str]]]:
    segments: list[list[dict[str, str]]] = []
    current: list[dict[str, str]] = []
    previous_frame: int | None = None
    for row in rows:
        frame_value = row.get("frame_index") or row.get("Frame") or "0"
        try:
            frame_idx = int(float(frame_value))
        except (TypeError, ValueError):
            frame_idx = 0
        if current and previous_frame is not None and frame_idx < previous_frame:
            segments.append(current)
            current = []
        current.append(row)
        previous_frame = frame_idx
    if current:
        segments.append(current)
    return [segment for segment in segments if len(segment) > 1]


def infer_fps(rows: list[dict[str, str]], override_fps: float) -> float:
    if override_fps > 0.0:
        return override_fps
    for key in ("effective_send_fps", "native_fps"):
        value = str(rows[0].get(key, "")).strip()
        if value:
            parsed = float(value)
            if parsed > 0.0:
                return parsed
    playback_speed = max(_float_text(rows[0].get("playback_speed"), 1.0), 0.05)
    return 20.0 * playback_speed


def row_capabilities(fieldnames: list[str]) -> dict[str, bool]:
    columns = set(fieldnames)
    return {
        "robot": all(column in columns for column in [*RIGHT_COLUMNS, *LEFT_COLUMNS]),
        "lift": "telescopic_lift_joint_dof" in columns,
        "base": (
            {"left_motor_rpm", "right_motor_rpm"}.issubset(columns)
            or {"base_left_rpm", "base_right_rpm"}.issubset(columns)
        ),
    }


def mode_requirements(mode: str) -> dict[str, bool]:
    return {
        "robot": mode in {"robot", "robot_lift", "full"},
        "lift": mode in {"robot_lift", "base_lift", "full"},
        "base": mode in {"base_lift", "full"},
    }


@dataclass
class AppState:
    csv_path: Path | None = None
    rows: list[dict[str, str]] = field(default_factory=list)
    fieldnames: list[str] = field(default_factory=list)
    segment_index: int = 0
    segment_count: int = 0
    fps: float = 20.0
    playing: bool = False
    paused: bool = False
    dry_run: bool = True
    mode: str = ""
    frame_index: int = -1
    row_index: int = -1
    status: str = "Load a CSV to begin."
    last_payload: dict[str, object] = field(default_factory=dict)
    error: str = ""
    events: list[queue.Queue] = field(default_factory=list)
    lock: threading.Lock = field(default_factory=threading.Lock)
    stop_event: threading.Event = field(default_factory=threading.Event)
    pause_event: threading.Event = field(default_factory=threading.Event)
    worker: threading.Thread | None = None

    def snapshot(self) -> dict[str, object]:
        with self.lock:
            caps = row_capabilities(self.fieldnames) if self.fieldnames else {"robot": False, "lift": False, "base": False}
            return {
                "csv_path": str(self.csv_path) if self.csv_path else "",
                "rows": len(self.rows),
                "segment_index": self.segment_index,
                "segment_count": self.segment_count,
                "fps": self.fps,
                "playing": self.playing,
                "paused": self.paused,
                "dry_run": self.dry_run,
                "mode": self.mode,
                "frame_index": self.frame_index,
                "row_index": self.row_index,
                "status": self.status,
                "error": self.error,
                "capabilities": caps,
                "payload": self.last_payload,
            }

    def emit(self) -> None:
        event = json.dumps(self.snapshot(), default=_json_default)
        dead = []
        for q in self.events:
            try:
                q.put_nowait(event)
            except Exception:
                dead.append(q)
        for q in dead:
            self.events.remove(q)


STATE = AppState()


def load_path(path: Path, segment: int, fps_override: float) -> dict[str, object]:
    rows, fieldnames = read_csv(path)
    segments = split_segments(rows)
    if not segments:
        raise ValueError("CSV has no playable frame segments")
    segment_index = max(0, min(int(segment), len(segments) - 1))
    selected_rows = segments[segment_index]
    fps = infer_fps(selected_rows, fps_override)
    with STATE.lock:
        STATE.csv_path = path
        STATE.rows = selected_rows
        STATE.fieldnames = fieldnames
        STATE.segment_index = segment_index
        STATE.segment_count = len(segments)
        STATE.fps = fps
        STATE.frame_index = -1
        STATE.row_index = -1
        STATE.paused = False
        STATE.pause_event.clear()
        STATE.last_payload = {}
        STATE.error = ""
        STATE.status = f"Loaded {path.name}"
    STATE.emit()
    return STATE.snapshot()


def start_playback(options: dict[str, object]) -> dict[str, object]:
    from t3_payloads import build_t3_csv_frame_payload

    mode = str(options.get("mode", "full"))
    dry_run = bool(options.get("dry_run", True))
    fps_override = max(0.0, float(options.get("fps", 0.0)))
    lift_step_frames = max(1, int(options.get("lift_step_frames", 10)))
    wait_for_subscribers = max(0.0, float(options.get("wait_for_subscribers", 5.0)))
    require_lift_subscriber = bool(options.get("require_lift_subscriber", False))
    scales = {
        "rpm_scale": float(options.get("rpm_scale", 1.0)),
        "max_abs_rpm": float(options.get("max_abs_rpm", 90.0)),
        "linear_scale": float(options.get("linear_scale", 1.0)),
        "backward_scale": float(options.get("backward_scale", 1.0)),
        "yaw_scale": float(options.get("yaw_scale", 1.0)),
    }
    topic_args = [
        "--right-topic",
        str(options.get("right_topic", "/right_arm/control/move_j")),
        "--left-topic",
        str(options.get("left_topic", "/left_arm/control/move_j")),
        "--gripper-topic",
        str(options.get("gripper_topic", "/right_arm/control/joint_states")),
        "--base-topic",
        str(options.get("base_topic", "/base/cmd_wheel_rpm")),
        "--lift-topic",
        str(options.get("lift_topic", "/control/lift_frame")),
        "--wait-for-subscribers",
        str(wait_for_subscribers),
    ]

    with STATE.lock:
        if STATE.playing:
            raise RuntimeError("Playback is already running")
        if not STATE.rows:
            raise RuntimeError("Load a CSV first")
        caps = row_capabilities(STATE.fieldnames)
        req = mode_requirements(mode)
        missing = [name for name, needed in req.items() if needed and not caps[name]]
        if missing:
            raise RuntimeError("CSV is missing required data for this mode: " + ", ".join(missing))
        rows = list(STATE.rows)
        fps = fps_override if fps_override > 0.0 else float(STATE.fps)
        STATE.fps = fps
        STATE.playing = True
        STATE.paused = False
        STATE.dry_run = dry_run
        STATE.mode = mode
        STATE.error = ""
        STATE.status = "Playing"
        STATE.stop_event.clear()
        STATE.pause_event.clear()
    STATE.emit()

    def run() -> None:
        bridge = None
        try:
            if not dry_run:
                from t3_bridge import T3HardwareBridge

                bridge = T3HardwareBridge(
                    dry_run=False,
                    require_arms=mode_requirements(mode)["robot"],
                    require_base=mode_requirements(mode)["base"],
                    require_lift=require_lift_subscriber and mode_requirements(mode)["lift"],
                    stream_args=topic_args,
                )
                bridge.connect()
                bridge.wait_until_ready(timeout=max(10.0, wait_for_subscribers + 5.0))
            dt = 1.0 / max(fps, 1.0e-6)
            sent_zero_on_pause = False
            for row_index, row in enumerate(rows):
                if STATE.stop_event.is_set():
                    break
                while STATE.pause_event.is_set() and not STATE.stop_event.is_set():
                    if bridge is not None and not sent_zero_on_pause:
                        bridge.send_raw({"frame_index": -1, "base_wheel_rpm": [0.0, 0.0]})
                        sent_zero_on_pause = True
                    with STATE.lock:
                        STATE.paused = True
                        STATE.status = "Paused"
                    STATE.emit()
                    time.sleep(0.05)
                if STATE.stop_event.is_set():
                    break
                with STATE.lock:
                    if STATE.paused:
                        STATE.paused = False
                        STATE.status = "Resuming"
                sent_zero_on_pause = False
                STATE.emit()
                started_at = time.time()
                payload = build_t3_csv_frame_payload(
                    row,
                    mode=mode,
                    rpm_scale=scales["rpm_scale"],
                    max_abs_rpm=scales["max_abs_rpm"],
                    linear_scale=scales["linear_scale"],
                    backward_scale=scales["backward_scale"],
                    yaw_scale=scales["yaw_scale"],
                    emit_lift=row_index % lift_step_frames == 0,
                )
                data = payload.to_stream_payload()
                if bridge is not None:
                    bridge.send(payload)
                with STATE.lock:
                    STATE.row_index = row_index
                    STATE.frame_index = int(data.get("frame_index", row_index))
                    STATE.last_payload = data
                    STATE.status = "Dry run playing" if dry_run else "Publishing to ROS"
                STATE.emit()
                if wait_for_next_frame(max(0.0, dt - (time.time() - started_at))) and STATE.stop_event.is_set():
                    break
        except Exception as exc:
            with STATE.lock:
                STATE.error = str(exc)
                STATE.status = "Playback failed"
        finally:
            if bridge is not None:
                bridge.disconnect()
            with STATE.lock:
                STATE.playing = False
                STATE.paused = False
                if not STATE.error:
                    STATE.status = "Stopped" if STATE.stop_event.is_set() else "Finished"
            STATE.emit()

    worker = threading.Thread(target=run, daemon=True)
    with STATE.lock:
        STATE.worker = worker
    worker.start()
    return STATE.snapshot()


def stop_playback() -> dict[str, object]:
    STATE.stop_event.set()
    STATE.pause_event.clear()
    with STATE.lock:
        STATE.paused = False
        STATE.status = "Stopping"
    STATE.emit()
    return STATE.snapshot()


def pause_playback() -> dict[str, object]:
    with STATE.lock:
        if not STATE.playing:
            raise RuntimeError("Playback is not running")
        STATE.paused = True
        STATE.status = "Paused"
        STATE.pause_event.set()
    STATE.emit()
    return STATE.snapshot()


def resume_playback() -> dict[str, object]:
    with STATE.lock:
        if not STATE.playing:
            raise RuntimeError("Playback is not running")
        STATE.paused = False
        STATE.status = "Resuming"
        STATE.pause_event.clear()
    STATE.emit()
    return STATE.snapshot()


def wait_for_next_frame(seconds: float) -> bool:
    deadline = time.monotonic() + max(0.0, seconds)
    while time.monotonic() < deadline:
        if STATE.stop_event.is_set() or STATE.pause_event.is_set():
            return True
        time.sleep(min(0.02, max(0.0, deadline - time.monotonic())))
    return STATE.stop_event.is_set() or STATE.pause_event.is_set()


class Handler(BaseHTTPRequestHandler):
    server_version = "T3CsvUi/1.0"

    def log_message(self, fmt: str, *args) -> None:
        print(f"[web] {self.address_string()} {fmt % args}", flush=True)

    def send_json(self, data: object, status: HTTPStatus = HTTPStatus.OK) -> None:
        body = json.dumps(data, default=_json_default).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def read_json(self) -> dict[str, object]:
        length = int(self.headers.get("Content-Length", "0"))
        if length <= 0:
            return {}
        return json.loads(self.rfile.read(length).decode("utf-8"))

    def do_GET(self) -> None:
        parsed = urlparse(self.path)
        if parsed.path == "/api/status":
            self.send_json(STATE.snapshot())
            return
        if parsed.path == "/api/events":
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", "text/event-stream")
            self.send_header("Cache-Control", "no-cache")
            self.send_header("Connection", "keep-alive")
            self.end_headers()
            q: queue.Queue = queue.Queue()
            STATE.events.append(q)
            try:
                self.wfile.write(f"data: {json.dumps(STATE.snapshot())}\n\n".encode("utf-8"))
                self.wfile.flush()
                while True:
                    event = q.get(timeout=15.0)
                    self.wfile.write(f"data: {event}\n\n".encode("utf-8"))
                    self.wfile.flush()
            except Exception:
                if q in STATE.events:
                    STATE.events.remove(q)
            return
        path = HERE / "web" / ("index.html" if parsed.path == "/" else parsed.path.lstrip("/"))
        if path.is_file() and path.resolve().is_relative_to((HERE / "web").resolve()):
            content_type = "text/html"
            if path.suffix == ".css":
                content_type = "text/css"
            elif path.suffix == ".js":
                content_type = "application/javascript"
            body = path.read_bytes()
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        self.send_error(HTTPStatus.NOT_FOUND)

    def do_POST(self) -> None:
        try:
            parsed = urlparse(self.path)
            if parsed.path == "/api/load-path":
                data = self.read_json()
                path = Path(str(data.get("path") or DEFAULT_CSV)).expanduser()
                if not path.is_absolute():
                    path = (Path.cwd() / path).resolve()
                    if not path.exists():
                        path = (HERE / str(data.get("path") or DEFAULT_CSV)).resolve()
                self.send_json(load_path(path, int(data.get("segment", 0)), float(data.get("fps", 0.0))))
                return
            if parsed.path == "/api/upload":
                length = int(self.headers.get("Content-Length", "0"))
                filename, file_bytes, fields = parse_multipart_upload(self.headers, self.rfile.read(length))
                UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
                path = UPLOAD_DIR / filename
                path.write_bytes(file_bytes)
                segment = int(fields.get("segment", "0") or 0)
                fps = float(fields.get("fps", "0") or 0)
                self.send_json(load_path(path, segment, fps))
                return
            if parsed.path == "/api/play":
                self.send_json(start_playback(self.read_json()))
                return
            if parsed.path == "/api/stop":
                self.send_json(stop_playback())
                return
            if parsed.path == "/api/pause":
                self.send_json(pause_playback())
                return
            if parsed.path == "/api/resume":
                self.send_json(resume_playback())
                return
            self.send_error(HTTPStatus.NOT_FOUND)
        except Exception as exc:
            with STATE.lock:
                STATE.error = str(exc)
                STATE.status = "Error"
            STATE.emit()
            self.send_json({"error": str(exc), **STATE.snapshot()}, HTTPStatus.BAD_REQUEST)


def main(argv: list[str] | None = None) -> int:
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--csv", type=Path, default=DEFAULT_CSV)
    args = parser.parse_args(argv)

    if args.csv.exists():
        try:
            load_path(args.csv.resolve(), 0, 0.0)
        except Exception as exc:
            with STATE.lock:
                STATE.error = str(exc)
                STATE.status = "Default CSV failed to load"
    server = ThreadingHTTPServer((args.host, args.port), Handler)
    print(f"T3 CSV ROS UI: http://{args.host}:{args.port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        stop_playback()
        print("\nStopped UI server.", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
