#!/bin/bash

# This script contains definitions for all the files we want to link, or restore when updating an environment

########## Variables
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="gitconfig bash_profile vimrc vim ssh/rc ssh/config zshrc oh-my-zsh tmux.conf"
# list of folders with metadata that needs to be maintained
patch_dirs="ssh"
##########


