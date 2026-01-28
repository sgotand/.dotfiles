# zsh 改善案

今後実装を検討している zsh 設定の改善案。

---

## 1. モダンプロンプト (Starship)

**優先度**: 高

Rust製の高速でカスタマイズ可能なプロンプト。

### インストール

```bash
curl -sS https://starship.rs/install.sh | sh
```

### .zshrc設定

```zsh
eval "$(starship init zsh)"
```

### starship.toml (基本)

```toml
# ~/.config/starship.toml

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$rust\
$cmd_duration\
$line_break\
$character"""

[character]
success_symbol = "[❯](green)"
error_symbol = "[❯](red)"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'

[cmd_duration]
min_time = 2000
format = "took [$duration]($style) "
```

**効果**:
- Git情報、言語バージョン表示
- 高速（Rust製）
- クロスシェル対応

---

## 2. コマンド補完強化 (zsh-completions)

**優先度**: 高

追加の補完定義。

### インストール (zinit)

```zsh
zinit light zsh-users/zsh-completions
```

### 補完設定

```zsh
# 補完を有効化
autoload -Uz compinit && compinit

# 補完スタイル
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # 大文字小文字無視
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches: %d'

# キャッシュ
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
```

### fzf-tab (補完をfzfで)

```zsh
zinit light Aloxaf/fzf-tab

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || ls -la $realpath'
```

**効果**:
- より多くのコマンドで補完が効く
- fzfによるファジー選択
- プレビュー付き

---

## 3. シンタックスハイライト

**優先度**: 高

コマンドライン入力時のハイライト。

### インストール

```zsh
zinit light zsh-users/zsh-syntax-highlighting
```

### カスタムスタイル

```zsh
# ハイライトスタイルのカスタマイズ
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'

# パターンハイライト
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=white,bold,bg=yellow')
```

### fast-syntax-highlighting (高速版)

```zsh
zinit light zdharma-continuum/fast-syntax-highlighting
```

**効果**:
- 存在しないコマンドを赤く表示
- パス、オプションを色分け
- 危険なコマンドを警告

---

## 4. 自動サジェスト

**優先度**: 高

履歴から候補を表示。

### インストール

```zsh
zinit light zsh-users/zsh-autosuggestions
```

### 設定

```zsh
# サジェストの色
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# 候補ソース (履歴 → 補完)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# キーバインド
bindkey '^f' autosuggest-accept       # Ctrl+f で確定
bindkey '^e' autosuggest-accept       # Ctrl+e で確定 (代替)
bindkey '^ ' autosuggest-execute      # Ctrl+Space で即実行
```

**効果**:
- 入力に応じて候補をグレー表示
- →キー or Ctrl+f で確定
- 履歴と補完からサジェスト

---

## 5. ディレクトリジャンプ (zoxide)

**優先度**: 高

よく使うディレクトリに素早くジャンプ。

### インストール

```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

### .zshrc設定

```zsh
eval "$(zoxide init zsh)"
```

### 使い方

```bash
# 基本
z foo          # "foo" を含むディレクトリにジャンプ
z foo bar      # "foo" と "bar" を含むディレクトリ
zi             # fzfでインタラクティブ選択

# 追加コマンド
z -            # 直前のディレクトリ
zoxide query   # データベース確認
```

### エイリアス

```zsh
alias cd='z'
alias cdi='zi'
```

**効果**:
- フルパス入力不要
- 使用頻度と最近使ったディレクトリを学習
- fzfでインタラクティブ選択

---

## 6. fzf統合

**優先度**: 高

あらゆる選択をファジーに。

### インストール

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### .zshrc設定

```zsh
# fzfデフォルトオプション
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --preview-window=right:50%
  --bind='ctrl-/:toggle-preview'
"

# Ctrl+R: 履歴検索
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:3:wrap
"

# Ctrl+T: ファイル選択
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:100 {} 2>/dev/null || cat {}'
"

# Alt+C: ディレクトリ移動
export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -50'
"
```

### カスタム関数

```zsh
# fzf + ghq
function ghq-fzf() {
  local dir
  dir=$(ghq list -p | fzf --preview 'ls -la {}')
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}
alias repo='ghq-fzf'

# fzf + git branch
function git-branch-fzf() {
  git branch -a | fzf | xargs git checkout
}
alias gb='git-branch-fzf'

