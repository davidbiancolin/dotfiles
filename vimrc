set guifont=Monospace\ 9
set ai!
set wrap! "wrap
set hls! "Highlist all search patterns
set nu

"Invoke pathogen for awesomeness
execute pathogen#infect()

set ic! "Ignore case
set smartcase
set incsearch
set tabstop=4 shiftwidth=4 expandtab

:filetype plugin on
"Enable filetype specific smart indentation
:filetype plugin indent on
syntax enable
"prints the file path if you press F3 in insert mode
imap <F3> <C-R>=expand("%:P")<CR>
"to increment numbers. Put cursor over a number and press Ctrl-I

:noremap <C-I> <C-A>
"to keep the cursor in context"
set scrolloff=3

"Colorscheme stuff
colorscheme default

if &term =~ "^xterm|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;red\x7"
  silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif
if &term =~ '^xterm'
  " solid underscore
  let &t_SI .= "\<Esc>[3 q"
  " solid block
  let &t_EI .= "\<Esc>[3 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif

syntax match Tab /\t/
hi Tab gui=underline guifg=blue ctermbg=blue
" Set highlighting colors for terminals
hi Search cterm=NONE ctermfg=white ctermbg=red
hi PMenu ctermbg=blue ctermfg=white
hi PMenuSel ctermbg=white ctermfg=blue

set foldmethod=marker

" Taglist/Ctags
set tags=$ACDS_SRC_ROOT/quartus/tags; "search up to root for the tags file"
let Tlist_WinWidth = 50
let Tlist_Ctags_Cmd="ctags"
let g:ctags_statusline=1
let generate_tags=1
let Tlist_Use_Horiz_Window=0
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Auto_Open = 1

nnoremap TT :TlistToggle<CR>
map <F4> :TlistToggle<CR>
map <F5> :TlistUpdate<CR>
map <F8> :!"ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f $ACDS_SRC_ROOT/quartus/tags"<CR>

" FSwitch
augroup mycppfiles
  au!
  au BufEnter *.h let b:fswitchdst  = 'cpp,c'
  au BufEnter *.h let b:fswitchlocs = '../h,../../h'
augroup END


" Handle extra whitespace
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"Remap control U and control w in insert mode to avoid stupid deletions 
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Set custom colors for the indent guides 

let g:indent_guides_auto_colors = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=gray   ctermbg=gray
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgray ctermbg=254
let g:indent_guides_guide_size = 1

"Pydiction configuration
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

