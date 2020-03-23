autoload -Uz colors; colors
if which starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
  RPROMPT="%{$fg[green]%} %D{%Y/%m/%d} %* %{$reset_color%}"
else
PROMPT="%{${fg[green]}%}%n%{${reset_color}%}@%{${fg[cyan]}%}%m${reset_color}
%~$ "
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"

}
add-zsh-hook precmd _update_vcs_info_msg
fi
