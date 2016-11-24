#!/bin/bash
function _usage() {
    echo "git rename allows for quick renaming of branches.";
    echo "Usage:";
    echo "  git rename <new_name>";
    echo "  git rename <old_name> <new_name>";
}

function destructor() {
    unset retval
}

function _main() {
    call common.options git.switch_branch retval "$@"
    if [[ $retval == false ]]; then
        return
    fi

    if [[ $# == 1 ]]; then
        run "git branch -m "$1""
    elif [[ $# == 2 ]]; then
        run "git branch -m "$1" "$2""
    else
        _usage
    fi
}
