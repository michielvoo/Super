This program allows changing the horizontal and vertical offset of background layer 1 using the D-pad.

![screenshot](screenshot.png?raw=true "sprite")

The program first sets color 1 of palette 0 to orange. This color will be used by the background tiles.

Then the overall background configuration is set up. First background mode 0 is selected in register `BGMODE`, together with a tile size of 8 by 8 pixels. This makes 4 background layers available, and 4 colors for each layer. This program only uses background layer 1. 
For this layer, the tilemap segment is set to 1 in `BG1SC`, which means that the PPU will look for the layer's tilemap at address `$0400` in VRAM (the segment number is shifted to obtain the effective address in VRAM). The last part of the background layer configuration is setting its character segment in `BG12NBA` to 0. This means that pointers to characters are resolved starting at address `$00` in VRAM.

Before writing a tilemap the program first creates the character that the tiles will refer to. This will be character 1, so the VRAM address has to be set so to effectively skip over character 0. Because the color depth is 2 in background mode 0, a character takes up 8 words in VRAM. And since the VRAM ports (`VMDATA` in this program) implement double-writes, the address of character 1 `$08`.
When writing the bytes for the character, the program skips writing the high byte, by setting the VRAM port mode in `VMAIN` to increment the address after writing each low byte.

The tilemap is then created as a 32 by 32 'grid' of tiles, where each tile refers to character 1, to create the background pattern on layer 1.

Then background layer 1 is enabled in the `TM` register, and finally the program enables NMI, so the VBlank interrupt handler will be called every frame. Joypad auto-read is also enabled, so the joypad input can be read during VBlank.

After waiting for the joypad to be read, the program checks if up, down, left or right was pressed on joypad 1. It jumps to code that retrieves the current horizontal or vertical offset value of background layer 1 from WRAM, and increments or decrements it. After changing the value, it is set to register `BG1HOFS` or `BG1VOFS` and saved back to WRAM.
