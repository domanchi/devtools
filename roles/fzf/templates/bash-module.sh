[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# This allows for Ctrl + P to edit a file in vim.
# Use tab to indicate multiple files to load.
bind -x '"\C-p": {{ home_directory }}/.bash_scripts/fzf.sh'

# NOTE: Assumes ripgrep as a dependency (more likely to install rg than fzf)
export FZF_DEFAULT_COMMAND="rg . --files --no-ignore --hidden -g '!{.git,node_modules,venv,.tox,.idea}/*' -g '!*.pyc' 2>/dev/null"
