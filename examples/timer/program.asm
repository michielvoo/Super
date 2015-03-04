; timer
; Sets up a time to change the backdrop color twice on every frame


.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION ""

Main:
    Reset

    cli

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Set backdrop color
    stz CGADD
    lda #$FF
    sta CGDATA
    stz CGDATA

    ; Keep track of the horizontal offset to trigger IRQ
    .DEFINE VTrigger $00
    lda #$00
    sta VTrigger

    ; Set HTIME to trigger IRQ at the first pixel of the scanline
    sta VTIMEL
    sta VTIMEH

    ; Enable the screen at full brightness
    lda #$0F
    sta INIDISP

    ; Enable VBlank interrupt and enable IRQ on every scanline
    lda #NMITIMEN_IRQ_ENABLE_VTIME
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

IRQ:
    lda VTrigger

    cmp #$00
    beq +
    bne ++

    ; Set backdrop color
+   stz CGADD
    lda #%10000100
    sta CGDATA
    lda #%00010000
    sta CGDATA

    ; Set vertical IRQ trigger to 112
    lda #$70
    sta VTIMEL
    sta VTrigger

    lda TIMEUP
    rti

    ; Set backdrop color
++  stz CGADD
    lda #$FF
    sta CGDATA
    stz CGDATA

    ; Set vertical IRQ trigger to zero
    stz VTIMEL
    stz VTrigger

    lda TIMEUP
    rti

.ENDS