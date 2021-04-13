#!/usr/bin/env python3

import argparse
import re

parser = argparse.ArgumentParser(description='Splice two gcode files together.')
parser.add_argument('files', metavar='F', type=str, nargs='+', help='gcode file to splice')
parser.add_argument('-o', '--out', action='store', dest='out', default='out.gcode', help='output file')

args = parser.parse_args()

if len(args.files) != 2:
    print('I can only splice two files at the moment')
    exit(-1)

print(f'saving to output file: {args.out}')

# Gcode RE's
extruder_temp = re.compile('M10[49]\s+[RS](\d+)')
fan_speed = re.compile('M106\s+S(\d+)')
fan_off = re.compile('M107')
filament_change = re.compile('M600')
linear_advance = re.compile('M900\s+K(\d+)')

with open(args.files[1], 'r') as fh2:
    with open(args.out, 'w') as out:
        extruder_temp_file1 = 0
        extruder_temp_file2 = 0
        fan_speed_file2 = 0
        linear_advance_file2 = 0
        copy_file2 = False

        # Scan through 2nd file and track temp, fan state. Discard everything and stop when we hit M600.
        for line2 in fh2.readlines():
            if copy_file2:
                # print(f"taking line from file 2: {line2.rstrip()}")
                out.write(line2)

            if m := extruder_temp.match(line2):
                extruder_temp_file2 = int(m.groups()[0])
            elif m := fan_speed.match(line2):
                fan_speed_file2 = int(m.groups()[0])
            elif fan_off.match(line2):
                fan_speed_file2 = 0
            elif m := linear_advance.match(line2):
                linear_advance_file2 = int(m.groups()[0])
            elif filament_change.match(line2):
                # Copy 1st file up to M600
                with open(args.files[0], 'r') as fh1:
                    for line1 in fh1.readlines():
                        if m := extruder_temp.match(line1):
                            extruder_temp_file1 = int(m.groups()[0])
                        elif filament_change.match(line1):
                            break

                        # print(f"taking line from file 1: {line1.rstrip()}")
                        out.write(line1)

                # print(f'at splice; temp1 {extruder_temp_file1}, temp2 {extruder_temp_file2}')
                out.write('; -------------------- splice here --------------------\n')
                # this won't work: file2 gcode won't always set Z position
                # out.write('G91 ; relative position mode\n')
                # out.write('G1 Z10 F1000 ; move nozzle up to clear part\n')
                # out.write('G90 ; absolute position mode\n')
                # Set extruder temp halfway between file1 and file2
                if extruder_temp_file1 > 0 and extruder_temp_file2 > 0:
                    out.write(f'M104 S{(extruder_temp_file1 + extruder_temp_file2) // 2} ; extruder temp for filament change\n')
                out.write('M107 ; fan off\n')
                out.write('M600 ; filament change\n')
                out.write('G92 E0 ; reset extrusion distance\n')
                out.write(f'M104 S{extruder_temp_file2} ; extruder temp for 2nd filament\n')
                if fan_speed_file2 > 0:
                    out.write(f'M106 S{fan_speed_file2} ; fan for 2nd filament\n')
                if linear_advance_file2 > 0:
                    out.write(f'M900 K{linear_advance_file2} ; linear advance for 2nd filament\n')

                out.write('; -------------------- splice here --------------------\n')
                copy_file2 = True