# fzf + kill process
function kill-fzf() {
  ps aux | fzf --header-lines=1 | awk '{print $2}' | xargs kill
}
alias fkill='kill-fzf'
```

**効果**:
- `Ctrl+R`: 履歴をファジー検索
- `Ctrl+T`: ファイルをファジー選択
- `Alt+C`: ディレクトリをファジー選択

---

## 7. 履歴設定の最適化

**優先度**: 中

履歴の保存と検索を改善。

### 基本設定

```zsh
# 履歴ファイル
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# オプション
setopt EXTENDED_HISTORY       # タイムスタンプ記録
setopt HIST_EXPIRE_DUPS_FIRST # 重複を優先削除
setopt HIST_IGNORE_DUPS       # 連続する重複を無視
setopt HIST_IGNORE_ALL_DUPS   # 古い重複を削除
setopt HIST_IGNORE_SPACE      # スペース始まりを無視
setopt HIST_FIND_NO_DUPS      # 検索時に重複を表示しない
setopt HIST_SAVE_NO_DUPS      # 保存時に重複を除去
setopt SHARE_HISTORY          # セッション間で共有
setopt INC_APPEND_HISTORY     # 即座に追記
```

### 履歴検索の強化

```zsh
# 矢印キーで前方一致検索
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
```

**効果**:
- 10万件の履歴を保持
- 重複を自動削除
- ターミナル間で履歴共有

---

## 8. エイリアス体系化

**優先度**: 中

よく使うコマンドの短縮形。

### 基本エイリアス

```zsh
# ls
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# eza (ls の代替)
if command -v eza &> /dev/null; then
  alias ls='eza --icons'
  alias ll='eza -alh --icons --git'
  alias la='eza -a --icons'
  alias tree='eza --tree --icons'
fi

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# 安全系
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# 便利系
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
```

### Git エイリアス

```zsh
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'
```

### Docker エイリアス

```zsh
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs -f'
```

**効果**:
- タイプ数削減
- コマンドの統一
- 安全なデフォルト

---

## 9. Git情報のプロンプト統合

**優先度**: 中

Git状態をプロンプトに表示（Starship使用しない場合）。

### vcs_info使用

```zsh
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' %F{cyan}%b%f'
zstyle ':vcs_info:*' actionformats ' %F{cyan}%b%f %F{red}(%a)%f'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' formats ' %F{cyan}%b%f%c%u'

setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %# '
```

### git-prompt.sh使用

```zsh
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f$(__git_ps1 " (%s)") %# '
```

**効果**:
- ブランチ名表示
- 変更状態のインジケータ
- upstream との差分表示

---

## 10. 環境変数管理 (direnv)

**優先度**: 中

ディレクトリごとに環境変数を自動設定。

### インストール

```bash
# Ubuntu/Debian
sudo apt install direnv

# macOS
brew install direnv
```

### .zshrc設定

```zsh
eval "$(direnv hook zsh)"
```

### 使い方

```bash
# プロジェクトディレクトリで
cd ~/projects/myapp

# .envrc を作成
echo 'export DATABASE_URL="postgres://localhost/myapp"' > .envrc
echo 'export API_KEY="secret"' >> .envrc

# 許可
direnv allow

# 離れると自動でunset、戻ると自動でexport
```

### .envrc 例

```bash
# Node.js プロジェクト
export NODE_ENV=development
PATH_add node_modules/.bin

# Python プロジェクト
layout python3
export DJANGO_SETTINGS_MODULE=myapp.settings.local

# 共通の .env ファイルを読み込み
dotenv
```

**効果**:
- プロジェクトごとの環境変数
- 秘密情報の分離
- チーム間での設定共有

---

## 11. パス管理の改善

**優先度**: 中

PATHの追加を安全かつ簡潔に。

### ヘルパー関数

```zsh
# パスを先頭に追加（重複回避）
path_prepend() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

# パスを末尾に追加（重複回避）
path_append() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$PATH:$1"
  fi
}
```

### 使用例

```zsh
# ユーザーローカル
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# 言語別
path_prepend "$HOME/.cargo/bin"          # Rust
path_prepend "$HOME/.go/bin"             # Go
path_prepend "$HOME/.npm-global/bin"     # npm global

# Homebrew (Apple Silicon)
path_prepend "/opt/homebrew/bin"
```

### パス確認コマンド

```zsh
# パスを見やすく表示
alias path='echo -e ${PATH//:/\\n}'

