.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:

.INCDIR "../lib/"
.INCLUDE "registers.asm"
.INCLUDE "initialize.asm"

stz CGADD
lda #$FF
sta CGDATA
sta CGDATA

lda #$0F
sta INIDISP

lda #$80
sta NMITIMEN

Loop:
    jmp Loop

VBlank:
    rti

.ENDS

