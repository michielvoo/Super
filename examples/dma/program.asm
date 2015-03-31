; dma
; Changes the backdrop color by transferring color data to CGRAM using DMA.

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

    ; Set the accumulator to 8-bit mode
    sep #$10

    ; Enable display at full brightness
    lda #$0F
    sta INIDISP

    ; Enable VBlank
    lda #NMITIMEN_NMI_ENABLE
    sta NMITIMEN

    ; DMA control
    lda #%00000000  ; From A-bus to B-bus, read consecutive addresses
    sta DMAP0

    ; Set DMA destination (B-bus)
    lda #$22    ; CGDATA - $2100
    sta BBAD0

    ; Reset accumulator to 16-bit
    rep #$20

    ; Set DMA source (A-bus)
    lda #Color  ; Address of the defined bytes at the Color label
    sta A1T0

    ; Set accumulator to 8-bit
    sep #$20

    lda #:Color ; Bank of the defined bytes at the Color label
    sta A1B0

    ; Set DMA transfer size (number of bytes)
    lda #$02
    sta DAS0L
    stz DAS0H

    ; Set starting address
    stz CGADD

    ; Initialize DMA transfer
    lda #$01
    sta MDMAEN

-   wai
    jmp -

VBlank:
    rti;

IRQ:
    lda TIMEUP
    rti

Color:
    .db $AB, $CD

.ENDS
