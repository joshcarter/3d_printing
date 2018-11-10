; Tool change script
M106 S255                    ; Turn on fans to speed cooling
M104 S160 T[previous_extruder] ; Cool old tool
M104 S[temperature_[next_extruder]] T[next_extruder] ; Start new tool heating
G1 X100 Y0 F4000             ; Move to wait position
M109 R[temperature_[next_extruder]] T[next_extruder] ; Wait for new tool to come up to temp
M106 S[fan0_speed_pwm]       ; Put fans back