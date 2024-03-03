echom "start importing " . expand('<sfile>:p')
let g:coc_global_extensions = [
      \  'coc-neosnippet'
      \, 'coc-json'
      \, 'coc-toml'
      \, 'coc-sh'
      \, 'coc-rust-analyzer'
      \, 'coc-pyright'
      \, 'coc-clangd'
      \, 'coc-solargraph'
      \ ]
echom "finish importing " . expand('<sfile>:p')

" don't give |ins-completion-menu| messages.
set shortmess+=c

"" always show signcolumns
"set signcolumn=yes
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references-used)
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gl <Plug>(coc-codelens-action)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
 if (index(['vim','help'], &filetype) >= 0)
   execute 'h '.expand('<cword>')
 else
   call CocAction('doHover')
 endif
endfunction

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Refactor
nmap <silent> <space>r <Plug>(coc-refactor)
nmap <silent> FM <Plug>(coc-format)
vmap <silent> FM <Plug>(coc-format-selected)
