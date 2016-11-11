#!/bin/bash
# Global Flags
VERBOSE_MODE=false

DEVTOOLS_BASEPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

. $DEVTOOLS_BASEPATH/common/core.sh        # need to load the common functions first.
clear_cache                                # so we're starting afresh

import git
alias sb='call git.switch_branch "$@"'

import php
alias phpclean='call php.phpclean "$@"'
