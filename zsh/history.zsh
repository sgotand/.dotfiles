
################# History #######################

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000000
setopt hist_ignore_dups
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
