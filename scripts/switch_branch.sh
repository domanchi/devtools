#!/bin/bash

switch_branch_print_usage() {
    echo -e "switch_branch (sb) allows quick movement between git branches, for overly long branch names.";
    echo -e "Usage: sb (<QUERY>)";
    echo -e "QUERY is an optional parameter, that greps the branch name to switch to."
}

switch_branch_parser() {
    if [[ $# == 0 ]]; then
        #print_usage
        #echo "";

        echo "These are the branches you can switch to:"
        git branch
    elif [[ $# == 1 ]]; then
        # Switch branch based on search query
        BRANCH=`git branch | grep "$1"`
        if [[ $BRANCH = "" ]]; then
            echo "No git branch found with that query."
        elif [[ $(echo $BRANCH | wc -w) -gt 1 ]]; then
            echo "Multiple git branches found. Try a different query."
        else
            git checkout $BRANCH
        fi
    fi 
}
