"""Start webcam tracking and ARDY's native Newton scene together."""
import argparse
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--viewer', choices=['gl', 'rtx'], default='gl')
    parser.add_argument('--viewer-python', default=sys.executable)
    args, tracking_args = parser.parse_known_args()
    root = Path(__file__).resolve().parents[1]
    env = os.environ.copy()
    env['PYTHONPATH'] = str(root / 'newton_rtx_viewer/deps/newton') + os.pathsep + env.get('PYTHONPATH', '')
    env['PYTHONUNBUFFERED'] = '1'
    env['WARP_CACHE_PATH'] = str(root / 'newton_rtx_viewer/deps/newton_cache/warp')
    with tempfile.TemporaryDirectory(prefix='ardy-real-to-sim-') as folder:
        state = str(Path(folder) / 'poses.json')
        children = []
        try:
            children.append(subprocess.Popen([args.viewer_python, str(root / 'newton_rtx_viewer/viewer_process.py'),
                '--viewer', args.viewer, '--pick-table-physics',
                '--camera-preset', 'saved_origin_back', '--real-to-sim-state', state],
                cwd=root, env=env, stdin=subprocess.DEVNULL))
            children.append(subprocess.Popen([sys.executable, '-m', 'real_to_sim.run',
                '--ardy-state', state, *tracking_args], cwd=root))
            while all(child.poll() is None for child in children):
                time.sleep(0.2)
            failed = next((child.returncode for child in children if child.returncode not in (None, 0)), 0)
            if failed:
                raise SystemExit(failed)
        finally:
            for child in children:
                if child.poll() is None:
                    child.terminate()
            for child in children:
                try:
                    child.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    child.kill()
                    child.wait()


if __name__ == '__main__':
    main()
