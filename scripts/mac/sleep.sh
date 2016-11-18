#!/bin/bash
function _usage() {
    echo "A timer to put your computer to sleep after x minutes."
    echo "Usage: sleeptimer [-ah] <minutes>"
    echo "Flags:"
    echo "   -h : shows this help message"
    echo "   -a : aborts the timer."
}

function _main() {
    if [[ $# == 0 ]]; then
	_usage
	return
    fi

    OPTIND=1    # reset to beginning
    while getopts "ah" opt; do
        case $opt in
            h)
                _usage
                return
                ;;

            a)
		chmod +x "$DEVTOOLS_BASEPATH"/tmp/sleep.sh
		"$DEVTOOLS_BASEPATH"/tmp/sleep.sh
		rm "$DEVTOOLS_BASEPATH"/tmp/sleep.sh
                ;;
        esac
    done

    # Create bash script to run
    mkdir "$DEVTOOLS_BASEPATH/tmp"
    echo -e "#!/bin/bash\ncrontab -l | sed "s/$DEVTOOLS_BASEPATH\/tmp\/sleep.sh/d" | crontab -\npmset sleepnow" > "$DEVTOOLS_BASEPATH/tmp/sleep.sh"

    # Adds to crontab
    local MINUTES=$(($1*60))
    crontab -l | { cat; echo "0 $MINUTES * * * "$DEVTOOLS_BASEPATH/tmp/sleep.sh""; } | crontab -
}
