; background
; Displays a background pattern

.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    clc
    xce

    .INCDIR "../lib/"
    .INCLUDE "registers.asm"
    .INCLUDE "initialize.asm"

    stz CGADD
    lda #$57
    sta CGDATA
    sta CGDATA

    lda #$0F
    sta INIDISP

    lda #(NMIENABLE | JOYENABLE)
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS