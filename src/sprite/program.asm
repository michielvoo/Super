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

    sep #$20

; Setup...

    ; ???

; Enable...

    lda #$0F
    sta INIDISP

    lda #NMIENABLE
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    rti

.ENDS
