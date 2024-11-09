-- https://zenn.dev/yuucu/articles/lazy_nvim_tuning
return {
  -- https://github.com/vim-jp/vimdoc-ja/issues/279
  --   {
  --     "vim-jp/vimdoc-ja",
  --     config = true,
  --   },
  {
    "sheerun/vim-polyglot",
    config = true,
    -- hook_add = '''
    -- let g:polyglot_disabled = ['markdown']
    -- '''
  },
  {
    --  detect the filetype of the place of cursor
    "Shougo/context_filetype.vim",
  },
  {
    "osyo-manga/vim-precious",
    -- depends = ['context_filetype.vim']
  },
  {
    "cocopon/iceberg.vim",
    -- hook_add = '''
    -- au VimEnter * nested colorscheme iceberg
    -- '''
  }
}
