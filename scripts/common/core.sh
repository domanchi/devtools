#!/bin/bash
# This creates pseudo namespaces by altering each function with filename prefixes.

CACHE_FILE=".cache_namespace"

function clear_cache() {
    rm $CACHE_FILE
}

function import() {
    # Usage: import <relative_file_namespace>
    #
    # NOTE: All functions need to be declared with `function`

    if [[ $# != 1 ]]; then
        echo "Wrong use of import."
        return  # TODO: turn to exit
    fi

    # Convert relative_path_to_file to relative path
    local FILEPATH=`echo "$1" | tr "." "/"`.sh

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

    if [[ $ALREADY_IMPORTED ]]; then
        return
    fi

    # Prefix functions, and output (excluding first line)
    # NOTE: This is how to use sed with regex
    tail -n +2 $FILEPATH | sed -e "s/function \([A-Za-z]\)/function $PREFIX\1/g" >> $CACHE_FILE

    . $CACHE_FILE       # finally import file
}

function call() {
    # Usage: call <function_name_identifier> <arguments>

    if [[ $# < 1 ]]; then
        echo "Wrong use of call."
        return          # TODO: Change to exit
    fi

    local FUNCTION_NAME=`echo "$1" | tr "." "_"`
    shift
    
    $FUNCTION_NAME "$@"
}
