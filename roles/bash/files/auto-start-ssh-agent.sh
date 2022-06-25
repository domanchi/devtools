# Source: https://stackoverflow.com/a/18915067
SSH_ENV="$HOME/.ssh/environment"

function start_ssh_agent() {
    echo "Initializing new SSH Agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo "Succeeded!"

    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    /usr/bin/ssh-add;
}

ssh-add -l >/tmp/ssh-add.stdout 2>/tmp/ssh-add.stderr

if [[ `cat /tmp/ssh-add.stderr` == "Could not open a connection to your authentication agent." ]]; then
    start_ssh_agent;

# For scenarios where the socket is already passed through (e.g. ssh -A),
# we don't want to override it.
elif [[ `cat /tmp/ssh-add.stdout` == "The agent has no identities." ]]; then
    # Source SSH settings, if applicable
    if [[ -f "$SSH_ENV" ]]; then
        . "$SSH_ENV" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_ssh_agent;
        }
    else
        start_ssh_agent;
    fi
fi

unset SSH_ENV
unset start_ssh_agent
rm /tmp/ssh-add.std*
