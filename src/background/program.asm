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

    lda #$01    ; Palette 0, color 1
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA


    lda #$00
    sta VMAIN

    ldx #$08    ; Character segment 0, character 1
    stx VMADD

    lda #%00000000
    sta VMDATAL
    lda #%01111111
    sta VMDATAL
    lda #%01000001
    sta VMDATAL
    lda #%01000001
    sta VMDATAL
    lda #%01000001
    sta VMDATAL
    lda #%01000001
    sta VMDATAL
    lda #%01000001
    sta VMDATAL
    lda #%01111111
    sta VMDATAL


    lda #$80
    sta VMAIN

    rep #$10

    ldx #$0400  ; Tilemap segment 1
    stx VMADD
    lda #$01    ; Character 1, palette 0
    sta VMDATA


    stz BGMODE  ; Mode 0

    lda #$04
    sta BG1SC   ; Tilemap segment 1 (address $0400)

    stz BG12NBA ; Character segment 0

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