# パス内のコマンドを検索
alias which-all='whence -va'
```

**効果**:
- 重複パスを防止
- 存在確認してから追加
- 見やすいパス表示

---

## 12. キーバインド設定

**優先度**: 中

Emacs/Viモードとカスタムキー。

### 基本設定

```zsh
# Emacsモード（デフォルト）
bindkey -e

# または Vi モード
# bindkey -v
# export KEYTIMEOUT=1

# 共通の便利キー
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
bindkey '^[[3~' delete-char        # Delete
bindkey '^[[1;5C' forward-word     # Ctrl+→
bindkey '^[[1;5D' backward-word    # Ctrl+←
```

### 編集系

```zsh
# 単語削除
bindkey '^W' backward-kill-word    # Ctrl+W: 前の単語削除
bindkey '^[d' kill-word            # Alt+d: 次の単語削除

# 行操作
bindkey '^U' backward-kill-line    # Ctrl+U: カーソル前を削除
bindkey '^K' kill-line             # Ctrl+K: カーソル後を削除
bindkey '^Y' yank                  # Ctrl+Y: 貼り付け

# Undo/Redo
bindkey '^Z' undo                  # Ctrl+Z: 取り消し
bindkey '^[z' redo                 # Alt+z: やり直し
```

### カスタムウィジェット

```zsh
# sudo を先頭に追加
function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  fi
}
zle -N prepend-sudo
bindkey '^[s' prepend-sudo  # Alt+s

# コマンドをエディタで編集
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line  # Ctrl+X Ctrl+E
```

**効果**:
- 効率的なライン編集
- エディタでコマンド編集
- sudo の素早い追加

---

## 13. プラグインマネージャー (zinit)

**優先度**: 高

高速で柔軟なプラグイン管理。

### インストール

```bash
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

### 基本設定

```zsh
# zinit 読み込み
source ~/.local/share/zinit/zinit.git/zinit.zsh

# 遅延読み込み (turbo mode)
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# Oh-My-Zsh のスニペット
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::kubectl
```

### よく使うプラグイン

```zsh
# シンタックスハイライト
zinit light zdharma-continuum/fast-syntax-highlighting

# 自動サジェスト
zinit light zsh-users/zsh-autosuggestions

# 追加補完
zinit light zsh-users/zsh-completions

# fzf-tab
zinit light Aloxaf/fzf-tab

# 履歴検索
zinit light zdharma-continuum/history-search-multi-word
```

**効果**:
- 遅延読み込みで高速起動
- プラグインの自動更新
- スニペット機能

---

## 14. ディレクトリスタック

**優先度**: 低

訪問したディレクトリを記憶。

### 基本設定

```zsh
# ディレクトリスタック有効化
setopt AUTO_PUSHD           # cd で自動push
setopt PUSHD_IGNORE_DUPS    # 重複を無視
setopt PUSHD_SILENT         # push/pop時に表示しない
DIRSTACKSIZE=20             # スタックサイズ

# エイリアス
alias d='dirs -v'           # スタック一覧
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
# ...
```

### fzf でディレクトリスタック選択

```zsh
function cd-stack() {
  local dir
  dir=$(dirs -v | fzf --height 40% | awk '{print $2}')
  if [ -n "$dir" ]; then
    eval cd "$dir"
  fi
}
alias ds='cd-stack'
```

**効果**:
- `cd -2` で2つ前のディレクトリへ
- `d` でスタック一覧
- fzf でインタラクティブ選択

---

## 15. コマンド実行時間と通知

**優先度**: 低

長時間コマンドの実行時間表示と完了通知。

### 実行時間表示

```zsh
# preexec/precmd で計測
function preexec() {
  cmd_start=$EPOCHSECONDS
}

function precmd() {
  if [ -n "$cmd_start" ]; then
    local elapsed=$((EPOCHSECONDS - cmd_start))
    if [ $elapsed -gt 3 ]; then
      echo -e "\n⏱️  Command took ${elapsed}s"
    fi
    unset cmd_start
  fi
}
```

### 完了通知

```zsh
# 10秒以上かかったら通知
function notify-command-complete() {
  local elapsed=$((EPOCHSECONDS - cmd_start))
  if [ $elapsed -gt 10 ]; then
    # macOS
    if command -v terminal-notifier &> /dev/null; then
      terminal-notifier -title "Command Complete" -message "Took ${elapsed}s"
    # Linux (notify-send)
    elif command -v notify-send &> /dev/null; then
      notify-send "Command Complete" "Took ${elapsed}s"
    fi
  fi
}
precmd_functions+=(notify-command-complete)
```

