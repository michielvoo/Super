; move
; Moves a sprite on the screen and flips it when it changes direction

.INCLUDE "../lib/header.asm"
.INCLUDE "../lib/registers.asm"
.INCLUDE "../lib/settings.asm"
.INCLUDE "../lib/values.asm"
.INCLUDE "../lib/initialization.asm"

.BANK 0
.ORG 0

.SECTION "Main"
Reset:
    RESET

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Create a color for the sprite tile
    lda #$81
    sta CGADD
    lda #$00
    sta CGDATA
    lda #$7F
    sta CGDATA

    ; Set sprite size small to 8 by 8 pixels, large to 16 by 16 pixels
    ; and sprite character segment to 0
    stz OBSEL

    ; Select sprite table 1 record 0
    stz OAMADDH
    stz OAMADDL

    ; Create record
    lda #(SCREEN_W / 2 - 4)
    sta OAMDATA
    lda #(SCREEN_H / 2 - 4)
    sta OAMDATA
    lda #$01
    sta OAMDATA
    stz OAMDATA

    ; Select sprite table 2 record 0-3
    lda #$01
    sta OAMADDH
    stz OAMADDL

    ; Create records
    stz OAMDATA

    ; Set VRAM write mode to increment after every writing to VMDATAL
    stz VMAIN

    ; Create character 1 in sprite character segment 0 (@4bpp)
    lda #$10
    sta VMADD

    lda #%00011100
    sta VMDATAL
    lda #%00011100
    sta VMDATAL
    lda #%00011100
    sta VMDATAL
    lda #%00011100
    sta VMDATAL
    lda #%01111111
    sta VMDATAL
    lda #%00111110
    sta VMDATAL
    lda #%00011100
    sta VMDATAL
    lda #%00001000
    sta VMDATAL

    ; Enable the sprite layer
    lda #%00010000
    sta TM

    ; Enable screen and set it to full brightness
    lda #$0F
    sta INIDISP

    ; Enable VBlank and joypad auto-read
    lda #(NMITIMEN_NMI_ENABLE | NMITIMEN_JOY_ENABLE)
    sta NMITIMEN

-   wai
    jmp -

VBlank:
    ; Wait for joypad auto-read
-   lda HVBJOY
    bit #HVBJOY_JOYREADY
    bne -

    ; Reset accumulator to 16-bit
    rep #$20

    ; Get joypad input
    lda JOY1

    ; Check if up was pressed on the D-pad
    bit #JOY_UP
    bne Up

    ; Check if down was pressed on the D-pad
    bit #JOY_DOWN
    bne Down

    ; Check if left was pressed on the D-pad
    bit #JOY_LEFT
    bne Left

    ; Check if right was pressed on the D-pad
    bit #JOY_RIGHT
    bne Right

    rti

Up:
    ; Set accumulator to 9-bit mode
    sep #$20

    ; Select sprite table 1
    lda #$00
    sta OAMADDH

    ; Set sprite 0 vertical flip
    stz OAMADDL
    lda #(SCREEN_W / 2 - 4)
    sta OAMDATA
    lda #(SCREEN_H / 2 - 4)
    sta OAMDATA
    lda #$01
    sta OAMDATA
    lda #%10000000
    sta OAMDATA

    rti

Down:
    ; Set accumulator to 9-bit mode
    sep #$20

    ; Select sprite table 1
    lda #$00
    sta OAMADDH

    ; Set sprite 0 vertical flip
    stz OAMADDL
    lda #(SCREEN_W / 2 - 4)
    sta OAMDATA
    lda #(SCREEN_H / 2 - 4)
    sta OAMDATA
    lda #$01
    sta OAMDATA
    lda #%00000000
    sta OAMDATA

    rti

Left:
    rti

Right:
    rti

.ENDS








