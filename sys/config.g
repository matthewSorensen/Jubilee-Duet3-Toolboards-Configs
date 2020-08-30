    ; Jubilee CoreXY ToolChanging Printer - Config File
    ; This file intended for Duet 3 hardware; 6HC Mainboard; 3HC Expansion Board (CAN 1); LDO REL motor
    ; As of 4/08/2020 INCOMPLETE AND ONLY PARTIALLY TESTED.  See the discord for more info. 



; Communication and general -------------------------------------------------------------------------------------------------------------------------------------
    
    ; Debugging
    M111 S0                                     ; Debug on
    M929 P"eventlog.txt" S1                     ; Start logging to file eventlog.txt

    ; General Preferences
    M555 P2                                     ; Set Marlin-style output
    G21                                         ; Set dimensions to millimetres
    G90                                         ; Send absolute coordinates...
    M83                                         ; ...but relative extruder moves



; Axis to driver mapping -----------------------------------------------------------------------------------------------------------------------------------------
    M584 X0 Y2                                  ; X and Y for CoreXY
    M584 U1                                     ; U for toolchanger lock
    M584 Z3:4:5                                 ; Z has three drivers for kinematic bed suspension
    M584 E1.0                                   ; One extruder on the 3HC expansion board 

    M569 P0 S1                                  ; Drive 0 | X stepper   
    M569 P2 S1                                  ; Drive 2 | Y Stepper

    M569 P1 S1                                  ; Drive 1 | U Tool Changer Lock 

    M569 P3 S0                                  ; Drive 3 | Front Left Z
    M569 P4 S0                                  ; Drive 4 | Back Z
    M569 P5 S0                                  ; Drive 5 | Front Right Z

    M569 P1.0 D2  S1                            ; Drive 1.0 | Extruder 0


; Kinematics -----------------------------------------------------------------------------------------------------------------------------------------------------
    M669 K1                                     ; CoreXY mode

    ; Kinematic bed ball locations.
    ; Locations are extracted from CAD model assuming lower left build plate corner is (0, 0) on a 305x305mm plate

    M671 X297.5:150:2.5 Y313.5:-16.5:313.5 S10  ;Front Left: (297.5, 313.5) | Back: (150, -16.5) | Front Right: (2.5, 313.5)



; Axis and motor configuration -----------------------------------------------------------------------------------------------------------------------------------
    M350 X16 Y16 I1                             ; Set 16x microstepping for CoreXY axes. Use interpolation.
    M350 U4 I1                                  ; Set 4x for toolchanger lock. Use interpolation.
    M350 Z16 I1                                 ; Set 16x microstepping for Z axes. Use interpolation.
    M350 E16 I1                                 ; Set 16x microstepping for Extruder axes. Use interpolation.

    M906 X1900 Y1900 Z1700 E1250 I30            ; Motor currents (mA) and Idle percentage
    M906 U800 I60                               ; For LDO motor

    
    M201 X700 Y700 Z10 U1000 E1300          ; Accelerations (mm/s^2)
    M203 X10000 Y10000 Z500 U10000 E8000    ; Maximum speeds (mm/min)
    M566 X480 Y480 Z800 U200 E3000          ; Maximum jerk speeds mm/minute

    M92 X200 Y200                               ; Steps/mm for X,Y with 16 tooth pulleys (preferred). 
    M92 Z3200                                  ; Steps/mm for Z - TR8*4 / 0.9 deg stepper
    M92 30.578                                 ; Steps/mm for tool lock geared motor - again, LDO
    M92 E830


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


G10 P0 Z-3.20
