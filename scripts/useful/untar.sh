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

    # Configure options depending on filetype.
    if [[ "$extension" == "bz2" ]]; then
        local file_type="j"
    elif [[ "$extension" == "gz" ]]; then
        local file_type="z"
    else
        echo "Unknown file type."
        return
    fi

    if [[ $# == 2 ]]; then
        if [[ ! -d $2 ]]; then
            mkdir -p $2
        fi
        local output_location="-C $2"
    fi

    eval "tar -xv${file_type} -f $1 ${output_location}"
}
