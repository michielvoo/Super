; sprite
; Displays a sprite that can be controlled with a controller

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

; Create color palette

    sep #$20

    lda #$81    ; Palette 8, color 1 (white)
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

; Create a sprite

    stz OBSEL   ; Sprite size is 8x8 or 16x16, sprite character segment 0

    stz OAMADDL
    stz OAMADDH
    stz OAMDATA ; x
    stz OAMDATA ; y
    stz OAMDATA ; Character 0
    stz OAMDATA ; Palette 0, priority 0, no flip
                ; Size small (8x8)

; Create a character

    lda #$00    ; Increment address after writing VMDATAL
    sta VMAIN

    ; Sprite character segment 0
    ; Character 0
    stz VMADD

    ; Character 0
    lda #%10000000
    sta VMDATAL
    lda #%11000000
    sta VMDATAL
    lda #%10100000
    sta VMDATAL
    lda #%10010000
    sta VMDATAL
    lda #%10001000
    sta VMDATAL
    lda #%10000100
    sta VMDATAL
    lda #%10000010
    sta VMDATAL
    lda #%11111111
    sta VMDATAL

; Enable background layer, screen

    lda #%00010000  ; Enable BG1
    sta TM

    lda #$0F
    sta INIDISP

    lda #NMIENABLE
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS
