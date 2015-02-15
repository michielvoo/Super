This program creates a background pattern from tiles using different color palettes.

![screenshot](screenshot.png?raw=true "screenshot")

The program set the background mode to mode 0 in `BGMODE` and the tile size to 16 by 16 pixels. This makes 4 background layers available, and 4 colors for each background layer. The program sets background layer 1's tilemap segment to 1 in `BG1SC`. This segment number is shifted left by the PPU to obtain the address in VRAM (`$0400`). Background layer 1's character segment is set to 0 in `BG12NBA`. This means that characters used by tiles in the tilemap are stored in VRAM starting at address `$0000`.

The program creates color 1 of both palette 0 and palette 1. Color 1 of palette 0 is white (`$7FFF`), and color 1 of palette 1 is orange (`$FF00`).

The program then creates 4 characters in VRAM. One for each part of the 16 by 16 pixels background tile. These characters are stored in VRAM according to the documented interleaving pattern for background tiles, at address `$10`, `$20`, `$90` and `$100`. The characters all use color 1 of their tile's color palette.

Then the program creates a 16 by 1 tile map in VRAM starting at address `$0400`. All tiles in the tilemap use the same characters, but the first and the last tile use color palette 1, and the other tiles use color palette 0. Thus the first and last tile are orange, while the other tiles are white.

The program enables background layer 1 in the `TM` register and turns the screen on at full brightness in `INIDISP`.
