
# case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ignore completion of curent dir after "./"
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

### group the candidates
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
### select the candidate from list
### but when only one candidate exists complete promptly
#zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:default' menu select true
### colorize the completion
#export LS_COLORS='di=34:ln=35:so=31:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

zstyle ':completion:*' list-colors "${LS_COLORS}"
### 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

### 補完候補
### _oldlist: reuse the last completion result
### _complete: complete
### _match: complete from candidate rather than expand glob
### _history: use commands in history as candidate
### _ignored: use invalidated candidate
### _approximate: use the approximate candidate
### _prefix: complete according up to the cursor, or ignore afterwards
zstyle ':completion:*' completer _oldlist _complete _match _ignored _approximate _prefix

## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*' verbose yes
zstyle ':completion:*:manuals' separate-sections true

setopt always_last_prompt
setopt magic_equal_subst
setopt auto_menu
setopt list_types

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
#   export FZF_DEFAULT_OPTS='--height 40% --reverse --border' #  --preview "[ -f {} ] && head -80 {}"'
  #     export FZF_TMUX=1
  if (which fd >/dev/null 2>/dev/null);then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  fi

  export FZF_CTRL_T_OPTS="--preview  'head -200 {}'"
  bindkey '^D' fzf-file-widget
  bindkey '^R' fzf-history-widget
  export FZF_COMPLETION_TRIGGER=','
  bindkey '^J' fzf-completion
  bindkey '^O' $fzf_default_completion
  #     bindkey '^I' fzf-completion
  #     bindkey '^O' fzf_default_completion
fi
