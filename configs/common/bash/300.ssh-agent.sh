# Source: https://stackoverflow.com/a/18915067
SSH_ENV="$HOME/.ssh/environment"

function start-ssh-agent {
    echo "Initializing new SSH Agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo "Succeeded!"

    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [[ -f "$SSH_ENV" ]]; then
    . "$SSH_ENV" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start-ssh-agent;
    }
else
    start-ssh-agent;
fi

unset SSH_ENV
