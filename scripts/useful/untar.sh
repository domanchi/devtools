#!/bin/bash

function _usage() {
    echo "Usage: untar <file>"
}

function _main() {
    if [[ $# == 0 ]]; then
        _usage
        return
    fi

    local filename=$(basename "$1")
    local extension="${filename##*.}"

    if [[ "$extension" == "bz2" ]]; then
        tar -xvf -j $1
    elif [[ "$extension" == "gz" ]]; then
        tar -xvf -z $1
    elif [[ "$extension" == "tar" ]]; then
        tar -xvf $1
    else
        echo "Unknown file type."
    fi
}
