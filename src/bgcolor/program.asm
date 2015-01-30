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

-   wai
    jmp -

VBlank:
    lda #JOYREADY
-   and HVBJOY
    cmp #JOYREADY
    bne -

    stz CGADD

    rep #$20

    lda #(JOYA + JOYY)
    and JOY1
    cmp #(JOYA + JOYY)
    beq Yellow

    lda #JOYA
    and JOY1
    cmp #JOYA
    beq Red

    lda #JOYB
    and JOY1
    cmp #JOYB
    beq Yellow

    lda #JOYX
    and JOY1
    cmp #JOYX
    beq Blue

    lda #JOYY
    and JOY1
    cmp #JOYY
    beq Green

    rti

Red:
    sep #$20

    lda #%00011111
    sta CGDATA
    lda #%00000000
    sta CGDATA

    rti

Green:
    sep #$20

    lda #%11100000
    sta CGDATA
    lda #%00000011
    sta CGDATA

    rti

Blue:
    sep #$20

    lda #%00000000
    sta CGDATA
    lda #%01111100
    sta CGDATA

    rti

Yellow:
    sep #$20

    lda #%11111111
    sta CGDATA
    lda #%00000011
    sta CGDATA

    rti

.ENDS
