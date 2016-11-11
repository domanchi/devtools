#!/bin/bash
import common.options

function usage() {
    echo "switch_branch (sb) allows quick movement between git branches, for overly long branch names.";
    echo "Usage: sb (<query>)";
    echo "  query is an optional parameter, that greps the branch name to switch to."
    echo "  When run without parameters, switch_branch will list the branches that can be switched to."
}

function main() {
    call common.options switch_branch "$@"

    if [[ $# == 0 ]]; then
        #print_usage
        #echo "";

        echo "These are the branches you can switch to:"
        git branch
    elif [[ $# == 1 ]]; then
        # Switch branch based on search query
        local BRANCH=`git branch | grep "$1"`
        if [[ $BRANCH = "" ]]; then
            echo "No git branch found with that query."
        elif [[ $(echo $BRANCH | wc -w) -gt 1 ]]; then
            echo "Multiple git branches found. Try a different query."
        else
            git checkout $BRANCH
        fi
    fi 
}
