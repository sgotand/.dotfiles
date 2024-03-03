echom "start importing " . expand('<sfile>:t')

command! InsertModeLine call s:insertModeLine()
function! s:insertModeLine()
  put = 'vim: set ft=' . &ft . ' :'
endfunction

command! EchoRuntimePath call s:echoRuntimePath()
function! s:echoRuntimePath()
  let paths = split(&runtimepath, ',')
  for path in paths
    echo path
  endfor
endfunction

command! EchoPackPath call s:echoPackPath()
function! s:echoPackPath()
  let paths = split(&packpath, ',')
  for path in paths
    echo path
  endfor
endfunction

command! DeinUpdate call g:dein#update()
command! CleanDein call s:deinClean()
command! DeinClean call s:deinClean()
function! s:deinClean()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction

" インポート済みのプラグイン一覧の表示
echom "finish importing " . expand('<sfile>:t')
