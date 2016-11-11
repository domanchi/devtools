#!/bin/bash
# This creates pseudo namespaces by altering each function with filename prefixes.
# Eg.
#       import common.core
#       call common.core.clear_cache
# Needs global variable $BASEPATH to indicate where the root directory of scripts are.

CACHE_FILE=$BASEPATH/.cache_namespace

function clear_cache() {
    if [[ -f $CACHE_FILE ]]; then
        rm $CACHE_FILE
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
    local FILEPATH=$BASEPATH/`echo "$1" | tr "." "/"`.sh

    if [[ ! -f $FILEPATH ]]; then
        echo "$FILEPATH does not exist."
    fi

    # If file doesn't exist, create it.
    if [[ ! -f $CACHE_FILE ]]; then
        echo "#!/bin/bash" > $CACHE_FILE
    fi

    # Determine whether file is already imported, and if so, ignore.
    local PREFIX=`echo "$1" | tr "." "_"`_
    local ALREADY_IMPORTED=`cat $FILEPATH | grep $PREFIX`

    # TODO: My hunch is that this doesn't currently work...
    if [[ $ALREADY_IMPORTED != "" ]]; then
        log "$FILEPATH already imported!"
        return
    fi

    # Recursively import all files needed
    grep "import" $FILEPATH | while read -r line; do
        $line
    done

    # Prefix functions, and output (excluding first line)
    # NOTE: This is how to use sed with regex
    run 'tail -n +2 $FILEPATH | sed "/import/d" | sed -e "s/function \([A-Za-z]\)/function $PREFIX\1/g" >> $CACHE_FILE'

    . $CACHE_FILE       # finally import file
}

function call() {
    # Usage: call <function_name_identifier> <arguments>
    # Calls the function, with the namespace addon.

    if [[ $# < 1 ]]; then
        echo "Wrong use of call."
        return          # TODO: Change to exit
    fi

    local FILEPATH=$BASEPATH/`echo "$1" | tr "." "/"`.sh
    local FUNCTION_NAME=`echo "$1" | tr "." "_"`
    shift

    # Convenience functionality: if you're calling a file, just try to call it's main().
    if [[ -f $FILEPATH ]]; then
        FUNCTION_NAME="$FUNCTION_NAME"_main
    fi

    $FUNCTION_NAME "$@"
}

function run() {
    # Usage: run <bash cmd>
    # Prints bash command for debugging, if VERBOSE_MODE is set. 

    if [[ $# != 1 ]]; then
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
    eval $1
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
