#!/bin/bash
BASEPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

. $BASEPATH/common/core.sh        # need to load the common functions first.
clear_cache                       # so we're starting afresh

# Import all desired modules
import switch_branch

# These are all the aliases associated with differing functions
alias sb='call switch_branch "$@"'
