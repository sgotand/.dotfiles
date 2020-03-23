nnoremap <buffer> <unique> FN :<C-u>ClangFormat<CR>:w<CR>
autocmd FileType c nnoremap FM :<C-u>ClangFormat<CR>:w<CR>
autocmd FileType cpp nnoremap FM :<C-u>ClangFormat<CR>:w<CR>
