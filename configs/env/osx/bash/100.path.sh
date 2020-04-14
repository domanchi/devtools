# This is an important bit of hackery here.
#
# On OSX, the execution order for profile data is:
#   - /etc/profile
#     - /etc/bashrc
#   - ~/.bash_profile
#
# (There's a lot more nuance to this, but this is generally the idea as
# it pertains to us).
#
# However, when running through TMUX, it runs this order again, and path_helper
# seems to prepend all the system level paths to the existing path. Now, since
# the PATH variable is already tainted, it will keep the PATH the same, but
# re-order the system paths to be at the front (which is not what we want).
#
# Therefore, make sure to reset the PATH everytime we run this, so we can start
# off at a known state.
if [[ -x /usr/libexec/path_helper ]]; then
    export PATH=""
    eval $(/usr/libexec/path_helper)
fi
