print("start importing " .. vim.fn.expand('<sfile>:t'))

vim.o.backspace = "indent,eol,start"  -- Enable backspace
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.opt.virtualedit:append("block")
vim.o.spell = true
vim.o.spellfile = vim.fn.expand("~/.config/nvim/en.utf-8.add")

if vim.fn.has('persistent_undo') == 1 then
  local undo_dir = vim.g.vim_dir .. '/undo'
  vim.fn.mkdir(undo_dir, "p", 0755)
  vim.o.undodir = undo_dir
  vim.o.undofile = true
end

print("finish importing " .. vim.fn.expand('<sfile>:t'))
