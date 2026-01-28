# tmux 改善案

今後実装を検討している tmux 設定の改善案。

---

## 1. True color / Undercurl サポート

**優先度**: 高

```tmux
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # undercurl colors
```

**効果**: Neovimのカラースキームが正確に表示され、エラー波線 (undercurl) が見やすくなる

---

## 2. インデックスを1始まりに

**優先度**: 高

```tmux
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
```

**効果**: `M-1`〜`M-9` でのウィンドウ切り替えがキーボード配置と一致

---

## 3. クリップボード (クロスプラットフォーム対応)

**優先度**: 高

```tmux
# OSを検出して適切なコマンドを使用
if-shell "uname | grep -q Darwin" {
  set -g @copy_command "pbcopy"
} {
  if-shell "command -v xclip" {
    set -g @copy_command "xclip -selection clipboard"
  } {
    set -g @copy_command "xsel --clipboard --input"
  }
}
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "#{@copy_command}"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "#{@copy_command}"
```

**効果**: macOS / Linux / WSL2 すべてで動作

---

## 4. フォーカスイベント有効化

**優先度**: 中

```tmux
set -g focus-events on
```

**効果**: Neovim が `FocusGained` / `FocusLost` を検出可能に (autoread等が機能する)

---

## 5. ウィンドウ番号でのジャンプ

**優先度**: 中

```tmux
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5
bind -n M-6 select-window -t 6
bind -n M-7 select-window -t 7
bind -n M-8 select-window -t 8
bind -n M-9 select-window -t 9
```

**効果**: 数字キーで直接ウィンドウにジャンプ

---

## 6. セッション操作の強化

**優先度**: 低 (複数セッション使用時のみ必要)

```tmux
# セッション一覧をポップアップで表示 (tmux 3.2+)
bind -n M-S display-popup -E "tmux list-sessions | fzf --reverse | cut -d: -f1 | xargs tmux switch-client -t"

# 新しいセッション作成
bind -n M-N command-prompt -p "New session:" "new-session -s '%%'"

# 直前のセッションに切り替え
bind -n M-Tab switch-client -l
```

**効果**: 複数セッション間の移動が高速に

**依存**: fzf

---

## 7. ポップアップターミナル

**優先度**: 低 (tmux 3.2+ 必須)

```tmux
# 一時的なポップアップシェル
bind -n M-g display-popup -w 80% -h 80% -E "zsh"

# lazygit をポップアップで
bind -n M-G display-popup -w 90% -h 90% -E "lazygit"
```

**効果**: 現在の作業を中断せずにクイック操作

**依存**: lazygit (optional)

---

## 8. コピーモードの視認性向上

**優先度**: 低

```tmux
set -g mode-style "fg=black,bg=cyan"
```

**効果**: 選択範囲がカラースキーマとマッチ

---

## 9. Vim-tmux シームレス移動

**優先度**: 中

```tmux
# vim-tmux-navigator との連携
# Neovim側にも対応プラグインが必要
is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
```

**効果**: vim/neovim の split と tmux pane を同じキーで移動可能

**依存**: christoomey/vim-tmux-navigator (Neovim側)

---

## 10. ネストした tmux 対応

**優先度**: 低 (SSH先でtmux使用時のみ)

```tmux
# F12でローカルtmuxのキーバインドをON/OFF切り替え
bind -T root F12  \
  set prefix None \;\
  set key-table off \;\
  set status-style "fg=colour245,bg=colour238" \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S

bind -T off F12 \
  set -u prefix \;\
  set -u key-table \;\
  set -u status-style \;\
  refresh-client -S
```

**効果**: SSH先の tmux にキー操作を透過、ステータスバーの色で状態を識別

---

## 11. 長時間コマンド完了通知

**優先度**: 低

```tmux
# ベル音を有効化
set -g visual-bell off
set -g bell-action any

# 以下はシェル側 (.zshrc) に追加
# preexec() { cmd_start=$SECONDS }
# precmd() {
#   [ $((SECONDS - cmd_start)) -gt 10 ] && echo -e '\a'
# }
```

**効果**: 10秒以上かかったコマンドが終了したらベル通知

---

## 12. URL抽出・オープン

**優先度**: 低

```tmux
# tmux-fzf-url プラグインを使用
set -g @plugin 'wfxr/tmux-fzf-url'

# または手動でキーバインド
bind-key u run-shell -b "tmux capture-pane -J -p | grep -oE '(https?://|www\\.)[^ ]+' | fzf --reverse | xargs -r xdg-open"
```

**効果**: pane内のURLをfzfで選択して開く

**依存**: fzf, xdg-open (Linux) / open (macOS)

---

## 13. Pane スワップ操作

**優先度**: 中

```tmux
# 現在のpaneを前/次のpaneと入れ替え
bind -n M-{ swap-pane -U
bind -n M-} swap-pane -D

# paneを別ウィンドウに移動
bind-key ! break-pane
bind-key @ join-pane -h -t :-
```

**効果**: paneレイアウトの素早い調整

---

## 14. スクラッチpane (メモ用)

**優先度**: 低 (tmux 3.2+ 必須)

```tmux
# toggle でスクラッチターミナルを表示/非表示
bind -n M-\` if-shell -F '#{==:#{session_name},scratch}' {
  detach-client
} {
  display-popup -E -w 80% -h 70% "tmux new-session -A -s scratch"
}
```

**効果**: いつでも呼び出せる一時作業用ターミナル

---

## 15. Aggressive resize

**優先度**: 低

```tmux
setw -g aggressive-resize on
```

**効果**: 複数クライアントが接続している場合、アクティブなクライアントに合わせてリサイズ

---

## 16. escape-time 最適化

**優先度**: 高

```tmux
set -sg escape-time 10
```

**効果**: vim/neovim で Esc キーの反応が速くなる (デフォルト 500ms → 10ms)

**注意**: tmux-sensible プラグインが 0 に設定するが、一部環境では 10ms 程度が安定

---

## 17. 履歴検索改善

**優先度**: 低

```tmux
# コピーモードでインクリメンタル検索
bind-key -T copy-mode-vi / command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
bind-key -T copy-mode-vi ? command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
```

**効果**: `/` で検索時、入力に応じてリアルタイムでハイライト

