# Installing GNU commands, because fuck BSD.

# Install coreutils if necessary.
if [[ ! `brew --prefix coreutils` ]]; then
    echo "Installing coreutils..."
    brew install coreutils findutils gnu-tar gnu-sed gnutls gnu-getopt grep
fi

# Patch PATH
gnuToolsPath="$(brew --prefix coreutils)/libexec/gnubin"
if [[ "$PATH" != *"$gnuToolsPath"* ]]; then
    export PATH="$gnuToolsPath:$PATH"
fi
unset gnuToolsPath

# We want to point `man` to the correct location too.
alias man='_() { local path="$(brew --prefix coreutils)/libexec/gnuman"; man -M $path $1 1>/dev/null 2>&1;  if [[ "$?" == 0 ]]; then man -M $path $1; else man $1; fi }; _'

