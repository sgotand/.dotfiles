# vim: set ft=zsh:
echo "=====start scriptting $0===="
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000     # memory上のhistoryサイズ これを小さくすると、fzfで読み込めなくなるので注意
export SAVEHIST=10000000
setopt hist_ignore_dups
# setopt hist_ignore_all_dups
# setopt hist_ignore_space
# setopt hist_reduce_blanks
setopt hist_save_by_copy
setopt hist_save_no_dups
setopt hist_allow_clobber
setopt extended_history
setopt hist_find_no_dups
setopt share_history
setopt inc_append_history

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
echo "====finish scriptting $0===="
