#!/bin/bash
function vimFZF() {
    local filesToLoad=$(fzf -m)
    if [[ ! $filesToLoad ]]; then
        return
    fi

    vim $filesToLoad
}

vimFZF
