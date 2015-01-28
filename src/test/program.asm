; test
; Super Nintendo experiments

.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    clc
    xce
    sei

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

    cli

-   wai
    jmp -

Loop:
    jmp Loop

IRQ:
    rti

VBlank:
    rti

.ENDS
