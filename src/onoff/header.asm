.MEMORYMAP
    SLOTSIZE $8000
    SLOT 0 START $8000

    DEFAULTSLOT 0
.ENDME

.ROMBANKSIZE $8000 
.ROMBANKS 1

.LOROM
.SNESEMUVECTOR
    RESET   Reset
.ENDEMUVECTOR

.SNESNATIVEVECTOR
    NMI VBlank
    IRQ IRQ
.ENDNATIVEVECTOR

