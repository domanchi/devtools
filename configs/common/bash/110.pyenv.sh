# We want to run pyenv in bashrc because it's responsible for
# shimming the Python binary.

# Install pyenv if necessary
# NOTE: We can't use `which pyenv` to see whether it is installed since it
# may not be in the $PATH yet. Therefore, we check the location that it
# would be installed to first.
if [[ ! -d "$HOME/.pyenv" ]]; then
    echo "Installing pyenv..."
    curl -sSL 'https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer' \
        | bash
fi

# Add to path if not already in there.
if [[ "$PATH" != *"/.pyenv/"* ]]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi
