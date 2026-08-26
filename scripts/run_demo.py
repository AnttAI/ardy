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
        newton_use_websocket: bool = False,
        newton_websocket_url: str = "ws://127.0.0.1:8765",
    ):
        self.device = "cuda:0" if torch.cuda.is_available() else "cpu"
        print(f"Using device: {self.device}")
        self.newton_viewer_backend = "rtx"
        self.newton_background_usd = None
        self.newton_camera_preset = "saved_origin_back"
        self.newton_rtx_environment = "studio"
        self.newton_pythonpath = None
        self.newton_viewer_python = None
        self.newton_use_websocket = bool(newton_use_websocket)
        self.newton_websocket_url = newton_websocket_url
        print(
            "[ARDY] Newton websocket sender: "
            f"{'on' if self.newton_use_websocket else 'off'} "
            f"({self.newton_websocket_url})"
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
        "--newton-use-websocket",
        action="store_true",
        help="Stream live ARDY frames to an independently launched Newton viewer websocket server.",
    )
    parser.add_argument(
        "--newton-websocket-url",
        default=None,
        help="Independent Newton viewer websocket URL, e.g. ws://127.0.0.1:8765.",
    )
    args = parser.parse_args()

    if args.newton_websocket_url:
        os.environ["ARDY_NEWTON_WEBSOCKET_URL"] = args.newton_websocket_url
    if args.newton_use_websocket:
        os.environ["ARDY_NEWTON_USE_WEBSOCKET"] = "1"

    demo = InteractiveTimelineDemo(
        compile_model=not args.no_compile,
        cached_text_only=args.cached_text_only,
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
