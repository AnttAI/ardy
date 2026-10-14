import unittest
import json
import subprocess
import sys
import tempfile
from pathlib import Path
import numpy as np
from real_to_sim.fit_robot_calibration import fit_rigid, errors_mm


class RegistrationTests(unittest.TestCase):
    def test_recovers_rotation_translation_and_held_out_point(self):
        # Planar, non-collinear references suffice for a proper 3D rigid transform.
        camera = np.array([[0, 0, 1], [.3, 0, 1], [0, .2, 1], [.3, .2, 1]])
        rotation = np.array([[0, -1, 0], [0, 0, -1], [1, 0, 0]])
        translation = np.array([.4, -.2, .8])
        robot = camera @ rotation.T + translation
        transform = fit_rigid(camera, robot)
        np.testing.assert_allclose(transform[:3, :3], rotation, atol=1e-12)
        np.testing.assert_allclose(transform[:3, 3], translation, atol=1e-12)
        held_out = np.array([[.12, .08, 1.15]])
        self.assertLess(errors_mm(transform, held_out, held_out @ rotation.T + translation)[0], 1e-8)

    def test_rejects_two_points_collinear_and_invalid_coordinates(self):
        for values in ([[0, 0, 0], [1, 0, 0]],
                       [[0, 0, 0], [1, 0, 0], [2, 0, 0]],
                       [[0, 0, 0], [1, 0, 0], [0, float('nan'), 0]]):
            with self.assertRaises(ValueError):
                fit_rigid(values, values)

    def test_reflections_are_not_accepted_as_rotations(self):
        camera = np.array([[0, 0, 0], [1, 0, 0], [0, 1, 0], [0, 0, 1]])
        robot = camera * [-1, 1, 1]
        transform = fit_rigid(camera, robot)
        self.assertAlmostEqual(np.linalg.det(transform[:3, :3]), 1)
        self.assertGreater(errors_mm(transform, camera, robot).max(), 100)


class CalibrationCommandTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        def row(index, point):
            return dict(id=str(index), camera_point_m=point,
                        robot_point_m=(np.array(point) + [.1, .2, .3]).tolist(),
                        camera_evidence=f'synthetic-frame-{index}',
                        robot_feedback_evidence=f'synthetic-feedback-{index}')
        self.data = dict(units='m', camera_serial='SYNTHETIC_TEST_ONLY',
            camera_frame='color_optical', robot_frame='test_base',
            mount_description='synthetic fixed camera', physical_point_definition='synthetic point',
            fitting=[row(i, p) for i, p in enumerate([[0,0,1],[.3,0,1],[0,.2,1]])],
            validation=[row(3,[.1,.1,1.1])])

    def run_fit(self):
        source = self.root / 'input.json'
        source.write_text(json.dumps(self.data))
        output = self.root / 'output.json'
        result = subprocess.run([sys.executable, '-m', 'real_to_sim.fit_robot_calibration',
            str(source), '--output', str(output), '--max-error-mm', '5'],
            capture_output=True, text=True, timeout=15)
        return result, output

    def test_cli_success_and_no_overwrite(self):
        result, output = self.run_fit()
        self.assertEqual(result.returncode, 0, result.stderr)
        contents = output.read_text()
        parsed = json.loads(contents)
        self.assertTrue(parsed['geometric_validation_passed'])
        self.assertFalse(parsed['hardware_execution_enabled'])
        result, _ = self.run_fit()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(output.read_text(), contents)

    def test_bad_held_out_point_rejects_calibration(self):
        self.data['validation'][0]['robot_point_m'][0] += .05
        result, output = self.run_fit()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(json.loads(output.read_text())['geometric_validation_passed'])

    def test_missing_validation_rejected(self):
        self.data['validation'] = []
        result, output = self.run_fit()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(output.exists())

    def test_reused_reference_id_rejected(self):
        self.data['validation'][0]['id'] = '0'
        result, output = self.run_fit()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(output.exists())

    def test_missing_feedback_evidence_rejected(self):
        del self.data['fitting'][0]['robot_feedback_evidence']
        result, output = self.run_fit()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(output.exists())


if __name__ == '__main__':
    unittest.main()
