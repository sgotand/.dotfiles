
command! InsertModeLine call s:insertModeLine()
command! ModeLine call s:insertModeLine()

function! s:insertModeLine()
  put ='vim: set ft=' . &ft . ' :'
endfunction
