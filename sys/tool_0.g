; Toolboard 20 Tool 0
M308 S1 P"1.temp0" Y"thermistor" T100000 B4725 C7.060000e-8 R2200 A"T0"		; Thermistor for toolboard T0 extruder heater
M950 H1 C"1.out0" T1										; Heater for extruder out toolboad tool 0
M143 H1 S300                                                ; Set maximum temperature for hotend to 300C

M307 H1 A540.8 C217.6 D4.7 V23.9 B0 ;Auto tune results

M950 F1 C"1.out6"											; Define Hotend Fan on out1
M106 P1 S255 T45 H1											; Setup Hotend Fan for thermal control, full on when H1 reaches 45C

M950 F0 C"1.out7"											; Define Part Cooling fan on out2
M106 P0 C"Tool 0 - Part Fan"									; Setup Part Cooling Fan as Part Cooling T0

M563 P0 S"Tool 0" D0 H1 F0									; Px = Tool number, Dx = Drive Number (start at 0, after movement drives), Hx = Heater Number, Fx = Fan number print cooling fan

G10 P0 S0 R0												; Set tool 0 operating and standby temperatures(-273 = "off")
M572 D0 S0.05											    ; Set Pressure Advance On



;Heater 1 model: gain 540.8, time constant 217.6, dead time 4.7, max PWM 1.00, calibration voltage 23.9, mode PID
;Computed PID parameters for setpoint change: P15.4, I0.485, D50.3
;Computed PID parameters for load change: P15.4, I1.114, D50.3

 
