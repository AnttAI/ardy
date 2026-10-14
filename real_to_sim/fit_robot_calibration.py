"""Fit camera-to-robot rigid registration from reviewed, same-point references.

This does not infer a bottle centre from a surface depth pixel, generate reference
points from simulation, or enable robot control. All coordinates are in metres.
"""
import argparse
import json
from pathlib import Path

import numpy as np


def points(value):
    result = np.asarray(value, dtype=float)
    if result.ndim != 2 or result.shape[1] != 3 or not np.isfinite(result).all():
        raise ValueError('Expected finite Nx3 point coordinates in metres')
    return result


def fit_rigid(camera_points, robot_points):
    camera, robot = points(camera_points), points(robot_points)
    if camera.shape != robot.shape or len(camera) < 3:
        raise ValueError('Need at least three matching reference points')
    for cloud in (camera, robot):
        singular = np.linalg.svd(cloud - cloud.mean(axis=0), compute_uv=False)
        if singular[0] < 0.02 or singular[1] < 0.02 or singular[1] / singular[0] < 0.05:
            raise ValueError('Reference points are too close together or nearly collinear')
    u, _, vt = np.linalg.svd((camera - camera.mean(axis=0)).T @ (robot - robot.mean(axis=0)))
    correction = np.eye(3)
    correction[2, 2] = np.linalg.det(vt.T @ u.T)
    rotation = vt.T @ correction @ u.T
    translation = robot.mean(axis=0) - rotation @ camera.mean(axis=0)
    transform = np.eye(4)
    transform[:3, :3], transform[:3, 3] = rotation, translation
    return transform


def errors_mm(transform, camera_points, robot_points):
    camera, robot = points(camera_points), points(robot_points)
    if camera.shape != robot.shape or len(camera) == 0:
        raise ValueError('Need matching, nonempty validation points')
    predicted = camera @ transform[:3, :3].T + transform[:3, 3]
    return np.linalg.norm(predicted - robot, axis=1) * 1000


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('references', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--max-error-mm', type=float, required=True,
                        help='Acceptance tolerance chosen from the real grasp clearance')
    args = parser.parse_args()
    if not np.isfinite(args.max_error_mm) or args.max_error_mm <= 0:
        parser.error('Tolerance must be finite and positive')
    data = json.loads(args.references.read_text())
    for key in ('camera_serial', 'camera_frame', 'robot_frame', 'physical_point_definition',
                'mount_description'):
        if not data.get(key):
            raise ValueError(f'Missing provenance: {key}')
    if data.get('units') != 'm':
        raise ValueError('Reference units must be m')
    fitting, validation = data['fitting'], data['validation']
    ids = [row['id'] for row in fitting + validation]
    if len(set(ids)) != len(ids):
        raise ValueError('Fitting and held-out reference IDs must be unique')
    if not validation:
        raise ValueError('At least one independent held-out reference is required')
    def pair(rows):
        for row in rows:
            if not row.get('camera_evidence') or not row.get('robot_feedback_evidence'):
                raise ValueError('Each reference needs camera and physical feedback evidence')
        return [r['camera_point_m'] for r in rows], [r['robot_point_m'] for r in rows]
    camera, robot = pair(fitting)
    transform = fit_rigid(camera, robot)
    fit_errors = errors_mm(transform, camera, robot)
    validation_errors = errors_mm(transform, *pair(validation))
    accepted = bool(max(fit_errors.max(), validation_errors.max()) <= args.max_error_mm)
    result = dict(schema_version=1, transform_direction='robot_from_camera',
        transform=transform.tolist(), fit_errors_mm=fit_errors.tolist(),
        held_out_errors_mm=validation_errors.tolist(), max_error_mm=args.max_error_mm,
        geometric_validation_passed=accepted, hardware_execution_enabled=False,
        references=data)
    with args.output.open('x') as output:
        json.dump(result, output, indent=2)
        output.write('\n')
    print(json.dumps({k: v for k, v in result.items() if k not in ('references', 'transform')}))
    if not accepted:
        raise SystemExit('Calibration rejected: measured error exceeds tolerance')


if __name__ == '__main__':
    main()