---

## 18. Pane同期の視覚的フィードバック

**優先度**: 中

```tmux
# ステータスバーに同期状態を表示
set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P#{?synchronize-panes, #[fg=red][SYNC],}"
```

**効果**: synchronize-panes が有効な時、ステータスバーに `[SYNC]` を表示

---

## 19. Pane Dump Mode (履歴書き出し)

**優先度**: 中

pane の出力履歴をファイルに書き出す機能。デバッグログ保存やコマンド出力記録に便利。

### 基本版: ワンキーダンプ

```tmux
# M-P で現在のpaneをダンプ
bind -n M-P run-shell 'tmux capture-pane -pS - > ~/tmux-dump-$(date +%Y%m%d-%H%M%S).txt && tmux display "Pane dumped!"'
```

### 拡張版: スクリプトベース

```bash
#!/bin/bash
# ~/.local/bin/tmux-dump

PANE=${1:-}
FORMAT=${2:-plain}  # plain, ansi, numbered

SESSION=$(tmux display -p '#{session_name}')
WINDOW=$(tmux display -p '#{window_index}')
PANE_IDX=$(tmux display -p '#{pane_index}')
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTFILE=~/tmux-dumps/${SESSION}_w${WINDOW}_p${PANE_IDX}_${TIMESTAMP}.txt

mkdir -p ~/tmux-dumps

case $FORMAT in
  ansi)    tmux capture-pane -epS - ${PANE:+-t $PANE} > "$OUTFILE" ;;
  numbered) tmux capture-pane -pS - ${PANE:+-t $PANE} | nl > "$OUTFILE" ;;
  *)       tmux capture-pane -pS - ${PANE:+-t $PANE} > "$OUTFILE" ;;
esac

tmux display "Dumped to $OUTFILE"
```

### tmux.conf キーバインド

```tmux
# シンプル版
bind -n M-P run-shell "~/.local/bin/tmux-dump"

# pane選択 → ダンプ
bind P display-panes -d 0 "run-shell '~/.local/bin/tmux-dump %%'"
```

### fzf でpane選択 + プレビュー

```tmux
bind -n M-C-p display-popup -E '\
  tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
  fzf --preview "tmux capture-pane -pt {1} | head -30" | \
  cut -d" " -f1 | \
  xargs -I{} sh -c "tmux capture-pane -pS - -t {} > ~/tmux-dumps/dump_$(date +%Y%m%d-%H%M%S).txt && tmux display Dumped!"'
```

**効果**:
- `M-P`: 現在paneを即座にダンプ
- `prefix + P`: pane選択後にダンプ
- `M-C-p`: fzfでプレビューしながら選択

**出力形式**:
- `plain`: プレーンテキスト
- `ansi`: ANSIエスケープシーケンス付き (色を保持)
- `numbered`: 行番号付き

---

## 20. Pane Recording Mode (開始/終了方式)

**優先度**: 中

#19 の Dump Mode とは異なり、**記録開始 → 作業 → 記録終了** の制御で必要な部分だけを記録。

### 特徴比較

