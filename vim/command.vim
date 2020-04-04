command! InsertModeLine call s:insertModeLine()
command! EchoRuntimePath call s:echoRuntimePath()
command! EchoPackPath call s:echoPackPath()
command! Cheat call s:echoCheat()

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
  echo g:cheat_sheet
endfunction

" インポート済みのプラグイン一覧の表示
