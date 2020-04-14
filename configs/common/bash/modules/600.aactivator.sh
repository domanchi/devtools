# First, check to see if the aactivator script is installed.
if [[ ! -f "$HOME/devtools/scripts/aactivator" ]]; then
    echo "Installing aactivator..."
    curl -sSL 'https://raw.githubusercontent.com/Yelp/aactivator/master/aactivator.py' \
        > "$HOME/devtools/scripts/aactivator"

    chmod +x "$HOME/devtools/scripts/aactivator"
    echo "Install complete!"
fi

# Then, run it so it is aware of .activate.sh and .deactivate.sh
eval "$("$HOME/devtools/scripts/aactivator" init)"

function build-venv {
    # Usage: build-venv "<name>"
    # Parameters:
    #   - name: directory name of virtualenv.

    # First, check to see if there's any work to be done.
    if [[ -f "./.activate.sh" ]] && [[ -f "./.deactivate.sh" ]];
    then
        echo "Already initialized!"
        return 0
    fi

    # To make sure we aren't replacing any existing files, check to see
    # if any of these files exist first.
    if [[ -f "./.activate.sh" ]] || [[ -f "./.deactivate.sh" ]];
    then
        echo "error: only one file found. You should manually recreate the rest."
        return 1
    fi

    local name="$1"

    # If already in a virtualenv, just use this value.
    if [[ "$VIRTUAL_ENV" ]]; then
        if [[ ! "$name" ]]; then
            echo "warning: already in virtualenv! ignoring supplied name..."
        fi

        # Get the last part for name.
        local parts
        IFS='/'
        read -ra parts <<< "$VIRTUAL_ENV"
        name="${parts[-1]}"
    fi

    # Set default value after checking if a value can be derived from the
    # current virtualenv.
    if [[ -z "$name" ]]; then
        name="venv"
    fi

    if [[ ! -f "$name/bin/activate" ]]; then
        echo "error: can't find activator file."
        return 1
    fi

    # Creating necessary files.
    ln -s "$name/bin/activate" ./.activate.sh
    echo "deactivate" > ./.deactivate.sh
    echo "Created!"
}
