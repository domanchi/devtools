#!/bin/bash
function _usage() {
    echo "git.cleanup cleans up an inactive branch, both locally and on the remote repo.";
    echo "Usage: git.cleanup [-fr] <branch-name>";
    echo ""
    echo "Flags:"
    echo "  -h : shows this message"
    echo "  -f : uses 'git branch -D' rather than 'git branch -d'"
    echo "  -r : specifies remote repo. If not specified, default will be used as per script."
}

function _config() {
    DEFAULT_REMOTE_REPO="fork"
}

function _destructor() {
    unset DEFAULT_REMOTE_REPO
    unset retval
}

function _main() {
    local FORCE_FLAG=false
    local ARGS=("$@")

    # getopt process.
    OPTIND=1    # reset to beginning
    while getopts "hfr:" opt; do
        case $opt in
            h)
                _usage
                return
                ;;

            v)
                VERBOSE_MODE=true 
                ;;

            f)
                local FORCE_FLAG=true
                ;;

            r)
                DEFAULT_REMOTE_REPO=${ARGS[$OPTIND-2]}
                ;;
        esac
    done
    shift $((OPTIND-1))

    if [[ $# == 0 ]]; then
        _usage
        return
    fi

    if [[ $FORCE_FLAG == true ]]; then
        run "git branch -D "$1"" retval  
    else
        run "git branch -d "$1"" retval
    fi
    
    if [[ `echo "$retval" | grep "error"` != "" ]]; then
        echo "$retval"
        return
    fi

    run "git push $DEFAULT_REMOTE_REPO --delete $1"
}
