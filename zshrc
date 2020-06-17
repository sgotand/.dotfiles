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


source ${ZSH_RC_DIR}/prompt.zsh
source ${ZSH_RC_DIR}/plugin.zsh
source ${ZSH_RC_DIR}/completion.zsh
source ${ZSH_RC_DIR}/alias.zsh
source ${ZSH_RC_DIR}/history.zsh

agent="$HOME/.ssh/agent"
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

