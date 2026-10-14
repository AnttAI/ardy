"""Record aligned RGB-D observations. No robot connections or commands."""
import argparse
import json
import math
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / '.realsense_deps'))
import pyrealsense2 as rs
import cv2
import numpy as np


def intrinsics_dict(intr):
    return dict(width=intr.width, height=intr.height, fx=intr.fx, fy=intr.fy,
                ppx=intr.ppx, ppy=intr.ppy, model=str(intr.model), coeffs=list(intr.coeffs))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--serial', required=True)
    parser.add_argument('--seconds', type=float, default=10)
    parser.add_argument('--fps', type=int, default=5)
    args = parser.parse_args()
    if not math.isfinite(args.seconds) or args.seconds <= 0 or args.fps <= 0:
        parser.error('Duration and frame rate must be positive')
    args.output.mkdir(parents=True, exist_ok=False)
    pipeline = rs.pipeline()
    config = rs.config()
    config.enable_device(args.serial)
    config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, args.fps)
    config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, args.fps)
    count = 0
    valid_count = 0
    started = False
    status_path = args.output / 'status.json'
    status = dict(state='starting', camera_frames=0, calibrated_to_robot=False)
    status_path.write_text(json.dumps(status, indent=2) + '\n')
    try:
        profile = pipeline.start(config)
        started = True
        device = profile.get_device()
        depth_profile = profile.get_stream(rs.stream.depth).as_video_stream_profile()
        color_profile = profile.get_stream(rs.stream.color).as_video_stream_profile()
        extr = depth_profile.get_extrinsics_to(color_profile)
        metadata = dict(schema_version=1, serial=args.serial,
            device=device.get_info(rs.camera_info.name),
            usb_type=device.get_info(rs.camera_info.usb_type_descriptor),
            depth_scale_m=device.first_depth_sensor().get_depth_scale(),
            depth_intrinsics=intrinsics_dict(depth_profile.get_intrinsics()),
            color_intrinsics=intrinsics_dict(color_profile.get_intrinsics()),
            depth_to_color=dict(rotation=list(extr.rotation), translation=list(extr.translation)),
            aligned_depth_frame='color_optical', units='metres after multiplying raw depth by depth_scale_m',
            calibrated_to_robot=False,
            timing_note='Host monotonic receive times are approximate pairing only. Use stationary references; device and ROS source clocks are not synchronized.')
        (args.output / 'camera.json').write_text(json.dumps(metadata, indent=2) + '\n')
        align = rs.align(rs.stream.color)
        # Let exposure settle before keeping reference images.
        for _ in range(10):
            pipeline.wait_for_frames(10000)
        deadline = time.monotonic() + args.seconds
        with (args.output / 'frames.jsonl').open('x') as index:
            while time.monotonic() < deadline:
                frames = pipeline.wait_for_frames(10000)
                received_ns = time.monotonic_ns()
                received_unix_ns = time.time_ns()
                aligned = align.process(frames)
                depth, color = aligned.get_depth_frame(), aligned.get_color_frame()
                if not depth or not color:
                    continue
                depth_image = np.asanyarray(depth.get_data())
                color_image = np.asanyarray(color.get_data())
                if np.any(depth_image):
                    valid_count += 1
                stem = f'{count:06d}'
                if not cv2.imwrite(str(args.output / f'{stem}.jpg'), color_image):
                    raise RuntimeError('Failed to save color frame')
                if not cv2.imwrite(str(args.output / f'{stem}.depth.png'), depth_image):
                    raise RuntimeError('Failed to save depth frame')
                record = dict(frame=stem, receive_monotonic_ns=received_ns,
                    receive_unix_ns=received_unix_ns,
                    color_timestamp_ms=color.get_timestamp(),
                    depth_timestamp_ms=depth.get_timestamp(),
                    color_timestamp_domain=str(color.get_frame_timestamp_domain()),
                    depth_timestamp_domain=str(depth.get_frame_timestamp_domain()),
                    depth_valid_fraction=float(np.count_nonzero(depth_image) / depth_image.size))
                index.write(json.dumps(record) + '\n')
                index.flush()
                count += 1
        if not count or not valid_count:
            raise RuntimeError('No RGB-D frames with valid depth captured')
        status['state'] = 'recorded_unvalidated'
    except BaseException as exc:
        status.update(state='failed', error=f'{type(exc).__name__}: {exc}')
        raise
    finally:
        try:
            if started:
                pipeline.stop()
        finally:
            status.update(camera_frames=count, frames_with_nonzero_depth=valid_count)
            status_path.write_text(json.dumps(status, indent=2) + '\n')
    print(json.dumps({'camera_frames': count, 'output': str(args.output)}), flush=True)


if __name__ == '__main__':
    main()
