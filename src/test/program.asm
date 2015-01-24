.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:

.INCDIR "../lib/"
.INCLUDE "registers.asm"
.INCLUDE "initialize.asm"

Loop:
    jmp Loop

.ENDS

