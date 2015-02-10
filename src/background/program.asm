; background
; Displays a background pattern.

.INCLUDE "header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION "Main"

Reset:
    RESET

    ; Set accumulator register to 8-bit
    sep #$20

    ; Set background mode to 0 (4 layers with 4 colors) and tile size to 16x16
    lda #$10
    sta BGMODE

    ; Set background layer 1 to use tilemap segment 1 (address $0400 in VRAM)
    lda #$04
    sta BG1SC

    ; Set background layer 1 to use background character segment 0 (address $0000 in VRAM)
    stz BG12NBA

    ; Set color 1 of palette 0 to white
    lda #$01
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA

    ; Set color 1 of palette 1 to orange
    lda #$05
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #$00
    sta CGDATA

    ; Set VRAM write mode to increment the VRAM address after writing VMDATAL
    ; We will not be writing VMDATAH (bits for plane 1 of the background characters)
    lda #$00
    sta VMAIN

    ; Set VRAM address to background layer 1's character segment, character 2 (@2bpp)
    lda #$10
    sta VMADD

    ; Write bits for character 2 plane 0 (tile 1 part A)
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

    ; Write bits for character 3 plane 0 (tile 1 part A)
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

    ; Set VRAM address to background layer 1's character segment, character 18 (@2bpp)
    ; Characters for 16x16 tiles are interleaved in VRAM, so we skipped characters for other tiles
    lda #$90
    sta VMADD

    ; Write bits for character 18 plane 0 (tile 1 part C)
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

    ; Write bits for character 19 plane 0 (tile 1 part D)
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

    ; Set VRAM write mode to increment the VRAM address after writing VMDATAH
    lda #$80
    sta VMAIN

    ; Reset index registers to 16-bit
    rep #$10

    ; Write tilemap segment 1 starting at tile 0
    ldx #$0400
    stx VMADD
    ; Tile 0 refers to character 2
    lda #$02
    sta VMDATAL
    ; Tile 0 uses palette 1 (where color 1 is orange)
    lda #%00000100
    sta VMDATAH

    ; The next tiles also refer to character 2
    lda #$02
    ; We will create 14 tiles in tilemap
    ldx #$000E
-   sta VMDATAL
    ; These tiles use palette 0 (where color 1 is white)
    stz VMDATAH
    dex
    bne -

    ; The last tile also refers to character 2
    lda #$02
    sta VMDATAL
    ; This tile uses palette 1 (where color 1 is orange)
    lda #%00000100
    sta VMDATAH

    ; Enable background layer 1
    lda #$01
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

.ENDS
