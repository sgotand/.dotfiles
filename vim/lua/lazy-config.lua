local pack_path = vim.fn.stdpath "data" .. "/lazy/"
local lazy_path = pack_path .. "lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)
require("lazy").setup("lazy_plugins", {
    performance = {
      rtp = {
        disabled_plugins = {
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
        },
      },
    },
  })
