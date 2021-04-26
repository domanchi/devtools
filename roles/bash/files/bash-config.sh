# unlimited history
export HISTFILESIZE=""

# disable timestamps. after all, we're deduplicating history, so timestamp doesn't make sense.
export HISTTIMEFORMAT=""

# dedup history.
# We use `erasedups` for migratory efforts.
export HISTCONTROL=ignoredups:ignorespace:erasedups

# keep history between bash runs
shopt -s histappend
