"""Run with python -m real_to_sim.run --help."""

import argparse
import json
from pathlib import Path
import time

import cv2
import numpy as np

from .core import Slots, project_point


DEFAULT_CAMERA = '/dev/v4l/by-id/usb-Sonix_Technology_Co.__Ltd._Lenovo_FHD_Webcam_Audio_SN0001-video-index0'


class Camera:
    """Apply the same orientation to calibration and inference frames."""

    def __init__(self, source, rotation):
        self.cap = cv2.VideoCapture(source)
        self.rotation = rotation

    def isOpened(self):
        return self.cap.isOpened()

    def set(self, prop, value):
        return self.cap.set(prop, value)

    def read(self):
        ok, frame = self.cap.read()
        rotations = {90: cv2.ROTATE_90_CLOCKWISE, 180: cv2.ROTATE_180,
                     270: cv2.ROTATE_90_COUNTERCLOCKWISE}
        if ok and self.rotation:
            frame = cv2.rotate(frame, rotations[self.rotation])
        return ok, frame

    def release(self):
        self.cap.release()


def validate_calibration(calibration, source, rotation):
    if calibration.get('camera') != str(source) or calibration.get('rotation') != rotation:
        raise ValueError('Calibration belongs to a different camera/orientation or is from an older version. '
                         'Run --calibrate again with the USB camera and measured area dimensions.')


def calibrate(cap, path, width, depth, table_z, source, rotation):
    points = []
    window = 'Calibration: click origin, +X, opposite, +Y; Enter saves; R resets; Q quits'
    cv2.namedWindow(window)

    def click(event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONDOWN and len(points) < 4:
            points.append([x, y])

    cv2.setMouseCallback(window, click)
    try:
        while True:
            ok, frame = cap.read()
            if not ok:
                raise RuntimeError('Cannot read webcam during calibration')
            for i, p in enumerate(points):
                cv2.circle(frame, tuple(p), 6, (0, 255, 0), -1)
                cv2.putText(frame, str(i + 1), tuple(p), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 0), 2)
            cv2.imshow(window, frame)
            key = cv2.waitKey(1) & 255
            if key == ord('q'):
                return False
            if key == ord('r'):
                points.clear()
            if key in (10, 13) and len(points) == 4:
                polygon = np.array(points, dtype=np.float32)
                if not cv2.isContourConvex(polygon) or abs(cv2.contourArea(polygon)) < 100:
                    print('Select four distinct corners in perimeter order. Press R to reset.')
                    continue
                world = np.float32([[0, 0], [width, 0], [width, depth], [0, depth]])
                h = cv2.getPerspectiveTransform(polygon, world)
                path.write_text(json.dumps(dict(pixels=points, homography=h.tolist(),
                    frame_size=[frame.shape[1], frame.shape[0]], width=width, depth=depth,
                    table_z=table_z, camera=str(source), rotation=rotation), indent=2) + '\n')
                return True
    finally:
        cv2.destroyWindow(window)


