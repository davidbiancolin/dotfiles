function mcd() {
            mkdir -p $*
            cd $*
}


export -f mcd

alias edit='chmod u+w'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'

