# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

import gc
import glob
import hashlib
import json
import os
import pickle
import random
import threading
import time
from collections import defaultdict
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

import hydra
import numpy as np
import torch
import viser
from einops import repeat
from hydra.utils import instantiate
from omegaconf import DictConfig, OmegaConf

from ardy.constraints import (
    EndEffectorConstraintSet,
    TYPE_TO_CLASS,
    FullBodyConstraintSet,
    Root2DConstraintSet,
)
from ardy.model.load_model import load_model, load_text_encoder
from ardy.model.registry import (
    DEFAULT_HORIZON,
    MODELS,
    MODELS_BY_SKELETON,
    hf_repo_id,
    parse_model_name,
    resolve_model_name,
)
from ardy.motion_rep import ArdyMotionRep
from ardy.postprocess import post_process_motion
from ardy.retail_rack_route import (
    RACK_MAP_POSITIONS,
    RACK_PICK_CALM_PROMPT,
    RACK_ROUTE_WALKING_PROMPT,
    RACK_WIDTH_M,
    plan_rack_pick,
    plan_rack_return_route,
    plan_rack_to_rack_route,
    plan_rack_route,
    rack_outward_normal,
    rack_pick_auto_frame_count,
    rack_return_auto_frame_count,
    rack_to_rack_auto_frame_count,
    rack_route_auto_frame_count,
)
from ardy.skeleton import (
    CoreSkeleton27,
    G1Skeleton34,
    SkeletonBase,
    SOMASkeleton30,
    SOMASkeleton77,
    batch_rigid_transform,
)
from ardy.skeleton.transforms import global_rots_to_local_rots
from ardy.tools import seed_everything
from ardy.viz.viser_utils import (
    Character,
    EEJointsKeyframeSet,
    FullbodyKeyframeSet,
    RootKeyframe2DSet,
    VelocityArrowMesh,
)

# Repo root, resolved from this file's location (scripts/interactive_demo/common.py).
# Use this for filesystem paths to repo assets so they stay correct regardless of
# where the importing module lives in the package tree.
REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

# When CHECKPOINTS_DIR is set, models are discovered/loaded from that local
# folder; when unset, the released models are listed and pulled from Hugging Face.
CHECKPOINTS_DIR = os.environ.get("CHECKPOINTS_DIR")
DEFAULT_MODEL_DIR = "ARDY-Core-RP-20FPS-Horizon40"


def ground_motion_to_floor(
    skeleton: SkeletonBase,
    joints_pos: torch.Tensor,
    root_positions: torch.Tensor | None = None,
    *,
    floor_y: float = 0.0,
) -> tuple[torch.Tensor, torch.Tensor | None]:
    """Shift motion vertically so the lowest foot joint stays on the floor."""
    foot_indices = list(getattr(skeleton, "foot_joint_idx", []))
    if not foot_indices:
        return joints_pos, root_positions

    foot_y = joints_pos[..., foot_indices, 1]
    lowest_foot_y = foot_y.amin(dim=-1)
    y_offset = float(floor_y) - lowest_foot_y

    grounded_joints = joints_pos.clone()
    grounded_joints[..., 1] = grounded_joints[..., 1] + y_offset[..., None]

    grounded_root = None
    if root_positions is not None:
        grounded_root = root_positions.clone()
        grounded_root[..., 1] = grounded_root[..., 1] + y_offset

    return grounded_joints, grounded_root


def scan_checkpoint_dirs(base_dir: str = "checkpoints") -> list[str]:
    """Return sorted list of names in base_dir whose folders contain model weights directly — either
    training ``.ckpt`` files or exported ``.safetensors`` files."""
    if not os.path.isdir(base_dir):
        return []
    return sorted(
        name
        for name in os.listdir(base_dir)
        if os.path.isdir(os.path.join(base_dir, name))
        and (
            glob.glob(os.path.join(base_dir, name, "*.ckpt"))
            or glob.glob(os.path.join(base_dir, name, "*.safetensors"))
        )
    )


def available_models() -> list[str]:
    """Model choices for the dropdown.

    If CHECKPOINTS_DIR is set, discover model folders inside it. Otherwise, list the released models
    from the registry (downloaded from Hugging Face on load).
    """
    if CHECKPOINTS_DIR:
        return scan_checkpoint_dirs(CHECKPOINTS_DIR)
    return list(MODELS.values())


