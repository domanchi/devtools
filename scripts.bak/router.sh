#!/bin/bash

function _main() {
    if [[ $# == 0 ]]; then
        cd $DEVTOOLS_BASEPATH
    fi

    # getopt process.
    OPTIND=1    # reset to beginning
    while getopts "f" opt; do
        case $opt in
            f)
                typeset -F | cut -d " " -f3 | grep -v "^_"
                return
                ;;
        esac
    done
}
