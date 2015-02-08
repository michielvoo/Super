; bgcolor
; Press the A, B, X and Y buttons to change the background color. 
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
    lda #$7F
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

    stz CGADD

    rep #$20

    lda #(JOY_RED + JOY_GREEN)
    and JOY1
    cmp #(JOY_RED + JOY_GREEN)
    beq Yellow

    lda #JOY_RED
    and JOY1
    cmp #JOY_RED
    beq Red

    lda #JOY_YELLOW
    and JOY1
    cmp #JOY_YELLOW
    beq Yellow

    lda #JOY_BLUE
    and JOY1
    cmp #JOY_BLUE
    beq Blue

    lda #JOY_GREEN
    and JOY1
    cmp #JOY_GREEN
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
