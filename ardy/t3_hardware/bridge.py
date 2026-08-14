"""Stdin bridge to the T3 ROS hardware streamer."""

from __future__ import annotations

import json
import os
import subprocess
import threading
import time
from dataclasses import dataclass, field
from pathlib import Path

from .payloads import T3FramePayload


def default_stream_script() -> Path:
    env_path = os.environ.get("ARDY_T3_STREAM_SCRIPT")
    if env_path:
        return Path(env_path).expanduser()
    return Path(__file__).resolve().parents[2] / "scripts" / "stream_t3_robot_sync.sh"


@dataclass
class T3HardwareBridge:
    """Manage the long-lived T3 ROS stream process used by Kimodo."""

    stream_script: Path = field(default_factory=default_stream_script)
    dry_run: bool = True
    require_arms: bool = True
    require_base: bool = True
    require_lift: bool = False
    process: subprocess.Popen[str] | None = None
    last_output: list[str] = field(default_factory=list)
    last_payload: dict[str, object] | None = None
    _lock: threading.Lock = field(default_factory=threading.Lock)
    _ready_event: threading.Event = field(default_factory=threading.Event)
    _startup_error: str | None = None

    def is_connected(self) -> bool:
        with self._lock:
            return self.process is not None and self.process.poll() is None

    def connect(self) -> None:
        with self._lock:
            if self.process is not None and self.process.poll() is None:
                return
            script = self.stream_script.expanduser().resolve()
            if not script.is_file():
                raise FileNotFoundError(f"T3 stream script not found: {script}")

            env = os.environ.copy()
            env["ARDY_T3_DRY_RUN"] = "1" if self.dry_run else "0"
            env["ARDY_T3_REQUIRE_ARMS"] = "1" if self.require_arms else "0"
            env["ARDY_T3_REQUIRE_BASE"] = "1" if self.require_base else "0"
            env["ARDY_T3_REQUIRE_LIFT"] = "1" if self.require_lift else "0"
            process = subprocess.Popen(
                [str(script)],
                cwd=str(script.parent.parent),
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1,
                env=env,
            )
            self.process = process
            self.last_output.clear()
            self.last_payload = None
            self._startup_error = None
            self._ready_event.clear()

        def _watch() -> None:
            if process.stdout is not None:
                for line in process.stdout:
                    clean = line.rstrip()
                    self.last_output.append(clean)
                    self.last_output[:] = self.last_output[-20:]
                    print(f"[ARDY T3 HARDWARE] {clean}", flush=True)
                    if clean.startswith("[READY]"):
                        self._ready_event.set()
            return_code = process.wait()
            with self._lock:
                if self.process is process:
                    self.process = None
                if not self._ready_event.is_set():
                    self._startup_error = "\n".join(self.last_output[-6:]) or f"Exit code {return_code}"
                    self._ready_event.set()

        threading.Thread(target=_watch, daemon=True).start()

    def wait_until_ready(self, timeout: float = 10.0) -> None:
        if not self._ready_event.wait(max(0.0, float(timeout))):
            self.disconnect()
            raise TimeoutError("Timed out waiting for the T3 hardware stream to become ready.")
        if self._startup_error is not None or not self.is_connected():
            raise RuntimeError(self._startup_error or "T3 hardware stream exited before becoming ready.")

    def disconnect(self) -> None:
        with self._lock:
            process = self.process
            self.process = None
        if process is None or process.poll() is not None:
            self._ready_event.set()
            return
        if process.stdin is not None:
            try:
                process.stdin.write(json.dumps({"frame_index": -1, "base_wheel_rpm": [0.0, 0.0]}) + "\n")
                process.stdin.flush()
                process.stdin.close()
            except OSError:
                pass
        try:
            process.wait(timeout=0.25)
        except subprocess.TimeoutExpired:
            process.terminate()

    def send(self, payload: T3FramePayload) -> dict[str, object]:
        data = payload.to_stream_payload()
        with self._lock:
            process = self.process
        if process is None or process.poll() is not None or process.stdin is None:
            raise RuntimeError("T3 hardware stream is not connected.")
        self.last_payload = data
        try:
            process.stdin.write(json.dumps(data, separators=(",", ":")) + "\n")
            process.stdin.flush()
        except (BrokenPipeError, OSError) as exc:
            self.disconnect()
            raise RuntimeError("T3 hardware stream disconnected while sending a frame.") from exc
        return data
