import unittest
from unittest.mock import patch

import numpy as np

from .run import Camera, validate_calibration


class CameraTests(unittest.TestCase):
    def test_rotation_used_for_all_reads(self):
        frame = np.arange(18, dtype=np.uint8).reshape(2, 3, 3)
        with patch('real_to_sim.run.cv2.VideoCapture') as capture:
            capture.return_value.read.return_value = (True, frame)
            camera = Camera('/dev/video2', 270)
            ok, rotated = camera.read()
            self.assertTrue(ok)
            np.testing.assert_array_equal(rotated, np.rot90(frame))
            capture.assert_called_once_with('/dev/video2')
            camera.release()
            capture.return_value.release.assert_called_once()

    def test_camera_and_orientation_are_bound_to_calibration(self):
        calibration = {'camera': '/dev/video2', 'rotation': 270}
        validate_calibration(calibration, '/dev/video2', 270)
        for source, rotation in [('/dev/video0', 270), ('/dev/video2', 0)]:
            with self.assertRaisesRegex(ValueError, 'different camera'):
                validate_calibration(calibration, source, rotation)
        with self.assertRaises(ValueError):
            validate_calibration({}, '/dev/video2', 270)
