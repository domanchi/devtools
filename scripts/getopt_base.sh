#!/bin/bash
# NOTE: This uses getopts, which natively ships. It does not come
#       with a bunch of features, but at least its portable.
#
#       I chose this over the GNU getopt which DOES NOT come with Macs.
#       To experiment with GNU getopt, install Macports then run `port install getopt`.
#       Download Link: https://www.macports.org/install.php.
#
#       This only allows single flags, and you can run the same flag again.
#       However, on error, this quits (which is what I want).

print_usage() {
    echo "Usage:"
    echo "  -a: flag option"
    echo "  -m <message>: option with required argument"
    echo "  -h: shows this help message."
}

parser() {
    # Set initial flag values
    ARG_A="base option"

    # getopt process.
    while getopts "ahm:" opt; do
        case $opt in
            a)
                ARG_A="option A triggered"
                ;;

            h)
                print_usage
                exit 2
                ;;

            m)
                MESSAGE=$OPTARG
                ;;
            
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done

    # Do stuff with the collected arguments.
    echo "ARG_A = $ARG_A"
    if [[ $MESSAGE != "" ]]; then
        echo "...with message = $MESSAGE"
    fi
}
