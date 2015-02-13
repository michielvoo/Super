This program changes the brightness of the display when you press up or down on the D-pad.

![screenshot](screenshot.png?raw=true "sprite")

The program doesn't use any background layers or sprites, it simply sets color 0 of palette 0 to white. This color is visible by default when no background layers are active.

After setting the background color, the program enables NMI and joypad auto-read, so that it can read the joypad at every VBlank in the interrupt handler. 

It also defines two names slots in WRAM for storing variables, which will be used in the VBlank interrupt handler. The brightness variable is set to the current screen brightness value, which was set just before that, when the screen was enabled.

The first variable is used to compare the joypad input with the input that was previously read. If it's the same, the program returns from the interrupt handler. This disables 'repeat' for joypad input, meaning you cannot hold a button and have it continuously have effect.

If the input is not the same, the program jumps to one of two labels based on the input. At these labels the program reads the brightness value from WRAM, increments or decrements it, uses the new value to set the screen brightness, and then saves the new value back to WRAM.
