# My Cheat Sheet
- :Capture キャプチャする

# dein [link](https://github.com/Shougo/dein.vim/blob/master/doc/dein.txt)
- :call dein#update()
- :call dein#recache_runtimepath()
    - ランタイムパスのキャッシュを再構築する.
- :echo dein#is_sourced()
- :echo dein#get_updates_log()
  - アップデートlogをプリントする
- :echo dein#get_log()
- :echo dein#check_clean()
- :echo dein#clear_state()
# deoplete [link](https://github.com/Shougo/deoplete.nvim/blob/master/doc/deoplete.txt)
# neosnippet
- ~/.dotfiles/vim/snippets に置いてある
# vim-mundo
- :MundoToggle
- <leader>u

# デフォルトの機能
- `/<検索キーワード>` で検索を書けたあと、 `:%s//<replace_word>/g`とすればそのまま置換できる
