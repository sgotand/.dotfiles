autocmd FileType go nnoremap <buffer> FM :<C-u>GoFmt<CR>:w<CR>
autocmd BufWritePre *.go :<C-u>call CocAction('runCommand', 'editor.action.organizeImport')<CR>
