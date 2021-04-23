# Colorful bash
export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    # Inspired by https://github.com/demure/dotfiles/blob/master/subbash/prompt
    local EXIT="$?"     # this has to come first
    PS1=''

    # Colors
    local ResetColor='\[\033[m\]'
    local Yellow='\[\033[33;1m\]'
    local Green='\[\033[32m\]'
    local Blue='\[\033[36m\]'
    local GreenBold='\[\e[1;92m\]'
    local RedBold='\[\e[1;91m\]'

    # If in virtualenv, display this.
    if [[ "$VIRTUAL_ENV" ]]; then
        PS1+="(`basename "$VIRTUAL_ENV"`) "
    fi

    # Display current user
    PS1+="$Blue\u$ResetColor"
    PS1+="@"

    # Display current hostname
    PS1+="$Green\h$ResetColor"
    PS1+=":"

    # Display current path
    PS1+="$Yellow\w$ResetColor"
    PS1+=" "

    # Show different icon on error.
    if [[ "$EXIT" == 0 ]]; then
        PS1+="${GreenBold}✔$ResetColor"
    else
        PS1+="${RedBold}✘$ResetColor"
    fi

    # Display prompt on new line
    PS1+="\n\$ "
}

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