| | Dump Mode (#19) | Recording Mode (#20) |
|---|-----------------|---------------------|
| 用途 | 過去の履歴を保存 | これからの出力を記録 |
| 操作 | `M-P` 1回押し | `M-R` で開始/終了 |
| データ | 履歴全体 | 必要な部分だけ |
| 視覚表示 | 一時メッセージ | 常時 `[REC]` 表示 |

### スクリプト: ~/.local/bin/tmux-record

```bash
#!/bin/bash
# tmux-record - pane recording toggle

RECORDING=$(tmux show -pv @recording 2>/dev/null)

if [ "$RECORDING" = "on" ]; then
    # 記録停止
    tmux pipe-pane
    FILE=$(tmux show -pv @recording_file)
    START=$(tmux show -pv @recording_start)
    DURATION=$(($(date +%s) - START))

    tmux set -p @recording ""
    tmux set -p @recording_file ""
    tmux set -p @recording_start ""

    tmux display "Recording stopped: $FILE (${DURATION}s)"
else
    # 記録開始
    SESSION=$(tmux display -p '#{session_name}')
    WINDOW=$(tmux display -p '#{window_index}')
    PANE_IDX=$(tmux display -p '#{pane_index}')
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    FILE=~/tmux-recordings/${SESSION}_w${WINDOW}_p${PANE_IDX}_${TIMESTAMP}.log

    mkdir -p ~/tmux-recordings

    echo "=== Recording started: $(date) ===" > "$FILE"
    echo "=== Session: $SESSION, Window: $WINDOW, Pane: $PANE_IDX ===" >> "$FILE"
    echo "" >> "$FILE"

    tmux pipe-pane -o "cat >> '$FILE'"
    tmux set -p @recording "on"
    tmux set -p @recording_file "$FILE"
    tmux set -p @recording_start "$(date +%s)"

    tmux display "Recording started: $FILE"
fi
```

### tmux.conf キーバインド

```tmux
# 記録トグル
bind -n M-R run-shell "~/.local/bin/tmux-record"

# ステータスバーに記録状態表示
set -g status-left "#[fg=green]#S #[fg=yellow]#I #[fg=cyan]#P#{?@recording,#[fg=red] [REC],}"

# pane-border に記録状態表示
set -g pane-border-format " #P: #{pane_current_command}#{?@recording, [REC],} "
```

**効果**:
- `M-R`: 記録開始/停止をトグル
- 記録中は `[REC]` がステータスバー/pane境界に表示
- 停止時に記録時間を表示

**出力先**: `~/tmux-recordings/session_w1_p0_20260116-123456.log`

---

## 21. Window 名の自動命名改善

**優先度**: 中

複数windowを区別しやすくするための命名方式。

### 方式一覧

| 方式 | 例 | 設定 |
|------|-----|------|
| ディレクトリ名 | `myapp` | `automatic-rename-format '#{b:pane_current_path}'` |
| Git リポ名 | `dotfiles:main` | スクリプト必要 |
| SSH ホスト名 | `user@server` | シェル設定も必要 |
| プロセス階層 | `vim` ↔ `myapp` | 動的変更 |

### 推奨: ハイブリッド方式

```tmux
set -g automatic-rename on
set -g automatic-rename-format '#(~/.local/bin/tmux-smart-window-name "#{pane_current_path}" "#{pane_current_command}" "#{pane_title}")'
```

```bash
#!/bin/bash
# ~/.local/bin/tmux-smart-window-name
path="$1"
cmd="$2"
title="$3"

case "$cmd" in
    ssh)
        echo "${title:-ssh}"
        ;;
    vim|nvim)
        echo "vim:$(basename "$path")"
        ;;
    *)
        if git -C "$path" rev-parse 2>/dev/null; then
            basename "$(git -C "$path" rev-parse --show-toplevel)"
        else
            basename "$path"
        fi
        ;;
esac
```

### シンプル版: プロセス階層考慮

```tmux
# スクリプト不要の簡易版
set -g automatic-rename on
set -g automatic-rename-format '#{?#{==:#{pane_current_command},zsh},#{b:pane_current_path},#{pane_current_command}}'
```

**効果**:
- シェル実行中 → ディレクトリ名 (`myapp`)
- コマンド実行中 → コマンド名 (`vim`, `npm`)

### 手動命名プロンプト

```tmux
# 新規window作成時に名前入力
bind -n M-T command-prompt -p "Window name:" "new-window -n '%%' -c '#{pane_current_path}'"
```

---

## 22. ヘルプ/チートシート表示

**優先度**: 中

キーバインドを忘れがちな場合のためのヘルプ表示機能。

### 方式一覧

| 方式 | 特徴 | キー例 |
|------|------|--------|
| ポップアップ | 見やすいチートシート | `M-?` |
| fzf動的一覧 | 検索・実行可能 | `M-/` |
| カテゴリメニュー | Pane/Window等で分類 | - |
| ステータスバー | ランダムヒント | 常時 |
| which-key | prefix後に候補表示 | prefix後 |
| コンテキスト | モード別ヘルプ | - |

### 推奨: ポップアップチートシート

```tmux
bind -n M-? display-popup -w 60% -h 70% -E "cat ~/.tmux-cheatsheet.txt | less"
```

```text
# ~/.tmux-cheatsheet.txt
╔══════════════════════════════════════════════════════════╗
║                    TMUX CHEATSHEET                       ║
╠══════════════════════════════════════════════════════════╣
║ PANE                                                     ║
║   M-d      横分割        M-D      縦分割                 ║
║   M-h/j/k/l  移動        M-H/J/K/L  リサイズ             ║
║   M-q      閉じる        M-f      最大化                 ║
╠══════════════════════════════════════════════════════════╣
║ WINDOW                                                   ║
║   M-t      新規          M-Q      閉じる                 ║
║   M-n/p    次/前         M-1~9    番号で移動             ║
╠══════════════════════════════════════════════════════════╣
║ COPY MODE                                                ║
║   prefix+[  開始         v 選択   y コピー   q 終了     ║
╠══════════════════════════════════════════════════════════╣
║ RECORDING                                                ║
║   M-P      履歴ダンプ    M-R      記録開始/停止          ║
╚══════════════════════════════════════════════════════════╝
```

### fzf動的一覧 (検索・実行)

```bash
#!/bin/bash
# ~/.local/bin/tmux-help
tmux list-keys | \
  fzf --reverse --header="tmux keybindings" | \
  awk '{$1=$2=""; print $0}' | \
  xargs -I{} tmux {}
```

```tmux
bind -n M-/ display-popup -w 80% -h 80% -E "~/.local/bin/tmux-help"
```

### ステータスバーヒント

```tmux
set -g status-right "#(shuf -n1 ~/.tmux-tips.txt) | %H:%M"
```

**効果**:
- `M-?`: チートシート表示
- `M-/`: fzfで検索・実行
- ステータスバーでランダムヒント

---

## 23. Claude連携機能

**優先度**: 中

Claude Code CLI での開発作業を効率化する機能群。

### 機能一覧

| キー | 機能 | 説明 |
|------|------|------|
| `M-C` | 専用レイアウト | 3pane環境を即座に構築 |
| `M-c` | 自動キャプチャ | セッションを自動保存 |
| `M-y` | 出力コピー | 最新レスポンスをコピー |
| `M-E` | エラー送信 | エラー出力をClaudeに送信 |
| `M-F` | ファイル送信 | コードをClaudeに送信 |
| `M-x` | コード実行 | 生成コードを別paneで実行 |

### Claude専用レイアウト

```bash
#!/bin/bash
# ~/.local/bin/tmux-claude-layout
# 3pane: Claude (左60%) | Editor (右上) | Terminal (右下)
tmux split-window -h -p 40
tmux split-window -v -p 50
tmux select-pane -t 0
tmux send-keys "claude" Enter
```

```tmux
bind -n M-C run-shell "~/.local/bin/tmux-claude-layout"
```

### エラー出力をClaudeに送信

```bash
#!/bin/bash
# ~/.local/bin/tmux-send-error-to-claude
error=$(tmux capture-pane -t:.- -pS -50 | tail -20)
tmux select-pane -t:.+
tmux send-keys "以下のエラーを修正して:"
tmux send-keys Enter
tmux send-keys "\`\`\`"
tmux send-keys "$error"
tmux send-keys "\`\`\`"
```

```tmux
bind -n M-E run-shell "~/.local/bin/tmux-send-error-to-claude"
```

### pane識別 (Claudeアイコン)

```tmux
set -g pane-border-format " #P: #{?#{==:#{pane_current_command},claude},🤖 Claude,#{pane_current_command}} "
```

**効果**:
- `M-C`: Claude開発環境を即座にセットアップ
- `M-E`: エラーをワンキーでClaudeに送信
- Claudeペインを視覚的に識別

---

## 24. コピーモードの位置情報表示

**優先度**: 中

コピーモード時に現在のスクロール位置や履歴内の位置を表示する機能。

### pane境界に位置を表示

```tmux
# コピーモード時に位置情報を表示
set -g pane-border-format " #P: #{pane_current_command}#{?pane_in_mode, [COPY #{scroll_position}/#{history_size}],} "
```

**表示例**:
```
─ 0: zsh [COPY 142/5000] ─────────────
```

### ステータスバーに表示する場合

```tmux
# status-right にコピーモード状態を追加
set -g status-right "#{?pane_in_mode,#[fg=yellow][COPY L:#{scroll_position}] ,}#[fg=cyan][%Y-%m-%d %H:%M]"
```

### 利用可能な変数

| 変数 | 説明 |
|------|------|
| `#{scroll_position}` | 現在のスクロール位置（上から何行目） |
| `#{history_size}` | 履歴の総行数 |
| `#{cursor_y}` | 画面内でのカーソルY座標 |
| `#{cursor_x}` | 画面内でのカーソルX座標 |
| `#{pane_in_mode}` | コピーモード中なら1 |
| `#{copy_cursor_line}` | コピーモードでのカーソル行 |

### 拡張: 検索マッチ数表示 (tmux 3.1+)

```tmux
set -g pane-border-format " #P: #{pane_current_command}#{?pane_in_mode, [COPY #{scroll_position}/#{history_size}#{?search_present, (#{search_count} matches),}],} "
```

**効果**:
- コピーモード中に「今どこにいるか」が一目でわかる
- 長い履歴をスクロールする際に位置を把握しやすい
- 検索時にマッチ数も表示可能

---

## 25. モードヒント表示 (Zellij風)

**優先度**: 高

Zellijの最大の特徴である「現在モードで使えるキーをステータスバーに常時表示」をtmuxで実現。

### 基本実装

```tmux
# ステータスバー下部にヒント表示
set -g status 2
set -g status-format[1] '#[align=centre,fg=colour245]<M-d> split-h | <M-D> split-v | <M-h/j/k/l> move | <M-q> close | <M-f> zoom'
```

### モード別ヒント表示

```tmux
# コピーモード時は別のヒントを表示
set -g status-format[1] '#{?pane_in_mode,#[align=centre,fg=yellow]<v> select | <y> copy | </> search | <q> quit,#[align=centre,fg=colour245]<M-d> split | <M-hjkl> move | <M-q> close}'
```

### 完全版: 複数行ステータス

```tmux
set -g status 2
set -g status-format[0] '#[align=left]#S #I:#P #[align=centre]#W #[align=right]%H:%M'
set -g status-format[1] '#[align=centre,fg=colour245]PANE: M-d/D split | M-hjkl move | M-HJKL resize | M-f zoom | M-q close'
```

**効果**:
- キーバインドを覚えていなくても操作可能
- 初心者に優しい
- モードに応じたコンテキストヘルプ

---

## 26. フローティングペイン

**優先度**: 中 (tmux 3.2+)

Zellijのフローティングペインをtmuxの `display-popup` で実現。通常ペインの上に浮かぶ一時的なペイン。

### 基本実装

```tmux
# フローティングシェルをトグル
bind -n M-F if-shell -F '#{==:#{session_name},floating}' {
    detach-client
} {
    display-popup -E -w 80% -h 80% "tmux new-session -A -s floating"
}
```

### 複数フローティングペイン管理

```bash
#!/bin/bash
# ~/.local/bin/tmux-floating
# フローティングペインの作成・切り替え

NAME=${1:-float-main}
if tmux has-session -t "=$NAME" 2>/dev/null; then
    tmux display-popup -E -w 80% -h 80% "tmux attach -t '=$NAME'"
else
    tmux display-popup -E -w 80% -h 80% "tmux new-session -s '$NAME'"
fi
```

```tmux
bind -n M-F run-shell "~/.local/bin/tmux-floating"
bind -n M-1 run-shell "~/.local/bin/tmux-floating float-1"
bind -n M-2 run-shell "~/.local/bin/tmux-floating float-2"
```

### fzfでフローティング選択

```tmux
bind -n M-C-f display-popup -E '\
    echo "float-main\nfloat-work\nfloat-scratch" | \
    fzf --reverse --header="Select floating pane" | \
    xargs -I{} tmux display-popup -E -w 80% -h 80% "tmux new-session -A -s {}"'
```

**効果**:
- 作業を中断せずに一時的なタスクを実行
- 複数のフローティングペインを管理可能
- Zellij風のワークフロー

---

## 27. レイアウトの保存・復元 (名前付き)

**優先度**: 中

Zellijの `.kdl` レイアウトファイルのように、カスタムレイアウトを定義・呼び出し。

### レイアウト保存スクリプト

```bash
#!/bin/bash
# ~/.local/bin/tmux-layout-save
# 現在のレイアウトを名前付きで保存

NAME=${1:-default}
LAYOUT_DIR=~/.tmux/layouts
mkdir -p "$LAYOUT_DIR"

LAYOUT=$(tmux display -p '#{window_layout}')
echo "$LAYOUT" > "$LAYOUT_DIR/$NAME.layout"
tmux display "Layout saved: $NAME"
```

### レイアウト復元スクリプト

```bash
#!/bin/bash
# ~/.local/bin/tmux-layout-load
# 保存したレイアウトを復元

NAME=${1:-default}
LAYOUT_DIR=~/.tmux/layouts

if [ -f "$LAYOUT_DIR/$NAME.layout" ]; then
    LAYOUT=$(cat "$LAYOUT_DIR/$NAME.layout")
    tmux select-layout "$LAYOUT"
    tmux display "Layout loaded: $NAME"
else
    tmux display "Layout not found: $NAME"
fi
```

### プリセットレイアウト

```bash
#!/bin/bash
# ~/.local/bin/tmux-layout-preset
# よく使うレイアウトをプリセットとして定義

case ${1:-} in
    dev)
        # 開発用: メイン(左60%) | エディタ(右上) | ターミナル(右下)
        tmux split-window -h -p 40
        tmux split-window -v -p 50
        tmux select-pane -t 0
        ;;
    monitor)
        # モニタリング用: 4分割
        tmux split-window -h -p 50
        tmux split-window -v -p 50
        tmux select-pane -t 0
        tmux split-window -v -p 50
        ;;
    writing)
        # 執筆用: メイン(中央70%) | サイド
        tmux split-window -h -p 15
        tmux split-window -h -b -p 18
        tmux select-pane -t 1
        ;;
    *)
        echo "Presets: dev, monitor, writing"
        ;;
esac
```

### tmux.conf キーバインド

```tmux
# レイアウト保存 (プロンプト)
bind L command-prompt -p "Save layout as:" "run-shell '~/.local/bin/tmux-layout-save %%'"

# レイアウト復元 (fzf選択)
bind l display-popup -E '\
    ls ~/.tmux/layouts/*.layout 2>/dev/null | xargs -n1 basename | sed "s/.layout//" | \
    fzf --reverse --header="Load layout" | \
    xargs -I{} tmux run-shell "~/.local/bin/tmux-layout-load {}"'

# プリセットレイアウト選択
bind M-l display-popup -E '\
    echo "dev\nmonitor\nwriting" | \
    fzf --reverse --header="Select preset" | \
    xargs -I{} tmux run-shell "~/.local/bin/tmux-layout-preset {}"'
```

**効果**:
- よく使うレイアウトを即座に復元
- プロジェクトごとにレイアウトを保存
- Zellij風のレイアウト管理

---

## 28. ペインスタック (タブ化)

**優先度**: 低 (tmux 3.2+)

同じ場所に複数ペインを重ねてタブのように切り替え。Zellijの stacked panes 相当。

### 実装コンセプト

tmuxには直接的なスタック機能はないが、以下で擬似的に実現:
1. 複数ペインを作成し、1つ以外を最小化
2. キーで切り替え時に表示/非表示を切り替え

### スクリプトベース実装

```bash
#!/bin/bash
# ~/.local/bin/tmux-stack
# ペインのスタック管理

ACTION=${1:-toggle}
STACK_GROUP=$(tmux display -p '#{pane_id}')

case $ACTION in
    add)
        # 新しいペインをスタックに追加
        tmux split-window -v -l 1
        NEW_PANE=$(tmux display -p '#{pane_id}')
        tmux set -p @stack_group "$STACK_GROUP"
        tmux resize-pane -Z
        ;;
    next)
        # スタック内の次のペインに切り替え
        # (実装は複雑なため、簡易版としてウィンドウ内の次のペインに移動)
        tmux select-pane -t :.+ \; resize-pane -Z
        ;;
    prev)
        tmux select-pane -t :.- \; resize-pane -Z
        ;;
esac
```

### シンプル版: ズーム + ペイン切り替え

```tmux
# ズーム状態で次/前のペインに切り替え
bind -n M-] select-pane -t :.+ \; resize-pane -Z
bind -n M-[ select-pane -t :.- \; resize-pane -Z
```

**効果**:
- 画面を分割せずに複数のコンテキストを切り替え
- タブ感覚でペインを使用

**注意**: 完全なZellij風スタックは困難。ズーム+切り替えで代用。

---

## 29. インラインセッションマネージャー

**優先度**: 中 (tmux 3.2+)

Zellijの `session-manager` のようなポップアップUIでセッション管理。

### 基本実装

```bash
#!/bin/bash
# ~/.local/bin/tmux-session-manager

ACTION=$(echo -e "switch\nnew\nrename\nkill" | fzf --reverse --header="Session Manager")

case $ACTION in
    switch)
        tmux list-sessions -F "#{session_name}" | \
        fzf --reverse --header="Switch to session" \
            --preview 'tmux list-windows -t {}' | \
        xargs -r tmux switch-client -t
        ;;
    new)
        read -p "Session name: " name
        tmux new-session -d -s "$name"
        tmux switch-client -t "$name"
        ;;
    rename)
        read -p "New name: " name
        tmux rename-session "$name"
        ;;
    kill)
        tmux list-sessions -F "#{session_name}" | \
        fzf --reverse --multi --header="Kill sessions (TAB to select multiple)" | \
        xargs -r -I{} tmux kill-session -t {}
        ;;
esac
```

### tmux.conf キーバインド

```tmux
bind -n M-S display-popup -E -w 60% -h 60% "~/.local/bin/tmux-session-manager"
```

### オールインワン版 (fzf単体)

```tmux
bind -n M-S display-popup -E -w 70% -h 70% '\
    tmux list-sessions -F "#{session_name} (#{session_windows} windows)" | \
    fzf --reverse \
        --header="Sessions | ENTER:switch | Ctrl-N:new | Ctrl-D:delete" \
        --bind "ctrl-n:execute(read -p \"Name: \" n && tmux new-session -d -s \"$n\")+reload(tmux list-sessions -F \"#{session_name} (#{session_windows} windows)\")" \
        --bind "ctrl-d:execute(echo {} | cut -d\" \" -f1 | xargs tmux kill-session -t)+reload(tmux list-sessions -F \"#{session_name} (#{session_windows} windows)\")" \
        --preview "tmux list-windows -t {1}" | \
    cut -d" " -f1 | \
    xargs -r tmux switch-client -t'
```

**効果**:
- セッション一覧・作成・削除・切り替えを一箇所で
- プレビュー付きで選択
- Zellij風の直感的なUI

---

## 30. ペインタイトル/注釈

**優先度**: 中

各ペインに名前やメモを付けて識別しやすくする。

### 基本実装

```tmux
# ペインタイトルを設定
bind T command-prompt -p "Pane title:" "select-pane -T '%%'"

# pane-border-format でタイトルを表示
set -g pane-border-format " #P: #{?pane_title,#{pane_title},#{pane_current_command}} "
```

### 絵文字アイコン付き

```tmux
# アイコン付きタイトル設定
bind T command-prompt -p "Pane title (use emoji!):" "select-pane -T '%%'"

# 表示例: " 0: 🔧 Build Server "
set -g pane-border-format " #P: #{?pane_title,#{pane_title},#{pane_current_command}} "
```

### プリセットタイトル

```bash
#!/bin/bash
# ~/.local/bin/tmux-pane-title
# プリセットからタイトルを選択

TITLES="🔧 Build
📝 Editor
🖥️ Terminal
🧪 Test
📊 Monitor
🔍 Debug
📦 Docker
🌐 Server"

SELECTED=$(echo "$TITLES" | fzf --reverse --header="Select pane title")
if [ -n "$SELECTED" ]; then
    tmux select-pane -T "$SELECTED"
fi
```

```tmux
bind M-t display-popup -E "~/.local/bin/tmux-pane-title"
```

**効果**:
- 複数ペインを開いているときに役割が一目でわかる
- 絵文字で視覚的に区別
- プリセットで素早く設定

---

## 31. ペインロック機能

**優先度**: 低

誤って `M-q` で閉じないようにペインをロックする機能。

### 実装

```bash
#!/bin/bash
# ~/.local/bin/tmux-pane-lock
# ペインのロック状態をトグル

LOCKED=$(tmux show -pv @locked 2>/dev/null)

if [ "$LOCKED" = "1" ]; then
    tmux set -p @locked ""
    tmux display "Pane UNLOCKED"
else
    tmux set -p @locked "1"
    tmux display "Pane LOCKED 🔒"
fi
```

### ロック対応の kill-pane

```bash
#!/bin/bash
# ~/.local/bin/tmux-safe-kill-pane
# ロックされていないペインのみ閉じる

LOCKED=$(tmux show -pv @locked 2>/dev/null)

if [ "$LOCKED" = "1" ]; then
    tmux display "Pane is LOCKED! Press M-L to unlock first."
else
    tmux kill-pane
fi
```

### tmux.conf キーバインド

```tmux
# ロックトグル
bind -n M-C-l run-shell "~/.local/bin/tmux-pane-lock"

# M-q をセーフ版に置き換え
bind -n M-q run-shell "~/.local/bin/tmux-safe-kill-pane"

# ロック状態をpane境界に表示
set -g pane-border-format " #P: #{pane_current_command}#{?@locked, 🔒,} "
```

**効果**:
- 重要なペイン（長時間実行中のプロセスなど）を誤って閉じない
- ロック状態が視覚的にわかる

---

## 32. クイックアクションメニュー

**優先度**: 中 (tmux 3.2+)

fzfで操作を選んで実行するZellij風のアクションメニュー。

### 基本実装

```bash
#!/bin/bash
# ~/.local/bin/tmux-action-menu

ACTIONS="split-horizontal|M-d|tmux split-window -h -c '#{pane_current_path}'
split-vertical|M-D|tmux split-window -v -c '#{pane_current_path}'
new-window|M-t|tmux new-window -c '#{pane_current_path}'
close-pane|M-q|tmux kill-pane
zoom-toggle|M-f|tmux resize-pane -Z
next-window|M-n|tmux select-window -t :+
prev-window|M-p|tmux select-window -t :-
rename-window|prefix+,|tmux command-prompt -p 'Window name:' 'rename-window %%'
sync-panes|M-s|tmux set synchronize-panes
copy-mode|prefix+[|tmux copy-mode
reload-config|prefix+r|tmux source-file ~/.tmux.conf"

echo "$ACTIONS" | \
    column -t -s'|' | \
    fzf --reverse --header="Quick Actions" \
        --preview-window=hidden | \
    cut -d'|' -f3 | \
    xargs -r -I{} sh -c '{}'
```

### tmux.conf キーバインド

```tmux
bind -n M-a display-popup -E -w 50% -h 60% "~/.local/bin/tmux-action-menu"
```

### カテゴリ分け版

```bash
#!/bin/bash
# ~/.local/bin/tmux-action-menu-v2

CATEGORY=$(echo -e "Pane\nWindow\nSession\nLayout\nOther" | fzf --reverse --header="Category")

case $CATEGORY in
    Pane)
        ACTION=$(echo -e "split-h\nsplit-v\nclose\nzoom\nswap-up\nswap-down\nlock" | fzf --reverse)
        case $ACTION in
            split-h) tmux split-window -h ;;
            split-v) tmux split-window -v ;;
            close) tmux kill-pane ;;
            zoom) tmux resize-pane -Z ;;
            swap-up) tmux swap-pane -U ;;
            swap-down) tmux swap-pane -D ;;
            lock) ~/.local/bin/tmux-pane-lock ;;
        esac
        ;;
    Window)
        ACTION=$(echo -e "new\nclose\nrename\nnext\nprev" | fzf --reverse)
        case $ACTION in
            new) tmux new-window ;;
            close) tmux kill-window ;;
            rename) tmux command-prompt "rename-window '%%'" ;;
            next) tmux select-window -t :+ ;;
            prev) tmux select-window -t :- ;;
        esac
        ;;
    # ... 他のカテゴリも同様
esac
```

**効果**:
- キーバインドを覚えていなくても操作可能
- 操作の発見性が向上
- Zellij風の直感的なワークフロー

---

## 33. ペイン境界のカスタマイズ

**優先度**: 低

ペイン境界線のスタイルをカスタマイズして視認性向上。

### 基本設定

```tmux
# 境界線の文字を変更
set -g pane-border-lines single  # single, double, heavy, simple, number

# アクティブペインを目立たせる
set -g pane-border-style fg=colour240
set -g pane-active-border-style fg=cyan,bold

# 境界にステータス情報を表示
set -g pane-border-status top
set -g pane-border-format " #{pane_index}: #{pane_current_command} [#{pane_width}x#{pane_height}] "
```

### 条件付きスタイル

```tmux
# 同期モード時に境界を赤く
set -g pane-active-border-style "#{?synchronize-panes,fg=red,fg=cyan}"
```

**効果**:
- アクティブペインが一目でわかる
- ペインサイズの表示
- モード別の色分け

---

## 34. マウス操作の強化

**優先度**: 中

マウスでの操作をより便利に。

### 基本設定

```tmux
set -g mouse on

# ダブルクリックで単語選択
bind -T copy-mode-vi DoubleClick1Pane select-pane \; send-keys -X select-word

# トリプルクリックで行選択
bind -T copy-mode-vi TripleClick1Pane select-pane \; send-keys -X select-line

# 右クリックでペーストメニュー
bind -T root MouseDown3Pane if-shell -F -t = "#{||:#{mouse_any_flag},#{pane_in_mode}}" "select-pane -t=; send-keys -M" "display-menu -t= -xM -yM -T '#[align=centre]Paste' 'Paste' p 'paste-buffer' 'Paste from clipboard' P 'run \"xclip -o | tmux load-buffer - && tmux paste-buffer\"'"
```

### ドラッグでペインリサイズ

```tmux
# デフォルトで有効だが、感度調整
set -g @dragging-threshold 5
```

### ホイールスクロールでコピーモード

```tmux
bind -T root WheelUpPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"
```

**効果**:
- マウスだけで基本操作が完結
- コピー&ペーストが直感的
- ターミナル初心者にも優しい

---

## 35. ウィンドウ/ペインのプレビュー選択

**優先度**: 中 (tmux 3.2+)

fzfでプレビュー付きでウィンドウやペインを選択。

### ウィンドウ選択

```bash
#!/bin/bash
# ~/.local/bin/tmux-window-picker

tmux list-windows -F "#{window_index}: #{window_name} (#{window_panes} panes)" | \
fzf --reverse \
    --header="Select window" \
    --preview 'tmux capture-pane -t :{1} -p | head -30' \
    --preview-window=right:50% | \
cut -d: -f1 | \
xargs -r tmux select-window -t :
```

### ペイン選択

```bash
#!/bin/bash
# ~/.local/bin/tmux-pane-picker

tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
fzf --reverse \
    --header="Select pane" \
    --preview 'tmux capture-pane -t {1} -p | head -30' | \
cut -d' ' -f1 | \
xargs -r tmux switch-client -t
```

### キーバインド

```tmux
bind w display-popup -E "~/.local/bin/tmux-window-picker"
bind P display-popup -E "~/.local/bin/tmux-pane-picker"
```

**効果**:
- 内容をプレビューしながら選択
- 多くのウィンドウ/ペインがあっても素早く移動
- セッション横断で選択可能

---

## 36. カスタムメニュー

**優先度**: 中 (tmux 3.0+)

右クリックやキーでコンテキストメニューを表示。

### 基本メニュー

```tmux
# prefix + m でメニュー表示
bind m display-menu -T "#[align=centre]Actions" \
    "Horizontal Split" h "split-window -h" \
    "Vertical Split" v "split-window -v" \
    "" \
    "New Window" n "new-window" \
    "Kill Pane" x "kill-pane" \
    "Kill Window" X "kill-window" \
    "" \
    "Swap Up" u "swap-pane -U" \
    "Swap Down" d "swap-pane -D" \
    "" \
    "Reload Config" r "source-file ~/.tmux.conf; display 'Reloaded!'"
```

### ペインコンテキストメニュー

```tmux
bind -T root MouseDown3Pane display-menu -T "#[align=centre]#{pane_index} (#{pane_current_command})" -t = -xM -yM \
    "Split Horizontal" h "split-window -h" \
    "Split Vertical" v "split-window -v" \
    "" \
    "#{?pane_marked,Unmark,Mark}" m "select-pane -m" \
    "Swap Marked" s "swap-pane" \
    "" \
    "Kill" X "kill-pane" \
    "Respawn" R "respawn-pane -k"
```

**効果**:
- GUIライクな操作感
- よく使う操作をまとめて表示
- キーバインドを覚えなくてもOK

---

## 37. バッファ管理の強化

**優先度**: 低

コピーしたテキストの履歴管理。

### バッファ一覧表示

```tmux
# prefix + b でバッファ一覧をfzfで選択
bind b display-popup -E '\
    tmux list-buffers -F "#{buffer_name}: #{buffer_sample}" | \
    fzf --reverse --header="Select buffer to paste" | \
    cut -d: -f1 | \
    xargs -r tmux paste-buffer -b'
```

### バッファをファイルに保存

```tmux
bind B command-prompt -p "Save buffer to:" "save-buffer '%%'"
```

### バッファの最大数設定

```tmux
set -g buffer-limit 50
```

### クリップボード連携

```tmux
# コピー時にシステムクリップボードにも送る
set -g set-clipboard on

# または手動で
bind C run "tmux save-buffer - | xclip -selection clipboard" \; display "Copied to clipboard"
```

**効果**:
- 複数のコピー履歴を保持
- 過去にコピーした内容を再利用
- システムクリップボードとの連携

---

## 38. 条件分岐設定

**優先度**: 中

環境やバージョンに応じた設定の切り替え。

### バージョン分岐

```tmux
# tmux 3.0以上の場合
%if #{>=:#{version},3.0}
    set -g pane-border-status top
%endif

# tmux 3.2以上の場合
%if #{>=:#{version},3.2}
    bind -n M-g display-popup -E "zsh"
%endif
```

### OS分岐

```tmux
# macOS
%if #{==:#{host},*.local}
    set -g default-command "reattach-to-user-namespace -l zsh"
%endif

# if-shell を使う方法
if-shell "uname | grep -q Darwin" {
    set -g default-command "reattach-to-user-namespace -l zsh"
}
```

### SSH接続時の分岐

```tmux
%if #{SSH_CONNECTION}
    set -g status-bg colour52  # SSH時は赤っぽい背景
    set -g prefix C-a          # SSH時はprefix変更
%else
    set -g status-bg black
    set -g prefix C-t
%endif
```

**効果**:
- 1つの設定ファイルで複数環境に対応
- バージョン互換性の維持
- ローカル/リモートの区別

---

## 39. ステータスバー情報の拡張

**優先度**: 低

ステータスバーに有用な情報を追加。

### システム情報

```tmux
# CPU、メモリ、バッテリー (プラグイン使用)
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'tmux-plugins/tmux-battery'

set -g status-right "CPU:#{cpu_percentage} | Batt:#{battery_percentage} | %H:%M"
```

### 天気表示

```bash
#!/bin/bash
# ~/.local/bin/tmux-weather
curl -s "wttr.in/?format=%c%t" 2>/dev/null || echo "N/A"
```

```tmux
set -g status-right "#(~/.local/bin/tmux-weather) | %H:%M"
set -g status-interval 600  # 10分ごとに更新
```

### Gitブランチ表示

```tmux
set -g status-right "#(cd #{pane_current_path}; git branch --show-current 2>/dev/null || echo '-') | %H:%M"
```

### Spotify再生中の曲

```bash
#!/bin/bash
# ~/.local/bin/tmux-spotify (macOS)
osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null | cut -c1-30
```

**効果**:
- 一目でシステム状態を把握
- 外部情報の統合
- カスタマイズの自由度

---

## 40. ペインの自動リネーム抑制

**優先度**: 低

特定のペインで自動リネームを無効化。

### 設定

```tmux
# 全体で自動リネームを有効化
set -g automatic-rename on

# 特定のウィンドウで無効化
bind R set -w automatic-rename off \; display "Auto-rename disabled for this window"
bind r set -w automatic-rename on \; display "Auto-rename enabled for this window"
```

### 手動で名前を設定したら自動リネーム停止

```tmux
# rename-window後に自動リネームをOFF
bind , command-prompt -p "Rename window:" "rename-window '%%'; set -w automatic-rename off"
```

### ペインごとの制御

```tmux
# ペインタイトルを設定
bind T command-prompt -p "Pane title:" "select-pane -T '%%'"

# タイトルが設定されていたらそれを優先表示
set -g pane-border-format " #{?pane_title,#{pane_title},#{pane_current_command}} "
```

**効果**:
- 重要なウィンドウ名を保持
- 自動と手動の使い分け
- 一貫した命名

---

## 41. tmuxinator/smug連携

**優先度**: 中

セッションのテンプレート化と自動起動。

### tmuxinator設定例

```yaml
# ~/.config/tmuxinator/dev.yml
name: dev
root: ~/projects/myapp

windows:
  - editor:
      layout: main-vertical
      panes:
        - nvim
        - # empty for shell
  - server:
      panes:
        - npm run dev
  - logs:
      panes:
        - tail -f logs/app.log
        - docker logs -f myapp
```

### smug設定例 (よりシンプル)

```yaml
# ~/.config/smug/dev.yml
session: dev
root: ~/projects/myapp

windows:
  - name: editor
    commands:
      - nvim
  - name: server
    commands:
      - npm run dev
  - name: shell
```

### キーバインド

```tmux
# プロジェクト選択してセッション起動
bind S display-popup -E '\
    ls ~/.config/tmuxinator/*.yml 2>/dev/null | xargs -n1 basename | sed "s/.yml//" | \
    fzf --reverse --header="Start session" | \
    xargs -r tmuxinator start'
```

**効果**:
- プロジェクトごとの環境を即座に構築
- チームで設定を共有
- 繰り返し作業の自動化

---

## 42. リモートペアプログラミング対応

**優先度**: 低

複数人で同じセッションを共有。

### 基本設定

```bash
# 共有用ソケット作成
tmux -S /tmp/pair new -s pair

# 他のユーザーがアクセス
chmod 777 /tmp/pair
tmux -S /tmp/pair attach -t pair
```

### 読み取り専用接続

```bash
# 観覧者用（操作不可）
tmux -S /tmp/pair attach -t pair -r
```

### tmate使用 (より簡単)

```bash
# インストール
brew install tmate  # or apt install tmate

# セッション開始
tmate

# 表示されるURLを共有
# ssh URL: ssh xxxxx@nyc1.tmate.io
# Web URL: https://tmate.io/t/xxxxx
```

### 接続者表示

```tmux
# ステータスバーにクライアント数表示
set -g status-right "clients:#{session_attached} | %H:%M"
```

**効果**:
- リモートでのペアプログラミング
- コードレビューの効率化
- 教育・デモンストレーション

---

## 実装優先度まとめ

| 優先度 | # | 改善項目 | 理由 |
|--------|---|---------|------|
| 高 | 1 | True color / Undercurl | Neovim体験の向上 |
| 高 | 2 | インデックス1始まり | 操作効率 |
| 高 | 3 | クリップボード修正 | Linux/WSL2で必須 |
| 高 | 16 | ✅ escape-time最適化 | vim Esc反応速度 |
| 中 | 4 | フォーカスイベント | Neovim連携 |
| 中 | 5 | ウィンドウ番号ジャンプ | 操作効率 |
| 中 | 9 | Vim-tmux シームレス移動 | vim連携強化 |
| 中 | 13 | Pane スワップ | レイアウト調整 |
| 中 | 18 | Pane同期フィードバック | 状態の可視化 |
| 中 | 19 | Pane Dump Mode | ログ保存・デバッグ |
| 中 | 20 | Pane Recording Mode | リアルタイム記録 |
| 中 | 21 | Window名自動命名 | 区別しやすさ |
| 中 | 22 | ヘルプ/チートシート | 操作忘れ防止 |
| 中 | 23 | Claude連携機能 | AI開発効率化 |
| 中 | 24 | コピーモード位置情報表示 | 位置把握の改善 |
| 高 | 25 | モードヒント表示 (Zellij風) | 操作性・初心者対応 |
| 中 | 26 | フローティングペイン | 一時タスク効率化 |
| 中 | 27 | レイアウト保存・復元 | プロジェクト別管理 |
| 中 | 29 | インラインセッションマネージャー | セッション管理UI |
| 中 | 30 | ペインタイトル/注釈 | ペイン識別性向上 |
| 中 | 32 | クイックアクションメニュー | 操作発見性向上 |
| 低 | 6 | セッション操作強化 | 複数セッション時のみ |
| 低 | 7 | ✅ ポップアップターミナル | tmux 3.2+必須 |
| 低 | 8 | ✅ コピーモード視認性 | 好み |
| 低 | 10 | ネストtmux対応 | SSH使用時のみ |
| 低 | 11 | コマンド完了通知 | シェル設定も必要 |
| 低 | 12 | URL抽出・オープン | 外部依存あり |
| 低 | 14 | スクラッチpane | tmux 3.2+必須 |
| 低 | 15 | Aggressive resize | 複数クライアント時のみ |
| 低 | 17 | 履歴検索改善 | 好み |
| 低 | 28 | ペインスタック (タブ化) | tmux制約あり |
| 低 | 31 | ペインロック機能 | 誤操作防止 |
| 低 | 33 | ペイン境界カスタマイズ | 視認性向上 |
| 中 | 34 | マウス操作の強化 | 直感的操作 |
| 中 | 35 | プレビュー付き選択 | ナビゲーション改善 |
| 中 | 36 | カスタムメニュー | GUIライク操作 |
| 低 | 37 | バッファ管理強化 | コピー履歴活用 |
| 中 | 38 | 条件分岐設定 | マルチ環境対応 |
| 低 | 39 | ステータスバー情報拡張 | 情報表示 |
| 低 | 40 | 自動リネーム抑制 | 命名管理 |
| 中 | 41 | tmuxinator/smug連携 | セッションテンプレート |
| 低 | 42 | ペアプログラミング対応 | 共同作業 |
