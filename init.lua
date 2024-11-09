-- see :help lua-options for vim.o
-- - vim.go is for global == setglobal
-- - vim.wo is for window like set?
-- - vim.bo is for buffer == set, setlocal
-- see :help lua-vim-opt for vim.opt, which is for treat list/map options as lua list/map
-- 
--     In Lua using `vim.o`: `vim.o.listchars = 'space:_,tab:>~'`
--     In Lua using `vim.opt`:
--         `vim.opt.listchars = { space = '_', tab = '>~' }`

-- 1. initialization
-- NOTE: vim.cmd is an alias of vim.api.nvim_exec
vim.cmd('filetype off') -- disable filetype detection
vim.cmd('filetype plugin indent off') -- disable plugin based on filetype


-- TODO: why this is required?
vim.cmd('runtime! ftplugin/man.vim') -- source all ftplugin/man.vim file/Ex commands in runtimepath

--- global settings
if vim.env.XDG_CACHE_HOME == nil or vim.env.XDG_CACHE_HOME == '' then
    vim.g.cache_home = os.getenv("HOME") .. '/.cache'
else
    vim.g.cache_home = vim.env.XDG_CACHE_HOME
end
vim.g.vim_dir = vim.g.cache_home .. '/vim' -- this is now used to store undo history


if vim.env.DOTFILES_ROOT == nil or vim.env.DOTFILES_ROOT == '' then
  vim.g.dotfiles_root = os.getenv("HOME") .. '/.dotfiles'
else
  vim.g.dotfiles_root = vim.env.DOTFILES_ROOT
end
vim.g.dotfiles_vim_root = vim.g.dotfiles_root .. '/vim'

-- python
vim.g.python_host_prog = "python2"
vim.g.python3_host_prog = "python3"
print("python_host_prog:  " .. vim.g.python_host_prog)
print("python3_host_prog: " .. vim.g.python3_host_prog)

-- TODO: vimベース、かつ書き換えをしているので、luaっぽく直す
local function source_rc(path, use_global)
  print("sourcing " .. path)
  use_global = use_global or not vim.v.vim_did_enter
  local abspath = vim.fn.resolve(vim.fn.expand(vim.g.dotfiles_vim_root .. "/".. path))
  if not use_global then
    vim.cmd('source ' .. vim.fn.fnameescape(abspath))
    return
  end

  -- substitute all 'set' to 'setglobal'
  local content = vim.fn.readfile(abspath)
  for i, line in ipairs(content) do
    content[i] = line:gsub("^%s*set%s", "setglobal ")
  end

  -- create tempfile and source the tempfile
  local tempfile = vim.fn.tempname()
  pcall(function()
    vim.fn.writefile(content, tempfile)
    vim.cmd("source " .. vim.fn.fnameescape(tempfile))
  end)
  if vim.fn.filereadable(tempfile) > 0 then
    vim.fn.delete(tempfile)
  end
end
_G.source_rc = source_rc

vim.cmd('syntax on') -- enable syntax highlight
vim.o.compatible = false -- disable vi compatible mode
-- set encoding
vim.o.fileencoding = 'utf-8'
vim.o.encoding = 'utf-8'
-- vim.cmd('scriptencoding utf-8')

-- vim.opt.tenc = 'utf8'
vim.opt.mouse = 'a'

-- auto file control settings
vim.opt.backup = false -- do not create backupfile
vim.opt.swapfile = false -- do not create swapfile
vim.opt.confirm = true -- ask if save unsaved files on quit
vim.opt.autoread = true -- update unchanged buffer on external file change
vim.opt.hidden = true -- enable buffer switching
vim.opt.showcmd = true -- show command during input
vim.opt.modeline = true -- use modeline
vim.opt.modelines = 5 -- parse modeline to line 5

-- view settings
vim.opt.title = true
vim.opt.number = false
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.cmdheight = 2
vim.opt.list = true
vim.opt.listchars = {tab = '▸\\ ', eol = '↲', extends = '❯', precedes = '❮'}
vim.opt.scrolloff = 4

-- spell settings
vim.opt.spell = false
vim.opt.spelllang = 'en'

-- fold settings
vim.opt.foldmethod = 'syntax'
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 100

-- search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true -- ignore upper&lower case
vim.opt.smartcase = true -- care only upper case with ignorecase
vim.opt.wrapscan = true

vim.opt.wildmode = {'list', 'longest'}
-- vim.opt.wildchar = '<Tab>'
vim.opt.wildchar = 9 -- '\t'

-- clipboard settings
vim.opt.clipboard:remove('*')
vim.opt.clipboard:prepend('unnamedplus')
function OSCYankReg(reg)
    local reg_contents = vim.fn.getreg(reg)
    reg_contents = vim.fn.escape(reg_contents, '\\')
    reg_contents = vim.fn.escape(reg_contents, '\\\\')
    reg_contents = vim.fn.escape(reg_contents, '"')
    reg_contents = vim.fn.escape(reg_contents, '$')

    -- TODO: encode contents without shell call to avoid shell escape issue
    local base64_contents = vim.fn.system('echo -n "'.. reg_contents ..'" | base64 | tr -d "\\n"')
    local osc52 = "\x1b]52;c;" .. base64_contents .. "\x1b\\"

    -- $TTY env var is unset by vim, so _TTY should be set in your .bashrc/.zshrc
    local current_tty = vim.env._TTY
    vim.fn.writefile({osc52}, current_tty, "b")
end

vim.cmd('autocmd TextYankPost * lua OSCYankReg(vim.v.event.regname)')

-- This line must be before require
vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.g.dotfiles_vim_root
print("RUNTIME_PATH==")
print(vim.o.runtimepath)

require('map')
-- source_rc("map.vim")
require("command")
-- source_rc("command.vim")
require("edit")
-- source_rc("edit.vim")
-- require("dein.rc")
source_rc("dein.rc.vim")
-- require('lazy-config')


vim.cmd('filetype on')
vim.cmd('filetype plugin indent on')
