; offset
; Move the background by changing its offset with the D-pad 

.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION "Main" SEMIFREE

Reset:
    RESET

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Set color 1 of palette 0 to yellow/orange
    lda #$01
    sta CGADD
    lda #$FF
    sta CGDATA
    lda #%00000010
    sta CGDATA

    ; Set background mode to 0 (4 layers with 4 colors) and tile size to 8x8
    stz BGMODE

    ; Set background layer 1 to use tilemap segment 1 (address $0400 in VRAM) for one tilemap
    lda #$04
    sta BG1SC

    ; Set background layer 1 character segment to 0 (address $0000 in VRAM)
    stz BG12NBA

    ; Set VRAM port to increment after writing VMDATAL
    lda #$00
    sta VMAIN

    ; Set VRAM address to background layer 1's character segment, character 1 (@2bpp)
    lda #$08
    sta VMADD

    ; Write bits for character 1 plane 0 (tile 1)
    lda #%00000000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL
    lda #%00001000
    sta VMDATAL
    lda #%00011100
    sta VMDATAL
    lda #%00001000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL
    lda #%00000000
    sta VMDATAL

    ; Set VRAM port to increment after writing VMDATAH
    lda #$80
    sta VMAIN

    ; Reset index registers to 16-bit mode
    rep #$10

    ; Set VRAM address to background layer 1's tilemap segment
    ldx #$0400
    stx VMADD

    ; Write background layer 1's single 32x32 tilemap
    ; Each tile refers to character 1 in the character segment
    ldx #$0400
-   lda #$01
    sta VMDATAL
    stz VMDATAH
    dex
    bne -

    ; Enable background layer 1
    lda #$01
    sta TM

    ; Enable VBlank and joypad auto-red
    lda #(NMITIMEN_NMI_ENABLE | NMITIMEN_JOY_ENABLE)
    sta NMITIMEN

    ; Enable screen at full brightness
    lda #$0F
    sta INIDISP

-   wai
    jmp -

VBlank:

    rti

.ENDS