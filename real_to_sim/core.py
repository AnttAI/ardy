"""Table-plane projection and bounded, identity-preserving asset allocation."""

import numpy as np


def project_point(homography, pixel):
    p = np.asarray(homography) @ np.array([*pixel, 1.0])
    if not np.isfinite(p).all() or abs(p[2]) < 1e-8:
        raise ValueError("Invalid table projection")
    return p[:2] / p[2]


class Slots:
    def __init__(self, registry, timeout=0.75, alpha=0.5):
        self.registry = registry
        self.timeout = timeout
        self.alpha = alpha
        self.active = {}

    def update(self, observations, now):
        self.active = {k: v for k, v in self.active.items() if now - v['seen'] <= self.timeout}
        for track_id, label, xy in observations:
            if label not in self.registry:
                continue
            key = (label, track_id)
            if key not in self.active:
                used = {v['slot'] for k, v in self.active.items() if k[0] == label}
                free = next((i for i in range(self.registry[label]['capacity']) if i not in used), None)
                if free is None:
                    continue
                self.active[key] = {'slot': free, 'xy': np.asarray(xy), 'seen': now}
            entry = self.active[key]
            entry['xy'] = self.alpha * np.asarray(xy) + (1 - self.alpha) * entry['xy']
            entry['seen'] = now
        return self.active
