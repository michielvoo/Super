#!/bin/sh

# Test argument
if ! [ -f "$1" ];
then
    # Print usage
    echo "Usage: build.sh <PROGRAM ASM FILE>"
    exit 1
fi

# Determine file and project names
program_file="$1"
if ! [[ "$program_file" = /* ]];
then
    program_file="$(pwd)/$1"
fi

program_name="${program_file##*/}"
project_dir="${program_file%/*}"
project_name="${project_dir##*/}"
obj_file="$project_dir/${program_name%.*}.o"
link_file="$project_dir/link.txt"
rom_file="$project_dir/$project_name.rom"


# Remove previous build artifacts

rm -f "$obj_file"
rm -f "$rom_file"

# Assemble program

pushd "$project_dir" 1> /dev/null

PATH=$PATH:/usr/local/bin
wla-65816 -oiv "$program_file" "$obj_file" || { exit 1; }

wlalink -irv "$link_file" "$rom_file"
while [ $? -eq 139 ];
do
    # wlalink segfaults intermittently
    wlalink -irv "$link_file" "$rom_file"
done

if [ $? -gt 0 ];
then
    # Remove intermediate build artifacts
    rm -f "$obj_file"
    exit 1
fi

popd 1> /dev/null

# Determine path to the loader
build_script_file="$(pwd)/$0"
build_script_dir="${build_script_file%/*}"
upload_script_file="$build_script_dir/upload.sh"

# Upload ROM file to cartridge or emulator for testing
if [ -f "$upload_script_file" -a -f "$rom_file" ];
then
    "$upload_script_file" "$rom_file"
fi