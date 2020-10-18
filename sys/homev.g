	; Home V Axis

	G91                     ; Set relative mode
	G1 V-40 F200 H1       ; Big negative move to search for endstop
	G1 V1 F500              ; Back off the endstop
	G1 V-10 F100 H1         ; Find endstop again slowly
	G90                     ; Set absolute mode
	G1 V0.5 F200
