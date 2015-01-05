.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:

.INCDIR "../lib/"
.INCLUDE "reset.asm"

Loop:
    jmp Loop

.ENDS

