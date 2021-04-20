# There is an issue with tmux and $SSH_AUTH_SOCK, where the tmux session
# holds an invalid $SSH_AUTH_SOCK, making it harder to use ssh or git in
# an existing tmux session.
#
# However, I have an issue where if the socket dies, you need to be able to
# tell what the new socket is from within the tmux session. And this isn't
# able to give you the latest results, because it doesn't know values
# outside tmux.
#
# So fuck it. This script just fixes the symlink, and can be run manually
# when a fix is needed.

function tmux-fix() {
    # -n checks for non-zero string length
    if [[ -n "$TMUX" ]]; then
        echo "This should be run *outside* of tmux."
        return 1
    fi

    # -e follows symlinks, and checks if file (at the end) exists
    if [[ ! -e ~/.ssh/ssh-auth-sock ]]; then
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh-auth-sock
        echo "Fixed!"
    fi

    return 0
}
