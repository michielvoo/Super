This program uses color subtraction for the main screen and the subscreen.

![screenshot](screenshot.png?raw=true "screenshot")

The program first creates two colors, one for each background layer. The color for background layer 1 is in palette 1 which starts at `$00` in CGRAM. The color for background layer 2 is in the palette starting at `$20`. 

The program then sets background mode to 0 in `BGMODE`, with 4 available background layers, 4 available colors for each, and 8 by 8 pixel characters. Background layer 1 is then configured to use tilemap segment 1 (starting at `$400` in VRAM) and background layer 2 is configured to use tilemap segment 2 (starting at `$800` in VRAM).

Then two characters are created in background layer character segment 0. Both characters use the respective color 1 from the palette.

The tilemap for background layer 1 consists of 1024 tiles, completely filling the 32 by 32 tile background layer. The tilemap for background layer 2 starts at `$900` and consists of 256 tiles. This translates to a 'band' with a height of 8 characters (64 lines), running across the entire screen, starting 64 lines from the top of the screen.

Background layer 1 is enabled for the main screen in `TM` and background layer 2 is enabled for the subscreen in `TS`. Color math is set to use the subscreen in `CGWSEL` and finally color math is enabled for background layers 1 and 2, using color subtraction, in `CGADSUB`.

In the horizontal band formed by background layer 2, the color value of background layer 2 on the subscreen is subtracted from the color value of background layer 1 on the main screen.
