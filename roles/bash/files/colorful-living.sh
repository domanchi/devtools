# Colorful bash
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\n\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Default options
alias grep='grep --color'

# Unfortunately, BSD doesn't support long arguments (wtf).
# If you need to do converting:
#   --color          => -G
#   --human-readable => -h
#   --ignore         => -I
# However, if you use this with devtools, GNU should be auto-installed.
alias ls='`which ls` --color -Fh -I "*.pyc"'
alias la='ls -lA'
