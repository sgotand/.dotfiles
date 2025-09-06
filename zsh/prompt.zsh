[ -n "${SHOW_SOURCE:-}" ] && echo "====start scriptting $0===="
autoload -Uz colors; colors
autoload -Uz add-zsh-hook
if [ -e "/usr/local/opt/kube-ps1/share/kube-ps1.sh" ]; then
  source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
fi
if false && which starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
  #RPROMPT="%{$fg[green]%} %D{%Y/%m/%d} %* %{$reset_color%}"
  RPROMPT='$(kube_ps1)'
else
PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%{${fg[cyan]}%}%m${reset_color} %D{%Y/%m/%d} %* %~

$ "
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
# zstyle ':vcs_info:*' formats '%F{green}git=%b%c%f'
# zstyle ':vcs_info:*' actionformats '%F{red}git=%b%c|%a%f'
function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    # RPROMPT="$(kube_ps1)${vcs_info_msg_0_}"
export RPROMPT=""

# PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%{${fg[cyan]}%}%m${reset_color} %D{%Y/%m/%d} %* %~ [${VERDA:-none}] $(kube_ps1) ${vcs_info_msg_0_} 
# $ "
# 
export KUBE_PS1_NS_ENABLE=false
export KUBE_PS1_SYMBOL_ENABLE=false
# export KUBE_PS1_CTX_COLOR=black, red, green, yellow, blue, magenta, cyan
export KUBE_PS1_CTX_COLOR=blue
export KUBE_PS1_PREFIX='k8s='
export KUBE_PS1_SUFFIX=''
PROMPT="@%{${fg[cyan]}%}%m${reset_color} %~ v=${VERDA:-none} $(kube_ps1) ${vcs_info_msg_0_} %D{%Y/%m/%d} %* 
$ "

}
add-zsh-hook precmd _update_vcs_info_msg
fi

# If command execution time above min. time, plugins will not output time.
ZSH_COMMAND_TIME_MIN_SECONDS=3

# Message to display (set to "" for disable).
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"

# Message color.
ZSH_COMMAND_TIME_COLOR="cyan"

# Exclude some commands
ZSH_COMMAND_TIME_EXCLUDE=(vim nvim less)

[ -n "${SHOW_SOURCE:-}" ] && echo "====finish scriptting $0===="
