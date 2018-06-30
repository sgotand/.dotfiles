filetype off
filetype plugin indent off

"set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
"=============key mapping=======================

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sr <C-w>w

nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sR <C-w>r

nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap s= <C-w>=

nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap ; :
nnoremap : ;
inoremap jj <ESC>

"-============file setting======================

set fenc=utf-8 "file encording 
set nobackup "~ファイルを作らない
set noswapfile ".swpファイルを作らない
"set autoread "reload automatically what is changed outside 
set hidden "バッファを切り替える時に怒られなくなる
set showcmd "入力中コマンドを表示する。
set backspace=indent,eol,start



"=============edit setting=====================
set tabstop=2
set smartindent
set shiftwidth=4
set autoindent
set expandtab

"=============view setting=====================
"set termguicolors
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
syntax on
colorscheme elflord
set title 
set number
set ruler
set cursorline 
set cursorcolumn
set virtualedit=block
set showmatch
set t_co=256
set cmdheight=2
set wildmode =list:longest
set wildchar=<Tab>
set spell
set spelllang=en
if (v:version == 704 && has("patch88")) || v:version >= 705
      set spelllang+=cjk
endif
set list
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮
set scrolloff=4
"====search setting============================
set hlsearch 
set incsearch
set ignorecase
set smartcase
set wrapscan
set clipboard=unnamed,unnamedplus
set mouse=a

"==========dein.vim============================
if &compatible
  set nocompatible
endif
augroup MyAutoCmd
      autocmd!
  augroup END

" dein settings {{{
 " dein自体の自動インストール
 let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.vim') : $XDG_CACHE_HOME
 let s:dein_dir = s:cache_home . '/dein'
 let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
 if !isdirectory(s:dein_repo_dir)
   call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
 endif
 let &runtimepath = s:dein_repo_dir .",". &runtimepath

   set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')  
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')

call dein#add('thinca/vim-quickrun')
call dein#add('itchyny/lightline.vim')
call dein#add('mattn/benchvimrc-vim')
call dein#add('scrooloose/nerdtree')
call dein#end()

"================lightline.vim============================
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
set noshowmode
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightlineModified',
        \   'readonly': 'LightlineReadonly',
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode'
        \ }
        \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
    return fugitive#head()
  else
    return ''
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction


filetype on
filetype plugin indent on