### bellを使った通知

```zsh
# tmux/ターミナルのbell
function precmd() {
  if [ -n "$cmd_start" ]; then
    local elapsed=$((EPOCHSECONDS - cmd_start))
    if [ $elapsed -gt 10 ]; then
      echo -e '\a'  # bell
    fi
    unset cmd_start
  fi
}
```

**効果**:
- 長いコマンドの実行時間を表示
- 完了時にデスクトップ通知
- 別タブで作業中でも気付ける

---

## 16. 起動時間の最適化

**優先度**: 高

zshの起動を高速化。

### 計測方法

```zsh
# 起動時間の計測
time zsh -i -c exit

# 詳細なプロファイリング
zmodload zsh/zprof
# .zshrcの末尾で
zprof
```

### 遅延読み込み

```zsh
# 重いコマンドを遅延初期化
function nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# pyenv も同様
function pyenv() {
  unset -f pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}
```

### 補完のキャッシュ

```zsh
# compinit を1日1回だけ再構築
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
```

### zinitのturboモード

```zsh
# 遅延読み込みで高速化
zinit wait lucid for \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/fast-syntax-highlighting
```

**効果**:
- 起動時間を100ms以下に
- 必要な時だけ初期化
- 体感速度の向上

---

## 17. AWS/クラウドCLI補完

**優先度**: 中

AWS、GCP、AzureのCLI補完を強化。

### AWS CLI

```zsh
# AWS CLI v2 補完
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws

# プロファイル切り替え関数
function aws-profile() {
  export AWS_PROFILE=$(aws configure list-profiles | fzf --header="Select AWS Profile")
  echo "Switched to: $AWS_PROFILE"
}
alias awsp='aws-profile'
```

### kubectl

```zsh
# kubectl補完
source <(kubectl completion zsh)

# コンテキスト切り替え
alias kx='kubectl config use-context $(kubectl config get-contexts -o name | fzf)'
alias kn='kubectl config set-context --current --namespace=$(kubectl get ns -o name | cut -d/ -f2 | fzf)'

# よく使うエイリアス
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias klogs='kubectl logs -f'
```

### Docker

```zsh
# Docker補完 (zinit)
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

# よく使うエイリアス
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dex='docker exec -it'
alias dlogs='docker logs -f'
```

**効果**:
- クラウドCLIの補完が効く
- プロファイル/コンテキスト切り替えが簡単
- よく使う操作のショートカット

---

## 18. ブックマーク機能

**優先度**: 低

よく使うディレクトリをブックマーク。

### 基本実装

```zsh
# ブックマーク保存先
BOOKMARKS_FILE=~/.zsh_bookmarks

# ブックマークに追加
function bookmark-add() {
  local name=${1:-$(basename $PWD)}
  echo "$name|$PWD" >> $BOOKMARKS_FILE
  echo "Bookmarked: $name -> $PWD"
}

# ブックマークにジャンプ
function bookmark-jump() {
  local target
  target=$(cat $BOOKMARKS_FILE | fzf --delimiter='|' --with-nth=1 --preview='ls -la {2}')
  if [ -n "$target" ]; then
    cd "$(echo $target | cut -d'|' -f2)"
  fi
}

# ブックマーク削除
function bookmark-remove() {
  local line
  line=$(cat $BOOKMARKS_FILE | fzf --delimiter='|' --with-nth=1)
  if [ -n "$line" ]; then
    grep -v "^$line$" $BOOKMARKS_FILE > $BOOKMARKS_FILE.tmp
    mv $BOOKMARKS_FILE.tmp $BOOKMARKS_FILE
    echo "Removed: $(echo $line | cut -d'|' -f1)"
  fi
}

alias ba='bookmark-add'
alias bj='bookmark-jump'
alias br='bookmark-remove'
alias bl='cat $BOOKMARKS_FILE | column -t -s"|"'
```

**効果**:
- zoxideとは別のアプローチ
- 明示的なブックマーク管理
- 名前付きでわかりやすい

---

## 19. ターミナルタイトル自動更新

**優先度**: 低

現在のディレクトリやコマンドをタイトルに表示。

### 基本設定

```zsh
# ディレクトリ変更時にタイトル更新
function set-title-precmd() {
  print -Pn "\e]0;%~\a"
}

# コマンド実行時にコマンド名を表示
function set-title-preexec() {
  print -Pn "\e]0;$1\a"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec
```

### 詳細版

