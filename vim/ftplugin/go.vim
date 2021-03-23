" autocmd FileType go nnoremap FM :<C-u>GoFmt<CR>:w<CR>
autocmd BufWritePre *.go nnoremap FM :<C-u>call CocAction('runCommand', 'editor.action.organizeImport')<CR>
