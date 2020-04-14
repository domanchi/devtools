# This allows for Ctrl + P to edit a file in vim.
# Use tab to indicate multiple files to load.
bind -x '"\C-p": $HOME/devtools/scripts/fzf.sh'
export FZF_DEFAULT_COMMAND="rg . --files --no-ignore --hidden -g '!{.git,node_modules,venv,.tox,.idea}/*' -g '!*.pyc' 2>/dev/null"

