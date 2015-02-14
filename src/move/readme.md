Move the sprite accross the screen with the D-pad. The sprite changes its orientation to always point in the direction it is moving in.

![screenshot](screenshot.png?raw=true "screenshot")

The program creates two 8 by 8 pixels characters in VRAM, one of an arrow pointing down at `$10` (character 1), and one of an arrow pointing right at `$20` (character 2). Then it creates a single record for sprite 0 in sprite table 1 that points to the downwards pointing arrow.

After enabling the sprite layer in `TM`, screen display in `INIDISP`, and VBlank interrupt and joypad auto-read in `NMITIMEN`, the program waits for joypad input by checking the lowest bit of `HVBJOY`.

If the joypad input is one of up, down, left or right on the D-pad, it jumps to the corresponding label. At each label it recreates the sprite record for sprite 0 in sprite table 1. It uses vertical flip and horizontal flip to 'create' an arrow that points up or left.

The x and y coordinates of sprite 0 are stored in WRAM and incremented or decremented during VBlank based on the D-pad input. This effectively moves the arrow around the screen.
