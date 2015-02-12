This program displayes a multi-colored 16 by 16 pixels sprite in the middle of the screen.

![screenshot](screenshot.png?raw=true "sprite")

The program starts by creating five colors in a color palette using CGRAM port. Because sprites can only use color palettes starting at address 128 in CGRAM, the program first sets `CGADD` to `$81` (skipping the first 'transparant' color).

The program then sets the `OBSEL` register, which determines which actual dimensions correspond to the 'small' and 'large' sprite size. In this program small is 8 by 8 pixels, and large is 16 by 16 pixels. 
The `OBSEL` register also determines the sprite segment in VRAM where characters (pixel data) for all sprites are stored. This program sets it to zero, which means that sprite characters are stored at the beginning of VRAM.

The program then writes a single record to sprite table 1 and sprite table 2. The record in table 1 sets the x and y coordinates of the sprite to position it at the center of the screen (x and y apply to the characters top-left corner). This record also contains a pointer to a specific character in VRAM, in this case character 2 (explained below). 
The record in table 2 sets the sprite size to large, which, when combined with the information stored in `OBSEL`, means the sprite's dimensions are 16 by 16 pixels.

Characters are always 8 by 8 pixels. So to render the large sprite the system will require 4 characters. Only the first of these has been specified in the sprite table (character 2). The other 3 characters will be selected based on the documented character interleaving pattern for sprites. So the program writes the character data according to this pattern: characters 2, 3, 18 and 19 for the top-left, top-right, bottom-left and bottom-right of the sprite respectively.

Sprites use 16 colors so sprite characters have 4 planes to set each pixel to one of 16 values. The program only needs to select from colors 0 through 5, which requires setting bits in planes 0, 1 and 3. For each of the four characters the program sets the VRAM address in `VMADD` and chooses the most efficient addressing mode by setting `VMAIN`, before writing the bytes for the character.

The sprite points to character 2, because the `RESET` macro calls the initialization routines, one of which initializes the sprite table to all zeroes. So all other available sprites point to character 0.

For the sprite to be visible the sprite layer must be enabled by setting its corresponding bit in the `TM` register.
