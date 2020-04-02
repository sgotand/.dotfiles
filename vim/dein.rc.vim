if v:version >= 800

  let s:dein_cache_dir = g:cache_home . '/dein'
  let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir .",". &runtimepath

  let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
  let s:dein_config_dir = '~/.dotfiles/vim/toml'

  if dein#load_state(s:dein_cache_dir)
    call dein#begin(s:dein_cache_dir)

    call dein#load_toml(s:dein_config_dir . '/dein.toml', {'lazy': 0})
    call dein#load_toml(s:dein_config_dir . '/dein_lazy.toml', {'lazy': 1})
    call dein#load_toml(s:dein_config_dir . '/dein_deoplete.toml', {'lazy': 1})
    "call dein#load_toml(s:dein_config_dir . '/dein_coc.toml', {'lazy': 1})

    call dein#remote_plugins()
    call dein#end()
    call dein#save_state()
  endif

endif

if dein#check_install()
  call dein#install()
endif
