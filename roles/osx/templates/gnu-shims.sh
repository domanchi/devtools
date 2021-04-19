# Prefer GNU utils
gnuToolsPath="$(brew --prefix coreutils)/libexec/gnubin"
export PATH="$gnuToolsPath:$PATH"
unset gnuToolsPath

# We want to point `man` to the correct location too.
alias man='_() { local path="$(brew --prefix coreutils)/libexec/gnuman"; man -M $path $1 1>/dev/null 2>&1;  if [[ "$?" == 0 ]]; then man -M $path $1; else man $1; fi }; _'
