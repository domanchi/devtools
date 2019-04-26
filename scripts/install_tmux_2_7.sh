#!/bin/bash
# Source: https://gist.github.com/japrescott/aa15cb024fe38ea36849f5f62c3314a3

function main() {
    sudo apt-get update
    sudo apt-get install -y libevent-dev libncurses-dev make

    mkdir /tmp/tmux
    cd /tmp/tmux

    wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
    tar xvzf tmux-2.7.tar.gz
    cd tmux-2.7/

    ./configure && make
    sudo make install

    cd ../..
    rm -rf tmux
}

main
