# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System
# for boolean 1==true==yes==on
# for boolean 0==false==no==off
# zstyle :completion:function:completer:command:argument:tag
# dfault tag ":completion:*:default"
[ -n "${SHOW_SOURCE:-}" ] && echo "====start scriptting $0===="
autoload -Uz compinit; compinit
autoload -Uz +X bashcompinit;
bashcompinit

if [ -d "/usr/local/share/zsh/site-functions" ]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
# case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ignore completion of curent dir after "./"
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
# processesタグの補完データとして、command実行結果を使う
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# zstyle ':completion:*' show-completer true
zstyle ':completion:*' use-compctl true
### group the candidates
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
### select the candidate from list
### but when only one candidate exists complete promptly
#zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:default' menu select true
### colorize the completion
export LS_COLORS='di=34:ln=35:so=31:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' list-grouped true
### 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both
zstyle ":completion:*:commands" rehash true

# allow option completion for cd, chdir, pushd etc
zstyle ':completion:*' complete-options true

zstyle ':completion:*' remove-all-dups true

# option-stackingはdocker補完独自の設定
# docker run -i<tab>などで、
# false => space区切りで次の入力を促す
# true => -tなどの、別の設定を表示する
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

### 補完候補
### _oldlist: reuse the last completion result
### _complete: complete
### _match: complete from candidate rather than expand glob
### _history: use commands in history as candidate
### _ignored: use invalidated candidate
### _approximate: use the approximate candidate
### _prefix: complete according up to the cursor, or ignore afterwards
zstyle ':completion:*' completer _menu _oldlist _complete _match _ignored _approximate _prefix

## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*' verbose yes
zstyle ':completion:*:manuals' separate-sections true

setopt always_last_prompt
setopt magic_equal_subst
setopt auto_menu
setopt list_types


if (which fzf >/dev/null 2>/dev/null ); then
  source ${ZSH_RC_DIR}/fzf/completion.zsh
  source ${ZSH_RC_DIR}/fzf/key-bindings.zsh
  export FZF_DEFAULT_OPTS='--height 40% --reverse --border' #  --preview "[ -f {} ] && head -80 {}"'
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

if (which gcloud >/dev/null 2>/dev/null ); then
    source /usr/share/google-cloud-sdk/completion.zsh.inc
fi

if (which pip3 >/dev/null 2>/dev/null); then
  source <(pip3 completion --zsh)
fi
if (which pipx >/dev/null 2>/dev/null); then
    source <(register-python-argcomplete pipx)
fi

if (which gh >/dev/null 2>/dev/null); then
  source <(gh completion -s zsh)
fi

if (which kubectl >/dev/null 2>/dev/null); then
  source <(kubectl completion zsh)
fi

[ -n "${SHOW_SOURCE:-}" ] && echo "====finish scriptting $0===="
