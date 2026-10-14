import unittest

import numpy as np

from .core import Slots, project_point


class CoreTests(unittest.TestCase):
    def test_projection_and_invalid_depth(self):
        np.testing.assert_allclose(project_point([[0.01, 0, -1], [0, 0.02, -2], [0, 0, 1]],
                                                [150, 125]), [0.5, 0.5])
        with self.assertRaises(ValueError):
            project_point(np.zeros((3, 3)), [100, 100])

    def test_two_instances_keep_slots_when_detection_order_changes(self):
        slots = Slots({'bottle': {'capacity': 2}}, alpha=1)
        slots.update([(10, 'bottle', [0, 0]), (20, 'bottle', [1, 1])], 0)
        active = slots.update([(20, 'bottle', [2, 2]), (10, 'bottle', [3, 3])], 0.1)
        self.assertEqual(active['bottle', 10]['slot'], 0)
        self.assertEqual(active['bottle', 20]['slot'], 1)
        np.testing.assert_allclose(active['bottle', 10]['xy'], [3, 3])

    def test_timeout_capacity_and_reuse(self):
        slots = Slots({'bottle': {'capacity': 1}})
        slots.update([(1, 'bottle', [0, 0]), (2, 'bottle', [1, 1]), (3, 'cup', [0, 0])], 0)
        self.assertEqual(len(slots.active), 1)
        self.assertEqual(len(slots.update([], 0.5)), 1)
        self.assertEqual(len(slots.update([], 0.8)), 0)
        active = slots.update([(2, 'bottle', [1, 1])], 0.9)
        self.assertEqual(active['bottle', 2]['slot'], 0)


if __name__ == '__main__':
    unittest.main()
