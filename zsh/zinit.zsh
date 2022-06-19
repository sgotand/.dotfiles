ZINIT_LOAD=load

# zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit ${ZINIT_LOAD} "zsh-users/zsh-autosuggestions"

zinit ice wait lucid blockf
zinit ${ZINIT_LOAD} "zsh-users/zsh-completions"
zinit ice wait lucid blockf
zinit ${ZINIT_LOAD} "zsh-users/zsh-syntax-highlighting"
# ! suppress
zinit ice lucid mv"kube-ps1.sh -> kube_ps1"
zinit ${ZINIT_LOAD} "jonmosco/kube-ps1"

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/rsync/rsync.plugin.zsh
# add aliases like rsync-copy
# zinit snippet OMZ::plugins/rsync/rsync.plugin.zsh

zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

# zinit snippet PZT::modules/helper/init.zsh

## ↓ fzf is used instead
# zinit light zdharma-continuum/history-search-multi-word
# zinit light zsh-users/zsh-history-substring-search
