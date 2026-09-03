#!/usr/bin/env python3
"""Local bridge that starts the standalone ROS CSV stream publisher."""

from __future__ import annotations

import json
import os
import shlex
import subprocess
import threading
from dataclasses import dataclass, field
from pathlib import Path

from t3_payloads import T3FramePayload


HERE = Path(__file__).resolve().parent


@dataclass
class T3HardwareBridge:
    dry_run: bool = True
    require_arms: bool = True
    require_base: bool = True
    require_lift: bool = False
    stream_args: list[str] = field(default_factory=list)
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
            publisher = HERE / "t3_robot_stream_publisher.py"
            if not publisher.is_file():
                raise FileNotFoundError(f"T3 ROS publisher not found: {publisher}")

            env = os.environ.copy()
            env["ROS_DOMAIN_ID"] = env.get("ARDY_ROS_DOMAIN_ID", env.get("KIMODO_ROS_DOMAIN_ID", "10"))
            env["ROS_LOCALHOST_ONLY"] = env.get("ARDY_ROS_LOCALHOST_ONLY", env.get("KIMODO_ROS_LOCALHOST_ONLY", "0"))

            publisher_args = [
                env.get("ROS_PYTHON", "/usr/bin/python3"),
                str(publisher),
                "--wait-for-subscribers",
                env.get("ARDY_T3_SUBSCRIBER_WAIT", env.get("KIMODO_ROBOT_SUBSCRIBER_WAIT", "5")),
                "--arm-smooth-rate",
                env.get("ARDY_T3_ARM_SMOOTH_RATE", "0"),
            ]
            if self.dry_run:
                publisher_args.append("--dry-run")
            if self.require_arms:
                publisher_args.append("--require-arm-subscribers")
            if self.require_base:
                publisher_args.append("--require-base-subscriber")
            if self.require_lift:
                publisher_args.append("--require-lift-subscriber")
            publisher_args.extend(self.stream_args)

            command = " && ".join(
                [
                    "test ! -f /opt/ros/humble/setup.bash || source /opt/ros/humble/setup.bash",
                    'test ! -f "$HOME/catkin_ws/install/setup.bash" || source "$HOME/catkin_ws/install/setup.bash"',
                    "test ! -f /home/jony/agx_arm_ws/install/setup.bash || source /home/jony/agx_arm_ws/install/setup.bash",
                    "exec " + shlex.join(publisher_args),
                ]
            )
            process = subprocess.Popen(
                ["bash", "-lc", command],
                cwd=str(HERE),
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

        def watch() -> None:
            if process.stdout is not None:
                for line in process.stdout:
                    clean = line.rstrip()
                    self.last_output.append(clean)
                    self.last_output[:] = self.last_output[-20:]
                    print(f"[T3 ROS] {clean}", flush=True)
                    if clean.startswith("[READY]"):
                        self._ready_event.set()
            return_code = process.wait()
            with self._lock:
                if self.process is process:
                    self.process = None
                if not self._ready_event.is_set():
                    self._startup_error = "\n".join(self.last_output[-6:]) or f"Exit code {return_code}"
                    self._ready_event.set()

        threading.Thread(target=watch, daemon=True).start()

    def wait_until_ready(self, timeout: float = 10.0) -> None:
        if not self._ready_event.wait(max(0.0, float(timeout))):
            self.disconnect()
            raise TimeoutError("Timed out waiting for the T3 ROS stream to become ready.")
        if self._startup_error is not None or not self.is_connected():
            raise RuntimeError(self._startup_error or "T3 ROS stream exited before becoming ready.")

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
        self.send_raw(data)
        return data

    def send_raw(self, data: dict[str, object]) -> dict[str, object]:
        with self._lock:
            process = self.process
        if process is None or process.poll() is not None or process.stdin is None:
            raise RuntimeError("T3 ROS stream is not connected.")
        self.last_payload = data
        try:
            process.stdin.write(json.dumps(data, separators=(",", ":")) + "\n")
            process.stdin.flush()
        except (BrokenPipeError, OSError) as exc:
            self.disconnect()
            raise RuntimeError("T3 ROS stream disconnected while sending a frame.") from exc
        return data
