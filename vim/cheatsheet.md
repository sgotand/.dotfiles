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
- `<leader>u`で編集履歴をトグル

# todo
- `<leader>t`でTODOをトグルしてくれる

# register
- insert modeで<C-r>{レジスタ} でペースト #peekabooで表示
- "<レジスタ><コマンド><オペレータ>
- `"ay$` # aレジスタに、行末まで保存
- `"ap`  # aレジスタの内容をペースト
# デフォルトの機能
- `/<検索キーワード>` で検索を書けたあと、 `:%s//<replace_word>/g`とすればそのまま置換で


# vim
