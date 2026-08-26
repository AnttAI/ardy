# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""Interactive demo entry point.

The implementation is split across the ``interactive_demo`` package; this module assembles the
mixins into ``InteractiveTimelineDemo`` and exposes the Hydra ``main`` entry point.
"""

import argparse
import os

from interactive_demo.camera import CameraMixin
from interactive_demo.characters import CharactersMixin
from interactive_demo.client import ClientMixin
from interactive_demo.common import *  # noqa: F401,F403
from interactive_demo.constraints import ConstraintsMixin
from interactive_demo.embedding_cache import CachedTextEncoder
from interactive_demo.gen_constraints import GenConstraintsMixin
from interactive_demo.generation import GenerationMixin
from interactive_demo.hardware import T3HardwareMixin
from interactive_demo.gui import (
    GuiGenerateMixin,
    GuiIOMixin,
    GuiMixin,
    GuiModelMixin,
    GuiPlaybackMixin,
    GuiTextMixin,
    GuiVisualizeMixin,
)
from interactive_demo.loading import ModelLoadingMixin
from interactive_demo.motion_io import MotionIOMixin
from interactive_demo.playback import PlaybackMixin
from interactive_demo.session_io import SessionIOMixin


class InteractiveTimelineDemo(
    ModelLoadingMixin,
    MotionIOMixin,
    ClientMixin,
    CharactersMixin,
    ConstraintsMixin,
    SessionIOMixin,
    GenerationMixin,
    GenConstraintsMixin,
    T3HardwareMixin,
    CameraMixin,
    GuiMixin,
    GuiPlaybackMixin,
    GuiTextMixin,
    GuiGenerateMixin,
    GuiVisualizeMixin,
    GuiModelMixin,
    GuiIOMixin,
    PlaybackMixin,
):
    def __init__(
        self,
        compile_model: bool = True,
        cached_text_only: bool = True,
        newton_viewer_backend: str = "gl",
        newton_background_usd: str | None = None,
        newton_camera_preset: str = "saved_origin_back",
        newton_rtx_environment: str = "studio",
        newton_pythonpath: str | None = None,
        newton_viewer_python: str | None = None,
        newton_use_websocket: bool = False,
        newton_websocket_url: str = "ws://127.0.0.1:8765",
    ):
        self.device = "cuda:0" if torch.cuda.is_available() else "cpu"
        print(f"Using device: {self.device}")
        self.newton_viewer_backend = newton_viewer_backend
        self.newton_background_usd = newton_background_usd
        self.newton_camera_preset = newton_camera_preset
        self.newton_rtx_environment = newton_rtx_environment
        self.newton_pythonpath = newton_pythonpath
        self.newton_viewer_python = newton_viewer_python
        self.newton_use_websocket = bool(newton_use_websocket)
        self.newton_websocket_url = newton_websocket_url
        print(
            "[ARDY] Native Newton viewer config: "
            f"viewer={self.newton_viewer_backend}, "
            f"background_usd={self.newton_background_usd or 'none'}, "
            f"camera={self.newton_camera_preset}, "
            f"rtx_environment={self.newton_rtx_environment}, "
            f"websocket={'on' if self.newton_use_websocket else 'off'}"
        )

        # Built once and reused across all model loads (core / g1 / soma).
        # Wrapped in a disk-backed cache so repeated/preset prompts skip
        # re-encoding, both within a session and across demo restarts.
        embedding_cache_dir = os.path.join(REPO_ROOT, ".cache", "text_embeddings")
        if cached_text_only:
            print(
                "Text encoder disabled: using cached prompt embeddings only "
                f"from {embedding_cache_dir}."
            )
            self.text_encoder = CachedTextEncoder(
                encoder=None,
                cache_dir=embedding_cache_dir,
                device=self.device,
                dtype=torch.float32,
            )
        else:
            print("Text encoder explicitly enabled; remote/local encoder initialization is allowed.")
            self.text_encoder = CachedTextEncoder(
                self._build_text_encoder(),
                cache_dir=embedding_cache_dir,
            )

        # Prewarm the cache for the default prompt and Prompt List presets
        # on a background thread; the server must not wait on this.
        threading.Thread(
            target=self.text_encoder.prewarm,
            args=([DEFAULT_PROMPT, RACK_ROUTE_WALKING_PROMPT, RACK_PICK_CALM_PROMPT, *PRESET_PROMPTS],),
            daemon=True,
        ).start()

        self.compile_model = compile_model

        # Dataset (will be loaded per-client if needed)
        self.max_keyframe_num = 6

        # Motion file cache directory
        self._motion_cache_dir = os.path.join(REPO_ROOT, "datasets", "bones-seed", "cache")
        os.makedirs(self._motion_cache_dir, exist_ok=True)
        self._metadata_df = None  # Lazy-loaded metadata DataFrame
        # Cache of motion-file paths per skeleton family, built once from the
        # metadata CSV so the "Random Motion File" button doesn't need to walk
        # the dataset on every click. Any failure here (missing CSV, missing
        # pandas, malformed file) is logged but does not block the demo —
        # other features keep working without the bones-seed dataset.
        self._bones_seed_paths_by_skeleton: dict[str, list[str]] = {}
        try:
            self._prime_bones_seed_paths()
        except Exception as e:
            print(
                f"[bones-seed] Failed to load motion-path index: {e!r}. "
                "Random Motion File button will be disabled; other features "
                "remain available."
            )

        # Per-client sessions
        self.client_sessions: dict[int, ClientSession] = {}

        # Server setup
        self.server = viser.ViserServer(
            host="0.0.0.0",
            port=2333,
            label="ARDY Interactive Demo",
            enable_camera_keyboard_controls=False,
            show_timeline_arrow_keys=False,
        )
        self.server.scene.world_axes.visible = False
        self.server.scene.set_up_direction("+y")

        # Register callbacks for session handling
        self.server.on_client_connect(self.on_client_connect)
        self.server.on_client_disconnect(self.on_client_disconnect)

        # Floor setup
        self.floor_len = 20.0

        # Color palette for text prompts (darker colors for good contrast with white text)
        self.prompt_colors = [
            (40, 100, 200),  # Deep blue
            (200, 80, 40),  # Burnt orange
            (40, 150, 60),  # Forest green
            (180, 40, 150),  # Deep magenta
            (150, 120, 40),  # Dark gold
            (60, 120, 180),  # Steel blue
            (180, 60, 80),  # Deep red
            (100, 60, 180),  # Deep purple
            (40, 140, 120),  # Teal
            (160, 60, 120),  # Maroon
        ]

    def get_prompt_color(self, prompt_index: int) -> tuple:
        """Get a color for a prompt based on its index."""
        return self.prompt_colors[prompt_index % len(self.prompt_colors)]


def main() -> None:
    parser = argparse.ArgumentParser(description="ARDY Interactive Demo")
    parser.add_argument(
        "--no-compile",
        action="store_true",
        help="Do not compile the model (initial backend is 'None' instead of 'ONNX-TRT (fp16)').",
    )
    text_encoder_group = parser.add_mutually_exclusive_group()
    text_encoder_group.add_argument(
        "--cached-text-only",
        dest="cached_text_only",
        action="store_true",
        default=True,
        help=(
            "Do not initialize or download a text encoder; serve prompt embeddings only from "
            ".cache/text_embeddings. This is the default."
        ),
    )
    text_encoder_group.add_argument(
        "--enable-text-encoder",
        dest="cached_text_only",
        action="store_false",
        help="Explicitly allow remote/local text-encoder initialization for uncached prompts.",
    )
    parser.add_argument(
        "--newton-viewer",
        choices=("gl", "rtx"),
        default=None,
        help="Native Newton retarget viewer backend used by the Visualize tab button.",
    )
    parser.add_argument(
        "--background-usd",
        default=None,
        help="USD/USDA background scene to reference into the native Newton RTX viewer.",
    )
    parser.add_argument(
        "--camera-preset",
        choices=(
            "default",
            "front",
            "back",
            "left",
            "right",
            "top",
            "lobby",
            "saved_diagonal",
            "saved_full_right",
            "saved_grass",
            "saved_straight_left",
            "saved_straight_left_back",
            "saved_front",
            "saved_full_lobby_diagonal",
            "saved_origin_back",
            "saved_top_left",
            "saved_origin_top",
        ),
        default=None,
        help="Initial camera preset for the native Newton viewer.",
    )
    parser.add_argument(
        "--newton-pythonpath",
        default=None,
        help="Extra PYTHONPATH entry for a local Newton checkout, e.g. /home/jony/Downloads/newton/repos/newton.",
    )
    parser.add_argument(
        "--newton-viewer-python",
        default=None,
        help="Python executable used only for the native Newton viewer process.",
    )
    parser.add_argument(
        "--newton-file-csv",
        default=None,
        help="T3 CSV path preloaded into the native Newton/RTX File Playback panel.",
    )
    parser.add_argument(
        "--newton-file-bvh",
        default=None,
        help="SOMA BVH path preloaded into the native Newton/RTX File Playback panel.",
    )
    parser.add_argument(
        "--newton-use-websocket",
        action="store_true",
        help="Stream live ARDY frames to an independently launched Newton viewer websocket server.",
    )
    parser.add_argument(
        "--newton-websocket-url",
        default=None,
        help="Independent Newton viewer websocket URL, e.g. ws://127.0.0.1:8765.",
    )
    parser.add_argument(
        "--newton-rtx-environment",
        choices=("default", "studio", "none"),
        default=None,
        help="Lighting environment passed to Newton ViewerRTX.",
    )
    parser.add_argument(
        "--warp-cache-path",
        default=None,
        help="Warp kernel cache path for the native Newton viewer process.",
    )
    parser.add_argument(
        "--newton-pick-object",
        choices=("none", "cube"),
        default=None,
        help="Add a real Newton collision object to the native viewer for contact/pick testing.",
    )
    parser.add_argument(
        "--newton-pick-object-position",
        type=float,
        nargs=3,
        default=None,
        metavar=("X", "Y", "Z"),
        help="Initial pick object center position in Newton coordinates.",
    )
    parser.add_argument(
        "--newton-pick-object-size",
        type=float,
        default=None,
        help="Pick object cube side length in meters.",
    )
    parser.add_argument(
        "--newton-pick-object-push-mass-limit-kg",
        type=float,
        default=None,
        help="Maximum pick-object mass that streamed human/T3 actors can push in the Newton viewer.",
    )
    parser.add_argument(
        "--newton-record-video",
        action="store_true",
        help="Record the native Newton RTX viewer to MP4 while it is open.",
    )
    parser.add_argument(
        "--newton-record-output",
        default=None,
        help="MP4 output path for --newton-record-video.",
    )
    parser.add_argument(
        "--newton-record-fps",
        type=float,
        default=None,
        help="Video capture FPS for the native Newton RTX viewer.",
    )
    parser.add_argument(
        "--newton-record-seconds-per-view",
        type=float,
        default=None,
        help="Seconds to record before switching to the next camera view.",
    )
    parser.add_argument(
        "--newton-record-views",
        default=None,
        help="Comma-separated recording views. Default manual records the current RTX camera; saved_* names use captured poses.",
    )
    parser.add_argument(
        "--newton-playback-mode",
        choices=("realtime", "exact"),
        default=None,
        help="RTX/GL viewer playback mode: realtime keeps current speed and may skip stale frames; exact renders every ARDY frame.",
    )
    parser.add_argument(
        "--newton-viewer-width",
        type=int,
        default=None,
        help="Native Newton viewer window width in pixels.",
    )
    parser.add_argument(
        "--newton-viewer-height",
        type=int,
        default=None,
        help="Native Newton viewer window height in pixels.",
    )
    args = parser.parse_args()

    if args.newton_viewer:
        os.environ["ARDY_NEWTON_VIEWER"] = args.newton_viewer
    if args.background_usd:
        os.environ["ARDY_NEWTON_BACKGROUND_USD"] = args.background_usd
    if args.camera_preset:
        os.environ["ARDY_NEWTON_CAMERA_PRESET"] = args.camera_preset
    if args.newton_pythonpath:
        os.environ["ARDY_NEWTON_PYTHONPATH"] = args.newton_pythonpath
    if args.newton_viewer_python:
        os.environ["ARDY_NEWTON_VIEWER_PYTHON"] = args.newton_viewer_python
    if args.newton_file_csv:
        os.environ["ARDY_NEWTON_FILE_CSV_PATH"] = args.newton_file_csv
    if args.newton_file_bvh:
        os.environ["ARDY_NEWTON_FILE_BVH_PATH"] = args.newton_file_bvh
    if args.newton_use_websocket:
        os.environ["ARDY_NEWTON_USE_WEBSOCKET"] = "1"
    if args.newton_websocket_url:
        os.environ["ARDY_NEWTON_WEBSOCKET_URL"] = args.newton_websocket_url
    if args.newton_rtx_environment:
        os.environ["ARDY_NEWTON_RTX_ENVIRONMENT"] = args.newton_rtx_environment
    if args.warp_cache_path:
        os.environ["WARP_CACHE_PATH"] = args.warp_cache_path
    if args.newton_pick_object:
        os.environ["ARDY_NEWTON_PICK_OBJECT"] = args.newton_pick_object
    if args.newton_pick_object_position:
        os.environ["ARDY_NEWTON_PICK_OBJECT_POSITION"] = " ".join(str(v) for v in args.newton_pick_object_position)
    if args.newton_pick_object_size is not None:
        os.environ["ARDY_NEWTON_PICK_OBJECT_SIZE"] = str(args.newton_pick_object_size)
    if args.newton_pick_object_push_mass_limit_kg is not None:
        os.environ["ARDY_NEWTON_PICK_OBJECT_PUSH_MASS_LIMIT_KG"] = str(args.newton_pick_object_push_mass_limit_kg)
    if args.newton_record_video:
        os.environ["ARDY_NEWTON_RECORD_VIDEO"] = "1"
    if args.newton_record_output:
        os.environ["ARDY_NEWTON_RECORD_OUTPUT"] = args.newton_record_output
    if args.newton_record_fps is not None:
        os.environ["ARDY_NEWTON_RECORD_FPS"] = str(args.newton_record_fps)
    if args.newton_record_seconds_per_view is not None:
        os.environ["ARDY_NEWTON_RECORD_SECONDS_PER_VIEW"] = str(args.newton_record_seconds_per_view)
    if args.newton_record_views:
        os.environ["ARDY_NEWTON_RECORD_VIEWS"] = args.newton_record_views
    if args.newton_playback_mode:
        os.environ["ARDY_NEWTON_PLAYBACK_MODE"] = args.newton_playback_mode
    if args.newton_viewer_width is not None:
        os.environ["ARDY_NEWTON_VIEWER_WIDTH"] = str(args.newton_viewer_width)
    if args.newton_viewer_height is not None:
        os.environ["ARDY_NEWTON_VIEWER_HEIGHT"] = str(args.newton_viewer_height)

    demo = InteractiveTimelineDemo(
        compile_model=not args.no_compile,
        cached_text_only=args.cached_text_only,
        newton_viewer_backend=(args.newton_viewer or os.environ.get("ARDY_NEWTON_VIEWER", "gl")).lower(),
        newton_background_usd=args.background_usd or os.environ.get("ARDY_NEWTON_BACKGROUND_USD"),
        newton_camera_preset=(
            args.camera_preset or os.environ.get("ARDY_NEWTON_CAMERA_PRESET", "saved_origin_back")
        ).lower(),
        newton_rtx_environment=(
            args.newton_rtx_environment or os.environ.get("ARDY_NEWTON_RTX_ENVIRONMENT", "studio")
        ).lower(),
        newton_pythonpath=args.newton_pythonpath or os.environ.get("ARDY_NEWTON_PYTHONPATH"),
        newton_viewer_python=args.newton_viewer_python or os.environ.get("ARDY_NEWTON_VIEWER_PYTHON"),
        newton_use_websocket=bool(
            args.newton_use_websocket
            or os.environ.get("ARDY_NEWTON_USE_WEBSOCKET", "").strip().lower() in {"1", "true", "yes", "on"}
        ),
        newton_websocket_url=args.newton_websocket_url
        or os.environ.get("ARDY_NEWTON_WEBSOCKET_URL", "ws://127.0.0.1:8765"),
    )
    demo.run()


if __name__ == "__main__":
    main()
