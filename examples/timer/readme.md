This program uses a timed interrupt handler to change the backdrop color twice every frame.

(Does not work 100% correct on real hardware yet!)

![screenshot](screenshot.png?raw=true "screenshot")

The program first clears the interrupt flag in the `P` register using the `cli` instruction, then sets the backdrop color to its initial value.

Then the program creates a variable named `VTrigger` and sets its value to `0`. This value is then set as the `VTIME` value. After enabling the screen at full brightness in `INIDISP`, the program sets the system up to trigger an IRQ when the scanline is equal to the value of `VTIME`.

In the IRQ handler the value of `VTrigger` is checked. If it is zero, the backdrop color is set to a specific color, and the value of `VTIME` is changed to be equal to half the number of scanlines. This will trigger the IRQ a second time during the same frame, and then it will set the backgrop to another specific color, and change `VTIME` back to zero, to trigger the IRQ at the beginning of the next frame.
