; Tool change script
G91                          ; relative mode
G1 Z5 F3000                  ; raise nozzle 5mm
G90                          ; absolute mode
M106 S255                    ; Turn on fans to speed cooling
{IF NEWTOOL=0}M104 S160 T1   ; Cool old tool
{IF NEWTOOL=0}M104 S[extruder0_temperature] T0 ; Start new tool heating
{IF NEWTOOL=1}M104 S160 T0   ; Cool old tool
{IF NEWTOOL=1}M104 S[extruder1_temperature] T1 ; Start new tool heating
G1 X100 Y0 F4000             ; Move to wait position
G4 S10                       ; Pause for 10 seconds to wait for cooling
M106 S64                     ; Turn fans to 25% to balance heating/cooling
{IF NEWTOOL=0}M109 R[extruder0_temperature] T0 ; Wait for new tool to come up to temp
{IF NEWTOOL=1}M109 R[extruder1_temperature] T1 ; Wait for new tool to come up to temp
G91                          ; relative mode
G1 Z-5 F3000                 ; lower nozzle 5mm
G90                          ; absolute mode
M106 S[fan0_speed_pwm]       ; Put fans back