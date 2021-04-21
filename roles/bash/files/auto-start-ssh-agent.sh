# Source: https://stackoverflow.com/a/18915067
SSH_ENV="$HOME/.ssh/environment"

function start-ssh-agent() {
    echo "Initializing new SSH Agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo "Succeeded!"

    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    /usr/bin/ssh-add;
}

# For scenarios where the socket is already passed through (e.g. ssh -A),
# we don't want to override it.
if [[ `ssh-add -l` == "The agent has no identities." ]]; then
    # Source SSH settings, if applicable
    if [[ -f "$SSH_ENV" ]]; then
        . "$SSH_ENV" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start-ssh-agent;
        }
    else
        start-ssh-agent;
    fi
fi

unset SSH_ENV
unset start_ssh_agent
