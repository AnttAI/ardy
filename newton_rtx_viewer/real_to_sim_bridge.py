"""Local atomic pose snapshots, separate from ARDY's robot animation stream."""
import json
from pathlib import Path
import time

import numpy as np


def read_snapshot(path, capacity, now=None):
    now = time.monotonic() if now is None else now
    try:
        packet = json.loads(Path(path).read_text())
        age = now - float(packet['time'])
        if not 0 <= age <= 1.5:
            return {}, 'tracking stale'
        positions = {}
        for item in packet['objects']:
            slot = int(item['slot'])
            position = np.asarray(item['position'], dtype=float)
            if item['class'] != 'bottle' or not 0 <= slot < capacity:
                continue
            if position.shape != (3,) or not np.isfinite(position).all():
                continue
            positions[slot] = position
        return positions, str(packet.get('mode', 'camera tracking'))
    except (OSError, ValueError, KeyError, TypeError, OverflowError):
        return {}, 'waiting for camera'


def apply_snapshot(wp, state, state_next, body_indices, positions):
    for target in (state, state_next):
        poses = target.body_q.numpy()
        velocities = target.body_qd.numpy()
        for slot, body in enumerate(body_indices):
            poses[body] = [*positions.get(slot, (0, 0, -100)), 0, 0, 0, 1]
            velocities[body] = 0
        target.body_q.assign(poses)
        target.body_qd.assign(velocities)
