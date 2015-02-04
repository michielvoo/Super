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

    sep #$20

; Background

    lda #$10
    sta BGMODE  ; Mode 0, large tiles

    lda #$04
    sta BG1SC   ; Tilemap segment 1 (address $0400)

    stz BG12NBA ; Character segment 0

; Color

    lda #$01    ; Palette 0, color 1
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

; Character

    lda #$00    ; Skip the high bytes when writing the character (plane 0)
    sta VMAIN

    ldx #$08    ; Character segment 0, character 1
    stx VMADD

    ; A
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

    ; B
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

    ; C
    lda #($08 + (16 * 8) )
    sta VMADD

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

    ; D
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

    ldx #$0400  ; Tilemap segment 1
    stx VMADD
    lda #$01    ; Character 1, palette 0
    ldx #$0400  ; 32 by 32 tilemap
-   sta VMDATAL
    stz VMDATAH
    dex
    bne -

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
