; mosaic
; Demonstrates the mosaic effect

.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "../lib/initialization.asm"

.ORG 0
.BANK 0

.SECTION ""

Main:
    Reset

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Enable display at full brightness
    lda #$0F
    sta INIDISP

    ; Enable VBlank
    lda #NMITIMEN_NMI_ENABLE
    sta NMITIMEN

VBlank:
    rti

.ENDS