#!/bin/sh


# Handle wildcard in argument
for arg in "$@"
do

    # Test argument
    if ! [ -f "$arg" ];
    then
        # Print usage
        echo "Usage: build.sh <PROGRAM ASM FILE>"
        exit 1
    fi

    echo "Building $arg..."

    # Determine file and project names
    program_file="$arg"
    if ! [[ "$program_file" = /* ]];
    then
        program_file="$(pwd)/$arg"
    fi

    program_name="${program_file##*/}"
    project_dir="${program_file%/*}"
    project_name="${project_dir##*/}"
    obj_file_name="${program_name%.*}.o"
    obj_file="$project_dir/$obj_file_name"
    link_file="$project_dir/link.txt"
    rom_file="$project_dir/$project_name.rom"

    # Remove previous build artifacts

    rm -f "$obj_file"
    rm -f "$rom_file"

    # Assemble program

    pushd "$project_dir" 1> /dev/null

    PATH=$PATH:/usr/local/bin
    wla-65816 -oiv "$program_file" "$obj_file" || { exit 1; }

    echo "# This file was auto-generated" > "$link_file"
    echo "[objects]" >> "$link_file"
    echo "$obj_file_name" >> "$link_file"

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
    if [[ $0 == /* ]];
    then
        # Path to start this script was absolute, use as is
        build_script_file="$0"
    else
        # Path to start this script was relative, make absolute
        build_script_file="$(pwd)/$0"
    fi
    build_script_dir="${build_script_file%/*}"
    upload_script_file="$build_script_dir/upload.sh"

    # Upload ROM file to cartridge or emulator for testing
    if [ -f "$upload_script_file" -a -f "$rom_file" ];
    then
        "$upload_script_file" "$rom_file"
    fi

    echo "Built $arg."
    echo 

done

if [ $# -gt 1 ];
then
    printf "Built "
    echo "$*."
fi
