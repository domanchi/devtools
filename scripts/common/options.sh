#!/bin/bash
# Provides common flags for reuse.

function main() {
    # Usage: common.options <filename> "$@"
    if [[ $# < 1 ]]; then
        echo "Wrong usage of common.options."
        return          # TODO: Change to exit
    fi

    VERBOSE_MODE=false
    FILENAME=`echo "$1" | tr "." "_"`
    shift

    # getopt process.
    # NOTE: Trailing : indicates to ignore any errors from this getopts, because
    #       inputs can be passed onto the next getopts function.
    OPTIND=1    # reset to beginning
    while getopts ":hv" opt; do
        case $opt in
            h)
                "$FILENAME"_usage
                return
                ;;

            v)
                VERBOSE_MODE=true 
                ;;
        esac
    done
}
