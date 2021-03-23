let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_type_info = 1
"let g:go_updatetime = 1000
"  参考: https://github.com/hnakamur/vim-go-tutorial-ja

" :nextなどでバッファ移動時にファイルが変更されていれば書き込む
" :GoBuildするときにファイルを保存する必要がなくなる
autocmd FileType go set autowrite

" === VIM-GO COMMAND KEYBINDS ===
" autocmd FileType go nmap <leader>b  <Plug>(go-build) " 下記に改善版
autocmd FileType go nmap <leader>r <Plug>(go-run-split)
autocmd FileType go nmap <leader>f <Plug>(go-fmt)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>d <Plug>(go-doc)
autocmd FileType go nmap <leader>l <Plug>(go-lint)
autocmd FileType go nmap <leader>i <Plug>(go-import)
autocmd FileType go nmap <leader>I <Plug>(go-imports)
autocmd FileType go nmap <leader>p :<C-u>GoInfo<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
"" run :GoBuild or :GoTestCompile based on the go file
"function! s:build_go_files()
"  let l:file = expand('%')
"  if l:file =~# '^\f\+_test\.go$'
"    call go#test#Test(0, 1)
"  elseif l:file =~# '^\f\+\.go$'
"    call go#cmd#Build(0)
"  endif
"endfunction
"autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
"
"" ファイル切り替え
"" チュートリアルのおすすめキーバインド
"autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
"autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
"autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
"autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
"" 自分専用キーバインド(^とpが近いので)
"autocmd FileType go nmap <Leader>pp <Plug>(go-alternate-edit)
"autocmd FileType go nmap <Leader>ps <Plug>(go-alternate-split)
"autocmd FileType go nmap <Leader>pv <Plug>(go-alternate-vertical)
"" tabに表示はない
"
"" [[, ]]: 次/前の関数に移動
"" (go組込関数上などで)K: :GoDocと同様
"
"" === VIM-GO OPTIONS ===
"" GoRunの結果をsplitで表示 Default->"vsplit"
"let g:go_term_mode = "split"
"
"" :GoFmt時にimportのチェック Default->gofmt
"" ファイルが巨大だと保存時の:GoFmtが遅くなるので消しましょう
"let g:go_fmt_command = "goimports"
"
"" "コメントも関数の一部として扱われたくないときは0に設定する Default=>1
"" let g:go_textobj_include_function_doc = 1
"
"" キャメルケースに変換(defalut snake_cake)
"let g:go_addtags_transform = "camelcase"
"
"" :GoMetaLinterで呼び出すコマンド Default->['vet', 'golint', 'errcheck']
"" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
"
"" 自動保存時にLinter有効化 Default->0
"let g:go_metalinter_autosave = 1
"
"" 自動保存時に走らせるLinter Default->['vet', 'golint']
"" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
"
"" 自動保存時に走らせるLinterタイムアウト Default->"5s"
"" let g:go_metalinter_deadline = "5s"
"
"" :GoDef使用時に使うコマンド ['guru', 'godef'] guru使えないときはgodefに切り替える
"" Default->'guru
"" let g:go_def_mode = 'guru'
"
"" :GoDeclsはデフォルトで関数と型を表示する Default->"func,type"
"" 型だけにしたいときは"func"だけを指定
"" let g:go_decls_includes = "func,type"
"
"" カーソル上のワードに対して:GoInfo実行
"let g:go_auto_type_info = 1
"" :GoInfo更新時間 Default->800
"autocmd FileType go set updatetime=100
"" または:GoInfoのキーバインドを設定
"" autocmd FileType go nmap <Leader>i <Plug>(go-info)
"
"" 同じIDをカーソルがワードに移動するごとにハイライト Default->0
"" let g:go_auto_sameids = 1
"" または:GoSameIdsToggleのキーバインドを設定
"autocmd FileType go nmap <Leader>s :GoSameIdsToggle<CR>
"
"" :GoPlayでページをブラウザに読み込まない Default->1
"let g:go_play_open_browser = 0

" === Others ===
" GoInstallBinaries: vim-goに必要なツールのインストール(go get がバックグラウンドで動いて大変時間がかかる)
" GoUpdateBinaries: GoInstallBinariesで落としたツールのアップデート
" GoImport: importパスの追加
" GoImportAs: importパスの追加(パッケージ名変更)
" GoDrop: importパスの削除
" GoDef: ctagsジャンプと同じ(ショートカットキー<C-]>)
" GoDecls: gtagsジャンプと同じ(ファイル内のみ対象) ctrlPやFZFと連携
" GoDeclsdir: gtagsジャンプと同じ(ディレクトリ内の全ファイル対象)
" GoReferrers: gtagsジャンプと似たようなもん？GoDeclsと違ってロケーションリストに表示
" GoDescribe: フィールドの定義、メソッドの組と URL 構造体のフィールドが表示される
" GoImplements: 型が実装しているインターフェースをロケーションリストに表示
" GoWhicherrs: モードはエラーの型の値に現れうる可能な定数の組、グローバル変数、そして具象型を報告
" GoCallees: 関数を呼び出す可能性のあるターゲットを表示
" GoCallstack: 選択部分を含む関数へのコールグラフの根本からの任意のパスを表示
" GoChannelPeers: チャンネルの送信先 / 受信先を表示
" GoRename: GOPATH 以下にある全てのパッケージを検索してその識別子に依存している全ての識別子をリネーム
" GoFreevars: どれだけ多くの変数に依存しているかを見る
" GoGenarate: コード生成
" GoImpl: インターフェースを実装するメソッドスタブの生成
" GoPlay: コードをGo Playground に公開する(リンクはバッファかクリップボードにコピーされる)
