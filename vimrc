set number
set guifont=Monospace\ 9
set ai!
set wrap!
set hls!
set ic!
:filetype plugin on
"Enable filetype specific smart indentation
:filetype plugin indent on 
set smartcase
set incsearch
set tabstop=4 shiftwidth=4 expandtab 
"prints the file path if you press F3 in insert mode
imap <F3> <C-R>=expand("%:P")<CR>
"to increment numbers. Put cursor over a number and press Ctrl-I
:noremap <C-I> <C-A>
"to keep the cursor in context"
set scrolloff=3

"Set the cursor shape -> 1 = blinking rect" 
if &term =~ '^xterm'
    let &t_SI .= "\<Esc>[1 q"
endif

    
syntax match Tab /\t/
hi Tab gui=underline guifg=blue ctermbg=blue
" Set highlighting colors for terminals
hi Search cterm=NONE ctermfg=grey ctermbg=blue 

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

set foldmethod=marker

syntax on

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


