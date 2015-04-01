; sprite
; Displays a multi-colored sprite.

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

    ; Set accumulator register to 8-bit
    sep #$20

; Create color palette

    ; Set color 1 of palette 8 to white
    lda #$81
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

    ; Set color 2 of palette 8 to red
    lda #%00011111
    sta CGDATA
    lda #$00
    sta CGDATA

    ; Set color 3 of palette 8 to green
    lda #%11100000
    sta CGDATA
    lda #%00000011
    sta CGDATA

    ; Set color 4 of palette 8 to blue
    lda #$00
    sta CGDATA
    lda #%01111111
    sta CGDATA

    ; Set color 5 of palette 8 to yellow
    lda #$FF
    sta CGDATA
    lda #%00000011
    sta CGDATA

; Create a sprite

    ; Set available sprite sizes to 8x8 and 16x16 and select sprite character segment 0
    stz OBSEL

    ; Select sprite table 1
    stz OAMADDH
    stz OAMADDL
    
    ; Center sprite 0 on the screen
    lda #(SCREEN_W / 2 - 8)
    sta OAMDATA
    lda #(SCREEN_H / 2 - 8)
    sta OAMDATA

    ; Sprite 0 refers to character 2
    lda #$02
    sta OAMDATA
    ; Sprite 0 refers to palette 0, has priority 0 and no flip
    stz OAMDATA

    ; Select sprite table 2
    lda #$01
    stz OAMADDL
    sta OAMADDH

    ; Set sprite 0 size to large
    lda #%00000010
    sta OAMDATA

; Create characters

    ; Set VRAM write mode to increment the VRAM address after writing VMDATAH
    lda #VMAINC_INC_H
    sta VMAINC

    ; Set VRAM address to sprite 0's character segment, character 2 (@4bpp)
    lda #$20
    sta VMADD

    ; DMA control
    lda #%00000001  ; From A-bus to B-bus, read consecutive addresses, write low + high
    sta DMAP0

    ; Set DMA destination (B-bus)
    lda #(VMDATA - BBUS_OFFSET)
    sta BBAD0

    ; Reset accumulator to 16-bit
    rep #$20

    ; Set DMA source (A-bus)
    lda #SpriteAB
    sta A1T0

    ; Set accumulator to 8-bit
    sep #$20

    lda #:SpriteAB
    sta A1B0

    ; Set DMA transfer size (number of bytes)
    lda #$40
    sta DAS0L
    stz DAS0H

    ; Initialize DMA transfer
    lda #$01
    sta MDMAEN

    ; Reset accumulator to 16-bit
    rep #$20

    ; Set VRAM address to sprite 0's character segment, character 18 (@4bpp)
    ; Characters for sprites are interleaved in VRAM, so we skipped characters for other sprites
    lda #$0120
    sta VMADD

    ; Set accumulator to 8-bit
    sep #$20

    ; DMA control
    lda #%00000001  ; From A-bus to B-bus, read consecutive addresses, write low + high
    sta DMAP0

    ; Set DMA destination (B-bus)
    lda #$18    ; VMDATA - $2100
    sta BBAD0

    ; Reset accumulator to 16-bit
    rep #$20

    ; Set DMA source (A-bus)
    lda #SpriteCD
    sta A1T0

    ; Set accumulator to 8-bit
    sep #$20

    lda #:SpriteCD
    sta A1B0

    ; Set DMA transfer size (number of bytes)
    lda #$40
    sta DAS0L
    stz DAS0H

    ; Initialize DMA transfer
    lda #$01
    sta MDMAEN

    ; Set accumulator register to 8-bit mode
    sep #$20

    ; Enable the 'sprite layer'
    lda #%00010000
    sta TM

    ; Enable the screen at full brightness
    lda #$0F
    sta INIDISP

    ; Enable VBlank
    lda #NMITIMEN_NMI_ENABLE
    sta NMITIMEN

    ; Keep waiting for interrupts
-   wai
    jmp -

VBlank:
    rti

IRQ:
    lda TIMEUP
    rti

.INCLUDE "sprite.asm"

.ENDS
