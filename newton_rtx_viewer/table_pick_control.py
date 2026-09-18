"""Receiver-side pick interlocks. Never write bottle transforms."""
import math


def overlap(a, b, margin=0.005):
    return all(a[1][i] > b[0][i]-margin and a[0][i] < b[1][i]+margin for i in range(3))


def swept_bounds(a, b):
    return ([min(x, y) for x, y in zip(a[0], b[0])],
            [max(x, y) for x, y in zip(a[1], b[1])])


class PickControl:
    def __init__(self):
        self.plan_id = None
        self.frame = -1
        self.blocked = ""
        self.contact_aperture = None
        self.aperture = 0.0

    def update(self, plan, frame, bilateral, bottle_position, current_aperture):
        required = ("id", "phases", "bottle_position", "closed_aperture")
        for key in required:
            if key not in plan:
                raise ValueError(f"missing {key}")
        for key in ("pregrasp", "open", "arrive", "close_start", "close_end", "settled", "lift", "chest", "end"):
            if key not in plan["phases"]:
                raise ValueError(f"missing phase {key}")
        if plan["id"] != self.plan_id:
            self.__init__()
            self.plan_id = plan["id"]
        p = plan["phases"]
        if not (p["pregrasp"] <= p["open"] <= p["arrive"] <= p["close_start"] <= p["close_end"] <= p["settled"] <= p["lift"] <= p["chest"] <= p["end"]):
            raise ValueError("pick phases are not monotonic")
        if not 0.0 <= float(plan["closed_aperture"]) <= 0.10:
            raise ValueError("closed_aperture must be between 0 and 0.10 m")
        if self.blocked:
            return self.aperture
        if (self.frame < 0 and frame != 0) or frame < self.frame or frame > self.frame+1:
            self.blocked = "Pick frames skipped or rewound. Use all delivery and exact playback; rebuild pick."
            return self.aperture
        if frame < p["close_start"] and math.dist(bottle_position, plan["bottle_position"]) > 0.025:
            self.blocked = "Bottle moved since planning. Rebuild pick from the current RTX scene."
            return self.aperture
        if frame >= p["settled"] and not bilateral:
            self.blocked = "No bilateral finger contact: lift/transport stopped. Realign and rebuild pick."
            return self.aperture
        def smooth(a, b):
            u = min(1., max(0., (frame-a)/max(1, b-a)))
            return u*u*(3.-2.*u)
        if frame < p["close_start"]:
            aperture = 0.10*smooth(p["pregrasp"], p["open"])
        else:
            # Close gently up to a calibrated maximum. Contact can stop closure earlier.
            aperture = 0.10+(plan["closed_aperture"]-0.10)*smooth(p["close_start"], p["close_end"])
            if bilateral and self.contact_aperture is None:
                self.contact_aperture = max(0., current_aperture-0.001)
            if self.contact_aperture is not None:
                aperture = max(aperture, self.contact_aperture)
        self.frame = frame
        self.aperture = aperture
        return aperture
