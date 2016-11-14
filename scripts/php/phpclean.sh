#!/bin/bash
# Automated phpcleaner, based off .phpcs.xml
# Best used with pre-commit (http://pre-commit.com/) that checks for .phpcs style guide.

function _usage() {
    echo "Usage:"
    echo "  -a: performs phpclean on all tracked (staged + unstaged) files."
    echo "  -f: performs phpclean on specified filename"
    echo "  -m <message>: message to commit to git. If not provided, won't be committed."
    echo "  -h: shows this help message."
}

function _config() {
    # Edit these configuration values, if necessary
    DEVTOOLS_PHPCBF_LOCATION="vendor/bin/phpcbf"        # default to cleaning only if in project root
    DEVTOOLS_PHPCS_LOCATION=".phpcs.xml"
}

function _destructor() {
    # Remove all variables declared in config.
    unset DEVTOOLS_PHPCBF_LOCATION
    unset DEVTOOLS_PHPCS_LOCATION
}

function _main() {    
    # Set initial flag values
    local FILELIST_GENERATOR=("git diff --stat --cached --name-only")
    local COMMIT_MESSAGE=""
    local ARGS=("$@")
    local FILEMODE=false
    
    if [[ ! -f $(pwd)/"$DEVTOOLS_PHPCBF_LOCATION" ]] || [[ ! -f $(pwd)/"$DEVTOOLS_PHPCS_LOCATION" ]]; then
        echo "Cannot find phpcbf. Are you sure you're in the right directory?"
        return
    fi

    # getopt process.
    OPTIND=1    # reset to beginning
    while getopts "ahm:f:v" opt; do
        case $opt in
            a)
                local FILELIST_GENERATOR[0]="git diff HEAD --name-only"
                ;;

            \?)
                echo "Unknown flag."
                usage
                return
                ;;

            m)
                local COMMIT_MESSAGE=$OPTARG
                ;;

            f)
                # If you do [[ $FILEMODE ]], it seems to check if variable exists, not its truth value
                if [[ $FILEMODE == true ]]; then
                    local FILELIST_GENERATOR=("${FILELIST_GENERATOR[@]}" "echo ${ARGS[$OPTIND-2]}") 
                else
                    local FILELIST_GENERATOR[0]="echo ${ARGS[$OPTIND-2]}" 
                fi
                local FILEMODE=true
                ;;

            h)
                usage
                return
                ;;

            v)
                VERBOSE_MODE=true 
                ;;
        esac
    done

    for files_to_clean in "${FILELIST_GENERATOR[@]}"
    do
        # Quit, if no files to clean.
        if [[ `$files_to_clean` == "" ]]; then
            echo "No files to clean!"
            return
        fi

        # Clean up php files.
        run "$files_to_clean | xargs $DEVTOOLS_PHPCBF_LOCATION --standard='$DEVTOOLS_PHPCS_LOCATION'" $VERBOSE_MODE

        # Add the cleaned php files to git, so it "saves" changes.
        run "$files_to_clean | xargs git add" $VERBOSE_MODE
    done 

    # git commit, if applicable.
    if [[ $COMMIT_MESSAGE != "" ]]; then
        run "git commit -m $COMMIT_MESSAGE" $VERBOSE_MODE
    fi
}

