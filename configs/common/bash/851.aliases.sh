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
function ga() {
    local files
    files=$(git diff --staged --name-only --diff-filter=ARM)
    if [[ "$files" == "" ]]; then
        git add -u
    else
        # The prefix removal handles the case if you're not operating at the
        # git root level.
        local prefix=$(realpath --relative-to=`git rev-parse --show-toplevel` .)
        echo "$files" | sed "s#^$prefix/##g" | xargs git add
    fi
}
