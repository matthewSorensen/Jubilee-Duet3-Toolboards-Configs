
; Communication and general -------------------------------------------------------------------------------------------------------------------------------------
    
; Debugging
M111 S0                                     ; Debug on
M929 P"eventlog.txt" S1                     ; Start logging to file eventlog.txt

; General Preferences
M555 P2                                     ; Set Marlin-style output
G21                                         ; Set dimensions to millimetres
G90                                         ; Send absolute coordinates...
M83                                         ; ...but relative extruder moves

{{driver_declarations}}

; Kinematics -----------------------------------------------------------------------------------------------------------------------------------------------------
M669 K1                                     ; CoreXY mode
    
; Kinematic bed ball locations.
; Locations are extracted from CAD model assuming lower left build plate corner is (0, 0) on a 305x305mm plate

M671 X297.5:150:2.5 Y313.5:-16.5:313.5 S10  ;Front Left: (297.5, 313.5) | Back: (150, -16.5) | Front Right: (2.5, 313.5)

{{axis_configurations}}

; Endstops, Probes, and Axis Limits --------------------------------------------------------------------------------------------------------------------------------------------
;
M574 X1 S1 P"io0.in"                        ; Set homing switch configuration Y1 = low-end, S1 = active-high (NC)
M574 Y1 S1 P"io1.in"                        ; Dito
M574 U1 S1 P"io3.in"                        ; Dito

M558 P5 C"io4.in" H3 A1 T6000 S0.02

M208 X-11.5:311.5 Y-44:341 Z-0.2:315        ; Adjusted such that (0,0) lies at the lower left corner of a 300x300mm square in the 305mmx305mm build plate
M208 U0:200



; Call out to the tool-specific file 
M98 P"/sys/tool_0.g"
M98 P"/sys/tool_1.g"
M98 P"/sys/bed_heater.g"

M563 P2 S"Pen"

G10 P0 Z-3.45
G10 P1 Z-5.7

