import json
from pathlib import Path
import tempfile
import unittest

import numpy as np

from newton_rtx_viewer.real_to_sim_bridge import apply_snapshot, read_snapshot


class Array:
    def __init__(self, values):
        self.values = np.array(values, dtype=float)

    def numpy(self):
        return self.values.copy()

    def assign(self, values):
        self.values = values.copy()


class State:
    def __init__(self):
        self.body_q = Array([[5, 6, 7, 0, 0, 0, 1]] * 4)
        self.body_qd = Array(np.ones((4, 6)))


class BridgeTests(unittest.TestCase):
    def test_snapshot_filters_invalid_slots_and_expires(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'poses.json'
            path.write_text(json.dumps({'time': 10, 'objects': [
                {'class': 'bottle', 'slot': 0, 'position': [0.1, -0.5, 1.045]},
                {'class': 'bottle', 'slot': 10, 'position': [0, 0, 0]},
                {'class': 'bottle', 'slot': 1, 'position': [float('nan'), 0, 0]}]}))
            positions, _ = read_snapshot(path, 3, now=10.1)
            self.assertEqual(set(positions), {0})
            self.assertEqual(read_snapshot(path, 3, now=12)[0], {})
            path.write_text('{')
            self.assertEqual(read_snapshot(path, 3, now=10)[0], {})

    def test_updates_both_buffers_and_preserves_robot(self):
        a, b = State(), State()
        apply_snapshot(None, a, b, [1, 2, 3], {0: [0.1, -0.5, 1.045], 1: [0.3, -0.5, 1.045]})
        for state in (a, b):
            np.testing.assert_allclose(state.body_q.values[0, :3], [5, 6, 7])
            np.testing.assert_allclose(state.body_q.values[1, :3], [0.1, -0.5, 1.045])
            self.assertEqual(state.body_q.values[3, 2], -100)
            np.testing.assert_allclose(state.body_qd.values[1:], 0)
