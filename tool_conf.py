import os.path

def tfree(n, park_coords, offset = 55, retract = 21):
    x,y = park_coords
    return f"""; Runs at the start of a toolchange if the current tool is tool-{n}.
; Note: tool offsets are applied at this point unless we preempt commands with G53!
    
G91                      ; Set Relative Movements
G1 Z1                    ; Pop the Z up slightly
G90                      ; Restore Absolute Movements
G53 G0 X{x} Y{y - offset} F10000  ; Rapid to the approach position with tool-{n}. (park_x, park_y - offset)
G53 G1 Y{y} F6000        ; Controlled move to the park position with tool-{n}. (park_x, park_y)
M98 P"/macros/tool_unlock.g" ; Unlock the tool
G53 G1 Y{y - retract} F6000       ; Retract the pin.
"""

def tpre(n, park_coords, offset = 55):
    x,y = park_coords

    return f""";Runs after freeing the previous tool if the next tool is tool-{n}.
; Note: tool offsets are not applied at this point!

G0 X{x} Y{y - offset} F17000  ; Rapid to the approach position without any current tool.
G60 S2               ; Save this position as the reference point from which to later apply new tool offsets.
"""


def tpost(n, park_coords, offset = 55, push = 0.5, extra_wipes = 0, wipe_offset = 4):
    x,y = park_coords

    wipes = f"""G53 G1 Y{y - wipe_offset} F10000\nG53 G1 Y{y - offset} F10000\n""" * extra_wipes

    return f"""; tpost{n}.g
; called after firmware thinks Tool{n} is selected
; Note: tool offsets are applied at this point!

M116 P0                  ; Wait for set temperatures to be reached

; Note that commands preempted with G53 will NOT apply the tool offset.

G53 G0 X{x} Y311 F17000  ; Rapid to the approach position without any current tool.
;M302 P0                  ; Prevent Cold Extrudes, just in case temp setpoints are at 0
;G1 E10 F100              ; Purge the Nozzle
;G4 S1                    ; Slight Delay
;G1 E-1.0 F2000           ; Perform a retract to remove filament pressure.
G91                      ; Set Relative Movements
G1 Z3                    ; Pop the Z up slightly to avoid scraping carriage limit switch on pull-back for early layers.
                         ; Also clear any dangling debris on purge towers.
G90                      ; Restore Absolute Movements
G53 G1 Y{y} F6000        ; Move to the pickup position with tool-0.
G53 G1 Y{y + push} F600   ; Contact the coupler by pushing on it.
M98 P"/macros/tool_lock.g" ; Lock the tool

; Retract the tool and wipe the nozzle, optionally a few times
G53 G1 Y{y - offset} F6000
{wipes}

G1 R2 X0 Y0 Z0   ; Restore prior position now accounting for new tool offset
M106 R2           ; restore print cooling fan speed
"""

tools = [(0, (10, 320)),(1, (130, 320)),(2, (210, 320))]

for t in tools:
    for prefix,f in [("tpre",tpre),("tfree",tfree),("tpost",tpost)]:

        path = os.path.join("sys", prefix + str(t[0]) + ".g")
        with open(path, "w") as fp:
            fp.write(f(*t))
    
