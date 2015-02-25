; subscreen
; This program demonstrates the difference between the main screen and the subscreen

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

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Create a color to use for characters on the background layer
    lda #$01
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$33
    sta CGDATA

    ; Set background mode to 0 and 8 by 8 tiles (4 background layers @2bpp)
    stz BGMODE

    ; Configure background layer 1 with 32 by 32 tiles in tile segment 1 (at $0400 in VRAM)
    lda #%00000100
    sta BG1SC

    ; Configure background layer 1 to use background layer character segment 0
    stz BG12NBA

    ; Set VRAM port to increment after writing the low byte
    lda #VMAINC_INC_L
    sta VMAINC

    ; Create characters in background layer 1's character segment (@2bpp)
    lda #$08
    sta VMADDL
    stz VMADDH

    ; Character 1
    lda #$00000000
    sta VMDATAL
    lda #$00000000
    sta VMDATAL
    lda #$00000001
    sta VMDATAL
    lda #$00000001
    sta VMDATAL
    lda #$00000001
    sta VMDATAL
    lda #$00000000
    sta VMDATAL
    lda #$00000000
    sta VMDATAL
    lda #$00000000
    sta VMDATAL

    ; Set VRAM port to increment after writing high byte
    lda #VMAINC_INC_H
    sta VMAINC

    ; Reset accumulator to 16-bit mode
    rep #$20

    ; Create tilemap in segment 1
    lda #$0400
    sta VMADD

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Reset index register to 16-bit mode
    rep #$10

    ; Create 1024 tiles
    ldx #$0400

    ; Create tile 1
    lda #$01
-   sta VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    dex
    bne -

    ; Enable background layer 1 on the main screen
    lda #$01
    sta TM

    ; Turn on the screen at full brightness
    lda #$0F
    sta INIDISP

    ; Enable the VBlank interrupt
    lda #NMITIMEN_NMI_ENABLE
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS