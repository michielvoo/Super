; brightness
; Turn the brightness of the display up or down using the D-pad.

.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION "Main" SEMIFREE

Reset:
    RESET

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Set palette 0 color 0 to white
    stz CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

    ; Enable VBlank and joypad auto-read
    lda #(NMITIMEN_NMI_ENABLE | NMITIMEN_JOY_ENABLE)
    sta NMITIMEN

    ; Turn on the screen at full brightness
    lda #$0F
    sta INIDISP

    ; Save the current brightness in WRAM
    .DEFINE BRIGHTNESS $7F0000
    sta BRIGHTNESS

    ; For comparing joypad input
    .DEFINE INPUT $7F0001
    .DEFINE INPUT_PREVIOUS $7F0002

-   wai
    jmp -

VBlank:
    ; Wait until the joypad input can be read
    lda #HVBJOY_JOYREADY
-   and HVBJOY
    cmp #HVBJOY_JOYREADY
    bne -

    ; When the joypad input is the same as during the previous VBlank, return
    lda JOY1H
    sta INPUT
    cmp INPUT_PREVIOUS
    beq +
    sta INPUT_PREVIOUS

    ; Jump to label On if the up button was pressed
    lda #JOYH_UP
    and JOY1H
    cmp #JOYH_UP
    beq Brighten

    ; Jump to label Off if the down button was pressed
    lda #JOYH_DOWN
    and JOY1H
    cmp #JOYH_DOWN
    beq Dim

+   rti

Dim:
    ; Retrieve the current brightness, decrement, set screen brightness, and save value
    lda BRIGHTNESS
    beq +
    dec a
    sta INIDISP
    sta BRIGHTNESS

+   rti

Brighten:
    ; Retrieve the current brightness, increment, set screen brightness, and save value
    lda BRIGHTNESS
    cmp #$0F
    beq +
    inc a
    sta INIDISP
    sta BRIGHTNESS

+   rti

.ENDS