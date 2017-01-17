#!/bin/bash

# Colorful bash
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

# Default options (because, why wouldn't you?)
alias vim='vim -p'
alias diff='colordiff '         # brew install colordiff (or apt-get)
alias du='du -h'
alias cp='rsync --progress'     # for progress bar
alias jq='jq --indent 4 -S'
alias grep="grep --color"

# Linux => Mac conversion
alias sha256sum="shasum -a 256"
alias umount="diskutil unmount"

# Quick Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias la="ls -lA"
