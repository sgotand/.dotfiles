autocmd FileType cpp nnoremap FM :<C-u>ClangFormat<CR>:w<CR>
autocmd FileType cpp vmap FM <Plug>(operator-clang-format)
