#!/bin/bash
# Provides common flags for reuse.

function _main() {
    # Usage: common.options <filename> <retval_variable> "$@"
    # If retval_variable is set to true, the program will end.
    # NOTE: Cannot use more than one getopts function in a single run.
    if [[ $# < 2 ]]; then
        echo "Wrong usage of common.options."
        return          # TODO: Change to exit
    fi

    VERBOSE_MODE=false
    local FILENAME=`echo "$1" | tr "." "_"`
    shift

    # Need to remove this from the stack, else getopts won't run.
    local _RETVAL=$1
    shift

    # getopt process.
    # NOTE: Trailing : indicates to ignore any errors from this getopts, because
    #       inputs can be passed onto the next getopts function.
    OPTIND=1    # reset to beginning
    while getopts "hv" opt; do
        case $opt in
            h)
                "$FILENAME"__usage
                eval $_RETVAL=false     # default value for uninitialized values == true
                return
                ;;

            v)
                VERBOSE_MODE=true 
                ;;
        esac
    done
}
