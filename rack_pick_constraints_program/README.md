# Rack Pick Constraints Program

This folder stores the complete repeatable setup for a rack pick:

1. Generate/go to the target rack using the existing `Rack Route` controls.
2. Confirm the route has finished.
3. Sample the pick motion from the configured BVH using hands-only constraints.

Run:

```bash
python rack_pick_constraints_program/rack_pick_program.py
```

The program writes generated files under `rack_pick_constraints_program/generated/`.

In the interactive demo, use:

- `Motion File Path`: the configured BVH path.
- `Constraint Frames`: `rack_pick_constraints_program/generated/pick_constraints.json`
- Checked: `Hands`, `Hand Only Motion`
- Unchecked: `Full Body`, `Forearm Orientation`, `Feet`, `Hands and Feet`, `2D Root Waypoints`, `2D Root Trajectory`, `Continue from Current Frame`
- `Max Keyframes`: no special value needed because deterministic frames are used.

