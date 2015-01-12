#!/bin/sh

# Test argument
if ! [ -f "$1" ];
then
    # Print usage
    echo "Usage: build.sh <PROGRAM ASM FILE>"
    exit 1
fi

# Determine file and project names
program_file="$(pwd)/$1"
program_name="${program_file##*/}"
project_dir="${program_file%/*}"
project_name="${project_dir##*/}"
obj_file="$project_dir/${program_name%.*}.o"
link_file="$project_dir/link.txt"
rom_file="$project_dir/$project_name.rom"

# Assemble program

pushd "$project_dir" 1> /dev/null

wla-65816 -oiv "$program_file" "$obj_file" || { exit 1; }
wlalink -irvS "$link_file" "$rom_file" || { rm "$obj_file"; exit 1; }

popd 1> /dev/null

# Determine path to the loader
build_script_file="$(pwd)/$0"
build_script_dir="${build_script_file%/*}"
upload_script_file="$build_script_dir/upload.sh"

# Upload ROM file to cartridge or emulator for testing
if [ -f "$upload_script_file" ];
then
    "$upload_script_file" "$rom_file"
fi
