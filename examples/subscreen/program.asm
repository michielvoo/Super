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

    ; Create a color to use for characters on background layer 1
    lda #$01
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$33
    sta CGDATA

    ; Color to use for characters on background layer 2
    lda #$22
    sta CGADD
    lda #$FF
    sta CGDATA
    stz CGDATA

    ; Set background mode to 0 and 8 by 8 tiles (4 background layers @2bpp)
    stz BGMODE

    ; Configure background layer 1 with 32 by 32 tiles in tile segment 1 (at $0400 in VRAM)
    lda #%00000100
    sta BG1SC

    ; Configure background layer 2 with 32 by 32 tiles in tile segment 2 (at $0800 in VRAM)
    lda #%00001000
    sta BG2SC

    ; Configure background layer 1 and 2 to use background layer character segment 0
    stz BG12NBA

    ; Set VRAM port to increment after writing the low byte
    lda #VMAINC_INC_H
    sta VMAINC

    ; Create characters in background layer 1 and 2's character segment (@2bpp)
    lda #$08
    sta VMADDL
    stz VMADDH

    ; Character 1
    lda #%00000000
    sta VMDATAL
    stz VMDATAH
    lda #%00000000
    sta VMDATAL
    stz VMDATAH
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%00000000
    sta VMDATAL
    stz VMDATAH
    lda #%00000000
    sta VMDATAL
    stz VMDATAH
    lda #%00000000
    sta VMDATAL
    stz VMDATAH

    ; Character 2
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH
    stz VMDATAL
    lda #%11111111
    sta VMDATAH

    ; Set VRAM port to increment after writing high byte
    lda #VMAINC_INC_H
    sta VMAINC

    ; Reset index register to 16-bit mode
    rep #$10

; Tilemap for background layer 1

    ; Create tilemap in segment 1
    ldx #$0400
    stx VMADD

    ; Number of tiles
    ldx #$0400

    ; Create tiles
-   lda #$01
    sta VMDATAL
    stz VMDATAH
    dex
    bne -

; Tilemap for background layer 2

    ; Create tilemap in segment 2
    ldx #$0900
    stx VMADD

    ; Number of tiles
    ldx #$0100

    ; Create tiles
-   lda #$02
    sta VMDATAL
    stz VMDATAH
    dex
    bne -

    ; Enable background layer 1 on the main screen
    lda #%00000011
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