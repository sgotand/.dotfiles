" autocmd FileType go nnoremap <buffer> FM :<C-u>GoFmt<CR>:w<CR>
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')


