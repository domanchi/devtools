# Reset CDPATH, so we start from a known state.
export CDPATH="."

if [[ -d "$HOME/Documents" ]]; then
    export CDPATH+=":$HOME/Documents/gitlab:$HOME/Documents/github"
fi

if [[ -d "$HOME/repos" ]]; then
    export CDPATH+=":$HOME/repos"
fi
