function getPathWithSuffix() {
    # usage: getPath "<suffix>"
    local suffix="$1"

    # This list mirrors the homebrew installed packages as specified by the OSX role.
    local packages=("coreutils" "findutils" "gnu-tar" "gnu-sed" "gnutls" "gnu-getopt" "grep")

    local pkg
    local output=""
    for pkg in ${packages[@]}; do
        if [[ "$output" ]]; then
            output+=":"
        fi

        output+="$(brew --prefix $pkg)/libexec/$suffix"
    done

    echo "$output"
}

export PATH="`getPathWithSuffix 'gnubin'`:$PATH"

# We want to point `man` to the correct location too.
# We define it as such, to "hardcode" the path, so that the variable won't fall out of scope.
# TODO: It seems that normal `man` is able to identify the right man pages based on correct setting
# of path??
# alias man="_() { local path="$(getPathWithSuffix 'gnuman')"; man -M \$path "\$1" 1>/dev/null 2>&1; if [[ "\$?" == 0 ]]; then man -M \$path "\$1"; else man "\$1"; fi }; _"

unset getPathWithSuffix
