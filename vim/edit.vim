
set backspace=indent,eol,start "backspaceを有効にする
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set virtualedit+=block

if has('persistent_undo')
  let s:undo_dir = g:vim_dir . '/undo'
  call mkdir( s:undo_dir , "p", 0755)
  "set undodir= s:undo_dir
  let &undodir= s:undo_dir
  set undofile
endif
