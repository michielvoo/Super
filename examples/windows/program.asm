; window
; Masks backgound layer 1

.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION ""

Main:
    Reset

    ; Set accumulator to 8-bit
    sep #$20

    ; Set color 1 of palette 0 (white)
    lda #$01
    sta CGADD
    lda #$CC
    sta CGDATA
    lda #$7A
    sta CGDATA

    ; Set background mode to 0 and tilesize to 8 by 8 pixels
    stz BGMODE

    ; Set background layer 1's size to 32 by 32 tiles 
    ; and its tilemap segment to 1 (at $0400 in VRAM)
    lda #%00000100
    sta BG1SC

    ; Set background layer 1's character segment to 0 (at $0400 in VRAM)
    stz BG12NBA

    ; Set VRAM port to increment address after writing lower byte
    lda #VMAINC_INC_L
    sta VMAINC

    ; Create character 1 (background layer sprite segment 0, @2bpp)
    lda #$08
    sta VMADDL

    lda #%00000000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL
    lda #%01000000
    sta VMDATAL
    lda #%00101000
    sta VMDATAL
    lda #%00010000
    sta VMDATAL
    lda #%00101000
    sta VMDATAL
    lda #%00000100
    sta VMDATAL
    lda #%00000000
    sta VMDATAL

    ; Reset accumulator to 16-bit mode
    rep #$20

    ; Create tilemap at tilemap segment 1
    lda #$0400
    sta VMADD

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Set VRAM port to increment address after writing upper byte
    lda #VMAINC_INC_H
    sta VMAINC

    ; Reset index registers to 16-bit mode
    rep #$10

    ; Create 32 by 32 tiles
    lda #$01
    ldx #$0400
-   sta VMDATAL
    stz VMDATAH
    dex
    bne -

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