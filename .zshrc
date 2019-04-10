# vim:set filetype=zsh nospell :
# 色を使用出来るようにする
# -U :alias展開しない
# -z :zsh形式で読み込み
autoload -Uz colors; colors

# プロンプト
PROMPT="${fg[green]}[%n]${reset_color} %~
%# "


# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 単語の区切り文字を指定する
autoload -Uz select-word-style; select-word-style default

# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

################## Completion ######################
# 補完
# 補完機能を有効にする
fpath+=~/.zfunc
autoload -Uz compinit; compinit


# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


#########
### 補完方法毎にグループ化する。
# zstyle ':completion:*' format '%B%F{blue}%d%f%b'
# zstyle ':completion:*' group-name ''
### 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
### 補完候補に色を付ける。
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
### 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

### 補完候補
### _oldlist 前回の補完結果を再利用する。
### _complete: 補完する。
### _match: globを展開しないで候補の一覧から補完する。
### _history: ヒストリのコマンドも補完候補とする。
### _ignored: 補完候補にださないと指定したものも補完候補とする。
### _approximate: 似ている補完候補も補完候補とする。
### _prefix: カーソル以降を無視してカーソル位置までで補完する。
#zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
zstyle ':completion:*' completer _complete _ignored

## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
## 詳細な情報を使わない
# zstyle ':completion:*' verbose no

## sudo の時にコマンドを探すパス
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

#########

################### Version Control System (git) #####################
# vcs_info
# git

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"

}
add-zsh-hook precmd _update_vcs_info_msg




##################落ち穂拾い######################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# cdr, add-zsh-hook を有効にする
# cf. http://wada811.blogspot.com/2014/09/zsh-cdr.html
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
# zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

setopt autonamedirs
setopt cdable_vars
hash -d pdf=$HOME/Documents/pdf

################# History #######################
# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
# setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

__record_command() {
  typeset -g _LASTCMD=${1%%$'\n'}
  return 1
}
zshaddhistory_functions+=(__record_command)

__update_history() {
  local last_status="$?"

  # hist_ignore_space
  if [[ ! -n ${_LASTCMD%% *} ]]; then
    return
  fi

  # hist_reduce_blanks
  local cmd_reduce_blanks=$(echo ${_LASTCMD} | tr -s ' ')

  # Record the commands that have succeeded
  if [[ ${last_status} == 0 ]]; then
    print -sr -- "${cmd_reduce_blanks}"
  fi
}
precmd_functions+=(__update_history)


##################### Key Bindings ###################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward
bindkey -e

################# Aliases #######################
alias la='ls -a'
alias ll='ls -lh'
alias l1='ls -1'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias less='less -XF'
alias mkdir='mkdir -p'
# alias path="echo $PATH| tr ':' '\n'"
path(){ echo $PATH | tr ':' '\n' }


if which htop >/dev/null 2>&1 ; then
    alias top=htop
fi

case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac




# global aliases
alias -g L='| less'
alias -g G='| grep'
alias -g P='| peco'
alias -g H='| head'
alias -g T='| tail'

# cf. mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi



if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi









###########各種言語設定##############

if [[ -d ~/.pyenv ]] ; then
    export PATH="/home/progrunner/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
if [[ -d ~/.rbenv  ]] ; then
  export PATH=${HOME}/.rbenv/bin:${PATH}  
  eval "$(rbenv init -)"
fi



###########plugin###############
if [ -e  "$ZPLUG_HOME/init.zsh" ] && source $ZPLUG_HOME/init.zsh; then
    # Make sure to use double quotes

    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-completions" 
    zplug "kagamilove0707/moonline.zsh", from:github, defer:2

    # Better history searching with arrow keys
    if zplug check "zsh-users/zsh-history-substring-search"; then
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey -M emacs '^P' history-substring-search-up
        bindkey -M emacs '^N' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
    fi

    #zplug "kagamilove0707/moonline.zsh", from:github, defer:2 #above
    source $ZPLUG_HOME/repos/kagamilove0707/moonline.zsh/moonline.zsh
    moonline initialize

    zplug "zsh-users/zsh-syntax-highlighting", defer:2

    zplug "zsh-users/zsh-autosuggestions", defer:2
    bindkey '^ ' autosuggest-execute

    # cf. https://qiita.com/mollifier/items/81b18c012d7841ab33c3
    zplug "mollifier/anyframe", from:github
    if which peco >/dev/null 2>&1; then
        zstyle ":anyframe:selector:" use peco
        # zstyle ":anyframe:selector:peco:" command 'peco --no-ignore-case'
        alias cdrr='anyframe-widget-cdr'

        # bindkey '^xb' anyframe-widget-cdr
        # bindkey '^x^b' anyframe-widget-checkout-git-branch
        # bindkey '^xr' anyframe-widget-execute-history
        # bindkey '^x^r' anyframe-widget-execute-history
        # bindkey '^xi' anyframe-widget-put-history
        # bindkey '^x^i' anyframe-widget-put-history
        # bindkey '^xg' anyframe-widget-cd-ghq-repository
        # bindkey '^x^g' anyframe-widget-cd-ghq-repository
        # bindkey '^xk' anyframe-widget-kill
        # bindkey '^x^k' anyframe-widget-kill
        # bindkey '^xe' anyframe-widget-insert-git-branch
        # bindkey '^x^e' anyframe-widget-insert-git-branch
    fi


    zplug "plugins/cargo", from:oh-my-zsh

    zplug "zsh-users/zaw"
    bindkey '^j' zaw
    # zplug "plugins/colored-man-pages", from:oh-my-zsh

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    zplug load --verbose

else
    echo "zplug not found"
    echo "Do you want to install zplug? (y or n :default: y)"
    read ANSWER
    case $ANSWER in
        "" | "Y" |"y" ) 
            echo "start installing zplug"
           curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh 
           ;;
        *);;
    esac
fi









eval "$(direnv hook zsh)"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
