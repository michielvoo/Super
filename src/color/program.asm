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
    ; Switch to native mode
    clc
    xce

    .INCLUDE "../lib/initialize.asm"

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

    ; Keep waiting for the interrupts
-   wai
    jmp -

VBlank:
    ; Wait until the joypad input can be read
    lda #HVBJOY_JOYREADY
-   and HVBJOY
    cmp #HVBJOY_JOYREADY
    bne -

    ; Prepare to change color 0 of palette 0
    stz CGADD

    ; Set accumulator register to 16-bit
    rep #$20

    ; Jump to label Yellow if the A and Y buttons were pressed
    lda #(JOY_RED + JOY_GREEN)
    and JOY1
    cmp #(JOY_RED + JOY_GREEN)
    beq Yellow

    ; Jump to label Red if the A button was pressed
    lda #JOY_RED
    and JOY1
    cmp #JOY_RED
    beq Red

    ; Jump to label Yellow if the B button was pressed
    lda #JOY_YELLOW
    and JOY1
    cmp #JOY_YELLOW
    beq Yellow

    ; Jump to label Blue if the X button was pressed
    lda #JOY_BLUE
    and JOY1
    cmp #JOY_BLUE
    beq Blue

    ; Jump to label Green if the Y button was pressed
    lda #JOY_GREEN
    and JOY1
    cmp #JOY_GREEN
    beq Green

    rti

Red:
    ; Set accumulator register back to 8-bit
    sep #$20

    ; Set color 0 of palette 0 to red
    lda #%00011111
    sta CGDATA
    lda #%00000000
    sta CGDATA

    rti

Green:
    ; Set accumulator register back to 8-bit
    sep #$20

    ; Set color 0 of palette 0 to green
    lda #%11100000
    sta CGDATA
    lda #%00000011
    sta CGDATA

    rti

Blue:
    ; Set accumulator register back to 8-bit
    sep #$20

    ; Set color 0 of palette 0 to blue
    lda #%00000000
    sta CGDATA
    lda #%01111100
    sta CGDATA

    rti

Yellow:
    ; Set accumulator register back to 8-bit
    sep #$20

    ; Set color 0 of palette 0 to yellow
    lda #%11111111
    sta CGDATA
    lda #%00000011
    sta CGDATA

    rti

.ENDS
