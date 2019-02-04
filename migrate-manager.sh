#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "$0 takes 1 argument: The old manager's IP address"
    exit 2
fi

old_manager=$1
pkey=~/firesim.pem

if [[ ! -f ~/firesim.pem ]]; then
    echo "Copy over your FireSim private key."
    exit 2
fi

scp -i $pkey $old_manager:~/.zshrc_local ~
scp -i $pkey $old_manager:~/.ssh/config_local ~/.ssh/
rsync -av -e "ssh -i $pkey" -a $old_manager:~/firesim-* ~
