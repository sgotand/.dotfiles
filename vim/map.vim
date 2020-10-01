echom "start importing map.vim"
let mapleader = ","

nnoremap s <Nop>

nnoremap <leader><S-n> :<C-u>set relativenumber!<CR>
nnoremap <leader>n :<C-u>set number!<CR>
" go to
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sr <C-w>w

" move pane to
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sR <C-w>r

" pane size changer
nnoremap s= <C-w>=
nnoremap s_ <C-w>_
nnoremap s\|  <C-w>\|
nnoremap sa <C-w>_<C-w>\|

" split the pane
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>

" tab handling
nnoremap st :<C-u>tabnew<CR>
nnoremap sT <C-w>T "move pane to new tab
nnoremap sn gt
nnoremap sp gT
nnoremap sN :<C-u>tabmove +1<CR>
nnoremap sP :<C-u>tabmove -1<CR>

nnoremap tn :<C-u>tabnew<CR>
nnoremap tl gt
nnoremap th gT

" exchange line movement commands
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" multi line paste
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

inoremap jk <ESC>

inoremap <C-c> <Esc>
noremap <S-h> ^
noremap <S-l> $
"inoremap <C-j>  <down>
"inoremap <C-k>  <up>
"inoremap <C-h>  <left>
"inoremap <C-l>  <right>
"
"format indent
nnoremap == gg=G

" discard yank got with x(s)
nnoremap x "_x
nnoremap s "_s

nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

" vim as terminal multiplexer
if has('terminal') || has('nvim')
  tnoremap <silent> <ESC> <C-\><C-n>
  tnoremap jj <C-\><C-n>
  tnoremap jk <C-\><C-n>
  if has('nvim')
    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal nospell
    autocmd TermOpen * startinsert
  else
    autocmd TerminalOpen * set nonumber
    autocmd TerminalOpen * set nospell
  endif
endif

vnoremap / "zy:let @/ = @z<CR>n


function! HasQuickFix()
  echom "check quickfix"
  let s:ret = len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
  echom s:ret > 0
  return s:ret > 0
endfunction

nnoremap  <silent><expr> n HasQuickFix() ? ':<C-u>cn<CR>': 'n'
nnoremap  <silent><expr> N HasQuickFix() ? ':<C-u>cp<CR>': 'N'

