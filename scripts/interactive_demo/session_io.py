# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Part of InteractiveTimelineDemo (split for readability)."""

from .common import *  # noqa: F401,F403


class SessionIOMixin:
    def _compute_soma_debug_motion(self, local_rot_mats, root_positions, device):
        from ardy.exports.bvh import core27_to_soma77_bvh_local_rotations
        from ardy.skeleton import SOMASkeleton77, batch_rigid_transform

        soma_skeleton = SOMASkeleton77().to(device)
        bvh_local_np = core27_to_soma77_bvh_local_rotations(local_rot_mats)
        local_rot_mats_t = torch.as_tensor(bvh_local_np, device=device, dtype=torch.float32)

        # Match the BVH import path: exported BVH globals are post-multiplied by
        # standard T-pose offsets before visualization/skinning.
        neutral_joints = torch.ones(
            (local_rot_mats_t.shape[0], soma_skeleton.nbjoints, 3),
            device=device,
            dtype=torch.float32,
        )
        _, global_rot_mats = batch_rigid_transform(
            local_rot_mats_t,
            neutral_joints,
            soma_skeleton.joint_parents.to(device),
            soma_skeleton.root_idx,
        )
        if hasattr(soma_skeleton, "global_rot_offsets"):
            global_offsets = soma_skeleton.global_rot_offsets.to(device=device, dtype=torch.float32)
            global_rot_mats = torch.einsum("T N m n, N o n -> T N m o", global_rot_mats, global_offsets)
            parent_rots = global_rot_mats[:, soma_skeleton.joint_parents.to(device)]
            parent_rots[:, soma_skeleton.root_idx] = torch.eye(3, device=device, dtype=torch.float32)
            local_rot_mats_t = torch.einsum(
                "T N m n, T N n o -> T N m o",
                parent_rots.transpose(-2, -1),
                global_rot_mats,
            )

        root_positions_t = torch.as_tensor(root_positions, device=device, dtype=torch.float32)
        soma_global_rot, soma_joints_pos, _ = soma_skeleton.fk(local_rot_mats_t, root_positions_t)
        return soma_skeleton.cpu(), soma_joints_pos.detach().cpu(), soma_global_rot.detach().cpu()

    def _read_soma_worker_json(self, proc):
        if proc.stdout is None:
            raise RuntimeError("Soma T3 worker has no stdout pipe")
        while True:
            line = proc.stdout.readline()
            if not line:
                raise RuntimeError("Soma T3 worker exited without a JSON response")
            try:
                return json.loads(line)
            except json.JSONDecodeError:
                print(f"[T3 Live] Soma worker log: {line.rstrip()}")

    def _get_soma_t3_worker(self, client_id: int):
        import subprocess
        import sys
        from pathlib import Path

        if not self.client_active(client_id):
            return None
        session = self.client_sessions[client_id]
        proc = session.t3_soma_worker_process
        if proc is not None and proc.poll() is None:
            return proc

        worker = Path(REPO_ROOT) / "ardy" / "retarget_to_t3" / "soma_t3_worker.py"
        cmd = [sys.executable, str(worker)]
        proc = subprocess.Popen(
            cmd,
            cwd=REPO_ROOT,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=None,
            text=True,
            bufsize=1,
        )
        ready = self._read_soma_worker_json(proc)
        if not ready.get("ok"):
            raise RuntimeError(f"Soma T3 worker failed to start: {ready}")
        session.t3_soma_worker_process = proc
        return proc

    def _export_core27_t3_with_soma_env(
        self,
        local_rot_mats,
        root_positions,
        fps: float,
        output_csv,
        *,
        status_client_id: int | None = None,
    ):
        """Export Soma BVH locally, then retarget upper body in a warm Soma worker."""
        from pathlib import Path

        from ardy.exports.bvh import export_soma_bvh_from_arrays
        from ardy.retarget_to_t3.embedded_soma_t3 import VENDORED_REFERENCE_BVH

        output_csv = Path(output_csv).expanduser().resolve()
        output_csv.parent.mkdir(parents=True, exist_ok=True)
        live_root = Path(REPO_ROOT) / ".cache" / "t3_live"
        live_root.mkdir(parents=True, exist_ok=True)
        bvh_path = (live_root / f"{output_csv.stem}.soma.bvh").resolve()
        export_soma_bvh_from_arrays(
            local_rot_mats=local_rot_mats,
            root_positions=root_positions,
            fps=fps,
            reference_bvh=VENDORED_REFERENCE_BVH,
            output_bvh=bvh_path,
        )

        if status_client_id is not None:
            self._set_soma_t3_status(status_client_id, "Soma upper-body retarget worker")

        proc = self._get_soma_t3_worker(status_client_id) if status_client_id is not None else None
        if proc is None or proc.stdin is None or proc.stdout is None:
            raise RuntimeError("Soma T3 worker is unavailable")
        payload = {
            "bvh_path": str(bvh_path),
            "output_csv": str(output_csv),
            "fps": float(fps),
        }
        session = self.client_sessions[status_client_id]
        with session.t3_soma_worker_lock:
            proc.stdin.write(json.dumps(payload) + "\n")
            proc.stdin.flush()
            result = self._read_soma_worker_json(proc)
        if not result.get("ok"):
            raise RuntimeError(f"Soma T3 worker failed: {result.get('error')}\n{result.get('traceback', '')}")
        return output_csv

    def _merge_t3_csv_chunk(self, existing_csv, chunk_csv, output_csv, start_frame: int):
        """Merge a retargeted chunk into the accumulated frame-indexed T3 CSV."""
        import csv
        import shutil
        from pathlib import Path

        existing_csv = Path(existing_csv) if existing_csv is not None else None
        chunk_csv = Path(chunk_csv)
        output_csv = Path(output_csv)
        start_frame = max(0, int(start_frame))

        with chunk_csv.open(newline="", encoding="utf-8") as f:
            chunk_reader = csv.DictReader(f)
            if chunk_reader.fieldnames is None:
                raise ValueError(f"{chunk_csv} has no header")
            header = list(chunk_reader.fieldnames)
            chunk_rows = list(chunk_reader)

        if start_frame == 0 or existing_csv is None or not existing_csv.exists():
            output_csv.parent.mkdir(parents=True, exist_ok=True)
            if chunk_csv.resolve() != output_csv.resolve():
                shutil.copyfile(chunk_csv, output_csv)
            return output_csv, len(chunk_rows) - 1

        with existing_csv.open(newline="", encoding="utf-8") as f:
            existing_reader = csv.DictReader(f)
            if existing_reader.fieldnames is None:
                raise ValueError(f"{existing_csv} has no header")
            existing_rows = list(existing_reader)
            for column in existing_reader.fieldnames:
                if column not in header:
                    header.append(column)

        merged_rows = existing_rows[:start_frame] + chunk_rows
        output_csv.parent.mkdir(parents=True, exist_ok=True)
        with output_csv.open("w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=header)
            writer.writeheader()
            for frame_idx, row in enumerate(merged_rows):
                out = {column: row.get(column, "") for column in header}
                out["Frame"] = frame_idx
                writer.writerow(out)
        return output_csv, len(merged_rows) - 1

    def _write_full_soma_t3_stream_files(
        self,
        client_id: int,
        generation: int,
        local_rot_mats,
        root_positions,
        fps: float,
        rows: list[dict],
    ):
        """Save one complete SOMA BVH + T3 CSV pair for RTX replay."""
        import csv
        from pathlib import Path

        from ardy.exports.bvh import export_soma_bvh_from_arrays
        from ardy.retarget_to_t3.embedded_soma_t3 import VENDORED_REFERENCE_BVH

        full_root = Path(REPO_ROOT) / ".cache" / "t3_live" / "full"
        full_root.mkdir(parents=True, exist_ok=True)
        stem = f"client_{client_id}_gen_{generation}_full"
        csv_path = full_root / f"{stem}.csv"
        bvh_path = full_root / f"{stem}.soma.bvh"

        export_soma_bvh_from_arrays(
            local_rot_mats=local_rot_mats,
            root_positions=root_positions,
            fps=fps,
            reference_bvh=VENDORED_REFERENCE_BVH,
            output_bvh=bvh_path,
        )

        fieldnames: list[str] = []
        for row in rows:
            for key in row.keys():
                if key not in fieldnames:
                    fieldnames.append(key)
        if "Frame" in fieldnames:
            fieldnames.remove("Frame")
        fieldnames.insert(0, "Frame")

        with csv_path.open("w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            for frame_idx, row in enumerate(rows):
                out = {key: row.get(key, "") for key in fieldnames}
                out["Frame"] = frame_idx
                writer.writerow(out)

        session = self.client_sessions[client_id]
        session.t3_retarget_csv_path = str(csv_path)
        gui = getattr(session, "gui_elements", None)
        if gui is not None:
            if getattr(gui, "gui_viz_file_csv_path", None) is not None:
                gui.gui_viz_file_csv_path.value = str(csv_path)
            if getattr(gui, "gui_viz_file_bvh_path", None) is not None:
                gui.gui_viz_file_bvh_path.value = str(bvh_path)
        print(
            f"[T3 Live] Saved complete RTX replay pair: {csv_path} + {bvh_path} ({len(rows)} frames)",
            flush=True,
        )
        return csv_path, bvh_path

    def _read_t3_csv_rows(self, csv_path):
        import csv
        from pathlib import Path

        csv_path = Path(csv_path)
        with csv_path.open(newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            if reader.fieldnames is None:
                raise ValueError(f"{csv_path} has no header")
            return [
                {key: float(value) if value not in {"", None} else 0.0 for key, value in row.items()}
                for row in reader
            ]

    def _set_soma_t3_status(self, client_id: int, status: str) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        session.t3_retarget_status = status
        status_handle = getattr(session.gui_elements, "gui_viz_t3_retarget_status", None)
        if status_handle is not None:
            status_handle.value = status

    def _ensure_live_soma_t3_motion_cache(self, client_id: int) -> bool:
        """Cache the current generated motion through the exact SOMA BVH load path."""
        if not self.client_active(client_id):
            return False
        session = self.client_sessions[client_id]
        if session.motion_tensor is None or session.motion_rep is None:
            return False
        if (
            session.t3_live_soma77_local_rot_mats is not None
            and session.t3_live_root_positions is not None
            and session.t3_live_soma77_local_rot_mats.shape[0] == session.max_frame_idx + 1
        ):
            return True

        from pathlib import Path

        from scipy.spatial.transform import Rotation

        from ardy.exports.bvh import export_soma_bvh_from_arrays
        from ardy.retarget_to_t3.embedded_soma_t3 import (
            VENDORED_REFERENCE_BVH,
            ensure_vendored_soma_importable,
        )

        with session.motion_tensor_lock:
            motion_tensor = None if session.motion_tensor is None else session.motion_tensor.detach().clone()
            motion_rep = session.motion_rep
        if motion_tensor is None or motion_rep is None:
            return False

        with torch.no_grad():
            tensor_unnorm = motion_rep.unnormalize(motion_tensor)
            inverse_output = motion_rep.inverse(tensor_unnorm, is_normalized=False)
            local_rot_mats = inverse_output["local_rot_mats"][0].detach().cpu().numpy()
            root_positions = inverse_output["root_positions"][0].detach().cpu().numpy()
        ensure_vendored_soma_importable()
        import soma_retargeter.assets.bvh as bvh_utils

        live_root = Path(REPO_ROOT) / ".cache" / "t3_live"
        live_root.mkdir(parents=True, exist_ok=True)
        bvh_path = live_root / f"client_{client_id}_live_soma.bvh"
        export_soma_bvh_from_arrays(
            local_rot_mats=local_rot_mats,
            root_positions=root_positions,
            fps=session.model_fps,
            reference_bvh=VENDORED_REFERENCE_BVH,
            output_bvh=bvh_path,
        )
        _soma_skeleton, soma_animation = bvh_utils.load_bvh(bvh_path)
        soma77_local = np.empty((soma_animation.num_frames, 77, 3, 3), dtype=np.float32)
        soma_root_positions = np.empty((soma_animation.num_frames, 3), dtype=np.float32)
        for frame in range(soma_animation.num_frames):
            local_transforms = soma_animation.get_local_transforms(frame)
            if len(local_transforms) == 78:
                # Exported SOMA BVHs contain a dummy BVH Root above Hips. The
                # live Newton pipeline is built from the 77-joint SOMA skeleton,
                # so feed Hips as the root and drop the loader-only parent.
                local_transforms = local_transforms[1:]
            elif len(local_transforms) != 77:
                raise ValueError(f"Expected 77 or 78 SOMA BVH transforms, got {len(local_transforms)}")
            soma_root_positions[frame] = np.asarray(local_transforms[0][0:3], dtype=np.float32)
            soma77_local[frame] = np.stack(
                [Rotation.from_quat(transform[3:7]).as_matrix() for transform in local_transforms],
                axis=0,
            ).astype(np.float32, copy=False)

        session.t3_live_soma77_local_rot_mats = soma77_local.astype(np.float32, copy=False)
        session.t3_live_root_positions = soma_root_positions.astype(np.float32, copy=False)
        return True

    def solve_live_soma_t3_frame(self, client_id: int, frame_idx: int) -> dict[str, float] | None:
        """Retarget one live frame through the in-process embedded Soma/Newton solver."""
        if not self.client_active(client_id):
            return None
        session = self.client_sessions[client_id]
        frame_idx = int(frame_idx)
        if session.t3_live_last_row_frame_idx == frame_idx and session.t3_live_last_row is not None:
            return session.t3_live_last_row
        if not self._ensure_live_soma_t3_motion_cache(client_id):
            self._set_soma_t3_status(client_id, "waiting for motion")
            return None
        if session.t3_live_solver_warm_thread is not None and session.t3_live_solver_warm_thread.is_alive():
            self._set_soma_t3_status(client_id, "warming live solver")
            return None
        if (
            session.t3_live_soma77_local_rot_mats is None
            or session.t3_live_root_positions is None
            or frame_idx < 0
            or frame_idx >= session.t3_live_soma77_local_rot_mats.shape[0]
        ):
            return None

        with session.t3_live_solver_lock:
            if session.t3_live_soma_solver is None:
                self._set_soma_t3_status(client_id, "initializing in-process Soma solver")
                from ardy.retarget_to_t3.embedded_soma_t3 import SomaT3LiveUpperBodySolver

                session.t3_live_soma_solver = SomaT3LiveUpperBodySolver()

            previous_frame = int(session.t3_live_last_row_frame_idx)
            if previous_frame >= 0 and frame_idx == previous_frame + 1:
                row = session.t3_live_soma_solver.solve_frame(
                    session.t3_live_root_positions[frame_idx],
                    session.t3_live_soma77_local_rot_mats[frame_idx],
                )
                expected_status = f"live frame {frame_idx}"
            else:
                if previous_frame >= 0 and frame_idx > previous_frame + 1:
                    solve_start = previous_frame + 1
                else:
                    session.t3_live_soma_solver.reset()
                    solve_start = 0
                solve_start = max(0, min(solve_start, frame_idx))
                self._set_soma_t3_status(client_id, f"catching up {solve_start}-{frame_idx}")
                row = session.t3_live_soma_solver.solve_frames(
                    session.t3_live_root_positions[solve_start : frame_idx + 1],
                    session.t3_live_soma77_local_rot_mats[solve_start : frame_idx + 1],
                )
                expected_status = f"live frame {frame_idx} after catch-up {solve_start}-{frame_idx}"
        session.t3_live_last_row_frame_idx = frame_idx
        session.t3_live_last_row = row
        self._set_soma_t3_status(client_id, expected_status)
        return row

    def solve_live_soma_mesh_t3_frame(self, client_id: int, frame_idx: int, soma_joints_pos, soma_joints_rot, soma_skeleton) -> dict[str, float] | None:
        """Retarget the current live SOMA mesh pose through the embedded Soma/Newton solver."""
        if not self.client_active(client_id):
            return None
        session = self.client_sessions[client_id]
        if session.t3_live_solver_warm_thread is not None and session.t3_live_solver_warm_thread.is_alive():
            self._set_soma_t3_status(client_id, "warming live solver")
            return None
        with session.t3_live_solver_lock:
            if session.t3_live_soma_solver is None:
                self._set_soma_t3_status(client_id, "initializing in-process Soma solver")
                from ardy.retarget_to_t3.embedded_soma_t3 import SomaT3LiveUpperBodySolver

                session.t3_live_soma_solver = SomaT3LiveUpperBodySolver()

            if int(session.t3_live_last_row_frame_idx) >= 0 and int(frame_idx) < int(session.t3_live_last_row_frame_idx):
                session.t3_live_soma_solver.reset()
            row = session.t3_live_soma_solver.solve_soma_global_frame(
                soma_joints_pos,
                soma_joints_rot,
                soma_skeleton.bone_order_names,
            )
        session.t3_live_last_row_frame_idx = int(frame_idx)
        session.t3_live_last_row = row
        self._set_soma_t3_status(client_id, f"SOMA mesh Newton frame {frame_idx}")
        return row

    def reset_live_soma_t3_solver(self, client_id: int) -> None:
        """Reset the persistent in-process Soma/Newton solver state."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        session.t3_live_last_row_frame_idx = -1
        session.t3_live_last_row = None
        with session.t3_live_solver_lock:
            if session.t3_live_soma_solver is not None:
                session.t3_live_soma_solver.reset()
        self._set_soma_t3_status(client_id, "live solver reset")

    def warm_live_soma_t3_solver(self, client_id: int) -> None:
        """Initialize the in-process Soma/Newton solver without blocking playback."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        if session.t3_live_soma_solver is not None:
            self._set_soma_t3_status(client_id, "live solver ready")
            return
        if session.t3_retarget_thread is not None and session.t3_retarget_thread.is_alive():
            return
        if session.t3_live_solver_warm_thread is not None and session.t3_live_solver_warm_thread.is_alive():
            return

        def _warm() -> None:
            if not self.client_active(client_id):
                return
            try:
                session = self.client_sessions[client_id]
                from ardy.retarget_to_t3.embedded_soma_t3 import SomaT3LiveUpperBodySolver

                with session.t3_live_solver_lock:
                    if session.t3_live_soma_solver is None:
                        session.t3_live_soma_solver = SomaT3LiveUpperBodySolver()
                self._set_soma_t3_status(client_id, "live solver ready")
            except Exception as e:
                print(f"[T3 Live] In-process Soma live solver warmup failed: {e}")
                import traceback

                traceback.print_exc()
                self._set_soma_t3_status(client_id, "live solver failed")

        thread = threading.Thread(target=_warm, daemon=True)
        session.t3_live_solver_warm_thread = thread
        self._set_soma_t3_status(client_id, "warming live solver")
        thread.start()

    def request_soma_t3_retarget(self, client_id: int, force: bool = False, start_frame: int | None = None) -> None:
        """Start a background Soma/Newton retarget near the current live frame."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        if session.motion_tensor is None or session.motion_rep is None:
            self._set_soma_t3_status(client_id, "waiting for motion")
            return
        requested_start = int(session.frame_idx if start_frame is None else start_frame)
        requested_start = max(0, requested_start)
        requested_end = int(session.max_frame_idx)
        if requested_end < 0:
            self._set_soma_t3_status(client_id, "waiting for motion")
            return

        with session.t3_retarget_lock:
            ready_covers_request = (
                session.t3_retarget_csv_path is not None
                and session.t3_retarget_csv_start_frame <= 0
                and session.t3_retarget_csv_end_frame >= requested_end
            )
            if ready_covers_request and not force:
                return
            if (
                session.t3_retarget_thread is not None
                and session.t3_retarget_thread.is_alive()
                and session.t3_retarget_thread is not threading.current_thread()
            ):
                if session.t3_retarget_requested_end_frame >= requested_end and not force:
                    return
                session.t3_retarget_pending_after_current = True
                session.t3_retarget_requested_end_frame = max(
                    session.t3_retarget_requested_end_frame,
                    requested_end,
                )
                if session.t3_retarget_pending_start_frame is None:
                    session.t3_retarget_pending_start_frame = requested_start
                else:
                    session.t3_retarget_pending_start_frame = min(
                        session.t3_retarget_pending_start_frame,
                        requested_start,
                    )
                session.t3_retarget_status = "retarget already running"
                if getattr(session.gui_elements, "gui_viz_t3_retarget_status", None) is not None:
                    session.gui_elements.gui_viz_t3_retarget_status.value = session.t3_retarget_status
                return
            session.t3_retarget_generation += 1
            generation = session.t3_retarget_generation
            session.t3_retarget_requested_end_frame = requested_end
            session.t3_retarget_status = f"retargeting gen {generation}: frames 0-{requested_end}"
            if getattr(session.gui_elements, "gui_viz_t3_retarget_status", None) is not None:
                session.gui_elements.gui_viz_t3_retarget_status.value = session.t3_retarget_status

            thread = threading.Thread(
                target=self._run_soma_t3_retarget_worker,
                args=(client_id, generation, requested_start),
                daemon=True,
            )
            session.t3_retarget_thread = thread
            thread.start()

    def _run_soma_t3_retarget_worker(self, client_id: int, generation: int, requested_start_frame: int) -> None:
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        try:
            retarget_start_time = time.time()
            from pathlib import Path

            with session.motion_tensor_lock:
                motion_tensor = None if session.motion_tensor is None else session.motion_tensor.detach().clone()
                motion_rep = session.motion_rep
                fps = session.model_fps

            if motion_tensor is None or motion_rep is None:
                self._set_soma_t3_status(client_id, "waiting for motion")
                return

            with torch.no_grad():
                tensor_unnorm = motion_rep.unnormalize(motion_tensor)
                inverse_output = motion_rep.inverse(tensor_unnorm, is_normalized=False)
                local_rot_mats = inverse_output["local_rot_mats"][0].detach().cpu().numpy()
                root_positions = inverse_output["root_positions"][0].detach().cpu().numpy()
                soma_skeleton, soma_joints_pos, soma_joints_rot = self._compute_soma_debug_motion(
                    local_rot_mats,
                    root_positions,
                    self.device,
                )

            with session.t3_retarget_lock:
                session.soma_debug_skeleton = soma_skeleton
                session.soma_debug_joints_pos = soma_joints_pos
                session.soma_debug_joints_rot = soma_joints_rot
                session.soma_debug_generation = generation

            total_frames = int(local_rot_mats.shape[0])
            if total_frames <= 0:
                self._set_soma_t3_status(client_id, "waiting for motion")
                return
            with session.t3_retarget_lock:
                previous_ready_end = int(session.t3_retarget_csv_end_frame)

            stream_start = previous_ready_end + 1
            if stream_start < 0:
                stream_start = 0
            if stream_start >= total_frames:
                return

            # Packet size controls how quickly newly retargeted rows can be
            # appended to the live T3 buffer. Smaller packets reduce the first
            # playable slice size, but pay the SOMA/Newton per-call overhead
            # more often.
            env_packet_size = os.environ.get("T3_SOMA_PACKET_SIZE")
            configured_packet_size = (
                int(env_packet_size)
                if env_packet_size not in {None, ""}
                else int(getattr(session, "t3_stream_packet_size", 10))
            )
            packet_size = max(1, configured_packet_size)
            context_frames = max(15, int(round(float(fps) * 0.75)))
            live_root = Path(".cache") / "t3_live"
            if stream_start == 0:
                with session.t3_retarget_lock:
                    session.t3_stream_rows = []
                    session.t3_retarget_packet_ranges = []
                    session.t3_retarget_packet_end_frames = []

            merged_end_frame = previous_ready_end
            for packet_start in range(stream_start, total_frames, packet_size):
                if not self.client_active(client_id):
                    return
                packet_end = min(packet_start + packet_size, total_frames)
                packet_start_time = time.time()
                context_start = max(0, packet_start - context_frames)
                packet_csv = live_root / (
                    f"client_{client_id}_gen_{generation}_packet_{packet_start}_{packet_end - 1}"
                    f"_ctx_{context_start}.csv"
                )
                self._export_core27_t3_with_soma_env(
                    local_rot_mats[context_start:packet_end],
                    root_positions[context_start:packet_end],
                    fps,
                    packet_csv,
                    status_client_id=client_id,
                )
                packet_rows_all = self._read_t3_csv_rows(packet_csv)
                row_offset = packet_start - context_start
                rows = packet_rows_all[row_offset : row_offset + (packet_end - packet_start)]
                if len(rows) != packet_end - packet_start:
                    raise RuntimeError(
                        f"Expected {packet_end - packet_start} packet rows from {packet_csv}, got {len(rows)}"
                    )
                with session.t3_retarget_lock:
                    if len(session.t3_stream_rows) < packet_start:
                        session.t3_stream_rows.extend({} for _ in range(packet_start - len(session.t3_stream_rows)))
                    for offset, row in enumerate(rows):
                        frame_number = packet_start + offset
                        row = dict(row)
                        row["Frame"] = frame_number
                        if frame_number < len(session.t3_stream_rows):
                            session.t3_stream_rows[frame_number] = row
                        else:
                            session.t3_stream_rows.append(row)
                    merged_end_frame = len(session.t3_stream_rows) - 1
                    session.t3_retarget_csv_start_frame = 0
                    session.t3_retarget_csv_end_frame = merged_end_frame
                    packet_range = (int(packet_start), int(packet_end - 1))
                    if packet_range not in session.t3_retarget_packet_ranges:
                        session.t3_retarget_packet_ranges.append(packet_range)
                    if merged_end_frame not in session.t3_retarget_packet_end_frames:
                        session.t3_retarget_packet_end_frames.append(int(merged_end_frame))
                    session.t3_retarget_ready_generation = generation
                    session.t3_retarget_status = (
                        f"stream ready {packet_start}-{packet_end - 1} "
                        f"({packet_end - packet_start} frames in {time.time() - packet_start_time:.2f}s)"
                    )
                    if getattr(session.gui_elements, "gui_viz_t3_retarget_status", None) is not None:
                        session.gui_elements.gui_viz_t3_retarget_status.value = session.t3_retarget_status
                print(
                    f"[T3 Live] Soma stream ready: frames {packet_start}-{packet_end - 1} "
                    f"({(packet_end - packet_start) / float(fps):.2f}s motion) "
                    f"in {time.time() - packet_start_time:.2f}s"
                )
                self.set_frame(client_id, session.frame_idx)

            if not self.client_active(client_id):
                return
            session = self.client_sessions[client_id]
            with session.t3_retarget_lock:
                if generation >= session.t3_retarget_ready_generation:
                    session.t3_retarget_ready_generation = generation
                    session.t3_retarget_csv_start_frame = 0
                    session.t3_retarget_csv_end_frame = merged_end_frame
                    elapsed_s = time.time() - retarget_start_time
                    session.t3_retarget_status = (
                        f"stream gen {generation}: frames 0-{merged_end_frame} in {elapsed_s:.2f}s"
                    )
                    if getattr(session.gui_elements, "gui_viz_t3_retarget_status", None) is not None:
                        session.gui_elements.gui_viz_t3_retarget_status.value = session.t3_retarget_status
                run_pending = session.t3_retarget_pending_after_current
                pending_start_frame = session.t3_retarget_pending_start_frame
                session.t3_retarget_pending_after_current = False
                session.t3_retarget_pending_start_frame = None
                full_rows = [dict(row) for row in session.t3_stream_rows if row]
            if full_rows:
                self._write_full_soma_t3_stream_files(
                    client_id,
                    generation,
                    local_rot_mats[: len(full_rows)],
                    root_positions[: len(full_rows)],
                    fps,
                    full_rows,
                )
            print(
                f"[T3 Live] Soma stream generation {generation} ready: "
                f"frames 0-{merged_end_frame} in {time.time() - retarget_start_time:.2f}s"
            )
            self.set_frame(client_id, session.frame_idx)
            if run_pending:
                current_end = int(session.max_frame_idx)
                if current_end > merged_end_frame:
                    self.request_soma_t3_retarget(
                        client_id,
                        force=True,
                        start_frame=pending_start_frame if pending_start_frame is not None else session.frame_idx,
                    )
        except Exception as e:
            print(f"[T3 Live] Soma retarget failed: {e}")
            import traceback

            traceback.print_exc()
            self._set_soma_t3_status(client_id, "failed")
            if self.client_active(client_id):
                session = self.client_sessions[client_id]
                with session.t3_retarget_lock:
                    run_pending = session.t3_retarget_pending_after_current
                    pending_start_frame = session.t3_retarget_pending_start_frame
                    session.t3_retarget_pending_after_current = False
                    session.t3_retarget_pending_start_frame = None
                if run_pending:
                    current_end = int(session.max_frame_idx)
                    if current_end > int(session.t3_retarget_csv_end_frame):
                        self.request_soma_t3_retarget(
                            client_id,
                            force=True,
                            start_frame=pending_start_frame if pending_start_frame is not None else session.frame_idx,
                        )

    def export_soma_bvh(self, client_id: int, filepath: str):
        """Export the generated CoreSkeleton27 motion as a SOMA-style BVH."""
        if not self.client_active(client_id):
            return False
        session = self.client_sessions[client_id]
        if session.motion_tensor is None or session.motion_rep is None:
            print("[BVH Export] No generated motion is available to export")
            return False

        try:
            from pathlib import Path

            from ardy.exports.bvh import export_soma_bvh_from_arrays
            from ardy.retarget_to_t3.embedded_soma_t3 import VENDORED_REFERENCE_BVH

            tensor_unnorm = session.motion_rep.unnormalize(session.motion_tensor)
            inverse_output = session.motion_rep.inverse(tensor_unnorm, is_normalized=False)
            local_rot_mats = inverse_output["local_rot_mats"][0].detach().cpu().numpy()
            root_positions = inverse_output["root_positions"][0].detach().cpu().numpy()

            export_soma_bvh_from_arrays(
                local_rot_mats=local_rot_mats,
                root_positions=root_positions,
                fps=session.model_fps,
                reference_bvh=VENDORED_REFERENCE_BVH,
                output_bvh=Path(filepath),
            )
            print(f"[BVH Export] Saved SOMA BVH to {filepath}")
            return True
        except Exception as e:
            print(f"[BVH Export] Error exporting SOMA BVH: {e}")
            import traceback

            traceback.print_exc()
            return False

    def export_t3_motion_csv(self, client_id: int, filepath: str):
        """Export the generated motion retargeted to T3 as a CSV."""
        if not self.client_active(client_id):
            return False
        session = self.client_sessions[client_id]
        if session.motion_tensor is None or session.motion_rep is None:
            print("[T3 Export] No generated motion is available to export")
            return False

        try:
            tensor_unnorm = session.motion_rep.unnormalize(session.motion_tensor)
            inverse_output = session.motion_rep.inverse(tensor_unnorm, is_normalized=False)
            local_rot_mats = inverse_output["local_rot_mats"][0].detach().cpu().numpy()
            root_positions = inverse_output["root_positions"][0].detach().cpu().numpy()

            path = self._export_core27_t3_with_soma_env(
                local_rot_mats,
                root_positions,
                session.model_fps,
                filepath,
                status_client_id=client_id,
            )
            print(f"[T3 Export] Saved T3 CSV to {path}")
            return True
        except Exception as e:
            print(f"[T3 Export] Error exporting T3 CSV: {e}")
            import traceback

            traceback.print_exc()
            return False

    def export_session(self, client_id: int, filepath: str):
        """Export generated motion, text prompts, and constraints to a file using pickle."""
        if not self.client_active(client_id):
            return False
        session = self.client_sessions[client_id]

        try:
            # Prepare export data
            export_data = {
                "version": "1.0",
                "timestamp": datetime.now().isoformat(),
                "model_fps": session.model_fps,
                "max_frame_idx": session.max_frame_idx,
            }

            # Record the skeleton identity so loads can validate compatibility.
            _skel = getattr(getattr(session, "motion_rep", None), "skeleton", None)
            if _skel is not None:
                export_data["skeleton"] = {
                    "name": getattr(_skel, "name", None),
                    "nbjoints": getattr(_skel, "nbjoints", None),
                }

            # Export motion data (keep as numpy arrays)
            if session.joints_pos is not None:
                motion_data = {
                    "joints_pos": session.joints_pos.cpu().numpy(),
                    "joints_rot": session.joints_rot.cpu().numpy() if session.joints_rot is not None else None,
                    "root_velocities": session.root_velocities.cpu().numpy()
                    if session.root_velocities is not None
                    else None,
                    "motion_tensor": session.motion_tensor.cpu().numpy() if session.motion_tensor is not None else None,
                    "foot_contacts": session.foot_contacts.cpu().numpy() if session.foot_contacts is not None else None,
                }

                # Inverse motion_tensor to get local_rot_mats and root_positions
                if session.motion_tensor is not None and session.motion_rep is not None:
                    try:
                        tensor_unnorm = session.motion_rep.unnormalize(session.motion_tensor)
                        inverse_output = session.motion_rep.inverse(tensor_unnorm, is_normalized=False)
                        motion_data["local_rot_mats"] = inverse_output["local_rot_mats"].cpu().numpy()
                        motion_data["root_positions"] = inverse_output["root_positions"].cpu().numpy()
                        print("[Export] Added local_rot_mats and root_positions")
                    except Exception as e:
                        print(f"[Export] Could not compute local_rot_mats/root_positions: {e}")

                export_data["motion"] = motion_data

            # Export text prompts from timeline
            client = self.server.get_clients()[client_id]
            if hasattr(client, "timeline") and client.timeline._prompts:
                prompts_list = []
                for prompt_uuid, prompt in client.timeline._prompts.items():
                    prompts_list.append(
                        {
                            "uuid": prompt.uuid,
                            "text": prompt.text,
                            "start_frame": prompt.start_frame,
                            "end_frame": prompt.end_frame,
                            "color": prompt.color,
                        }
                    )
                export_data["prompts"] = prompts_list
                print(f"[Export] Exporting {len(prompts_list)} text prompts from timeline")
            else:
                # Fallback to single prompt from GUI if timeline is not available
                if session.gui_elements:
                    export_data["prompts"] = [
                        {
                            "text": session.gui_elements.gui_prompt_text.value,
                            "start_frame": 0,
                            "end_frame": session.max_frame_idx,
                            "color": None,
                        }
                    ]

            # Export constraints
            constraints_data = {}

            # Export 2D Root constraints
            root_constraint = session.constraints.get("2D Root")
            if root_constraint and len(root_constraint.keyframes) > 0:
                root_keyframes = {}
                for frame_idx, root_pos in root_constraint.keyframes.items():
                    # Handle both numpy arrays and torch tensors
                    if isinstance(root_pos, torch.Tensor):
                        root_pos_np = root_pos.cpu().numpy()
                    else:
                        root_pos_np = root_pos

                    root_data = {
                        "position": root_pos_np,
                    }
                    # Add heading if it exists
                    if frame_idx in root_constraint.root_headings:
                        root_data["heading"] = root_constraint.root_headings[frame_idx]
                    root_keyframes[frame_idx] = root_data  # Use int key instead of str

                constraints_data["2D Root"] = {
                    "keyframes": root_keyframes,
                    "dense_path": root_constraint.dense_path,
                    "smooth_path": root_constraint.smooth_path,
                }

            # Export Full-Body constraints
            fb_constraint = session.constraints.get("Full-Body")
            if fb_constraint and len(fb_constraint.keyframes) > 0:
                fb_keyframes = {}
                for frame_idx, keyframe_data in fb_constraint.keyframes.items():
                    # Handle both numpy arrays and torch tensors
                    joints_pos = keyframe_data["joints_pos"]
                    joints_rot = keyframe_data["joints_rot"]
                    if isinstance(joints_pos, torch.Tensor):
                        joints_pos = joints_pos.cpu().numpy()
                    if isinstance(joints_rot, torch.Tensor):
                        joints_rot = joints_rot.cpu().numpy()

                    fb_keyframes[frame_idx] = {  # Use int key instead of str
                        "joints_pos": joints_pos,
                        "joints_rot": joints_rot,
                    }

                constraints_data["Full-Body"] = {
                    "keyframes": fb_keyframes,
                }

            # Export End-Effector constraints
            ee_constraint = session.constraints.get("End-Effectors")
            if ee_constraint and len(ee_constraint.keyframes) > 0:
                ee_keyframes = {}
                for frame_idx, keyframe_data in ee_constraint.keyframes.items():
                    # Handle both numpy arrays and torch tensors
                    joints_pos = keyframe_data["joints_pos"]
                    joints_rot = keyframe_data["joints_rot"]
                    if isinstance(joints_pos, torch.Tensor):
                        joints_pos = joints_pos.cpu().numpy()
                    if isinstance(joints_rot, torch.Tensor):
                        joints_rot = joints_rot.cpu().numpy()

                    ee_keyframes[frame_idx] = {  # Use int key instead of str
                        "joints_pos": joints_pos,
                        "joints_rot": joints_rot,
                        "joint_names": keyframe_data["joint_names"],
                        "end_effector_type": keyframe_data["end_effector_type"],
                    }

                constraints_data["End-Effectors"] = {
                    "keyframes": ee_keyframes,
                }

            export_data["constraints"] = constraints_data

            # Save to file using pickle
            os.makedirs(
                os.path.dirname(filepath) if os.path.dirname(filepath) else ".",
                exist_ok=True,
            )
            with open(filepath, "wb") as f:
                pickle.dump(export_data, f, protocol=pickle.HIGHEST_PROTOCOL)

            print(f"[Export] Saved session to {filepath}")
            print(f"[Export] Motion frames: {session.max_frame_idx + 1}")
            print(f"[Export] Root constraints: {len(root_keyframes) if 'root_keyframes' in locals() else 0}")
            print(f"[Export] Full-Body constraints: {len(fb_keyframes) if 'fb_keyframes' in locals() else 0}")
            print(f"[Export] EE constraints: {len(ee_keyframes) if 'ee_keyframes' in locals() else 0}")

            return True
        except Exception as e:
            print(f"[Export] Error exporting session: {e}")
            import traceback

            traceback.print_exc()
            return False

    def load_session(self, client_id: int, filepath: str):
        """Load generated motion, text prompts, and constraints from a pickle file."""
        if not self.client_active(client_id):
            return False
        session = self.client_sessions[client_id]
        client = session.client

        try:
            # Check if file exists
            if not os.path.exists(filepath):
                print(f"[Load] File not found: {filepath}")
                return False

            # Load data from pickle file
            with open(filepath, "rb") as f:
                import_data = pickle.load(f)

            print(f"[Load] Loading session from {filepath}")
            print(f"[Load] Version: {import_data.get('version', 'unknown')}")
            print(f"[Load] Timestamp: {import_data.get('timestamp', 'unknown')}")

            # Load motion data (directly from numpy arrays)
            if "motion" in import_data:
                motion_data = import_data["motion"]

                # Abort (before mutating any session state) if the session's
                # skeleton differs from the currently loaded model's skeleton.
                # Joint count is a reliable discriminator across supported
                # skeletons (27/30/34/77).
                cur_skel = getattr(getattr(session, "motion_rep", None), "skeleton", None)
                if cur_skel is not None:
                    cur_nj = getattr(cur_skel, "nbjoints", None)
                    saved = import_data.get("skeleton") or {}
                    loaded_nj = saved.get("nbjoints")
                    if loaded_nj is None and motion_data.get("joints_pos") is not None:
                        loaded_nj = motion_data["joints_pos"].shape[-2]
                    if cur_nj is not None and loaded_nj is not None and loaded_nj != cur_nj:
                        msg = (
                            f"Session skeleton ({saved.get('name') or '?'}, "
                            f"{loaded_nj} joints) does not match the current model "
                            f"skeleton ({getattr(cur_skel, 'name', '?')}, {cur_nj} "
                            "joints). Load aborted — load the matching model first."
                        )
                        print(f"[Load] {msg}")
                        try:
                            session.client.add_notification(
                                title="Skeleton mismatch",
                                body=msg,
                                color="red",
                                auto_close_seconds=6.0,
                            )
                        except Exception:
                            pass
                        return False

                session.joints_pos = torch.from_numpy(motion_data["joints_pos"]).to(
                    dtype=torch.float32, device=self.device
                )
                if motion_data["joints_rot"] is not None:
                    session.joints_rot = torch.from_numpy(motion_data["joints_rot"]).to(
                        dtype=torch.float32, device=self.device
                    )
                if motion_data["root_velocities"] is not None:
                    session.root_velocities = torch.from_numpy(motion_data["root_velocities"]).to(
                        dtype=torch.float32, device=self.device
                    )
                if motion_data.get("motion_tensor") is not None:
                    session.motion_tensor = torch.from_numpy(motion_data["motion_tensor"]).to(
                        dtype=torch.float32, device=self.device
                    )

                # Restore foot_contacts; reset to None when the session has none
                # so a stale, shorter buffer from a previous generation does not
                # cap playback (set_frame indexes foot_contacts[:, frame_idx]).
                fc = motion_data.get("foot_contacts")
                session.foot_contacts = (
                    torch.from_numpy(fc).to(dtype=torch.float32, device=self.device) if fc is not None else None
                )

                session.max_frame_idx = import_data["max_frame_idx"]
                print(f"[Load] Loaded motion with {session.max_frame_idx + 1} frames")

                # Update frame index input max value
                session.gui_elements.gui_frame_idx_input.max = session.max_frame_idx

                # Disable auto-replan when loading a session
                session.gui_elements.gui_enable_auto_replan_checkbox.value = False

            # Clear existing constraints
            for constraint in session.constraints.values():
                constraint.clear()

            # Load constraints
            if "constraints" in import_data:
                constraints_data = import_data["constraints"]

                # Load 2D Root constraints
                if "2D Root" in constraints_data:
                    root_data = constraints_data["2D Root"]
                    root_constraint = session.constraints["2D Root"]

                    # Sort keyframes by frame index to detect consecutive sequences
                    sorted_frames = sorted(root_data["keyframes"].keys())

                    # Group consecutive frames into intervals
                    intervals = []
                    isolated_frames = []

                    i = 0
                    while i < len(sorted_frames):
                        start_idx = sorted_frames[i]
                        end_idx = start_idx

                        # Find consecutive sequence
                        while i + 1 < len(sorted_frames) and sorted_frames[i + 1] == sorted_frames[i] + 1:
                            i += 1
                            end_idx = sorted_frames[i]

                        # If we have at least 2 consecutive frames, treat as interval
                        if end_idx - start_idx >= 1:
                            intervals.append((start_idx, end_idx))
                        else:
                            isolated_frames.append(start_idx)

                        i += 1

                    print(
                        f"[Load] Detected {len(intervals)} intervals and {len(isolated_frames)} isolated root keyframes"
                    )

                    # Add intervals
                    for start_idx, end_idx in intervals:
                        # Collect positions for this interval
                        num_frames = end_idx - start_idx + 1
                        root_positions = []

                        for frame_idx in range(start_idx, end_idx + 1):
                            keyframe_data = root_data["keyframes"][frame_idx]
                            root_pos = torch.from_numpy(keyframe_data["position"]).to(
                                dtype=torch.float32, device=self.device
                            )
                            root_positions.append(root_pos)

                        root_positions_tensor = torch.stack(root_positions)

                        root_constraint.add_interval(
                            interval_id=f"loaded_interval_{start_idx}_{end_idx}",
                            start_frame_idx=start_idx,
                            end_frame_idx=end_idx,
                            root_pos=root_positions_tensor,
                            add_annulus=False,
                        )
                        print(f"[Load] Added interval: frames {start_idx}-{end_idx} ({num_frames} frames)")

                    # Add isolated keyframes
                    for frame_idx in isolated_frames:
                        keyframe_data = root_data["keyframes"][frame_idx]
                        root_pos = torch.from_numpy(keyframe_data["position"]).to(
                            dtype=torch.float32, device=self.device
                        )
                        heading = keyframe_data.get("heading")

                        root_constraint.add_keyframe(
                            keyframe_id=f"loaded_{frame_idx}",
                            frame_idx=frame_idx,
                            root_pos=root_pos,
                            global_root_heading=heading,
                            exists_ok=True,
                            update_path=False,  # Don't update path until all keyframes are loaded
                        )

                    # Set path properties after all keyframes are loaded
                    # Set smooth_path first (doesn't create line segments)
                    smooth_path_value = root_data.get("smooth_path", True)
                    root_constraint.smooth_path = smooth_path_value
                    print(f"[Load] Root constraints: smooth_path={smooth_path_value}")

                    # Set dense_path last, as it creates line_segments and updates visualization
                    dense_path_value = root_data.get("dense_path", False)
                    print(f"[Load] Root constraints: dense_path={dense_path_value}")
                    if dense_path_value:
                        # This will create line_segments and call update_line_segments()
                        root_constraint.set_dense_path(True)
                        if root_constraint.line_segments is not None:
                            print(
                                f"[Load] Created dense path visualization with {len(root_constraint.keyframes)} keyframes, "
                                f"{root_constraint.line_segments.points.shape[0]} line segments"
                            )
                        else:
                            print(f"[Load] Warning: line_segments is None after set_dense_path(True)")

                    print(f"[Load] Loaded {len(root_data['keyframes'])} root constraints")

                # Load Full-Body constraints
                if "Full-Body" in constraints_data:
                    fb_data = constraints_data["Full-Body"]
                    fb_constraint = session.constraints["Full-Body"]

                    for frame_idx, keyframe_data in fb_data["keyframes"].items():
                        # frame_idx is already an int from pickle
                        joints_pos = torch.from_numpy(keyframe_data["joints_pos"]).to(
                            dtype=torch.float32, device=self.device
                        )
                        joints_rot = torch.from_numpy(keyframe_data["joints_rot"]).to(
                            dtype=torch.float32, device=self.device
                        )

                        fb_constraint.add_keyframe(
                            keyframe_id=f"loaded_{frame_idx}",
                            frame_idx=frame_idx,
                            joints_pos=joints_pos,
                            joints_rot=joints_rot,
                            viz_label=True,
                        )

                    print(f"[Load] Loaded {len(fb_data['keyframes'])} full-body constraints")

                # Load End-Effector constraints
                if "End-Effectors" in constraints_data:
                    ee_data = constraints_data["End-Effectors"]
                    ee_constraint = session.constraints["End-Effectors"]

                    for frame_idx, keyframe_data in ee_data["keyframes"].items():
                        # frame_idx is already an int from pickle
                        joints_pos = torch.from_numpy(keyframe_data["joints_pos"]).to(
                            dtype=torch.float32, device=self.device
                        )
                        joints_rot = torch.from_numpy(keyframe_data["joints_rot"]).to(
                            dtype=torch.float32, device=self.device
                        )
                        joint_names = keyframe_data["joint_names"]
                        end_effector_type = keyframe_data["end_effector_type"]

                        ee_constraint.add_keyframe(
                            keyframe_id=f"loaded_{frame_idx}",
                            frame_idx=frame_idx,
                            joints_pos=joints_pos,
                            joints_rot=joints_rot,
                            joint_names=joint_names,
                            end_effector_type=end_effector_type,
                            viz_label=True,
                        )

                    print(f"[Load] Loaded {len(ee_data['keyframes'])} end-effector constraints")

            # Update timeline with loaded prompts and constraints
            if session.timeline_data is not None and hasattr(client, "timeline"):
                # Clear existing timeline prompts
                self.clear_timeline_prompts(client_id)

                # Add loaded prompts to timeline
                if "prompts" in import_data:
                    prompt_uuid_list = []
                    for prompt_data in import_data["prompts"]:
                        try:
                            # check if start_frame is not larger than the end_frame
                            if prompt_data.get("start_frame", 0) > prompt_data.get("end_frame", INFINITE_FRAME_IDX):
                                print(
                                    f"[Load] Warning: Start frame is larger than end frame for prompt: '{prompt_data['text']}'"
                                )
                                continue
                            prompt_uuid = client.timeline.add_prompt(
                                text=prompt_data["text"],
                                start_frame=prompt_data.get("start_frame", 0),
                                end_frame=prompt_data.get("end_frame", INFINITE_FRAME_IDX),
                                color=prompt_data.get("color", None),
                            )
                            prompt_uuid_list.append(prompt_uuid)
                            print(
                                f"[Load] Added prompt to timeline: '{prompt_data['text']}' (frames {prompt_data.get('start_frame', 0)}-{prompt_data.get('end_frame', INFINITE_FRAME_IDX)})"
                            )
                        except Exception as e:
                            print(f"[Load] Warning: Failed to add prompt to timeline: {e}")
                    session.timeline_data["prompt_uuid_list"] = prompt_uuid_list
                    session.timeline_data["prompt_counter"] = len(prompt_uuid_list)
                    print(f"[Load] Loaded {len(prompt_uuid_list)} prompts to timeline")
                # Fallback to old single prompt format
                elif "prompt" in import_data:
                    try:
                        prompt_uuid = client.timeline.add_prompt(
                            text=import_data["prompt"]["text"],
                            start_frame=0,
                            end_frame=INFINITE_FRAME_IDX,
                            color=self.get_prompt_color(0),
                        )
                        session.timeline_data["prompt_uuid_list"].append(prompt_uuid)
                        print(f"[Load] Added prompt to timeline: '{import_data['prompt']['text']}'")
                    except Exception as e:
                        print(f"[Load] Warning: Failed to add prompt to timeline: {e}")

                # Add constraint keyframes to timeline
                if "constraints" in import_data:
                    constraints_data = import_data["constraints"]

                    # Add 2D Root keyframes/intervals to timeline
                    if "2D Root" in constraints_data:
                        root_data = constraints_data["2D Root"]

                        # Re-detect intervals and isolated frames for timeline
                        sorted_frames = sorted(root_data["keyframes"].keys())
                        timeline_intervals = []
                        timeline_isolated = []

                        i = 0
                        while i < len(sorted_frames):
                            start_idx = sorted_frames[i]
                            end_idx = start_idx

                            while i + 1 < len(sorted_frames) and sorted_frames[i + 1] == sorted_frames[i] + 1:
                                i += 1
                                end_idx = sorted_frames[i]

                            if end_idx - start_idx >= 1:
                                timeline_intervals.append((start_idx, end_idx))
                            else:
                                timeline_isolated.append(start_idx)
                            i += 1

                        # Add intervals to timeline
                        for start_idx, end_idx in timeline_intervals:
                            self.add_interval_to_timeline(
                                client_id=client_id,
                                constraint_type="2D Root",
                                start_frame_idx=start_idx,
                                end_frame_idx=end_idx,
                                constraint_id=f"loaded_interval_{start_idx}_{end_idx}",
                            )

                        # Add isolated keyframes to timeline
                        for frame_idx in timeline_isolated:
                            self.add_keyframe_to_timeline(
                                client_id=client_id,
                                constraint_type="2D Root",
                                frame_idx=frame_idx,
                                constraint_id=f"loaded_{frame_idx}",
                            )

                        print(
                            f"[Load] Added {len(timeline_intervals)} root intervals and {len(timeline_isolated)} isolated keyframes to timeline"
                        )

                    # Add Full-Body keyframes to timeline
                    if "Full-Body" in constraints_data:
                        fb_data = constraints_data["Full-Body"]
                        for frame_idx in fb_data["keyframes"].keys():
                            self.add_keyframe_to_timeline(
                                client_id=client_id,
                                constraint_type="Full-Body",
                                frame_idx=frame_idx,
                                constraint_id=f"loaded_{frame_idx}",
                            )
                        print(f"[Load] Added {len(fb_data['keyframes'])} full-body keyframes to timeline")

                    # Add End-Effector keyframes to timeline
                    if "End-Effectors" in constraints_data:
                        ee_data = constraints_data["End-Effectors"]
                        for frame_idx, keyframe_data in ee_data["keyframes"].items():
                            # Add keyframe for each joint (skip Hips as it doesn't have a timeline track)
                            joint_names = keyframe_data["joint_names"]
                            for joint_name in joint_names:
                                if joint_name == "Hips":
                                    continue  # Hips is used for smoothed root but doesn't have a timeline track
                                self.add_keyframe_to_timeline(
                                    client_id=client_id,
                                    constraint_type="End-Effectors",
                                    frame_idx=frame_idx,
                                    constraint_id=f"loaded_{frame_idx}_{joint_name}",
                                    joint_name=joint_name,
                                )
                        print(f"[Load] Added {len(ee_data['keyframes'])} end-effector keyframes to timeline")

            # Update display
            self.set_frame(client_id, 0)

            # Send notification
            client.add_notification(
                title="Session Loaded",
                body=f"Loaded {session.max_frame_idx + 1} frames from {os.path.basename(filepath)}",
                auto_close_seconds=3.0,
            )

            return True
        except Exception as e:
            print(f"[Load] Error loading session: {e}")
            import traceback

            traceback.print_exc()
            client.add_notification(
                title="Load Failed",
                body=f"Error: {str(e)}",
                auto_close_seconds=5.0,
            )
            return False

    def load_mesh(self, client_id: int, filepath: str, transform_type: str):
        """Load a 3D mesh file (.ply or .obj) and apply transformation."""
        if not self.client_active(client_id):
            return
        session = self.client_sessions[client_id]
        client = session.client

        import trimesh

        try:
            # Check if file exists
            if not os.path.exists(filepath):
                print(f"File not found: {filepath}")
                return

            # Load the mesh using trimesh
            mesh = trimesh.load(filepath)

            # Apply transformation if needed
            if transform_type == "Z-up to Y-up":
                # Rotation matrix to convert Z-up to Y-up
                # This rotates -90 degrees around X-axis
                rotation_matrix = np.array([[1, 0, 0, 0], [0, 0, 1, 0], [0, -1, 0, 0], [0, 0, 0, 1]])
                mesh.apply_transform(rotation_matrix)
                print("Applied Z-up to Y-up transformation")
            else:
                print("No transformation applied")

            # Add mesh to the scene
            mesh_name = f"/loaded_mesh_{client_id}"
            mesh_handle = client.scene.add_mesh_trimesh(
                name=mesh_name,
                mesh=mesh,
            )

            # Store the mesh handle and reset translation sliders
            session.loaded_scene_mesh_handle = mesh_handle
            session.gui_elements.gui_scene_translation_x.value = 0.0
            session.gui_elements.gui_scene_translation_y.value = 0.0
            session.gui_elements.gui_scene_translation_z.value = 0.0

            print(f"Loaded mesh from {filepath} with {len(mesh.vertices)} vertices and {len(mesh.faces)} faces")

        except ImportError:
            print("trimesh library not installed. Install with: pip install trimesh")
        except Exception as e:
            print(f"Error loading mesh: {e}")
