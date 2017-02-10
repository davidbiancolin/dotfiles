# This script creates symlinks from the home directory to any desired dotfiles in the working directory
############################

set -ex
source ./common.sh

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    rm -f ~/.$file
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done


install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh -o ~/.local/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        apt-get install zsh
        install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

#Grab various vim plugins that are version controlled 
git submodule update --init --recursive

install_zsh

#List of other shit to install
#Brew? 
#Need: 
# reattach-to-user-namespace pbcopy
