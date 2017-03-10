#!/bin/bash
# This creates pseudo namespaces by altering each function with filename prefixes.
# Eg.
#	# This imports common/core.sh
#       import common.core
#
#       # This calls the function clear_cache specifically within common/core.sh
#       call common.core.clear_cache
#
#	# This calls the main() function within common.core.
#	call common.core
#
# NOTE: Needs global variable $DEVTOOLS_BASEPATH to indicate where the
#       root directory of scripts are.
function clear_cache() {
    if [[ -f $DEVTOOLS_CACHE_FILE ]]; then
        rm $DEVTOOLS_CACHE_FILE
    fi
}

function import() {
    # Usage: import <relative_file_namespace>
    # Imports file functions, with namespaces.
    # NOTE: All functions need to be declared with `function`
    log "importing $1"

    if [[ $# != 1 ]]; then
        echo "Wrong use of import."
        return  # TODO: turn to exit
    fi

    # Convert relative_path_to_file to relative path
    local FILEPATH=$DEVTOOLS_BASEPATH/`echo "$1" | tr "." "/"`

    # Check to see if folder. If so, import everything in that folder.
    if [[ -d "$FILEPATH" ]]; then
        while read -r line; do
            import $1.${line%".sh"}
        done <<< "$(ls "$FILEPATH" | grep -e ".sh$")"
        return
    fi

    local FILEPATH=$FILEPATH.sh
    if [[ ! -f $FILEPATH ]]; then
        echo "$FILEPATH does not exist."
    fi

    # If file doesn't exist, create it.
    if [[ ! -f $DEVTOOLS_CACHE_FILE ]]; then
        echo "#!/bin/bash" > $DEVTOOLS_CACHE_FILE
    fi

    # Determine whether file is already imported, and if so, ignore.
    local PREFIX=`echo "$1" | tr "." "_"`_
    local ALREADY_IMPORTED=`grep "$PREFIX" "$DEVTOOLS_CACHE_FILE"`

    if [[ "$ALREADY_IMPORTED" != "" ]]; then
        log "$FILEPATH already imported!"
        return
    fi

    # Recursively import all files needed
    while read -r line; do
        $line
    done <<< "$(grep "^import" "$FILEPATH")"

    # Prefix functions, and output (excluding first line, and imports)
    local OUTPUT=`tail -n +2 $FILEPATH | sed "/^import/d"`

    # Rename all local function calls to new namespace
    # NOTE: This is how to do a while loop by keeping it in main shell instance
    while read -r line; do
        local FUNCTION_NAME=`echo $line | cut -d ' ' -f 2`
        local FUNCTION_NAME=${FUNCTION_NAME%"()"}       # remove trailing ()
        local OUTPUT=`echo "$OUTPUT" | \
            sed "s/function $FUNCTION_NAME/function FLUBFLUBFLUB/g; \
                 s/ $FUNCTION_NAME/ call $(echo "$PREFIX$FUNCTION_NAME" | tr "_" ".")/g; \
                 s/FLUBFLUBFLUB/$PREFIX$FUNCTION_NAME/g"`
    done <<< "$(echo "$OUTPUT" | grep "^function [a-zA-Z_]\(\)")"

    run 'echo "${OUTPUT}" >> $DEVTOOLS_CACHE_FILE'

    . $DEVTOOLS_CACHE_FILE       # finally import file
    log "Imported $FILEPATH"
}

function call() {
    # Usage: call <function_name_identifier> <arguments>
    # Calls the function, with the namespace addon.

    if [[ $# < 1 ]]; then
        echo "Wrong use of call."
        return          # TODO: Change to exit
    fi

    local FILEPATH=$DEVTOOLS_BASEPATH/`echo "$1" | tr "." "/"`.sh
    local FUNCTION_NAME=`echo "$1" | tr "." "_"`
    shift

    # Modular functionality: if you're calling a file, just try to call it's _main().
    if [[ -f $FILEPATH ]]; then
        # If there are any configurations, (stored in function `config`), call it first.
        if [[ `typeset -F | cut -d " " -f3 | grep ^"$FUNCTION_NAME"__config` != "" ]]; then
            "$FUNCTION_NAME"__config
        fi

        "$FUNCTION_NAME"__main "$@"

        # Call the destructor, if declared (which it should be, if config is declared)
        # TODO: I wonder whether this can be automated (don't need destructor), or even
        #       whether I should.
        if [[ `typeset -F | cut -d " " -f3 | grep ^"$FUNCTION_NAME"__destructor` != "" ]]; then
            "$FUNCTION_NAME"__destructor
        fi

    else
        $FUNCTION_NAME "$@"
    fi

    unset VERBOSE_MODE
}

function run() {
    # Usage: run <bash cmd> (<retval>)
    # Prints bash command for debugging, if VERBOSE_MODE is set.
    # retval can be passed in, to extract the error return value of the command.
    # NOTE: This will run in a subshell. There's no other way around it (that I currently know of)

    if [[ $# != 1 ]] && [[ $# != 2 ]]; then
        echo "Wrong use of run."
        return          # TODO: Change to exit
    fi

    local VERBOSE_FLAG=false
    if [[ $VERBOSE_MODE ]]; then
        local VERBOSE_FLAG=$VERBOSE_MODE
    fi

    if [[ $VERBOSE_FLAG == true ]]; then
        echo "$1"
    fi

    if [[ $# == 2 ]]; then
        # TODO: Gotta be really careful. One of the reasons why this wasn't working was
        # if single quotes were used inside, it would be escaped in the output.
        local TEMP=`eval $1 2>&1`
        eval $2='"$TEMP"'
    else
        eval $1
    fi
}

function log() {
    # Usage: log <log message>
    # Prints log message for debugging, only if VERBOSE_MODE is set.

    if [[ $# != 1 ]]; then
        echo "Wrong use of log."
        return          # TODO: Change to exit
    fi

    local VERBOSE_FLAG=false
    if [[ $VERBOSE_MODE ]]; then
        local VERBOSE_FLAG=$VERBOSE_MODE
    fi

    if [[ $VERBOSE_FLAG == true ]]; then
        echo $1
    fi
}
