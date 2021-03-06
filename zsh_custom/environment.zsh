# This little function circumvents the lag issues i sometimes have when 
# im in a large repo, by avoiding a call to git status (think hurricane)
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

export DISPLAY_CACHE_DIR=~/.displays/
function cache_display_variable() {
  mkdir -p $DISPLAY_CACHE_DIR
  echo $DISPLAY > $DISPLAY_CACHE_DIR/`uname -n`.display
}

alias tmux='cache_display_variable && tmux'

function load_display_variable() {
  export DISPLAY=$(cat $DISPLAY_CACHE_DIR/`uname -n`.display)
}
