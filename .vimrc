filetype off
filetype plugin indent off


set fenc=utf-8 "file encording 
"set nobackup "~ファイルを作らない

"set noswapfile ".swpファイルを作らない
"set autoread "reload automatically what is changed outside 
set hidden "バッファを切り替える時に怒られなくなる
set showcmd "入力中コマンドを表示する。

"######表示設定#######

syntax on

set title				   "タイトル表示
set number				   "行番号表示
set ruler				   " カーソルが何行目の何列目に置かれているかを表示する

colorscheme molokai 		"カラースキームをmolokaiに設定

set cursorline 				"カーソル行をハイライト
set cursorcolumn  			"カーソル列をハイライト

set virtualedit=block  		"all "virtualモードで文字のない場所も選択可能に
set showmatch 				"対応するカッコを強調表示
set t_co=256
set laststatus=2
set cmdheight=2
set wildmode =list:longest
set wildchar=<c-z>
set tabstop=4  				"画面上でtabが占める幅
set smartindent
set autoindent
set spell
set spelllang=en,cjk 
set list 					"不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮
set scrolloff=4  

"####検索設定########
set hlsearch
set incsearch
set ignorecase
set smartcase  
set wrapscan 

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

call dein#end()


filetype on
filetype plugin indent on
