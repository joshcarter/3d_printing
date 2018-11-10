; Taz 6 with Dual Extruder V3 start for both extruders
M75                          ; start GLCD timer
G26                          ; clear potential 'probe fail' condition
G21                          ; set units to Millimetres
M107                         ; disable fans
M420 S0                      ; disable leveling matrix
G90                          ; absolute positioning
M104 S170 T0                 ; soften filament
M104 S170 T1                 ; soften filament
M140 S[bed0_temperature]     ; get bed heating up
G28 X Y                      ; home X and Y
G1 X-17 F3000                ; clear X endstop
G1 Y258 F3000                ; move over the Z_MIN switch
G1 X-19 F3000                ; move left as far as possible
M117 Heating...              ; LCD status message
M109 R170 T0                 ; wait for temp
M109 R170 T1                 ; wait for temp
T0                           ; return to first extruder
G28 Z                        ; home Z
T0                           ; select this extruder first
M82                          ; set extruder to absolute mode
G92 E0                       ; set extruder to zero
G1  E-15 F100                ; suck up XXmm of filament
T1                           ; switch extruders
M82                          ; set extruder to absolute mode
G92 E0                       ; set extruder to zero
G1  E-15 F100                ; suck up XXmm of filament
M104 S170 T0                 ; set to wipe temp
M104 S170 T1                 ; set to wipe temp
M106                         ; Turn on fans to speed cooling
G1 X-17 Y100 F3000           ; move above wiper pad
M104
M117 Cooling...              ; LCD status message
M109 R170 T0                 ; wait for T0 to reach temp
M109 R170 T1                 ; wait for T1 to reach temp
M107                         ; Turn off fan
T0                           ; switch extruders
G1 Z1                        ; push nozzle into wiper
G1 X -18 Y95 F1000           ; slow wipe
G1 X -18 Y90 F1000           ; slow wipe
G1 X -18 Y85 F1000           ; slow wipe
G1 X -17 Y90 F1000           ; slow wipe
G1 X -18 Y80 F1000           ; slow wipe
G1 X -17 Y95 F1000           ; slow wipe
G1 X -18 Y75 F2000           ; fast wipe
G1 X -17 Y65 F2000           ; fast wipe
G1 X -18 Y70 F2000           ; fast wipe
G1 X -17 Y60 F2000           ; fast wipe
G1 X -18 Y55 F2000           ; fast wipe
G1 X -17 Y50 F2000           ; fast wipe
G1 X -18 Y40 F2000           ; fast wipe
G1 X -17 Y45 F2000           ; fast wipe
G1 X -18 Y35 F2000           ; fast wipe
G1 X -17 Y40 F2000           ; fast wipe
G1 X -18 Y70 F2000           ; fast wipe
G1 X -17 Y30 Z2 F2000        ; fast wipe
G1 X -18 Y35 F2000           ; fast wipe
G1 X -17 Y25 F2000           ; fast wipe
G1 X -18 Y30 F2000           ; fast wipe
G1 X -17 Y25 Z1.5 F1000      ; slow wipe
G1 X -18 Y23 F1000           ; slow wipe
G1 X -17 Z15                 ; raise extruder
M109 R170                    ; heat to probe temp
M204 S100                    ; set accel for probing
G29                          ; probe sequence (for auto-leveling)
M420 S1                      ; enable leveling matrix
M425 Z                       ; use measured Z backlash for compensation
M425 Z F0                    ; turn off measured Z backlash compensation (if activated in the quality settings this command will automatically be ignored)
M204 S500                    ; set accel back to normal
M104 S[extruder0_temperature] T0 ; set extruder temp
M104 S[extruder1_temperature] T1 ; set extruder temp
G1 X100 Y-25 Z0.5 F3000      ; move to open space
M400                         ; clear buffer
M117 Heating...              ; LCD status message
M109 R[extruder0_temperature] T0 ; set extruder temp and wait
M109 R[extruder1_temperature] T1 ; set extruder temp and wait
M190 S[bed0_temperature]     ; stabilize bed
M117 Purging...              ; LCD status message
T0                           ; select this extruder first
G1  E0 F100                  ; undo retraction
G92 E-15                     ; set extruder negative amount to purge
G1  E0 F100                  ; purge XXmm of filament
T1                           ; switch to second extruder
G92 E-15                     ; set extruder negative amount to purge
G1  E0 F100                  ; undo retraction
G92 E-15                     ; set extruder negative amount to purge
G1  E0 F100                  ; purge XXmm of filament
G1 Z0.5                      ; clear bed (barely)
G1 X100 Y0 F5000             ; move above bed to shear off filament
M104 S160 T1                 ; allow second extruder to start cooling
T0                           ; switch to first extruder
G1 Z2 E0 F75                 ; raise Z 2mm
M218 T1 X13 Y0               ; set offset of T1
M400                         ; clear buffer
M117 TAZ Printing...         ; LCD status message