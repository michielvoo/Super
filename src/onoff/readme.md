This program turns off the screen when you press down on the D-pad. 

![screenshot](screenshot.png?raw=true "screenshot")

It enables joypad auto-read by setting the `NMITIMEN_JOY_ENABLE` value in the `NMITIMEN` register. This allows to read the `JOY1`, `JOY1L` and `JOYH` registers for the joypad input during the VBlank. Before reading it during VBlank, the program loops until the `HVBJOY` register is equal to the `HVBJOY_JOYREADY` value.

The screen is turned off by setting the most significant bit of `INIDISP` to zero. 
