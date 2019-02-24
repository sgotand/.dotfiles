filetype off
filetype plugin indent off

"set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
"=============key mapping=======================

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

" split the pane
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap s= <C-w>=

" tab handling
nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT

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

inoremap jj <ESC>
inoremap jk <ESC>

"============file setting======================

set fenc=utf-8 
set nobackup 
set noswapfile 
set autoread 
set hidden 
set showcmd 
set backspace=indent,eol,start
" vim modeline setting 
set modeline
set modelines=5

"=============edit setting=====================
set tabstop=2
set expandtab
set smartindent
set shiftwidth=2
set autoindent

"=============view setting=====================
syntax on
colorscheme iceberg

set title
set number
set ruler
set cursorline
set cursorcolumn
set virtualedit=block
set showmatch
set matchtime=1
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

"=============utility==========================
"{{{
command! InsertModeLine call s:insertModeLine()

function! s:insertModeLine()
    put ='vim: set ft=' . &ft . ' :'
endfunction
"}}}

    "==========dein.vim============================
if v:version >= 800 
    if &compatible
      set nocompatible
    endif

 
    let s:cache_home = expand('~/.vim')
    let s:dein_dir = s:cache_home . '/dein'
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_repo_dir)
       call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
     endif
    let &runtimepath = s:dein_repo_dir .",". &runtimepath

    set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

    call dein#begin(s:dein_dir)

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
    call dein#add('nathanaelkane/vim-indent-guides')
    call dein#end()

    "================vim-indent-guides================================    
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_start_level = 2
    let g:indent_guitds_auto_colors=1
    hi IndentGuidesEven ctermbg=darkgrey

    "================quickrun============================
    let g:quickrun_config = {}
    let g:quickrun_config.cpp = { 'command': 'g++','cmdopt': '-std=c++11'}

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
endif

filetype on
filetype plugin indent on

