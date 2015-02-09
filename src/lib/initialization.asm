.MACRO RESET
    ; Disable interrupts
    sei

    ; Switch to native mode
    clc
    xce

    ; Turn off decimal mode
    rep #$08

    ; Reset index registers to 16-bit mode
    rep #$10

    ; Setup the stack
    ldx #$1FFF
    txs

    jsr InitializeSystem
.ENDM

.BANK 0
.ORG 0

.SECTION "Initialization" SEMIFREE

InitializeSystem:

    jsr InitializeCPU
    jsr InitializePPU

    rts ; // InitializeSystem

InitializeCPU:

    ; Reset WRAM address to zero
    stz WMADDL
    stz WMADDH
    stz WMADDB

    ; Disable NMI, IRQ and auto-joypad read
    stz NMITIMEN

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Enable RDIO
    lda #$FF
    sta WRIO

    ; Initialize multiplication and division registers
    stz WRMPYA
    stz WRMPYB
    stz WRDIVL
    stz WRDIVH
    stz WRDIVB

    ; Initialize timer registers
    stz HTIMEL
    stz HTIMEH
    stz VTIMEL
    stz VTIMEH

    ; Initialize (H)DMA channel registers
    stz MDMAEN
    stz HDMAEN

    ; Initialize ROM speed register
    stz MEMSEL

    rts ; // InitializeCPU

InitializePPU:

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Turn off the screen and set brightness to zero
    lda #$80
    sta INIDISP

    ; Clear color palettes
    jsr ClearCGRAM
    
    ; Clear tilemaps and characters
    jsr ClearVRAM

    ; Clear sprite tables
    jsr ClearOAM

    ; Initialize sprite mode
    stz OBSEL

    ; Initialize background registers
    stz BGMODE
    stz MOSAIC
    stz BG1SC
    stz BG2SC
    stz BG3SC
    stz BG4SC
    stz BG12NBA
    stz BG34NBA
    stz BG1HOFS
    stz BG1HOFS
    stz BG1VOFS
    stz BG1VOFS
    stz BG2HOFS
    stz BG2HOFS
    stz BG2VOFS
    stz BG2VOFS
    stz BG3HOFS
    stz BG3HOFS
    stz BG3VOFS
    stz BG3VOFS
    stz BG4HOFS
    stz BG4HOFS
    stz BG4VOFS
    stz BG4VOFS

    ; Initialize mode 7 registers
    stz M7SEL
    stz M7A
    stz M7A
    stz M7B
    stz M7B
    stz M7C
    stz M7C
    stz M7D
    stz M7D
    stz M7X
    stz M7X
    stz M7Y
    stz M7Y

    ; Initialize window registers
    stz W12SEL
    stz W34SEL
    stz WOBJSEL
    stz WH0
    stz WH1
    stz WH2
    stz WH3
    stz WBGLOG
    stz WOBJLOG

    ; Initialize main and subscreen
    stz TM
    stz TD
    stz TMW
    stz TSW

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Initialize color registers
    stz CGWSEL
    stz CGADSUB
     ; Reset BGR to 0
    lda #$E0
    sta COLDATA

    ; Initialize video mode
    stz SETINI

    rts ; // InitializePPU

ClearOAM:

    ; Start at address zero
    stz OAMADDL
    stz OAMADDH

    ; Set index registers to 8-bit mode
    sep #$10

    ; Clear sprite table 1
    ldx #$80
-   stz OAMDATA
    stz OAMDATA
    stz OAMDATA
    stz OAMDATA
    dex
    bne -

    ; Clear sprite table 2
    ldx #$20
-   stz OAMDATA
    dex
    bne -

    ; Reset OAM address to zero
    stz OAMADDL
    stz OAMADDH
    
    rts ; // ClearOAM

ClearVRAM:

    ; Start at address zero
    stz VMADDL
    stz VMADDH

    ; Set accumulator to 8-bit mode
    sep #$20

    ; Set VRAM transfer mode to 16-bit
    lda #$80
    sta VMAIN

    ; Reset index registers to 16-bit mode
    rep #$10

    ; Clear VRAM
    ldx #$8000
-   stz VMDATAL
    stz VMDATAH
    dex
    bne -

    ; Reset VRAM address to zero
    stz VMADDL
    stz VMADDH

    rts ; // ClearVRAM

ClearCGRAM:

    ; Start at address zero
    stz CGADD

    ; Reset index registers to 16-bit mode
    rep #$10

    ; Clear color palettes
    ldx #$0100
-   stz CGDATA
    stz CGDATA
    dex
    bne -

    ; Reset CGRAM address to zero
    stz CGADD

    rts ; // ClearCGRAM

.ENDS