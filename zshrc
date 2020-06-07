# vim:set filetype=zsh nospell :
# 色を使用出来るようにする
# -U :alias展開しない
# -z :zsh形式で読み込み
# 単語の区切り文字を指定する
#
ZSH_RC_DIR=$(dirname $0)/zsh/
bindkey -e
autoload -Uz colors
colors

# set words delimitter
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt auto_cd
setopt auto_pushd


source ${ZSH_RC_DIR}/prompt.zsh
source ${ZSH_RC_DIR}/plugin.zsh
source ${ZSH_RC_DIR}/completion.zsh
source ${ZSH_RC_DIR}/alias.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

bindkey '^D' fzf-file-widget
bindkey '^R' fzf-history-widget
export FZF_COMPLETION_TRIGGER=';'
#bindkey '^I' fzf-completion
#bindkey '^O' $fzf_default_completion
#

if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi

