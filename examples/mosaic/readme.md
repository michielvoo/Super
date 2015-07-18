This program increases and decreases the size of the mosaic effect when you press up or down on the D-pad.

(Does not work on real hardware yet!)

![screenshot](screenshot.png?raw=true "screenshot")

The program first creates 3 primary colors in the color palette in `CGDATA` starting at color 4. The the program sets background mode to 0 in `BGMODE`, in which every background has 4 colors, so this palette will be refered to as palette 1. Background layer 1 is configured with default dimensions of 32 by 32 tiles and tilemap segment 1 in `BG1SC`, and background layer character segment 0 in VRAM in `BG12NBA`.

Then three characters are created in background layer character segment 0 in VRAM. Each character uses one of the primary colors for its top-left pixel and the pixel below that. Then a tilemap is created in VRAM at address `$0400` with 1024 tiles alternating between each of the three available characters. This creates the starting pattern when background layer 1 is enabled on the main screen in `TM`.

The mosaic effect is configured for background layer 1 in `MOSAIC` and its size is set to 0. When up or down are pressed on the D-pad, the VBlank interrupt handler retrieves the mosaic size from WRAM and increments or decrements its value, before setting it in `MOSAIC` again.
