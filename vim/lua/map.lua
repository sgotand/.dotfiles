
-- Helper function to set keymap
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

print("start importing " .. debug.getinfo(1).short_src)
-- print("start importing " .. vim.fn.expand('<sfile>:t'))

vim.g.mapleader = ","

map('n', 's', '<Nop>', {})

map('n', vim.g.mapleader .. '<S-n>', ':<C-u>set relativenumber!<CR>', {})
map('n', vim.g.mapleader .. 'n', ':<C-u>set number!<CR>', {})

-- go to
map('n', 'sj', '<C-w>j', {})
map('n', 'sk', '<C-w>k', {})
map('n', 'sl', '<C-w>l', {})
map('n', 'sh', '<C-w>h', {})
map('n', 'sr', '<C-w>w', {})

-- move pane to
map('n', 'sJ', '<C-w>J', {})
map('n', 'sK', '<C-w>K', {})
map('n', 'sL', '<C-w>L', {})
map('n', 'sH', '<C-w>H', {})
map('n', 'sR', '<C-w>r', {})

-- pane size changer
map('n', 's=', '<C-w>=', {})
map('n', 's_', '<C-w>_', {})
map('n', 's\\|', '<C-w>\\|', {})
map('n', 'sa', '<C-w>_<C-w>\\|', {})

-- split the pane
map('n', 'ss', ':<C-u>sp<CR>', {})
map('n', 'sv', ':<C-u>vs<CR>', {})
map('n', 'sq', ':<C-u>q<CR>', {})

-- tab handling
map('n', 'st', ':<C-u>tabnew<CR>', {})
-- move pane to new tab
map('n', 'sT', '<C-w>T', {})
map('n', 'sn', 'gt', {})
map('n', 'sp', 'gT', {})
map('n', 'sN', ':<C-u>tabmove +1<CR>', {})
map('n', 'sP', ':<C-u>tabmove -1<CR>', {})

map('n', 'tn', ':<C-u>tabnew<CR>', {})
map('n', 'tl', 'gt', {})
map('n', 'th', 'gT', {})

-- exchange line movement commands
map('n', 'j', 'gj', {})
map('n', 'k', 'gk', {})
map('n', 'gj', 'j', {})
map('n', 'gk', 'k', {})

-- multi line paste
-- https://vim-jp.org/vimdoc-en/motion.html#%60]
-- `] is the motion To the last character of the previously changed or yanked text.
--
map('v', 'y', 'y`]', { silent = true})
map('v', 'p', 'p`]', { silent = true})
map('n', 'p', 'p`]', { silent = true})


-- switch ; and :
map('n', ';', ':', {})
map('n', ':', ';', {})
map('v', ';', ':', {})
map('v', ':', ';', {})

map('i', 'jk', '<ESC>', {})
map('i', '<C-c>', '<ESC>', {})
map('n', '<S-h>', '^', {})
map('n', '<S-l>', '$', {})

--format indent
map('n', '==', 'gg=G')

-- discard yank got with x(s)
map('n', 'x', '"_x')
map('n', 's', '"_s')

map('n', '<ESC><ESC>', ':nohlsearch<CR>', {silent = true})

-- vim as terminal multiplexer
map('t', '<ESC>', '<C-\\><C-n>', {silent = true})
map('t', 'jj', '<C-\\><C-n>')
map('t', 'jk', '<C-\\><C-n>')

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('nvim-as-tmux', { clear = true })
autocmd({'TermOpen'},{
    pattern = {'*'},
    group = 'nvim-as-tmux',
    callback = function()
      vim.o.number = false
      vim.o.spell = false
      vim.cmd("startinsert")
    end
  })

-- search text for selected string
map('v', '/', '"zy:let @/ = @z<CR>n')

local function has_quick_fix()
  print("check quickfix")
  local win_info = vim.fn.getwininfo()
  local filtered = vim.tbl_filter(function(v) return v.quickfix and not v.loclist end, win_info)
  return #filtered > 0
end

-- Make the function globally accessible
_G.has_quick_fix = has_quick_fix

local function nMap()
  if has_quick_fix() then
    return ":<C-u>cnext<CR>"
  else 
    return "n"
  end
end

_G.nMap = nMap

-- map('n', 'n', 'call v:lua.has_quick_fix() and ":cnext<CR>" or "n"', {expr = true, noremap = true, silent = true})
-- map('n', 'n', 'call v:lua.nMap()', {expr = true, noremap = true, silent = true})
-- map('n', 'n', 'call v:lua.nMap()', {noremap = true, silent = true})
-- map('n', 'N', 'v:lua.has_quick_fix() and ":cprevious<CR>" or "N"', {expr = true, noremap = true, silent = true})
-- 
print("finish importing " .. debug.getinfo(1).short_src)


