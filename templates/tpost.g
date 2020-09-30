; called after firmware thinks Tool {{number}} is selected
; Note: tool offsets are applied at this point!

M116 P0                  ; Wait for set temperatures to be reached

; Note that commands preempted with G53 will NOT apply the tool offset.

G53 G0 X{{docking['x']}} Y311 F17000  ; Rapid to the approach position without any current tool.
;M302 P0                  ; Prevent Cold Extrudes, just in case temp setpoints are at 0
;G1 E10 F100              ; Purge the Nozzle
;G4 S1                    ; Slight Delay
;G1 E-1.0 F2000           ; Perform a retract to remove filament pressure.
G91                      ; Set Relative Movements
G1 Z3                    ; Pop the Z up slightly to avoid scraping carriage limit switch on pull-back for early layers.
                         ; Also clear any dangling debris on purge towers.
G90                      ; Restore Absolute Movements
G53 G1 Y{{docking['y']}} F6000        ; Move to the pickup position with tool-0.
G53 G1 Y{{docking['y'] + docking['overshoot']}} F600   ; Contact the coupler by pushing on it.
M98 P"/macros/tool_lock.g" ; Lock the tool

; Retract the tool and wipe the nozzle, optionally a few times
G53 G1 Y{{docking['y'] - docking['offset']}} F6000
{% for item in range(wipe['n']) %}
G53 G1 Y{{docking['y'] - wipe['distance']}} F10000
G53 G1 Y{{docking['y'] - docking['offset']}}  F10000
{% endfor %}



G1 R2 X0 Y0 Z0   ; Restore prior position now accounting for new tool offset
M106 R2           ; restore print cooling fan speed

