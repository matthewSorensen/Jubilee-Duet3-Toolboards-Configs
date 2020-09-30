;Runs after freeing the previous tool if the next tool is tool #{{number}} ({{name}})
; Note: tool offsets are not applied at this point!

G0 X{{docking['x']}} Y{{docking['y'] - docking['offset']}} F17000  ; Rapid to the approach position without any current tool.
G60 S2               ; Save this position as the reference point from which to later apply new tool offsets.

