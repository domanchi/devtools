# Then, run it so it is aware of .activate.sh and .deactivate.sh
eval "$(~/.bash_scripts/aactivator init)"

function virtualenv() {
    # Usage: virtualenv "<name>"
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
    shift

    # If already in a virtualenv, just use this value.
    if [[ "$VIRTUAL_ENV" ]]; then
        if [[ ! "$name" ]]; then
            echo "warning: already in virtualenv! ignoring supplied name..."
        fi

        # Get the last part for name.
        # This is because $VIRTUAL_ENV gives the fully qualified path to the virtualenv root.
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
        $(pyenv which virtualenv) "$@" "$name"
    fi

    # Creating necessary files.
    ln -s "$name/bin/activate" ./.activate.sh
    echo "deactivate" > ./.deactivate.sh
}
