#!/bin/bash
import common.options

function usage() {
    echo "git.submodule allows automated updating of a submodule.";
    echo "Usage: git.submodule <path_to_submodule> (<hash>)";
    echo "  <hash> is an optional parameter, referring to the hash you want to checkout."
    echo "  If this isn't provided, it will default to HEAD."
}

function main() {
    # Don't need if statement, because [[ $# == 0 ]] already handles it.
    call common.options git.switch_branch retval "$@"

    if [[ $# == 0 ]]; then
        echo "Incorrect use."
        return
    fi

    # After the update, you can just add the submodule folder in the parent git folder.
    local current_path=$(pwd)

    # Go into git submodule, because it's a different git repo within the folder.
    cd $1

    if [[ $# == 2 ]]; then
        git checkout $2
    else
        git pull origin HEAD
    fi

    # Go back to where you were.
    cd $current_path
}
