#!/bin/bash

# Colorful bash
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

# Default options (because, why wouldn't you?)
alias vim='vim -p'
alias diff='colordiff '         # brew install colordiff (or apt-get)

# Quick Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
