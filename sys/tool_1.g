M308 S2 P"1.temp1" Y"pt1000"		; Thermistor for toolboard T1 extruder heater
M950 H2 C"1.out1" T2										; Heater for extruder out toolboad T1
M143 H2 S300												; Set maximum temperature for hotend to 300C

M307 H1 A482.6 C232.8 D5.5 V23.9 B0 ;Auto tune results


M950 F2 C"1.out4"											; Define Hotend Fan on out1
M106 P2 S255 T45 H2											; Setup Hotend Fan for thermal control, full on when H2 reaches 45C

M950 F3 C"1.out8"											; Define Part Cooling fan on out2
M106 P3 C"Tool 1 - Part Fan"									; Setup Part Cooling Fan as Part Cooling T1

M563 P1 S"Tool 1"  D1 H2 F3									; Px = Tool number, Dx = Drive Number (start at 0, after movement drives), Hx = Heater Number, Fx = Fan number print cooling fan

G10 P1 S0 R0												; Set tool 1 operating and standby temperatures(-273 = "off")
M572 D1 S0.05										        ; Set pressure advance on
