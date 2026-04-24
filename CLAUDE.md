# PrusaSlicer configs for Voron 2.4 350

## Printer
- Voron 2.4 350mm, Klipper firmware, BTT Octopus V1
- Stealthburner + Clockwork 2 + Revo hotend
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

## PrusaSlicer conventions for this setup
- machine_limits_usage = emit_to_gcode (not ignore)
- use_relative_e_distances = 1
- Per-filament start_gcode sets SET_PRESSURE_ADVANCE and optionally SET_VELOCITY_LIMIT
- Max volumetric speed matters more than print speed for 0.6mm nozzle

## Preferred filament accel ceilings (commanded via SET_VELOCITY_LIMIT)
- PLA: 4000
- PETG: 3000
- PETG-CF: 2000
- ABS/ASA: 3000
