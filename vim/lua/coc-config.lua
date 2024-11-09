vim.g.coc_global_extensions = {
  'coc-neosnippet',
  'coc-json',
  'coc-toml',
  'coc-sh',
  'coc-rust-analyzer',
  'coc-pyright',
  'coc-clangd',
  'coc-solargraph'
}

vim.o.shortmess = vim.o.shortmess .. 'c'

vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})
vim.api.nvim_set_keymap('n', 'gt', '<Plug>(coc-type-definition)', {silent = true})
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references-used)', {silent = true})
vim.api.nvim_set_keymap('n', 'gp', '<Plug>(coc-diagnostic-prev)', {silent = true})
vim.api.nvim_set_keymap('n', 'gn', '<Plug>(coc-diagnostic-next)', {silent = true})
vim.api.nvim_set_keymap('n', 'gl', '<Plug>(coc-codelens-action)', {silent = true})

vim.api.nvim_set_keymap('n', 'K', ':lua show_documentation()<CR>', {silent = true})

function _G.show_documentation()
  if vim.tbl_contains({'vim', 'help'}, vim.bo.filetype)  then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  else
    vim.call('CocAction', 'doHover')
  end
end

vim.api.nvim_set_keymap('n', '<space>a', ':<C-u>CocList diagnostics<cr>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>e', ':<C-u>CocList extensions<cr>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>c', ':<C-u>CocList commands<cr>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>o', ':<C-u>CocList outline<cr>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':<C-u>CocList -I symbols<cr>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>j', ':<C-u>CocNext<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>k', ':<C-u>CocPrev<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<space>p', ':<C-u>CocListResume<CR>', {silent = true})

vim.api.nvim_set_keymap('n', '<space>r', '<Plug>(coc-refactor)', {silent = true})
vim.api.nvim_set_keymap('n', 'FM', '<Plug>(coc-format)', {silent = true})
vim.api.nvim_set_keymap('v', 'FM', '<Plug>(coc-format-selected)', {silent = true})

