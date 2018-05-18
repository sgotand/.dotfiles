filetype off
filetype plugin indent off


"set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
"=============key mapping=======================
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap ; :
nnoremap : ;
inoremap jj <ESC>





set fenc=utf-8 "file encording 
set nobackup "~ファイルを作らない

set noswapfile ".swpファイルを作らない
"set autoread "reload automatically what is changed outside 
set hidden "バッファを切り替える時に怒られなくなる
set showcmd "入力中コマンドを表示する。

"######表示設定#######

syntax on

set title				   "タイトル表示
set number				   "行番号表示
set ruler				   " カーソルが何行目の何列目に置かれているかを表示する

colorscheme elflord 		"カラースキームをmolokaiに設定
set cursorline 				"カーソル行をハイライト
set cursorcolumn  			"カーソル列をハイライト

set virtualedit=block  		"all "virtualモードで文字のない場所も選択可能に
set showmatch 				"対応するカッコを強調表示
set t_co=256
set cmdheight=2
set wildmode =list:longest
set wildchar=<Tab>
set tabstop=2				"画面上でtabが占める幅
set smartindent
set shiftwidth=4
set autoindent				
set noexpandtab				"
set spell					"スペルチェックを有効化
set spelllang=en,cjk 		"英語および漢字でスペルチェック
set list 					"不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮ "不可視文字を指定。
set scrolloff=4  "画面スクロール時に残す余白行数を指定

"####検索設定########
set hlsearch "検索した文字列をハイライト
set incsearch "インクリメンタルなサーチ
set ignorecase "ケースを無視
set smartcase  "大文字のみケースを考慮
set wrapscan  "検索時、最後まで行ったら上まで戻る

"
set clipboard=unnamed,unnamedplus
set mouse=a

"##########   dein.vim   ########

if &compatible
  set nocompatible
endif
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

