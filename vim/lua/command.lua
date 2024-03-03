print("start importing " .. vim.fn.expand('<sfile>:t'))

vim.cmd([[
  command! InsertModeLine lua insert_mode_line()
  command! EchoRuntimePath lua echo_runtime_path()
  command! EchoPackPath lua echo_pack_path()
  command! DeinUpdate call g:dein#update()
  command! CleanDein lua dein_clean()
  command! DeinClean lua dein_clean()
]])

local function insert_mode_line()
  vim.api.nvim_put(
    {'vim: set ft=' .. vim.bo.filetype .. ' :'},
    'l', true, true
  )
end

local function echo_runtime_path()
  local paths = vim.split(vim.o.runtimepath, ',')
  for _, path in ipairs(paths) do
    print(path)
  end
end

local function echo_pack_path()
  local paths = vim.split(vim.o.packpath, ',')
  for _, path in ipairs(paths) do
    print(path)
  end
end

local function dein_clean()
  local dein_check_clean = vim.api.nvim_call_function('dein#check_clean', {})
  for _, val in ipairs(dein_check_clean) do
    vim.fn.delete(val, 'rf')
  end
  vim.api.nvim_call_function('dein#recache_runtimepath', {})
end

-- Make the functions globally accessible
_G.insert_mode_line = insert_mode_line
_G.echo_runtime_path = echo_runtime_path
_G.echo_pack_path = echo_pack_path
_G.dein_clean = dein_clean

print("finish importing " .. vim.fn.expand('<sfile>:t'))

