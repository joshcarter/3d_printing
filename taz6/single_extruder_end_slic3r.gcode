M400 ; wait for moves to finish
M104 S0 ; turn off extruder
M140 S0 ; turn off bed
M107 ; turn off fan
G91 ; relative positioning
G1 E-1 F300 ; filament retraction to release pressure
G1 Z20 E-5 X-20 Y-20 F3000 ; lift up and retract even more filament
G1 E6 ; re-prime extruder
G90 ; absolute positioning
G1 Y280 F3000 ; present finished print
M77 ; stop GLCD timer
M84 ; disable steppers
M117 Print complete