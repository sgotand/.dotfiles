[ -n "${SHOW_SOURCE:-}" ] && echo "====start scriptting $0===="
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
###########plugin###############
source "${0:a:h}/zinit.zsh"
# source "${0:a:h}/zplug.zsh"
[ -n "${SHOW_SOURCE:-}" ] && echo "====finish scriptting $0===="
