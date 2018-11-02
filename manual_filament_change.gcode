                                ;Pause Code
G91                             ;Set Relative Mode
G1 E-5.000000 F500              ;Retract 5mm
G1 Z15 F300                     ;move Z up 15mm
G90                             ;Set Absolute Mode
G1 X20 Y20 F9000                ;Move to hold position
G91                             ;Set Relative Mode
G1 E-40 F500                    ;Retract 40mm
M104 S165 T0                    ;Lower extruder temp to 165
M0                              ;Idle Hold
M104 S[changeme] T0             ;Start extruder heating to target
G90                             ;Set Absolute Mode
G1 F5000                        ;Set speed limits
G28 X0 Y0                       ;Home X Y
M82                             ;Set extruder to Absolute Mode
G92 E0                          ;Set Extruder to 0
M109 S[changeme] T0             ;Wait for extruder to hit target temp