class Scene:
    def __init__(self, registry, calibration, registry_dir):
        import newton
        import newton.viewer
        import warp as wp

        self.wp = wp
        self.z = calibration['table_z']
        self.registry = registry
        builder = newton.ModelBuilder()
        w, d = calibration['width'], calibration['depth']
        builder.add_shape_box(-1, xform=wp.transform(wp.vec3(w / 2, d / 2, self.z - 0.025)),
                              hx=w / 2, hy=d / 2, hz=0.025, color=(0.65, 0.65, 0.65))
        self.bodies = {}
        for label, asset in registry.items():
            mesh = None
            if asset['kind'] == 'mesh':
                import trimesh
                loaded = trimesh.load(str(registry_dir / asset['path']), force='mesh')
                mesh = newton.Mesh(np.asarray(loaded.vertices, dtype=np.float32),
                                   np.asarray(loaded.faces, dtype=np.int32).reshape(-1))
            elif asset['kind'] != 'bottle':
                raise ValueError(f'Unsupported asset kind: {asset["kind"]}')
            for slot in range(asset['capacity']):
                body = builder.add_body(xform=wp.transform(wp.vec3(0, 0, -100)),
                                        label=f'{label}_{slot}', is_kinematic=True)
                self.bodies[label, slot] = body
                color = tuple(asset.get('color', [0.2, 0.65, 0.85]))
                if mesh is not None:
                    builder.add_shape_mesh(body, mesh=mesh, scale=wp.vec3(*asset.get('scale', [1, 1, 1])),
                                           color=color)
                else:
                    builder.add_shape_cylinder(body, radius=asset['radius'],
                        half_height=asset['half_height'], color=color)
                    builder.add_shape_cylinder(body, radius=asset['neck_radius'],
                        half_height=asset['neck_half_height'], color=color,
                        xform=wp.transform(wp.vec3(0, 0, asset['half_height'] + asset['neck_half_height'])))
        self.model = builder.finalize()
        self.state = self.model.state()
        self.viewer = newton.viewer.ViewerGL()
        self.viewer.set_model(self.model)
        self.viewer.set_camera(wp.vec3(w / 2, -max(w, d) * 1.5, self.z + max(w, d)),
                               pitch=-30, yaw=90)

    def render(self, active, now):
        poses = self.state.body_q.numpy()
        for body in self.bodies.values():
            poses[body] = [0, 0, -100, 0, 0, 0, 1]
        for (label, track_id), entry in active.items():
            body = self.bodies[label, entry['slot']]
            poses[body] = [*entry['xy'], self.z + self.registry[label]['origin_height'], 0, 0, 0, 1]
        self.state.body_q.assign(poses)
        self.viewer.begin_frame(now)
        self.viewer.log_state(self.state)
        self.viewer.end_frame()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--camera', default=DEFAULT_CAMERA,
                        help='Camera index/path/URL; defaults to the external Lenovo USB camera')
    parser.add_argument('--rotation', type=int, choices=[0, 90, 180, 270], default=180,
                        help='Clockwise image rotation; default 180 corrects the current USB camera mount')
    parser.add_argument('--confidence', type=float, default=0.25, help='Detection confidence threshold')
    parser.add_argument('--registry', type=Path, default=Path(__file__).with_name('registry.json'))
    parser.add_argument('--calibration', type=Path, default=Path('real_to_sim/calibration.json'))
    parser.add_argument('--calibrate', action='store_true')
    parser.add_argument('--width', type=float, help='Measured marked-area width in meters; required for calibration')
    parser.add_argument('--depth', type=float, help='Measured marked-area depth in meters; required for calibration')
    parser.add_argument('--table-z', type=float, default=0.9)
    parser.add_argument('--weights', default='yolo11n.pt')
    parser.add_argument('--device', default=None, help='Detector device, e.g. cpu or 0')
    parser.add_argument('--detect-only', action='store_true',
                        help='Show full-frame tracking without Newton or table calibration')
    parser.add_argument('--ardy-state', type=Path, help='Send poses to the native ARDY viewer via this snapshot file')
    parser.add_argument('--preview-area', action='store_true',
                        help='Uncalibrated demo: map the entire camera image onto the ARDY table')
    args = parser.parse_args()
    if not 0 < args.confidence <= 1:
        parser.error('--confidence must be greater than zero and at most one')
    if args.preview_area and not args.ardy_state:
        parser.error('--preview-area requires --ardy-state')
    if args.detect_only and args.ardy_state:
        parser.error('--detect-only cannot be used with --ardy-state')
    if args.calibrate and (args.width is None or args.depth is None or
                           not np.isfinite([args.width, args.depth, args.table_z]).all() or
                           min(args.width, args.depth) <= 0):
        parser.error('--calibrate requires positive --width and --depth in meters')
    source = int(args.camera) if args.camera.isdecimal() else args.camera
    print(f'Camera: {source} | clockwise rotation: {args.rotation} degrees', flush=True)
    cap = Camera(source, args.rotation)
    scene = None
    try:
        if not cap.isOpened():
            raise RuntimeError(f'Cannot open camera {source!r}. Check device visibility and permissions.')
        cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
        if args.calibrate:
            args.calibration.parent.mkdir(parents=True, exist_ok=True)
            if not calibrate(cap, args.calibration, args.width, args.depth, args.table_z, source, args.rotation):
                return
        calibration = None
        if not args.detect_only and not args.preview_area:
            if not args.calibration.exists():
                parser.error('Calibrate first with --calibrate --width METERS --depth METERS')
            calibration = json.loads(args.calibration.read_text())
            validate_calibration(calibration, source, args.rotation)
        registry = json.loads(args.registry.read_text())
        for label, asset in registry.items():
            if not isinstance(asset['capacity'], int) or asset['capacity'] <= 0:
                raise ValueError(f'{label}: capacity must be a positive integer')
        from ultralytics import YOLO
        detector = YOLO(args.weights)
        classes = [i for i, name in detector.names.items() if name in registry]
        missing = set(registry) - set(detector.names.values())
        if missing:
            raise ValueError(f'Weights do not recognize registry classes: {sorted(missing)}')
        if not classes:
            raise ValueError('The registry must contain at least one detector class')
        if args.ardy_state:
            if set(registry) != {'bottle'} or registry['bottle']['capacity'] > 3:
                parser.error('The native ARDY bridge currently supports up to three bottle instances')
            args.ardy_state.parent.mkdir(parents=True, exist_ok=True)
        if not args.detect_only and not args.ardy_state:
            scene = Scene(registry, calibration, args.registry.resolve().parent)
        slots = Slots(registry)
        contour = np.float32(calibration['pixels']) if calibration else None
        start = time.monotonic()
        while scene is None or scene.viewer.is_running():
            ok, frame = cap.read()
            if not ok:
                raise RuntimeError('Webcam frame read failed; stopping live mirror')
            if calibration and [frame.shape[1], frame.shape[0]] != calibration['frame_size']:
                raise ValueError('Camera resolution changed: recalibrate at this resolution')
            result = detector.track(frame, persist=True, classes=classes, tracker='bytetrack.yaml',
                                    conf=args.confidence, device=args.device, verbose=False)[0]
            observations = []
            boxes = result.boxes
            if boxes is not None and boxes.id is not None:
                for box, track_id, cls in zip(boxes.xyxy.cpu().numpy(), boxes.id.int().cpu().tolist(),
                                               boxes.cls.int().cpu().tolist()):
                    # Approximate table contact point for an upright, unobscured object.
                    pixel = (float((box[0] + box[2]) / 2), float(box[3]))
                    if args.preview_area:
                        # Demonstration only: normalized screen coordinates, not measured world coordinates.
                        observations.append((track_id, result.names[cls],
                                             [pixel[0] / frame.shape[1] * 1.8,
                                              (1 - pixel[1] / frame.shape[0]) * 0.9]))
                    elif contour is not None and cv2.pointPolygonTest(contour, pixel, False) >= 0:
                        observations.append((track_id, result.names[cls],
                                             project_point(calibration['homography'], pixel)))
            now = time.monotonic()
            active = slots.update(observations, now)
            if args.ardy_state:
                mode = 'UNCALIBRATED image-to-table preview' if args.preview_area else 'calibrated table XY'
                packet = {'time': now, 'mode': mode, 'objects': [
                    {'class': label, 'slot': entry['slot'], 'track_id': track_id,
                     'position': [float(entry['xy'][0]) - 0.9, float(entry['xy'][1]) - 1.2,
                                  0.9 + registry[label]['origin_height']]}
                    for (label, track_id), entry in active.items()]}
                temporary = args.ardy_state.with_suffix('.tmp')
                temporary.write_text(json.dumps(packet))
                temporary.replace(args.ardy_state)
            if scene:
                scene.render(active, now - start)
            preview = result.plot()
            if contour is not None:
                cv2.polylines(preview, [contour.astype(np.int32)], True, (0, 255, 255), 2)
            bottle_count = sum(result.names[int(cls)] == 'bottle' for cls in boxes.cls.cpu().tolist()) if boxes is not None else 0
            status = f'Bottles: {bottle_count} | ' + (f'Sent to ARDY: {len(active)}' if args.ardy_state else
                       f'Mirrored: {len(active)}' if scene else 'Detection only')
            if args.preview_area:
                cv2.putText(preview, 'UNCALIBRATED PREVIEW', (10, 50),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 165, 255), 2)
            cv2.putText(preview, status + ' | Q quits', (10, 25),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 255), 2)
            cv2.imshow('Real to Newton', preview)
            if cv2.waitKey(1) & 255 == ord('q'):
                break
    finally:
        if args.ardy_state and args.ardy_state.exists():
            args.ardy_state.unlink()
        cap.release()
        cv2.destroyAllWindows()
        if scene:
            scene.viewer.close()


if __name__ == '__main__':
    main()
