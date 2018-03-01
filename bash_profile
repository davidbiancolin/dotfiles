export HISTFILESIZE=5000
export EDITOR=vim
export PATH=~/bin:$PATH
export PS1='\n\[\033[0;31m\]\u @ \w\n\[\033[0;36m\]\t $ \[\033[0;39m\]'
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export HOTEL='/Volumes/biancolin'

function mcd() {
            mkdir -p $*
            cd $*
}

function lsc() {
			ls --color
}

export -f mcd
export -f lsc

alias edit='chmod u+w'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'

#Commonly used directories
alias cde='cd $HOTEL'
alias ssh250='ssh cs250-ao@icluster16.eecs.berkeley.edu'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias l='ls -CF'
alias la='ls -A'
alias ctags_setup='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f tags'


source ~/.zshrc_local
