This program changes the background color when you press the A, B, X or Y button.

![screenshot](screenshot.png?raw=true "screenshot")

The program uses only color 0 of palette 0, stored at address `$00` in CGRAM. This color is the 'transparant' color and is visible when no background layers are active (nothing is set in the `TM` or `TD` registers). The program sets this color to white (15-bit value `#%0111 1111 1111 1111`), then turns on the screen on full brightness in `INIDISP`. 

The program enables NMI and joypad auto-read in `NMITIMEN`. This means that the `VBlank` interrupt handler will be called automatically, and that the joypad input can be read at the start of every frame.

In the VBlank the program waits until the joypad can be read, and then checks if one of the supported buttons was pressed. For each button it jumps to a different label. At each label the program changes color 0 of palette 0 to a diffent value.
