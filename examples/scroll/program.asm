; scroll
; Move the background by changing its offset with the D-pad 

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
    lda #VMAINC_INC_L
    sta VMAINC

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
    lda #VMAINC_INC_H
    sta VMAINC

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

    ; Define some variables
    .DEFINE JOY1_VALUE $7F0000
    .DEFINE BG1HOFS_VALUE $7F0002
    .DEFINE BG1VOFS_VALUE $7F0004

    ; Initialize variables to zero
    lda #$00
    sta JOY1_VALUE
    sta BG1HOFS_VALUE
    sta BG1VOFS_VALUE

-   wai
    jmp -

VBlank:
    ; Wait for joypad auto-read
-   lda #HVBJOY_JOYREADY
    and HVBJOY
    cmp #HVBJOY_JOYREADY
    bne -

    ; Reset accumulator to 16-bit mode
    rep #$20

    ; Jump to label Up if the up button was pressed
    lda #JOY_UP
    and JOY1
    cmp #JOY_UP
    beq Up

    lda #JOY_DOWN
    and JOY1
    cmp #JOY_DOWN
    beq Down

    lda #JOY_LEFT
    and JOY1
    cmp #JOY_LEFT
    beq Left

    lda #JOY_RIGHT
    and JOY1
    cmp #JOY_RIGHT
    beq Right

None:
    rti

Up:
    ; Reset accumulator to 16-bit
    rep #$20

    ; Load current value and increment to move layer up
    lda BG1VOFS_VALUE
    inc a
    sta BG1VOFS_VALUE

    ; Set accumulator to 8-bit
    sep #$20

    ; Store low and high byte in register
    sta BG1VOFS
    xba
    sta BG1VOFS

    rti

Down:
    ; Reset accumulator to 16-bit
    rep #$20

    ; Load current value and decrement to move layer down
    lda BG1VOFS_VALUE
    dec a
    sta BG1VOFS_VALUE

    ; Set accumulator to 8-bit
    sep #$20

    ; Store low and high byte in register
    sta BG1VOFS
    xba
    sta BG1VOFS

    rti

Left:
    ; Reset accumulator to 16-bit
    rep #$20

    ; Load current value and increment to move layer left
    lda BG1HOFS_VALUE
    inc a
    sta BG1HOFS_VALUE

    ; Set accumulator to 8-bit
    sep #$20

    ; Store low and high byte in register
    sta BG1HOFS
    xba
    sta BG1HOFS

    rti

Right:
    ; Reset accumulator to 16-bit
    rep #$20

    ; Load current value and decrement to move layer right
    lda BG1HOFS_VALUE
    dec a
    sta BG1HOFS_VALUE

    ; Set accumulator to 8-bit
    sep #$20

    ; Store low and high byte in register
    sta BG1HOFS
    xba
    sta BG1HOFS

    rti

IRQ:
    lda TIMEUP
    rti

.ENDS