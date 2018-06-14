#!/bin/bash

function burn_iso_usage() {
    echo "Usage: burn_iso <path_to_iso>"
}

function burn_iso() {
    # This function burns an iso to a USB.
    if [[ $# == 0 ]]; then
        burn_iso_usage
        return
    fi

    echo "$1"
    if [[ ! -f $1 ]]; then
        echo "Invalid file."
        burn_iso_usage
        return
    fi

    # Display devices
    diskutil list

    local identifier=""
    read -p "Type in the identifier you wish to write to: " identifier
    
    local temp=`diskutil list | grep "$identifier"`
    if [[ $temp == "" ]]; then
        echo "Invalid identifier."
        return
    fi

    local yn=""
    while true; do
        # This isn't nice, but there's many edge cases when you want
        # to just extract those damn columns.
        read -p "Are you sure you want to write to '$temp'? [y/n] " yn
        case $yn in
            [Yy]* ) break ;;
            [Nn]* ) return ;;
            * ) echo "Please answer yes or no." ;;
        esac 
    done

    # NOTE: conv=ascii == makes it ascii output. may be needed for windows boot.
    echo "Writing....this may take a while."
    echo "NOTE: You can press Ctrl+T to see progress."
    echo "      105+0 records out means 105MB has been transferred"
    sudo dd if=$1 of=/dev/r$identifier bs=1m
}

function mount_main() {
    if [[ $# == 0 ]]; then
        df -ah
    elif [[ $# == 1 ]]; then
        hdiutil mount $1
    fi
}
