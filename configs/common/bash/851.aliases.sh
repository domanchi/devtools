# Quick Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Default options (because, why wouldn't you?)
alias cp='rsync --progress'     # for progress bar
alias du='du --human-readable'
alias jq='jq --indent 4 --sort-keys'
alias tmux='tmux -u'    # support utf-8

# Better git commands
alias gs='git status'
alias ga='git diff --staged --name-only --diff-filter=ARM | xargs git add'
