# vim:set filetype=zsh nospell :
# 色を使用出来るようにする
# -U :alias展開しない
# -z :zsh形式で読み込み
autoload -Uz colors
colors

# 単語の区切り文字を指定する
autoload -Uz select-word-style; select-word-style default

# set words delimitter
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

################## Completion ######################
fpath+=~/.zfunc
autoload -Uz compinit; compinit

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
zstyle ':completion:*:default' menu select=2
### colorize the completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
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

setopt no_beep
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

# cdr
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

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000000
# setopt hist_ignore_dups
# setopt hist_ignore_all_dups
# setopt hist_ignore_space
# setopt hist_reduce_blanks
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt share_history


# 高機能なワイルドカード展開を使用する
setopt extended_glob

# __record_command() {
#    typeset -g _LASTCMD=${1%%$'\n'}
#    return 1
#}
# zshaddhistory_functions+=(__record_command)

# __update_history() {
#    local last_status="$?"
#
#    # hist_ignore_space
#    if [[ ! -n ${_LASTCMD%% *} ]]; then
#        return
#    fi
#
#    # hist_reduce_blanks
#    local cmd_reduce_blanks=$(echo ${_LASTCMD} | tr -s ' ')
#
#    # Record the commands that have succeeded
#    if [[ ${last_status} == 0 ]]; then
#        print -sr -- "${cmd_reduce_blanks}"
#    fi
#}
#precmd_functions+=(__update_history)

##################### Key Bindings ###################

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

alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'

alias vs='vagrant status'
alias vss='vagrant ssh'
alias vssh='vagrant ssh'
alias vu='vagrant up'
alias vup='vagrant up'
alias vd='vagrant destroy'

path(){ echo $PATH | tr ':' '\n' }
alias p=path

if which htop >/dev/null 2>&1 ; then
    alias top=htop
fi

case ${OSTYPE} in
    darwin*)
        #Mac
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux
        alias ls='ls -F --color=auto'
        ;;
esac

# global aliases
alias -g L='| less'
alias -g G='| grep'
alias -g P='| peco'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sed'

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


# expand the global alias when " " is inputted
global_alias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
    # zle expand-word
  fi
  zle self-insert
}
zle -N global_alias
bindkey " " global_alias



###########ENV DEPENDENT SETTINGS################################

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi


###########plugin###############
if [ -z "${ZPLUG_HOME}" ]; then
    export ZPLUG_HOME=$HOME/.zplug
fi


if [ ! -e  "${ZPLUG_HOME}/init.zsh" ];then
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

fi

