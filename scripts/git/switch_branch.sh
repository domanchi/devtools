#!/bin/bash
function _usage() {
    echo "switch_branch (sb) allows quick movement between git branches, for overly long branch names.";
    echo "Usage: sb [-f] (<query>)";
    echo "  query is an optional parameter, that greps the branch name to switch to."
    echo "  When run without parameters, switch_branch will list the branches that can be switched to."
    echo ""
    echo "Flags:"
    echo "  -f : forces the switch (when git tells you that the following files will be overwritten)"
    echo "  -h : shows this message"
}

function _main() {
    local FORCE_FLAG=false

    # getopt process.
    OPTIND=1    # reset to beginning
    while getopts "hvf" opt; do
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
        esac
    done
    shift $((OPTIND-1))

    if [[ $# == 0 ]]; then
        echo "These are the branches you can switch to:"
        git branch
    elif [[ $# == 1 ]]; then
        # Switch branch based on search query
        local BRANCH=`git branch | grep "$1"`
        if [[ $BRANCH = "" ]]; then
            echo "No git branch found with that query."
            return
        elif [[ $(echo $BRANCH | wc -w) -gt 1 ]]; then
            echo "Multiple git branches found. Try a different query."
            return
        fi

        if [[ $FORCE_FLAG == true ]]; then
            local EXPECTED_ERROR_MSG="error: Your local changes to the following files would be overwritten by checkout:"
            local TEMP=$((git checkout $BRANCH) 2>&1)   # capture stderr

            local HAS_ERROR=`echo "$TEMP" | head -n 1 | grep "$EXPECTED_ERROR_MSG"`
            if [[ "$HAS_ERROR" != "" ]]; then
                # The error response is in format: \$EXPECTED_ERROR_MSG\n<list of files>\nPlease commit your changes...\nAborting
                # There's probably a better sed way to do this, but my sed skills aren't fantastic.
                # Want to only checkout the files that will be overriden, because if you checkout everything,
                # you might lose files that you wanted to keep.

                while read -r line; do
                    git checkout -- "$line"
                done <<< "$(echo "$TEMP" | sed '1d;$d;' | sed '$d')"
            fi
        fi

        git checkout $BRANCH
    fi 
}
