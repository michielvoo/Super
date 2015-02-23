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

    ; Create colors for tiles in palette 1 (color depth in mode 0 is 2, skip color 0)
    lda #$05
    sta CGADD

    ; Color 1 (red)
    lda #%00011111
    sta CGDATA
    stz CGDATA

    ; Color 2 (green)
    lda #%11100000
    sta CGDATA
    lda #%00000011
    sta CGDATA

    ; Color 3 (blue)
    lda #$00
    sta CGDATA
    lda #%01111100
    sta CGDATA

    ; Set background mode to 0 and tilesize to 8 by 8 pixels
    stz BGMODE

    ; Set background layer 1 to 32 by 32 tiles and its tilemap segment to 1 ($0400 in VRAM)
    lda #%00000100
    sta BG1SC

    ; Set background layer 1's character segment to 0 ($0000 in VRAM)
    stz BG12NBA

    ; Set VRAM port to increment its address after writing VMDATAH
    lda #VMAINC_INC_H
    sta VMAINC

    ; Create characters (background layer character segment 0, @2bpp)
    lda #$08
    sta VMADDL

    lda #%10000000

    ; Character 1 (top-left pixel color 1)
    sta VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH

    ; Character 2 (top-left pixel color 2)
    stz VMDATAL
    sta VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH

    ; Character 3 (top-left pixel color 3)
    sta VMDATAL
    sta VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH
    stz VMDATAL
    stz VMDATAH

    ; Reset accumulator to 16-bit mode
    rep #$20

    ; Create a tilemap in segment 1
    lda #$0400
    sta VMADD

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Set VRAM port to increment its address after writing VMDATAH
    lda #VMAINC_INC_H
    sta VMAINC

    ; Reset index registers to 16-bit mode
    rep #$10

    ; Create 32 by 32 tilemap
    ldx #$0400

    lda #$01
    pha

    ; Create 32 by 32 tilemap
    ldx #$0400
-   pla
    sta VMDATAL

    inc a
    cmp #$04
    bne +
    
    ; Rest to 1
    lda #$01
+   pha

    lda #%00000100  ; Palette 1 (starts at color $04?)
    sta VMDATAH

    dex
    bne -
    
    ; Enable background layer 1 on the main screen
    lda #$01
    sta TM

    ; Enable display at full brightness
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