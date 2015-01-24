lda $80
sta INIDISP     ; Screen off, brightness to zero

stz OBSEL
stz OAMADDL
stz OAMADDH
; Clear OAMDATA

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

lda $80
sta VMAIN       ; Set VMDATA transfer mode to 16-bit
stz VMADDL
stz VMADDH
; Clear VMDATA

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

stz CGADD
; Clear CGDATA

stz W12SEL
stz W34SEL
stz WOBJSEL
stz WH0
stz WH1
stz WH2
stz WH3
stz WBGLOG
stz WOBJLOG

stz TM
stz TD
stz TMW
stz TSW

stz CGWSEL
stz CGADSUB
lda $E0
sta COLDATA     ; Set BGR to 0
stz SETINI

stz NMITIMEN
lda $FF
sta WRIO        ; Enable RDIO
stz WRMPYA
stz WRMPYB
stz WRDIVL
stz WRDIVH
stz WRDIVB
stz HTIMEL
stz HTIMEH
stz VTIMEL
stz VTIMEH
stz MDMAEN
stz HDMAEN
stz MEMSEL

stz WMADDL
stz WMADDH
stz WMADDB
; Clear WRAM
