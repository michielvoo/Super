; move
; Moves a sprite on the screen and flips it when it changes direction

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

    ; Create variables for the sprite coordinates
    .DEFINE SPRITE_X $7E0000
    .DEFINE SPRITE_Y $7E0001

    ; Load variables
    lda #(SCREEN_W / 2 - 4)
    sta SPRITE_X
    lda #(SCREEN_H / 2 - 4)
    sta SPRITE_Y

    ; Select sprite table 1 record 0
    stz OAMADDH
    stz OAMADDL

    ; Create record
    lda SPRITE_X
    sta OAMDATA
    lda SPRITE_Y
    sta OAMDATA
    lda #$02
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

    ; Arrow up/down
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

    ; Create character 2 in sprite character segment 0 (@4bpp)
    lda #$20
    sta VMADD

    ; Arrow left/right
    lda #%00010000
    sta VMDATAL
    lda #%00011000
    sta VMDATAL
    lda #%11111100
    sta VMDATAL
    lda #%11111110
    sta VMDATAL
    lda #%11111100
    sta VMDATAL
    lda #%00011000
    sta VMDATAL
    lda #%00010000
    sta VMDATAL
    lda #%00000000
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
    ; Set accumulator and index registers to 9-bit mode
    sep #$20

    ; Select sprite table 1
    lda #$00
    sta OAMADDH

    ; Enable sprite 0 vertical flip and move it up
    stz OAMADDL
    lda SPRITE_X
    sta OAMDATA
    lda SPRITE_Y
    dec a
    dec a
    sta SPRITE_Y
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

    ; Disable sprite 0 vertical flip
    stz OAMADDL
    lda SPRITE_X
    sta OAMDATA
    lda SPRITE_Y
    inc a
    inc a
    sta SPRITE_Y
    sta OAMDATA
    lda #$01
    sta OAMDATA
    stz OAMDATA

    rti

Left:
    ; Set accumulator to 9-bit mode
    sep #$20

    ; Select sprite table 1
    lda #$00
    sta OAMADDH

    ; Enable sprite 0 horizontal flip
    stz OAMADDL
    lda SPRITE_X
    dec a
    dec a
    sta SPRITE_X
    sta OAMDATA
    lda SPRITE_Y
    sta OAMDATA
    lda #$02
    sta OAMDATA
    lda #%01000000
    sta OAMDATA

    rti

Right:
    ; Set accumulator to 9-bit mode
    sep #$20

    ; Select sprite table 1
    lda #$00
    sta OAMADDH

    ; Enable sprite 0 horizontal flip
    stz OAMADDL
    lda SPRITE_X
    inc a
    inc a
    sta SPRITE_X
    sta OAMDATA
    lda SPRITE_Y
    sta OAMDATA
    lda #$02
    sta OAMDATA
    stz OAMDATA

    rti

.ENDS








