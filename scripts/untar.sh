#!/bin/bash
function usage() {
    echo "Usage: untar <file> (dest)"
}

function main() {
    if [[ $# == 0 ]]; then
        usage
        return 0
    fi

    local filename=$(basename "$1")
    local extension="${filename##*.}"
    local destination="$2"

    # Configure options depending on filetype.
    local fileType
    if [[ "$extension" == "bz2" ]]; then
        fileType="j"
    elif [[ "$extension" == "gz" ]]; then
        fileType="z"
    elif [[ "$extension" == "xz" ]]; then
        fileType="J"
    elif [[ "$extension" != "tar" ]]; then
        echo "Unknown file type."
        return 1
    fi

    local outputLocation=""
    if [[ ! -z "$destination" ]]; then
        if [[ ! -d "$destination" ]]; then
            mkdir -p "$destination"
        fi

        outputLocation="-C $destination"
    fi

    eval "tar -xv${fileType} -f $1 ${outputLocation}"
}

main "$@"
