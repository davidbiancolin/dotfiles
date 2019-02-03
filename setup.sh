# This script creates symlinks from the home directory to any desired dotfiles in the working directory
############################

set -ex
source ./common.sh

# Check if a non-standard LOCAL is desired;
if [[ -e $1 ]]; then
    echo "Non-standard LOCAL desired at $1"
    export LOCAL=$1
    cat "export LOCAL=$1" >> ~/.zshrc_local
else
    export LOCAL=$HOME/.local
fi
mkdir -p $LOCAL

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in "${files[@]}"; do
    rm -f ~/.$file
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

for local_file in "${locals[@]}"; do
    touch ${local_file}
done


install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh -o -f $LOCAL/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        set +e
        chsh -s $(which zsh)
        set -e
    fi
else
    # If zsh isn't installed, check for some common pacakge managers
    # Should do this from source; for now just try to use root
    if [[ -x "$(which apt-get)" ]]; then sudo apt-get install zsh
    elif [[ -x "$(which yum)" ]]; then sudo yum update && sudo yum install zsh
    elif [[ -x "$(which brew)" ]]; then brew install zsh zsh-completions
    else
        echo "Please install zsh, then re-run this script!"
        exit 2
    fi
    install_zsh
fi
}

#Grab various vim plugins that are version controlled 
git submodule update --init --recursive
install_zsh

make
