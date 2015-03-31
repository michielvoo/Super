This program uses DMA to transfer color data to CGRAM.

![screenshot](screenshot.png?raw=true "screenshot")

After initializing the screen the program sets up a DMA transfer by writing transfer settings to several registers for DMA channel 0. The program first configures the data flow in `DMAP0`. The data will flow from the A-bus to the B-bus, and the A-bus address will increment normally during transfer.

The program then sets the B-bus address in `BBAD0` which will be the destination of the data transfer. By setting the value of `BBAD0` to `$22`, the effective memory-mapped address will be `$2122`, which is the CGDATA port. The program then sets the A-bus address and bank in `A1T0` and `A1B0` respectively, using a label as a reference to the memory address of 2 defined bytes. Finally the program sets the data transfer size in `DAS0L` to `2`.

After setting up the DMA transfer, the program initializes the actual data transfer by writing `1` to `MDMAEN`.
