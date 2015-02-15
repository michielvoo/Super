This program changes the brightness of the display when you press up or down on the D-pad.

![screenshot](screenshot.png?raw=true "screenshot")

The program doesn't use any background layers or sprites, it simply sets color 0 of palette 0 (at CGRAM address `$00`) to white. This color is visible by default when no background layers are active.

After setting the background color, the program enables NMI and joypad auto-read in `NMITIMEN`, so that it can read the joypad at the beginning of every frame in the `VBlank` interrupt handler. 

It also defines two names slots in WRAM for storing variables, which will be used in the `VBlank` interrupt handler. The brightness variable is set to the current screen brightness value, which was set just before that, when the screen was enabled in `INIDISP`.

The first variable is used to compare the joypad input with the input that was previously read. If it's the same, the program returns from the interrupt handler by jumping forward to the `rti` instruction. This disables 'repeat' for joypad input, meaning you cannot hold a button and have it continuously have effect.

If the input is not the same, the program jumps to one of two labels based on the input. At these labels the program reads the brightness value from WRAM (`lda`), increments or decrements it (`inc a` or `dec a`), uses the new value to set the screen brightness in `INIDISP`, and then saves the new value back to WRAM (`sta`).