```zsh
function set-title() {
  local title
  case $1 in
    precmd)
      # ディレクトリ + git branch
      if git rev-parse --git-dir > /dev/null 2>&1; then
        title="%~ ($(git branch --show-current))"
      else
        title="%~"
      fi
      ;;
    preexec)
      # コマンド名 + ディレクトリ
      title="$2 - %~"
      ;;
  esac
  print -Pn "\e]0;${title}\a"
}

add-zsh-hook precmd 'set-title precmd'
add-zsh-hook preexec 'set-title preexec'
```

**効果**:
- タブで現在地がわかる
- 実行中のコマンドが見える
- SSH先では hostname 表示

---

## 20. 安全なrm (trash-cli)

**優先度**: 中

rmをゴミ箱に移動に置き換え。

### インストール

```bash
# macOS
brew install trash-cli

# Linux
pip install trash-cli
# または
npm install -g trash-cli
```

### 設定

```zsh
# rmをtrashに置き換え
if command -v trash &> /dev/null; then
  alias rm='trash'
  alias rm!='/bin/rm -i'  # 本当に削除したい場合
fi

# ゴミ箱操作
alias trash-list='trash-list'
alias trash-restore='trash-restore'
alias trash-empty='trash-empty'
```

### 確認プロンプト付き

```zsh
function safe-rm() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: rm <files>"
    return 1
  fi

  echo "Moving to trash:"
  for f in "$@"; do
    echo "  - $f"
  done

  read "?Continue? [y/N] " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    trash "$@"
  fi
}
alias rm='safe-rm'
```

**効果**:
- 誤削除からの復旧が可能
- 本物のrmも使える
- 安全なデフォルト

---

## 21. コマンドNot Found時のサジェスト

**優先度**: 低

存在しないコマンド実行時にインストール方法を提示。

### 基本設定

```zsh
# Ubuntu/Debian
if [[ -f /etc/zsh_command_not_found ]]; then
  source /etc/zsh_command_not_found
fi

# または手動実装
function command_not_found_handler() {
  local cmd=$1
  echo "zsh: command not found: $cmd"

  # 類似コマンドを検索
  local suggestions=$(compgen -c | grep -i "^$cmd" | head -5)
  if [[ -n $suggestions ]]; then
    echo "\nDid you mean:"
    echo "$suggestions" | while read s; do
      echo "  - $s"
    done
  fi

  # パッケージマネージャーで検索
  if command -v apt &> /dev/null; then
    echo "\nTo install, try:"
    echo "  sudo apt install $cmd"
  elif command -v brew &> /dev/null; then
    echo "\nTo install, try:"
    echo "  brew install $cmd"
  fi

  return 127
}
```

**効果**:
- タイポ時に候補を表示
- インストール方法のヒント
- 初心者に優しい

---

## 22. SSH接続管理

**優先度**: 中

SSH接続を便利に管理。

### fzfでホスト選択

```zsh
function ssh-fzf() {
  local host
  host=$(grep -E "^Host\s+" ~/.ssh/config | awk '{print $2}' | grep -v '*' | fzf --header="Select SSH host")
  if [ -n "$host" ]; then
    ssh "$host"
  fi
}
alias sshf='ssh-fzf'
```

### SSH接続履歴

```zsh
# 最近の接続先を記録
function ssh() {
  echo "$(date +%Y-%m-%d) $@" >> ~/.ssh_history
  command ssh "$@"
}

# 履歴から選択
function ssh-history() {
  local host
  host=$(cat ~/.ssh_history | awk '{print $2}' | sort -u | fzf)
  if [ -n "$host" ]; then
    command ssh "$host"
  fi
}
alias sshh='ssh-history'
```

### SSH agent 自動起動

```zsh
# SSH agent を自動起動
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
```

**効果**:
- ホスト名を覚えなくてよい
- よく使う接続先に素早くアクセス
- SSH agent の自動管理

---

## 23. 一時ディレクトリ作成

**優先度**: 低

一時的な作業用ディレクトリを素早く作成。

### 基本関数

```zsh
# 一時ディレクトリ作成して移動
function tmpdir() {
  local dir
  if [[ -n $1 ]]; then
    dir=$(mktemp -d -t "$1.XXXXXX")
  else
    dir=$(mktemp -d -t "tmp.XXXXXX")
  fi
  cd "$dir"
  echo "Created: $dir"
}

# 日付付き一時ディレクトリ
function workdir() {
  local name=${1:-work}
  local dir=~/tmp/${name}_$(date +%Y%m%d_%H%M%S)
  mkdir -p "$dir"
  cd "$dir"
  echo "Created: $dir"
}

# 今日の作業ディレクトリ
function today() {
  local dir=~/tmp/$(date +%Y%m%d)
  mkdir -p "$dir"
  cd "$dir"
}
```

