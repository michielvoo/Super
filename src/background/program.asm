; background
; Displays a background pattern

.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    clc
    xce

    rep #$08

    .INCDIR "../lib"
    .INCLUDE "registers.asm"
    .INCLUDE "initialize.asm"

; Background

    sep #$20

    lda #$10
    sta BGMODE  ; Mode 0, 16 x 16 tiles

    lda #$04
    sta BG1SC   ; Background layer 1 uses tilemap segment 1 (address $0400 in VRAM)

    stz BG12NBA ; Background layer 1 uses character segment 0 (address $0000 in VRAM)

; Color

    lda #$01    ; Palette 0, color 1 (white)
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

    lda #$05    ; Palette 1, color 1 (orange)
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$00
    sta CGDATA

; Character

    lda #$00    ; Increment address after writing VMDATAL
    sta VMAIN

    ; Character segment 0
    ; Skip to character 2 (@2bpp)
    ldx #$0010
    stx VMADD

    ; Character 2 (tile 1 part A)
    lda #%00000000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL
    lda #%00111111
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL

    ; Character 3 (tile 1 part B)
    lda #%00000000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL
    lda #%11111110
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL

    ; Skip to character 18 (@2bpp)
    ldx #$0090
    stx VMADD

    ; Character 18 (tile 1 part C)
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00100000
    sta VMDATAL
    lda #%00111111
    sta VMDATAL
    lda #%00000000
    sta VMDATAL

    ; Character 19 (tile 1 part D)
    lda #%10000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%00000010
    sta VMDATAL
    lda #%11111110
    sta VMDATAL
    lda #%00000000
    sta VMDATAL

; Tilemap

    lda #$80
    sta VMAIN

    rep #$10

    ldx #$0400      ; Tilemap segment 1, tile 0 (first tile)
    stx VMADD
    lda #$02        ; Refer to character 2, ...
    sta VMDATAL
    lda #%00000100  ; ... using color 1 of palette 1 (orange)
    sta VMDATAH

    lda #$02    ; Refer to character 2, ...
    ldx #$000E  ; Create 14 tiles in tilemap
-   sta VMDATAL
    stz VMDATAH ; ... using color 1 of palette 0 (white)
    dex
    bne -

    lda #$02        ; Refer to character 2, ...
    sta VMDATAL
    lda #%00000100  ; ... using color 1 of palette 1 (orange)
    sta VMDATAH

; Enable

    lda #$01
    sta TM      ; Background layer 1

    lda #$0F
    sta INIDISP

    lda #NMIENABLE
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS
