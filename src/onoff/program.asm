; onoff
; Turn the screen on and off by pressing up and down respectively on the direction pad.

.INCLUDE "header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    RESET

    ; Set accumulator register to 8-bit
    sep #$20

    ; Set color 0 of palette 0 to white
    stz CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

    ; Enable the screen at full brightness
    lda #$0F
    sta INIDISP

    ; Enable the VBlank NMI and the joypad
    lda #(NMITIMEN_NMIENABLE | NMITIMEN_JOYENABLE)
    sta NMITIMEN

    ; Keep waiting for interrupts
-   wai
    jmp -

VBlank:
    ; Wait until the joypad input can be read
    lda #HVBJOY_JOYREADY
-   and HVBJOY
    cmp #HVBJOY_JOYREADY
    bne -

    ; Jump to label On if the up button was pressed
    lda #JOYH_UP
    and JOY1H
    cmp #JOYH_UP
    beq On

    ; Jump to label Off if the down button was pressed
    lda #JOYH_DOWN
    and JOY1H
    cmp #JOYH_DOWN
    beq Off

    rti

On:
    ; Turn on the screen at full brightness
    lda #$0F
    sta INIDISP

    rti

Off:
    ; Turn off the screen and set brightness to zero
    lda #$80
    sta INIDISP

    rti

.ENDS