def models_by_skeleton() -> dict[str, dict[str, str]]:
    """Group the available models for the two-step picker in the Model tab:
    ``skeleton -> {horizon label -> model name}``.

    Skeleton keys are ``"core"``/``"g1"``/``"soma"`` with horizon labels like
    ``"40"``, sorted numerically. Local folders that don't follow the released
    naming scheme are grouped under ``"other"``, with the folder name itself as
    the label.
    """
    grouped: dict[str, dict[str, str]] = {}
    for name in available_models():
        parsed = parse_model_name(name)
        if parsed:
            skeleton, horizon = parsed
            grouped.setdefault(skeleton, {})[horizon] = name
        else:
            grouped.setdefault("other", {})[name] = name
    if not grouped:
        # Nothing found (e.g. empty CHECKPOINTS_DIR) — offer the released models.
        for skeleton, by_horizon in MODELS_BY_SKELETON.items():
            for horizon, folder in by_horizon.items():
                grouped.setdefault(skeleton, {})[horizon] = folder
    return {
        skeleton: {
            str(label): options[label]
            for label in (sorted(options) if skeleton == "other" else sorted(options, reverse=True))
        }
        for skeleton, options in grouped.items()
    }


def skeleton_supports_constraint_sampling(skeleton) -> bool:
    """Whether ``skeleton`` has a companion bones-seed dataset for constraint sampling / random
    motion file loading.

    The Core skeleton does not.
    """
    return not isinstance(skeleton, CoreSkeleton27)


def resolve_model_dir(model_name: str) -> str:
    """Local folder for a model: ``CHECKPOINTS_DIR/<name>`` when set, otherwise the (already
    downloaded, cached) Hugging Face snapshot dir."""
    full_name = resolve_model_name(model_name, checkpoints_dir=CHECKPOINTS_DIR)
    if CHECKPOINTS_DIR:
        return os.path.join(CHECKPOINTS_DIR, full_name)
    from huggingface_hub import snapshot_download

    return snapshot_download(repo_id=hf_repo_id(full_name), local_files_only=True)


def is_g1_skeleton(skeleton) -> bool:
    """True when ``skeleton`` belongs to the G1 robot family (34 joints)."""
    return isinstance(skeleton, G1Skeleton34) or (getattr(skeleton, "nbjoints", None) == 34)


DEFAULT_REPLAN_TRIGGER_THRESH = 4
DEFAULT_REPLAN_BUFFER_SIZE = 1
DEFAULT_HISTORY_CROP_LENGTH = 4

# Default text prompt (initial GUI value) and the Prompt List preset buttons
# (gui/text.py). Also used by run_demo.py to prewarm the text-embedding
# cache at startup.
DEFAULT_PROMPT = "A person is standing."
PRESET_PROMPTS = [
    "A person is walking.",
    "A person jumps backwards.",
    "A person side steps to the right.",
    "A person is walking backwards.",
    "A person is kicking with their right leg.",
    "A person is standing.",
    "A young lady walks forward elegantly.",
    "A person bows down and then stands upright.",
    "A ballet dancer, performs a forward, turn joining feet, in a repeating loop",
    "a performer gives high bow, with arms to the side, right leg crossed behind the left",
]

LIGHT_THEME = dict(
    floor=(220, 220, 220),
    grid=(180, 180, 180),
)

DARK_THEME = dict(
    floor=(40, 40, 40),
    grid=(90, 90, 90),
)

INFINITE_FRAME_IDX = 99999
TIMELINE_WINDOW_BEFORE = 20
TIMELINE_WINDOW_AFTER = 200

ARROW_KEYS = {"ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"}

TARGET_VELOCITY_UPDATE_INTERVAL = 4
TARGET_VELOCITY_GOAL_FRAME_INTERVAL = 10
VELOCITY_TRANSITION_DURATION = 2.0  # seconds - duration for velocity to smoothly transition to target

# VelocityArrowMesh scales arrow length as magnitude / 4.0, so the "velocity"
# fed to it for the start-direction marker is scaled up to reach this length.
START_DIRECTION_MARKER_LENGTH = 0.5
KIMODO_PICK_MOTION_FILE_PATH = "/home/jony/Downloads/soma-retargeter/assets/motions/bvh/generated/kimodo_0eaccddc7f.bvh"
KIMODO_PICK_CONSTRAINT_FRAMES = "0,20,38,52,64,84,end"


