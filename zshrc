# vim:set filetype=zsh nospell :

[[ "$-" =~ i ]] || return

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
setopt noclobber #履歴が何故か変更されて>|になる
[[ "$(locale LC_CTYPE)" == "UTF-8" ]] && setopt COMBINING_CHARS


source ${ZSH_RC_DIR}/prompt.zsh
source ${ZSH_RC_DIR}/plugin.zsh
source ${ZSH_RC_DIR}/completion.zsh
source ${ZSH_RC_DIR}/alias.zsh
source ${ZSH_RC_DIR}/history.zsh

USE_AGENT=true
agent="$HOME/.ssh/agent"
if [ -S $agent ]; then
  export SSH_AUTH_SOCK=$agent
elif [ -S "$SSH_AUTH_SOCK" ]; then
    if [[ $SSH_AUTH_SOCK =~ /tmp/.*/agent.[0-9]* ]]  then
      # reuse existing agent
    elif [[ $SSH_AUTH_SOCK = ${XDG_RUNTIME_DIR}* ]]  then
      if [[ $USE_AGENT = true ]];then
      eval $(ssh-agent)
      fi
    fi
    echo "ssh auth sock:" $SSH_AUTH_SOCK
    ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
else
  echo "no ssh-agent"
fi

