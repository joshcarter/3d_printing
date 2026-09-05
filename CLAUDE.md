# PrusaSlicer configs for Voron 2.4 350

## Printer
- Voron 2.4 350mm, Klipper firmware, BTT Octopus V1
- Stealthburner + G2E extruder + Rapido 2 HF hotend (PT1000, max_temp 350)
- Nozzle: Diamondback 0.4mm (polycrystalline diamond) -- abrasive-safe, fine for CF
- LDO kit motors (2A peak XY, 0.9° step)
- Two nozzle variants: 0.4mm and 0.6mm
- Config file is at `voron/printer.cfg`

## Klipper-side constraints
- max_accel: 4000 (hard ceiling)
- max_velocity: 300
- max_z_velocity: 25, max_z_accel: 350
- Per-filament accel via M204 (slicer commands it)
- Per-filament pressure advance via SET_PRESSURE_ADVANCE in filament start_gcode
- PRINT_START accepts params: EXTRUDER, BED, CHAMBER, SOAK (minutes)
- Extruder heater is capped at `max_power: 0.7` for the Rapido 2. At high flow
  and high temp the heater may not hold setpoint; a temp sag during a max-flow
  calibration is the heater, not the filament.

## PrusaSlicer conventions for this setup
- machine_limits_usage = emit_to_gcode (not ignore)
- use_relative_e_distances = 1
- Per-filament start_gcode sets SET_PRESSURE_ADVANCE and optionally SET_VELOCITY_LIMIT
- Max volumetric speed matters more than print speed for 0.6mm nozzle

## Preferred filament accel ceilings (commanded via SET_VELOCITY_LIMIT)
- PLA: 4000
- PETG: 3000
- PETG-CF: 2000
- PET-CF: 2000
- ABS/ASA: 3000

## Prusa XL (5 tool heads)
- Nozzles get swapped around often. Currently: ObXidian 0.4mm on two tool
  heads, brass 0.4mm on the other three.
- Only the ObXidian heads are safe for abrasive filament. Check which head a
  CF/GF filament is assigned to before slicing.

## Filament/printer restrictions
- **PET-CF is Voron-only.** It needs 300C+ and an abrasive-safe nozzle; the
  Voron's Rapido 2 + Diamondback is the only setup here that has both. Do not
  create PET-CF profiles for the Mk3 or XL -- earlier ones were deleted because
  they were PETG-CF copies with the temperature raised, which is wrong on both
  cooling and flow.
- Siraya Tech Fibreheart PET-CF spec: 280-320C nozzle, 60-80C bed, cooling fan
  OFF, max volumetric 20 mm3/s at 320C (that figure assumes a large nozzle;
  expect 10-14 through a 0.4mm).

## Calibration
- OrcaSlicer is used for calibration tests; PrusaSlicer lacks them. Presets are
  in `orcaslicer_presets/` (symlinked to ~/Library/Application Support/OrcaSlicer).
- Keep an Orca profile alongside the PrusaSlicer one for anything being
  calibrated, then hand-copy results back.
- Order: temp tower, flow ratio, pressure advance, max flowrate, retraction.
- Orca -> PrusaSlicer mappings are 1:1 except two: Orca's native
  `pressure_advance` becomes `SET_PRESSURE_ADVANCE ADVANCE=` in
  `start_filament_gcode`, and Orca's single `overhang_fan_speed` +
  `overhang_fan_threshold` has to be spread across PrusaSlicer's four
  `overhang_fan_speed_0..3` bands by hand.
