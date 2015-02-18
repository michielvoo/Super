; window
; Masks backgound layer 1

.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    RESET

    ; Set accumulator to 8-bit
    sep #$20

    ; Enable background layer 1
    lda #$01
    sta TM

    ; Enable screen at full brightness
    lda #$0F
    sta INIDISP

    ; Enable VBlank
    lda #NMITIMEN_NMI_ENABLE
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS