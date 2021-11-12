echo "=====start scriptting $0===="
autoload -Uz colors; colors
autoload -Uz add-zsh-hook
if [ -e "/usr/local/opt/kube-ps1/share/kube-ps1.sh" ]; then
  source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
fi
if which starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
  #RPROMPT="%{$fg[green]%} %D{%Y/%m/%d} %* %{$reset_color%}"
  RPROMPT='$(kube_ps1)'
else
PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%{${fg[cyan]}%}%m${reset_color} %~
$ "
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    # RPROMPT="$(kube_ps1)${vcs_info_msg_0_}"
export RPROMPT="\${VERDA:-none}; \$(kube_ps1)"
PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%{${fg[cyan]}%}%m${reset_color}${vcs_info_msg_0_} %~
$ "
}
add-zsh-hook precmd _update_vcs_info_msg
fi

echo "====finish scriptting $0===="
