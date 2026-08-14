# Rack Pick Checklist

Target rack: `rack_2`
Pick shelf: `4`
Pick object: `2`

1. In `Rack Route`, choose the target rack and click `Go To Rack`.
2. Wait until the route finishes and confirm the character is standing at the rack.
3. In `Constraints`, set these values:
   - `Motion File Path`: `/home/jony/Downloads/soma-retargeter/assets/motions/bvh/generated/kimodo_0eaccddc7f.bvh`
   - `Constraint Frames`: `/home/jony/Downloads/ardy/rack_pick_constraints_program/generated/pick_constraints.json`
   - Checked: `hands, hand_only_motion`
   - Unchecked: `full_body, forearm_orientation, feet, hands_and_feet, root_2d_waypoints, root_2d_trajectory, continue_from_current_frame`
   - `Max Keyframes`: leave as-is; deterministic frames override random sampling.
4. Click `Sample Constraints` and play/generate the pick motion.
