" set user defined snippets dir
let g:neosnippet#snippets_directory='~/.dotfiles/vim/snippets'
let g:neosnippet#enable_completed_snippet=1
"  let g:neosnippet#enable_auto_clear_markers=0

echom 'neosnippet hook_add'
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" TODO 候補をenterで消さないようにする

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