@dataclass
class GuiElements:
    """GUI elements for the demo."""

    gui_skeleton_dropdown: viser.GuiDropdownHandle[str]
    gui_horizon_dropdown: viser.GuiDropdownHandle[str]
    gui_chosen_model_md: viser.GuiInputHandle
    gui_load_model_button: viser.GuiInputHandle
    gui_skeleton_name_text: viser.GuiInputHandle[str]
    gui_model_fps: viser.GuiInputHandle[int]
    gui_frame_idx_input: viser.GuiInputHandle[int]
    gui_play_pause_button: viser.GuiInputHandle
    gui_next_frame_button: viser.GuiInputHandle
    gui_prev_frame_button: viser.GuiInputHandle
    gui_actual_fps: viser.GuiInputHandle[float]
    gui_current_time: viser.GuiInputHandle[float]
    gui_compile_mode: viser.GuiInputHandle[str]
    gui_text_encoder_mode: viser.GuiInputHandle[str]
    gui_playback_speed: viser.GuiInputHandle[float]
    gui_diffusion_steps_slider: viser.GuiInputHandle[int]
    gui_num_samples: viser.GuiInputHandle[int]
    gui_history_crop_length: viser.GuiInputHandle[int]
    gui_future_crop_length: viser.GuiInputHandle[int]
    gui_replan_buffer_size: viser.GuiInputHandle[int]
    gui_replan_trigger_thresh: viser.GuiInputHandle[int]
    gui_realtime_mode_checkbox: viser.GuiInputHandle[bool]
    gui_enable_auto_replan_checkbox: viser.GuiInputHandle[bool]
    gui_cfg_text_weight: viser.GuiInputHandle[float]
    gui_cfg_constraint_weight: viser.GuiInputHandle[float]
    gui_prompt_text: viser.GuiInputHandle[str]
    gui_active_prompt_label: viser.GuiInputHandle
    gui_seed: viser.GuiInputHandle[int]
    gui_use_target_velocity_checkbox: viser.GuiInputHandle[bool]
    gui_target_root_velocity: viser.GuiInputHandle  # 2D vector (x, z) for target root velocity
    gui_use_target_heading_checkbox: viser.GuiInputHandle[bool]
    gui_restart_button: viser.GuiInputHandle
    gui_load_seq_button: viser.GuiInputHandle
    gui_random_motion_button: viser.GuiInputHandle
    gui_source_rack_route_dropdown: viser.GuiInputHandle[str]
    gui_rack_route_dropdown: viser.GuiInputHandle[str]
    gui_apply_rack_route_button: viser.GuiInputHandle
    gui_return_rack_route_button: viser.GuiInputHandle
    gui_rack_to_rack_route_button: viser.GuiInputHandle
    gui_rack_pick_shelf_dropdown: viser.GuiInputHandle[str]
    gui_rack_pick_object_dropdown: viser.GuiInputHandle[str]
    gui_rack_pick_button: viser.GuiInputHandle
    gui_kimodo_pick_status_md: viser.GuiInputHandle
    gui_kimodo_pick_command_text: viser.GuiInputHandle[str]
    gui_kimodo_pick_apply_command_button: viser.GuiInputHandle
    gui_kimodo_pick_configure_button: viser.GuiInputHandle
    gui_kimodo_pick_run_button: viser.GuiInputHandle
    gui_kimodo_pick_enabled_checkbox: viser.GuiInputHandle[bool]
    gui_kimodo_pick_spacebar_checkbox: viser.GuiInputHandle[bool]
    gui_kimodo_pick_go_rack_button: viser.GuiInputHandle
    gui_kimodo_pick_confirm_button: viser.GuiInputHandle
    gui_kimodo_pick_sample_button: viser.GuiInputHandle
    gui_waypoint_mode_checkbox: viser.GuiInputHandle[bool]
    gui_dense_root_checkbox: viser.GuiInputHandle[bool]
    gui_one_meter_root_distance_cm: viser.GuiInputHandle[float]
    gui_one_meter_root_duration_s: viser.GuiInputHandle[float]
    gui_one_meter_root_button: viser.GuiInputHandle
    gui_one_meter_root_back_button: viser.GuiInputHandle
    gui_root_turn_degrees: viser.GuiInputHandle[float]
    gui_root_turn_duration_s: viser.GuiInputHandle[float]
    gui_root_turn_left_button: viser.GuiInputHandle
    gui_root_turn_right_button: viser.GuiInputHandle
    gui_root_file_path: viser.GuiInputHandle[str]
    gui_load_root_button: viser.GuiInputHandle
    gui_save_root_button: viser.GuiInputHandle
    gui_soma_bvh_file_path: viser.GuiInputHandle[str]
    gui_export_soma_bvh_button: viser.GuiInputHandle
    gui_scene_file_path: viser.GuiInputHandle[str]
    gui_mesh_transform_dropdown: viser.GuiInputHandle[str]
    gui_load_mesh_button: viser.GuiInputHandle
    gui_scene_translation_x: viser.GuiInputHandle[float]
    gui_scene_translation_y: viser.GuiInputHandle[float]
    gui_scene_translation_z: viser.GuiInputHandle[float]
    gui_waypoint_interval: viser.GuiInputHandle[int]
    gui_max_keyframe_num: viser.GuiInputHandle[int]
    gui_constraint_frame_indices: viser.GuiInputHandle[str]
    gui_motion_file_path: viser.GuiInputHandle[str]
    gui_constraint_fullbody_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_hands_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_forearm_orientation_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_hand_only_motion_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_feet_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_hands_feet_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_2d_waypoints_checkbox: viser.GuiInputHandle[bool]
    gui_constraint_2d_trajectory_checkbox: viser.GuiInputHandle[bool]
    gui_continue_from_current_checkbox: viser.GuiInputHandle[bool]
    gui_viz_skeleton_checkbox: viser.GuiInputHandle[bool]
    gui_viz_foot_contacts_checkbox: viser.GuiInputHandle[bool]
    gui_viz_ref_motion_checkbox: viser.GuiInputHandle[bool]
    gui_viz_soma_mesh_checkbox: viser.GuiInputHandle[bool]
    gui_viz_soma_mesh_offset: viser.GuiInputHandle[tuple[float, float, float]]
    gui_viz_t3_robot_checkbox: viser.GuiInputHandle[bool]
    gui_viz_t3_soma_retarget_checkbox: viser.GuiInputHandle[bool]
    gui_viz_t3_retarget_now_button: viser.GuiInputHandle
    gui_viz_t3_retarget_status: viser.GuiInputHandle[str]
    gui_viz_t3_packet_size: viser.GuiInputHandle[int]
    gui_viz_t3_offset: viser.GuiInputHandle[tuple[float, float, float]]
    gui_viz_t3_yaw_offset: viser.GuiInputHandle[float]
    gui_t3_hardware_enable_checkbox: viser.GuiInputHandle[bool]
    gui_t3_hardware_send_checkbox: viser.GuiInputHandle[bool]
    gui_t3_hardware_rpm_scale: viser.GuiInputHandle[float]
    gui_t3_hardware_max_abs_rpm: viser.GuiInputHandle[float]
    gui_t3_hardware_linear_scale: viser.GuiInputHandle[float]
    gui_t3_hardware_backward_scale: viser.GuiInputHandle[float]
    gui_t3_hardware_yaw_scale: viser.GuiInputHandle[float]
    gui_t3_hardware_rack_yaw_scale: viser.GuiInputHandle[float]
    gui_t3_hardware_base_lead_frames: viser.GuiInputHandle[int]
    gui_t3_hardware_lift_step_frames: viser.GuiInputHandle[int]
    gui_t3_hardware_base_mapping: viser.GuiInputHandle[str]
    gui_t3_hardware_csv_path: viser.GuiInputHandle[str]
    gui_t3_hardware_csv_segment: viser.GuiInputHandle[int]
    gui_t3_hardware_csv_fps: viser.GuiInputHandle[float]
    gui_t3_hardware_csv_robot_button: viser.GuiInputHandle
    gui_t3_hardware_csv_full_button: viser.GuiInputHandle
    gui_t3_hardware_payload_md: viser.GuiInputHandle
    gui_t3_hardware_base_button: viser.GuiInputHandle
    gui_t3_hardware_robot_button: viser.GuiInputHandle
    gui_t3_hardware_both_button: viser.GuiInputHandle
    gui_t3_hardware_lift_button: viser.GuiInputHandle
    gui_t3_hardware_base_lift_button: viser.GuiInputHandle
    gui_t3_hardware_robot_lift_button: viser.GuiInputHandle
    gui_t3_hardware_full_button: viser.GuiInputHandle
    gui_t3_hardware_stop_base_button: viser.GuiInputHandle
    gui_t3_hardware_stop_robot_button: viser.GuiInputHandle
    gui_t3_hardware_stop_lift_button: viser.GuiInputHandle
    gui_t3_hardware_stop_both_button: viser.GuiInputHandle
    gui_t3_hardware_disconnect_button: viser.GuiInputHandle
    gui_viz_skinned_mesh_checkbox: viser.GuiInputHandle[bool]
    gui_viz_skinned_mesh_opacity_slider: viser.GuiInputHandle[float]
    gui_viz_hand_orientations_checkbox: viser.GuiInputHandle[bool]
    gui_viz_hide_distant_constraints_checkbox: viser.GuiInputHandle[bool]
    gui_show_timeline_checkbox: viser.GuiInputHandle[bool]
    gui_show_start_direction_checkbox: viser.GuiInputHandle[bool]
    gui_viz_auto_camera_checkbox: viser.GuiInputHandle[bool]
    gui_viz_camera_type_dropdown: viser.GuiInputHandle[str]
    gui_viz_camera_fov_slider: viser.GuiInputHandle[float]
    gui_viz_camera_position: viser.GuiInputHandle[tuple[float, float, float]]
    gui_viz_camera_look_at: viser.GuiInputHandle[tuple[float, float, float]]
    gui_viz_camera_up: viser.GuiInputHandle[tuple[float, float, float]]
    gui_dark_mode_checkbox: viser.GuiInputHandle[bool]
    gui_enable_postprocess_checkbox: viser.GuiInputHandle[bool]
    gui_postprocess_root_margin: viser.GuiInputHandle[float]
    gui_postprocess_contact_threshold: viser.GuiInputHandle[float]


