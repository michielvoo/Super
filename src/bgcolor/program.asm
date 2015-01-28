; bgcolor
; Press the A, B, X and Y buttons to change the background color to red, yellow, blue or green 
; respectively. 

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
    lda #$7F
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
    lda #JOYREADY
-   and HVBJOY
    cmp #JOYREADY
    bne -

    stz CGADD

    lda #JOYLA
    and JOY1L
    cmp #JOYLA
    beq Red

    lda #JOYHB
    and JOY1H
    cmp #JOYHB
    beq Yellow

    lda #JOYLX
    and JOY1L
    cmp #JOYLX
    beq Blue

    lda #JOYHY
    and JOY1H
    cmp #JOYHY
    beq Green

    rti

Red:
    lda #%00011111
    sta CGDATA
    lda #%00000000
    sta CGDATA

    rti

Green:
    lda #%11100000
    sta CGDATA
    lda #%00000011
    sta CGDATA

    rti

Blue:
    lda #%00000000
    sta CGDATA
    lda #%01111100
    sta CGDATA

    rti

Yellow:
    lda #%11111111
    sta CGDATA
    lda #%00000011
    sta CGDATA

    rti

.ENDS
