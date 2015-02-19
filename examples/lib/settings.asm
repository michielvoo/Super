; Register settings

; Auto-increment VMADD after reading from VMDATAL or writing to VMDATAREADL
.DEFINE VMAINC_INC_L $00

; Auto-increment VMADD after reading from VMDATAH or writing to VMDATAREADH
.DEFINE VMAINC_INC_H $80

; Enable NMI
.DEFINE NMITIMEN_NMI_ENABLE $80

 ; Enable joypad auto-read
.DEFINE NMITIMEN_JOY_ENABLE $01
