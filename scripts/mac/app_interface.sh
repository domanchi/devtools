#!/bin/bash
function sublime() {
    # Usage: sublime <file>.
    # Opens a file in sublime.
    if [[ $# != 1 ]]; then
        echo "Incorrect use."
        return
    fi

    open -a '/Applications/Sublime Text.app' $(pwd)/$1
}

function chrome_usage() {
    echo "Usage: chrome [-fu]"
    echo "Opens a file, or url in Google Chrome."
    echo "Flags:"
    echo "  -u <url> : indicates a url to open."
    echo "  -f <relative_path_to_file> : indicates a file to open."
}

function chrome_main() {
    local ARGS=("$@")
    local ARR=()

    # getopt process.
    OPTIND=1    # reset to beginning
    while getopts "hvf:u:" opt; do
        case $opt in
            h)
                chrome_usage
                return
                ;;

            \?)
                echo "Unknown flag."
                chrome_usage
                return
                ;;

            f)
                local ARR=("${ARR[@]}" $(pwd)/"${ARGS[$OPTIND-2]}") 
                ;;

            u)
                local ARR=("${ARR[@]}" "${ARGS[$OPTIND-2]}") 
                ;;

            v)
                VERBOSE_MODE=true 
                ;;
        esac
    done

    if [[ ! $ARR ]]; then
        echo "No files to open!"
        chrome_usage
        return
    fi

    local TEMP="${ARR[@]}"      # need to expand array first, before sending into run
    run "open -a '/Applications/Google Chrome.app' $TEMP"
}
