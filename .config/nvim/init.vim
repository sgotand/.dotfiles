
filetype off
filetype plugin indent off
runtime! ftplugin/man.vim

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:vim_dir = s:cache_home . '/vim'
"============file setting======================

set fileencoding=utf-8
set encoding=utf-8
scriptencoding utf-8
set nocompatible
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set backspace=indent,eol,start
set modeline
set modelines=5

"=============key mapping=======================
set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]

nnoremap s <Nop>




"move among panes
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sr <C-w>w

" move the pane position
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

" swap ; and :
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

inoremap jk <ESC>

" discard yank got with x(s)
nnoremap x "_x
nnoremap s "_s

" delete highlight with double <ESC> or Ctrl-l
nnoremap <silent> <ESC><ESC> :nohl<CR>
"nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
" highlight the word under cursor with double space
nnoremap <silent> HH  "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>



"" statusline
"set statusline=%{anzu#search_status()}
"emacs keybinds for command
"cnoremap <C-p> <Up>
"cnoremap <C-n> <Down>
"cnoremap <C-b> <Left>
"cnoremap <C-f> <Right>
"cnoremap <C-a> <Home>
"cnoremap <C-e> <End>
"cnoremap <C-d> <Del>
"inoremap <C-k> <Up>
"inoremap <C-j> <Down>
"inoremap <C-b> <Esc>bi
"inoremap <C-f> <Esc>ewi
"inoremap <C-a> <Home>
"inoremap <C-e> <End>
"inoremap <C-d> <Del>

"line join
vnoremap J <Nop>
"vnoremap <C-j> :join<CR>
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

"=============edit setting=====================
set tabstop=2
set expandtab
set smartindent
set shiftwidth=2
set autoindent

if has('persistent_undo')
  let s:undo_dir = s:vim_dir . '/undo'
  call mkdir( s:undo_dir , "p", 0755)
  "set undodir= s:undo_dir
  let &undodir= s:undo_dir
  set undofile
endif
"=============view setting=====================
syntax on
"colorscheme iceberg " setup at plugin

set title
set number
set ruler
"set cursorline
"set cursorcolumn
set virtualedit=block
set showmatch
set matchtime=1
set cmdheight=2
set wildmode=list:longest
set wildchar=<Tab>
set nospell
autocmd FileType man set nospell
autocmd FileType c nnoremap FM :<C-u>ClangFormat<CR>:w<CR>
autocmd FileType cpp nnoremap FM :<C-u>ClangFormat<CR>:w<CR>
autocmd FileType go nnoremap FM :<C-u>GoFmt<CR>:w<CR>

set spelllang=en
if (v:version == 704 && has("patch88")) || v:version >= 705
      set spelllang+=cjk
endif
set list
"set listchars+=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:.
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮
set scrolloff=4

"====fold setting==============================

set foldmethod=syntax
set foldcolumn=1
set foldlevel=1

"====search setting============================
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
set clipboard&
set clipboard^=unnamedplus
set mouse=a

"=============utility==========================
"{{{
command! InsertModeLine call s:insertModeLine()

function! s:insertModeLine()
    put ='vim: set ft=' . &ft . ' :'
endfunction
"}}}

"==========dein.vim============================
if v:version >= 800
    augroup MyAutoCmd
      autocmd!
    augroup END

    let s:dein_cache_dir = s:cache_home . '/dein'
    let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif
    let &runtimepath = s:dein_repo_dir .",". &runtimepath

    let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
    let s:dein_config_dir = s:config_home . '/nvim'



    if dein#load_state(s:dein_cache_dir)
        call dein#begin(s:dein_cache_dir)

        call dein#load_toml(s:dein_config_dir . '/dein.toml', {'lazy': 0})
        call dein#load_toml(s:dein_config_dir . '/dein_lazy.toml', {'lazy': 1})

        call dein#remote_plugins()
        call dein#end()
        call dein#save_state()
    endif

   " call dein#begin(s:dein_dir)
   " if has('nvim')
   "   call dein#add('Shougo/denite.nvim')
   " else
   "   call dein#add('Shougo/unite.vim')
   " endif
   " call dein#add('Shougo/neomru.vim') "recently used file
   "
   " let s:my_snippet_dir = s:cache_home . '/snippet/'
   " let g:neosnippet#snippets_directory = s:my_snippet_dir

   " if !has('nvim')
   "   call dein#add('mattn/benchvimrc-vim') "Use with :BenchVimrc
   " endif
   " call dein#add('scrooloose/nerdtree')
   " call dein#add('airblade/vim-gitgutter')
   " call dein#add()
   " call dein#add()
   " call dein#add('itchyny/vim-parenmatch')
   " call dein#add('fatih/vim-go')
   " call dein#add('zchee/deoplete-go')
   " call dein#end()



"    "================NERDTree============================
"    if has("vim_starting")
"      function s:MoveToFileAtStart()
"        call feedkeys("\<Space>")
"        call feedkeys("\s")
"        call feedkeys("\l")
"      endfunction
"    endif
"
"    let g:NERDTreeShowBookmarks=1
"
"    if !argc()
"      "autocmd VimEnter *  NERDTree
"    endif
"
"    "================vim-parenmatch===========================
"    let g:loaded_matchparen = 1
"    highlight link ParenMatch MatchParen
"    let g:parenmatch_highlight = 0
endif
" for esolang Function
au BufEnter *.function set ft=function
au BufEnter *.function nnoremap x x
au BufEnter *.function unmap x
au BufEnter *.function nnoremap s s
au BufEnter *.function unmap s

filetype on
filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

