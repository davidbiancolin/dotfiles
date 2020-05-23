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

" color scheme guide:
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

syntax match Tab /\t/
hi Tab gui=underline guifg=blue ctermbg=blue
" Set highlighting colors for terminals
hi Search cterm=NONE ctermfg=white ctermbg=red
hi PMenu ctermbg=blue ctermfg=white
hi PMenuSel ctermbg=white ctermfg=blue

set foldmethod=marker

" Add a guide to highlight columns 80 - 100. Reasonble boundaries for most
" code write
highlight ColorColumn ctermbg=235
let &colorcolumn=join(range(81,100),",")


" Handle extra whitespace
:highlight ExtraWhitespace ctermbg=yellow guibg=yellow
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=yellow guibg=yellow
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"RE-FUCKING-MAPPINGS WHATS GOOD
"Remap control U and control w in insert mode to avoid stupid deletions
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Kill some bad habits..jk to escape insert mode
inoremap jk <esc>
inoremap kj <esc>
cnoremap jk <esc>
cnoremap kj <esc>
inoremap <esc> <nop>

" Disable the arrow keys...
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Set custom colors for the indent guides

let g:indent_guides_auto_colors = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=gray   ctermbg=gray
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgray ctermbg=254
let g:indent_guides_guide_size = 1

"Set the colour palette for rainbow brackets -- remove black from the list
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
" Rainbow parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"Pydiction configuration
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

" Pymode configuration
let g:pymode_rope = 0

" Control-P Configuration
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](\.git|\.hg|\.svn|project\/target|target)$',
    \ 'file': '\v\.(exe|so|dll|class)$'
    \ }
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Let autocomplete treat hyphen separated strings as single words
set iskeyword+=-
