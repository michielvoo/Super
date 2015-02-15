#!/bin/sh

# Determine OpenEMU file name and OpenEMU library paths
rom_name="${1##*/}"
sfc=${rom_name%.*}.sfc

library="$HOME/Library/Application Support/OpenEmu/Game Library/roms"
snes="$library/Super Nintendo (SNES)"
import="$library/Automatically Import"

# Move ROM to emulator library (import or replace)
if [ -f "$snes/$sfc" ];
then
    destination="$snes/$sfc"
else
    destination="$import/$sfc"
fi

cp "$1" "$destination"
echo "Copied $rom_name to $destination"
