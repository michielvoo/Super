; onoff
; Turn the screen on and off again by pressing up and down respectively on the direction pad.

.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    clc
    xce

    .INCLUDE "../lib/initialize.asm"

    stz CGADD
    lda #$FF
    sta CGDATA
    sta CGDATA

    lda #$0F
    sta INIDISP

    lda #(NMITIMEN_NMIENABLE | NMITIMEN_JOYENABLE)
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    lda #HVBJOY_JOYREADY
-   and HVBJOY
    cmp #HVBJOY_JOYREADY
    bne -

    lda #JOYH_UP
    and JOY1H
    cmp #JOYH_UP
    beq On

    lda #JOYH_DOWN
    and JOY1H
    cmp #JOYH_DOWN
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