### 古い一時ディレクトリの削除

```zsh
# 7日以上前の一時ディレクトリを削除
function cleanup-tmp() {
  find ~/tmp -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
  echo "Cleaned up old directories in ~/tmp"
}
```

**効果**:
- 素早く作業場所を確保
- 命名規則の統一
- 古いディレクトリの自動削除

---

## 24. グローバルエイリアス

**優先度**: 中

パイプラインやリダイレクトで使えるエイリアス。

### 基本設定

```zsh
# ページャー
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc -l'

# 出力加工
alias -g J='| jq .'
alias -g C='| pbcopy'    # macOS
alias -g C='| xclip -selection clipboard'  # Linux

# ファイル操作
alias -g N='> /dev/null 2>&1'
alias -g NE='2> /dev/null'
alias -g A='| awk'
alias -g S='| sort'
alias -g U='| sort -u'

# fzf
alias -g F='| fzf'
alias -g FP='| fzf --preview "cat {}"'
```

### 使用例

```zsh
# ls | less
ls -la L

# grep して head
cat file.txt G "error" H

# JSON を整形して less
curl api.example.com J L

# 行数カウント
cat file.txt W

# クリップボードにコピー
echo "hello" C
```

**効果**:
- パイプラインが短く書ける
- よく使うパターンの省略
- 入力効率の向上

---

## 25. マルチライン編集

**優先度**: 低

長いコマンドを複数行で編集。

### 基本設定

```zsh
# Ctrl+X Ctrl+E でエディタ起動
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# エディタ設定
export EDITOR='nvim'
export VISUAL='nvim'
```

### 継続行の入力

```zsh
# バックスラッシュで継続
docker run \
  --name myapp \
  -p 8080:80 \
  -v $(pwd):/app \
  -e NODE_ENV=development \
  myimage:latest

# ヒアドキュメント
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  key: value
EOF
```

### マルチライン プロンプト

```zsh
# 継続行のプロンプトをカスタマイズ
PS2='  > '

# または Starship で
# continuation_prompt = "▶▶ "
```

**効果**:
- 複雑なコマンドを見やすく
- エディタで本格的に編集
- コピペしやすい形式

---

## 実装優先度まとめ

| 優先度 | # | 改善項目 | 理由 |
|--------|---|---------|------|
| 高 | 1 | モダンプロンプト (Starship) | 見た目と情報量 |
| 高 | 2 | コマンド補完強化 | 操作効率 |
| 高 | 3 | シンタックスハイライト | エラー防止 |
| 高 | 4 | 自動サジェスト | タイプ削減 |
| 高 | 5 | ディレクトリジャンプ (zoxide) | 移動効率 |
| 高 | 6 | fzf統合 | 検索効率 |
| 高 | 13 | プラグインマネージャー (zinit) | 管理基盤 |
| 中 | 7 | 履歴設定最適化 | 履歴活用 |
| 中 | 8 | エイリアス体系化 | タイプ削減 |
| 中 | 9 | Git情報プロンプト | 状態把握 |
| 中 | 10 | 環境変数管理 (direnv) | プロジェクト管理 |
| 中 | 11 | パス管理改善 | 保守性 |
| 中 | 12 | キーバインド設定 | 編集効率 |
| 低 | 14 | ディレクトリスタック | 便利機能 |
| 低 | 15 | コマンド実行時間と通知 | 便利機能 |
| 高 | 16 | 起動時間の最適化 | 体感速度 |
| 中 | 17 | クラウドCLI補完 | 開発効率 |
| 中 | 20 | 安全なrm (trash-cli) | 誤削除防止 |
| 中 | 22 | SSH接続管理 | 接続効率 |
| 中 | 24 | グローバルエイリアス | 入力効率 |
| 低 | 18 | ブックマーク機能 | 便利機能 |
| 低 | 19 | ターミナルタイトル更新 | 視認性 |
| 低 | 21 | コマンドNot Foundサジェスト | 初心者対応 |
| 低 | 23 | 一時ディレクトリ作成 | 作業効率 |
| 低 | 25 | マルチライン編集 | 複雑コマンド |
