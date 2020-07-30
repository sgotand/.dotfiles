" set user defined snippets dir
let g:neosnippet#snippets_directory='~/.dotfiles/vim/snippets'
let g:neosnippet#enable_completed_snippet=1
"  let g:neosnippet#enable_auto_clear_markers=0

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

function! Jumpable_to_right()
  echom "checking"
  let s:ret = !search('\%#[])}] *[;{] *$', 'n')
  echom s:ret
  echom search('\%#[]>),]', 'n')
  let s:ret_or = search('\%#[]>),]', 'n')
  echom search('\%#}[^>]', 'n')
  let s:ret_or = s:ret_or || search('\%#}\([^>]\|$\)', 'n') " }のあとは>意外であればok
  echom search("\%#'[])}]", 'n')
  let s:ret_or = s:ret_or || search("\%#'[])}]", 'n')
  echom search('\%#"[])}]', 'n')
  let s:ret_or = s:ret_or || search('\%#"[])}]', 'n')
  echom search('\%#" *$', 'n')
  let s:ret_or = s:ret_or || search('\%#" *$', 'n')
"   echom s:ret_or
  " FIXME: support single quote
  return s:ret && s:ret_or
endfunction

imap <expr><TAB>
      \ Jumpable_to_right() ?  "\<Right>" :
      \ neosnippet#expandable_or_jumpable() ?  "\<Plug>(neosnippet_expand_or_jump)" :
      \ search('\%#[])}] *[;{] *$', 'n') ? "\<Esc>o" : "\<Tab>"

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"


" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" TODO 候補をenterで消さないようにする

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
