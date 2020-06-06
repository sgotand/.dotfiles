command! InsertModeLine call s:insertModeLine()
command! EchoRuntimePath call s:echoRuntimePath()
command! EchoPackPath call s:echoPackPath()
command! DeinUpdate call g:dein#update()
"command! Cheat call s:echoCheat()

function! s:insertModeLine()
  put = 'vim: set ft=' . &ft . ' :'
endfunction

function! s:echoRuntimePath()
  let paths = split(&runtimepath, ',')
  for path in paths
    echo path
  endfor
endfunction

function! s:echoPackPath()
  let paths = split(&packpath, ',')
  for path in paths
    echo path
  endfor
endfunction

function! s:echoCheat()
  if !exists("g:pluginname_setting")
    let g:cheat_sheet=":Capture"
  endif
  echo g:cheat_sheet
endfunction

command! CleanDein call s:deinClean()
command! DeinClean call s:deinClean()
function! s:deinClean()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction



function! ProfileCursorMove() abort
  let profile_file = expand('~/log/vim-profile.log')
  if filereadable(profile_file)
    call delete(profile_file)
  endif

  normal! gg
  normal! zR

  execute 'profile start ' . profile_file
  profile func *
  profile file *

  augroup ProfileCursorMove
    autocmd!
    autocmd CursorHold <buffer> profile pause | q
  augroup END

  for i in range(100)
    call feedkeys('j')
  endfor
endfunction


" インポート済みのプラグイン一覧の表示
"
