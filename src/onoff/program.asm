; onoff
; Turn the screen on and off again by pressing up and down respectively on the direction pad.

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
    lda #$FF
    sta CGDATA
    sta CGDATA

    lda #$0F
    sta INIDISP

    lda #(NMIENABLE | JOYENABLE)
    sta NMITIMEN

    cli

-   wai
    jmp -

IRQ:
    rti

VBlank:
    lda #JOYHUP
    and JOY1H
    cmp #JOYHUP
    beq On

    lda #JOYHDOWN
    and JOY1H
    cmp #JOYHDOWN
    beq Off

    rti

On:
    lda #$0F
    sta INIDISP

    rti

Off:
    lda #$80
    sta INIDISP

    rti

.ENDS
