; sprite
; Displays a sprite that can be controlled with a controller
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "header.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    clc
    xce

    rep #$08

    .INCLUDE "../lib/initialize.asm"

; Create color palette

    sep #$20

    lda #$81    ; Palette 8, color 1 (white)
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

    ; Color 2 (red)
    lda #%00011111
    sta CGDATA
    lda #$00
    sta CGDATA

    ; Color 3 (green)
    lda #%11100000
    sta CGDATA
    lda #%00000011
    sta CGDATA

    ; Color 4 (blue)
    lda #$00
    sta CGDATA
    lda #%01111111
    sta CGDATA

    ; Color 5 (yellow)
    lda #$FF
    sta CGDATA
    lda #%00000011
    sta CGDATA

; Create a sprite

    stz OBSEL   ; Sprite size is 8x8 or 16x16, sprite character segment 0

    stz OAMADDH     ; Select table 1
    stz OAMADDL
    
    ; Sprite 0
    lda #(SCREEN_W / 2 - 8)
    sta OAMDATA     ; x
    lda #(SCREEN_H / 2 - 8)
    sta OAMDATA     ; y
    lda #$02
    sta OAMDATA     ; Character 2
    stz OAMDATA     ; Palette 0, priority 0, no flip

    stz OAMADDL
    lda #$01        ; Select table 2
    sta OAMADDH
    lda #%00000010
    sta OAMDATA     ; Size large (see OBSEL)

; Create a character

    lda #$80    ; Increment address after writing VMDATAH
    sta VMAIN

    ; Sprite character segment 0
    ; Character 2 (@4bpp)
    lda #$20
    sta VMADD

    ; Character 2 (A)  plane 0 + 1
    stz VMDATAL
    lda #%00000000
    sta VMDATAH
    stz VMDATAL
    lda #%01111111
    sta VMDATAH
    stz VMDATAL
    lda #%01000000
    sta VMDATAH
    stz VMDATAL
    lda #%01000000
    sta VMDATAH
    stz VMDATAL
    lda #%01000000
    sta VMDATAH
    stz VMDATAL
    lda #%01000000
    sta VMDATAH
    stz VMDATAL
    lda #%01000000
    sta VMDATAH
    stz VMDATAL
    lda #%01000000
    sta VMDATAH

    ; Character 3 (@4bpp)
    lda #$30
    sta VMADD

    ; Character 3 (B)  plane 0 + 1
    lda #%00000000
    sta VMDATAL
    sta VMDATAH
    lda #%01111111
    sta VMDATAL
    sta VMDATAH
    lda #%00000001
    sta VMDATAL
    sta VMDATAH
    lda #%00000001
    sta VMDATAL
    sta VMDATAH
    lda #%00000001
    sta VMDATAL
    sta VMDATAH
    lda #%00000001
    sta VMDATAL
    sta VMDATAH
    lda #%10000001
    sta VMDATAL
    lda #%00000001
    sta VMDATAH
    lda #%10000001
    sta VMDATAL
    lda #%00000001
    sta VMDATAH

    rep #$20

    ; Skip to character 18 (@4bpp)
    lda #$0120
    sta VMADD

    sep #$20

    ; Character 18 (C)  plane 0 + 1
    lda #%00000011
    sta VMDATAL
    stz VMDATAH
    lda #%00000000
    sta VMDATAL
    stz VMDATAH
    lda #%00000000
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

    ; Character 18 (C)  plane 2 + 3
    lda #%00000000
    sta VMDATAL
    stz VMDATAH
    lda #%01000000
    sta VMDATAL
    stz VMDATAH
    lda #%01000000
    sta VMDATAL
    stz VMDATAH
    lda #%01000000
    sta VMDATAL
    stz VMDATAH
    lda #%01000000
    sta VMDATAL
    stz VMDATAH
    lda #%01000000
    sta VMDATAL
    stz VMDATAH
    lda #%01000000
    sta VMDATAL
    stz VMDATAH
    lda #%01111111
    sta VMDATAL
    stz VMDATAH

    rep #$20

    ; Skip to character 19 (@4bpp)
    lda #$0130
    sta VMADD

    sep #$20

    ; Character 19 (D) plane 0 + 1
    lda #%11100000
    sta VMDATAL
    stz VMDATAH
    lda #%10000001
    sta VMDATAL
    stz VMDATAH
    lda #%10000001
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
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%01111111
    sta VMDATAL
    stz VMDATAH

    ; Character 19 (D) plane 2 + 3
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
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%00000001
    sta VMDATAL
    stz VMDATAH
    lda #%01111111
    sta VMDATAL
    stz VMDATAH

; Enable background layer, screen

    sep #$20

    lda #%00010000  ; Enable BG1
    sta TM

    lda #$0F
    sta INIDISP

    lda #NMITIMEN_NMIENABLE
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS
