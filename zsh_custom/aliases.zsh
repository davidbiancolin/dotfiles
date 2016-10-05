function mcd() {
            mkdir -p $*
            cd $*
}



alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'

function fix_git_urls() {
    git_config="$(GIT_EDITOR=echo git config -e)"
    echo "Fixing https submodule pointers in $git_config"
    sed 's!https://github.com/!git@github.com:!g' -i $git_config
}

function submodule_grep() {
    git --no-pager grep "$@"
    git --no-pager submodule --quiet foreach "git grep --full-name -n $@; true"
}

