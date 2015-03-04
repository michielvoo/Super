; Register settings

; Auto-increment VMADD after reading from VMDATAL or writing to VMDATAREADL
.DEFINE VMAINC_INC_L $00

; Auto-increment VMADD after reading from VMDATAH or writing to VMDATAREADH
.DEFINE VMAINC_INC_H $80

 ; Enable joypad auto-read
.DEFINE NMITIMEN_JOY_ENABLE $01

; Enable NMI after H counter == HTIME
.DEFINE NMITIMEN_IRQ_ENABLE_HTIME %00010000

; Enable IRQ after V counter == VTIME
.DEFINE NMITIMEN_IRQ_ENABLE_VTIME %00100000

; Enable IRQ
.DEFINE NMITIMEN_NMI_ENABLE $80
