"""Live D455 bottle preview. Camera observations only; never commands the robot."""
import argparse
import json
import math
import time
from pathlib import Path

from .record_realsense import rs, cv2, np, intrinsics_dict


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--serial', required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--weights', type=Path, default=Path(__file__).resolve().parents[1] / 'yolo11n.pt')
    parser.add_argument('--seconds', type=float, default=600)
    parser.add_argument('--headless', action='store_true')
    args = parser.parse_args()
    if not math.isfinite(args.seconds) or args.seconds <= 0:
        parser.error('--seconds must be finite and positive')
    if not args.weights.is_file():
        parser.error('Local detection weights are missing')
    from ultralytics import YOLO
    detector = YOLO(str(args.weights))
    bottle_classes = [i for i, name in detector.names.items() if name == 'bottle']
    if not bottle_classes:
        parser.error('Detector has no bottle class')
    args.output.mkdir(parents=True, exist_ok=False)
    pipeline = rs.pipeline()
    config = rs.config()
    config.enable_device(args.serial)
    config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 15)
    config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 15)
    profile = pipeline.start(config)
    frames = 0
    observations = []
    state_path = args.output / 'latest.json'
    status = 'starting'
    error = None
    try:
        scale = profile.get_device().first_depth_sensor().get_depth_scale()
        intrinsics = profile.get_stream(rs.stream.color).as_video_stream_profile().get_intrinsics()
        (args.output / 'camera.json').write_text(json.dumps(dict(serial=args.serial,
            color_intrinsics=intrinsics_dict(intrinsics), depth_scale_m=scale,
            calibrated_to_robot=False), indent=2) + '\n')
        align = rs.align(rs.stream.color)
        deadline = time.monotonic() + args.seconds
        while time.monotonic() < deadline:
            captured = pipeline.wait_for_frames(5000)
            receive_ns = time.monotonic_ns()
            aligned = align.process(captured)
            depth, color = aligned.get_depth_frame(), aligned.get_color_frame()
            if not depth or not color:
                continue
            image = np.asanyarray(color.get_data()).copy()
            depth_m = np.asanyarray(depth.get_data()) * scale
            result = detector.predict(image, classes=bottle_classes, device='cpu', verbose=False)[0]
            observations = []
            boxes = sorted(result.boxes, key=lambda box: float(box.xyxy[0][0]))
            for index, box in enumerate(boxes, 1):
                x1, y1, x2, y2 = box.xyxy[0].cpu().numpy().astype(int)
                x1, x2 = int(np.clip(x1, 0, 639)), int(np.clip(x2, 1, 640))
                y1, y2 = int(np.clip(y1, 0, 479)), int(np.clip(y2, 1, 480))
                # Small central patch reduces box-edge background contamination.
                # This is a visible surface measurement, NOT a bottle centre.
                u, v = (x1 + x2) // 2, (y1 + y2) // 2
                patch = depth_m[max(0,v-3):min(480,v+4),max(0,u-3):min(640,u+4)]
                valid = patch[np.isfinite(patch) & (patch > 0)]
                depth_value = None
                spread = None
                if valid.size >= patch.size * .7:
                    spread = float(np.percentile(valid, 90) - np.percentile(valid, 10))
                    if spread <= .03:
                        depth_value = float(np.median(valid))
                observations.append(dict(camera_left_to_right_index=index,
                    bbox_xyxy=[x1,y1,x2,y2], confidence=float(box.conf[0]),
                    sample_pixel=[u,v], surface_depth_m=depth_value,
                    patch_depth_spread_m=spread, is_grasp_target=False))
                text = f'Camera {index}: ' + (f'{depth_value:.3f} m surface' if depth_value else 'depth uncertain')
                cv2.rectangle(image,(x1,y1),(x2,y2),(0,255,255),2)
                cv2.putText(image,text,(max(0,x1-20),max(40,y1-10)),cv2.FONT_HERSHEY_SIMPLEX,.4,(0,255,255),1)
            cv2.rectangle(image,(0,0),(640,28),(0,0,0),-1)
            cv2.putText(image,f'{len(observations)} bottles | UNCALIBRATED | No robot commands',
                        (8,19),cv2.FONT_HERSHEY_SIMPLEX,.48,(0,255,255),1)
            frames += 1
            record = dict(state='observing',receive_monotonic_ns=receive_ns,
                          serial=args.serial,calibrated_to_robot=False,
                          index_note='Image order only; not simulation IDs or persistent tracking IDs',
                          observations=observations)
            temporary = state_path.with_suffix('.tmp')
            temporary.write_text(json.dumps(record,indent=2)+'\n')
            temporary.replace(state_path)
            cv2.imwrite(str(args.output / 'preview.jpg'),image)
            if not args.headless:
                cv2.imshow('RealSense bottles - calibration pending',image)
                if cv2.waitKey(1) & 255 == ord('q'):
                    break
        status = 'stopped'
    except BaseException as exc:
        status, error = 'failed', str(exc)
        raise
    finally:
        pipeline.stop()
        if not args.headless:
            cv2.destroyAllWindows()
        record = dict(state=status,error=error,frames=frames,calibrated_to_robot=False,
                      observations=observations)
        state_path.write_text(json.dumps(record,indent=2)+'\n')
        print(json.dumps(dict(state=status,frames=frames,bottles=len(observations))),flush=True)


if __name__ == '__main__':
    main()
