#!/bin/bash
set -ex

# Important directories
export SCRATCH_DIR=/scratch/biancolin
export LOCAL=$SCRATCH_DIR/.local
export DOTFILES_DIR=$SCRATCH_DIR/dotfiles
REMOTE=git@github.com:davidbiancolin/dotfiles.git

mkdir -p $SCRATCH_DIR

if [[ -e $DOTFILES_DIR/.git ]]; then
    set +x
    echo "Updating an old dotfiles"
    set -x
    cd $DOTFILES_DIR
    git pull
else
    set +x
    echo "Setting up a fresh dotfiles"
    set -x
    git clone $REMOTE $DOTFILES_DIR
    cd $DOTFILES_DIR
fi

./setup.sh
# HACK: Assumption is LOCAL is the same on all machines
mkdir -p $LOCAL
make
