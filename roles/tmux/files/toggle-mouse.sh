#!/bin/bash
mouse_mode=$(tmux show -g | grep mouse | head -n 1 | cut -d ' ' -f2)
if [[ "$mouse_mode" == "on" ]]; then
    tmux set -g mouse off \; display "mouse: OFF"
else
    tmux set -g mouse on \; display "mouse: ON"
fi
unset mouse_mode
