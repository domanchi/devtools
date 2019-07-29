#!/bin/bash
function _usage() {
    echo "Usage: stest [-tf] <search_string>"
    echo "Will find and execute single test in $DEVTOOLS_PHPUNIT_DEFAULT_TEST_FOLDER"
    echo "Flags:"
    echo "  -t <relative_path> : overrides default test path, with supplied relative path."
    echo "  -f <test_case> : runs singular testcase within test file."
    echo ""
    echo "Known Bugs:"
    echo "  * If your function relies on send_mess(), for some reason, this won't work with single tests."
}

function _config() {
    # This runs in the docker env, so be sure to configure the path to fit that.
    DEVTOOLS_PHPUNIT_LOCATION="./vendor/phpunit/phpunit/phpunit"
    DEVTOOLS_PHPUNIT_DEFAULT_TEST_FOLDER="./tests/integration/_sites"
}

function _destructor() {
    unset DEVTOOLS_PHPUNIT_LOCATION
    unset DEVTOOLS_PHPUNIT_DEFAULT_TEST_FOLDER
}

function _main() {
    if [[ $# = 0 ]]; then
        _usage
        return
    fi

    local ARGS=("$@")

    # getopt process.
    OPTIND=1    # reset to beginning
    while getopts "hvt:f:" opt; do
        case $opt in
            t)
                DEVTOOLS_PHPUNIT_DEFAULT_TEST_FOLDER=./"${ARGS[$OPTIND-2]}"
                ;;

            \?) 
                echo "Unknown flag."
                _usage
                return
                ;;

            f)
                local filter=" --filter ${ARGS[$OPTIND-2]}"
                ;;

            h)
                _usage
                return
                ;;

            v)
                VERBOSE_MODE=true 
                ;;
        esac
    done

    shift $((OPTIND-1))         # pop off all flag parameters (assumes before non-option inputs)
                                # if non-option inputs are BEFORE flags, getopts doesn't even run.

    if [[ $# == 0 ]]; then
        echo "Incorrect use."
        _usage
        return
    fi

    # This runs the test in the docker environment.
    local prefix="docker-compose --project-name midkit-test --file docker-compose-test.yml run test $DEVTOOLS_PHPUNIT_LOCATION"
    local basepath=`find "$DEVTOOLS_PHPUNIT_DEFAULT_TEST_FOLDER" -path "*$1*Test.php"`

    if [[ "$basepath" == "" ]]; then
        echo "No test cases found!"
        return
    elif [[ $(echo "$basepath" | wc -w) -gt 1 ]]; then
        echo "Multiple test cases found. Which one did you mean?"
        echo "$basepath"
        return
    fi

    if [[ $VERBOSE_MODE == true ]]; then
        echo "$prefix $basepath$filter; echo ''"
    fi
    $prefix $basepath$filter; echo ''
}
