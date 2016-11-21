#!/bin/bash
# Global Flags
VERBOSE_MODE=false
DEVTOOLS_BASEPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
DEVTOOLS_CACHE_FILE=$DEVTOOLS_BASEPATH/.cache_namespace

function devtools_main() {
    . $DEVTOOLS_BASEPATH/common/core.sh        # need to load the common functions first.

    # See if need to clear cache first.
    local filelist=`find $DEVTOOLS_BASEPATH -type f | sort`
    local public_hash=`echo -n "$filelist" | \
        sed -e "/.cache_namespace/d" -e "/.swp/d" -e "/private_main.sh/d" | \
        xargs cat | openssl sha1`
    local private_hash=`echo -n "$filelist" | \
        sed -e "/.cache_namespace/d" -e "/.swp/d" | \
        xargs cat | openssl sha1`

    # If there's no private_main, then it would just be the same.
    if [[ ! -f $DEVTOOLS_CACHE_FILE ]] || \
       [[ "#$private_hash" != `tail -n 1 "$DEVTOOLS_CACHE_FILE"` ]]; then
        clear_cache                            # so we're starting afresh

        import git
        import php
        import mac.app_interface
 
        # Save commit
        echo "#$public_hash" >> $DEVTOOLS_CACHE_FILE
    else
        . $DEVTOOLS_CACHE_FILE
    fi

    alias sb='call git.switch_branch "$@"'
    alias rmb='call git.cleanup "$@"'

    alias phpclean='call php.phpclean "$@"'
    alias stest='call php.phpunit "$@"'

    alias chrome='call mac.app_interface.chrome_main'
    alias sub='call mac.app_interface.sublime'
}

devtools_main