@dataclass
class ClientSession:
    """Per-client session data."""

    client: viser.ClientHandle
    gui_elements: GuiElements

    # Model and motion representation (per-client)
    model: Optional[object] = None
    motion_rep: Optional[object] = None
    motion_rep_infer: Optional[object] = None
    model_fps: int = 30
    num_frames_per_token: int = 4
    gen_horizon_len: int = 20
    max_window_len: int = 300  # per-step window budget in frames; set on model load
    dataset: Optional[object] = None
    mesh_mode: str = "core_skin"  # Mesh visualization mode for character creation

    # Motion state
    motion_tensor: Optional[torch.Tensor] = None
    joints_pos: Optional[torch.Tensor] = None
    joints_rot: Optional[torch.Tensor] = None
    foot_contacts: Optional[torch.Tensor] = None
    root_velocities: Optional[torch.Tensor] = None  # [N, T, 3] root joint velocities (x, y, z)
    characters: dict = field(default_factory=dict)
    soma_debug_character: Optional[object] = None
    soma_debug_joints_pos: Optional[torch.Tensor] = None
    soma_debug_joints_rot: Optional[torch.Tensor] = None
    soma_debug_generation: int = -1
    soma_debug_skeleton: Optional[object] = None
    soma_live_mapper: Optional[object] = None
    t3_live_soma77_local_rot_mats: Optional[np.ndarray] = None
    t3_live_root_positions: Optional[np.ndarray] = None
    t3_live_last_row_frame_idx: int = -1
    t3_live_last_row: Optional[dict] = None
    t3_live_soma_solver: Optional[object] = None
    t3_live_solver_lock: threading.Lock = field(default_factory=threading.Lock)
    t3_live_solver_warm_thread: Optional[threading.Thread] = None
    target_velocity_arrow: Optional[object] = None  # VelocityArrowMesh for target velocity visualization
    t3_live_retargeter: Optional[object] = None
    t3_csv_player: Optional[object] = None
    t3_retarget_thread: Optional[threading.Thread] = None
    t3_retarget_lock: threading.Lock = field(default_factory=threading.Lock)
    t3_retarget_generation: int = 0
    t3_retarget_pending_after_current: bool = False
    t3_retarget_ready_generation: int = -1
    t3_csv_player_generation: int = -1
    t3_retarget_csv_start_frame: int = 0
    t3_retarget_csv_end_frame: int = -1
    t3_retarget_requested_end_frame: int = -1
    t3_retarget_pending_start_frame: Optional[int] = None
    t3_retarget_status: str = "idle"
    t3_retarget_csv_path: Optional[str] = None
    t3_retarget_packet_ranges: list[tuple[int, int]] = field(default_factory=list)
    t3_retarget_packet_end_frames: list[int] = field(default_factory=list)
    t3_stream_rows: list = field(default_factory=list)
    t3_stream_packet_size: int = 10
    t3_soma_worker_process: Optional[object] = None
    t3_soma_worker_lock: threading.Lock = field(default_factory=threading.Lock)
    t3_hardware_bridge: Optional[object] = None
    t3_hardware_stream_base: bool = False
    t3_hardware_stream_robot: bool = False
    t3_hardware_stream_lift: bool = False
    t3_hardware_last_lift_target_frame: int = -1
    t3_hardware_last_sent_frame: int = -1
    t3_hardware_log_path: Optional[str] = None
    t3_hardware_csv_log_path: Optional[str] = None
    t3_hardware_last_log_wall_time_s: Optional[float] = None
    t3_hardware_last_log_frame_idx: Optional[int] = None
    t3_hardware_clock_active: bool = False
    t3_hardware_clock_thread: Optional[threading.Thread] = None
    t3_hardware_stop_event: Optional[threading.Event] = None
    t3_hardware_lock: threading.Lock = field(default_factory=threading.Lock)
    t3_base_route_positions: Optional[np.ndarray] = None
    t3_base_route_headings: Optional[np.ndarray] = None

    # Initial body transform (for generation)
    init_global_translation: Optional[np.ndarray] = None  # [3] initial body translation, float32
    init_first_heading_angle: Optional[float] = None  # Initial heading angle in radians
    init_transform_gizmo: Optional[object] = None  # Transform control gizmo
    start_direction_marker: Optional[object] = None  # Blue VelocityArrowMesh showing initial position + facing

    # Playback state
    frame_idx: int = -1
    max_frame_idx: int = -1
    playing: bool = False
    play_once: bool = False
    playback_speed: float = 1.0
    realtime_mode: bool = True
    task_end_frame_idx: Optional[int] = None
    task_generation_pending: bool = False
    task_reached_reported: bool = False
    cur_time: float = -1.0
    playback_fps: int = 30

    # Camera state for smoothing
    camera_position: Optional[np.ndarray] = None
    camera_look_at: Optional[np.ndarray] = None
    camera_forward_direction: Optional[np.ndarray] = None  # Smoothed character forward direction
    camera_position_buffer: list = field(default_factory=list)  # Temporal buffer for smoothing
    camera_last_update_frame: int = -1  # Track last frame when camera was updated

    # Text prompt
    text_embedding: Optional[torch.Tensor] = None

    # Waypoints (now managed by 2D Root constraint)
    waypoint_mode: bool = False
    click_plane: Optional[object] = None

    # Constraints and timeline
    constraints: dict = field(default_factory=dict)
    timeline_data: Optional[dict] = None
    edit_mode: bool = False

    # Threading locks
    replan_lock: threading.Lock = field(default_factory=threading.Lock)
    rack_pick_lock: threading.Lock = field(default_factory=threading.Lock)
    characters_lock: threading.Lock = field(default_factory=threading.Lock)
    motion_tensor_lock: threading.Lock = field(default_factory=threading.Lock)

    # Playback thread control
    playback_thread: Optional[threading.Thread] = None
    stop_playback: bool = False

    # Hand orientation gizmos (dict of character_name -> dict of joint_name -> gizmo)
    hand_gizmos: dict = field(default_factory=dict)

    # Loaded scene mesh handle
    loaded_scene_mesh_handle: Optional[object] = None

    # Reference motion (loaded from file for constraint sampling)
    ref_character: Optional[object] = None
    ref_joints_pos: Optional[torch.Tensor] = None  # [T, J, 3]
    ref_joints_rot: Optional[torch.Tensor] = None  # [T, J, 3, 3]

    # MujocoQposConverter for Mujoco/CSV motion import (G1 only)
    mujoco_converter: Optional[object] = None


def add_checkerboard(
    client,
    grid_size=10,
    square_size=0.5,
    plane_thickness=0.01,
    color1=(230, 230, 230),
    color2=(40, 40, 40),
):
    """Add a checkerboard floor to the scene."""
    offset = -grid_size * square_size / 2.0 + square_size / 2.0

    for i in range(grid_size):
        for j in range(grid_size):
            if (i + j) % 2 == 0:
                color = color1
            else:
                color = color2

            position = (
                i * square_size + offset,
                -plane_thickness / 2.0,
                j * square_size + offset,
            )

            client.scene.add_box(
                name=f"/checkerboard/cell_{i}_{j}",
                dimensions=(square_size, plane_thickness, square_size),
                color=color,
                position=position,
            )
