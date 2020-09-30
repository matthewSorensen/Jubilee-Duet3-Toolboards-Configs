; Runs at the start of a toolchange if the current tool is #{{number}} ({{name}})
; Note: tool offsets are applied at this point unless we preempt commands with G53!
    
G91                      ; Set Relative Movements
G1 Z1                    ; Pop the Z up slightly
G90                      ; Restore Absolute Movements
G53 G0 X{{docking['x']}} Y{{docking['y'] -docking['offset']}} F10000  ; Rapid to the approach position
G53 G1 Y{{docking['y']}} F6000        ; Controlled move to the park position
M98 P"/macros/tool_unlock.g" ; Unlock the tool
G53 G1 Y{{docking['y'] - docking['retract']}} F6000       ; Retract the pin.

