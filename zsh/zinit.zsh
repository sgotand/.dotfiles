ZINIT_LOAD=light
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit ${ZINIT_LOAD} "zsh-users/zsh-autosuggestions"

zinit ice wait lucid blockf
zinit ${ZINIT_LOAD} "zsh-users/zsh-completions"
zinit ice wait lucid blockf
zinit ${ZINIT_LOAD} "zsh-users/zsh-syntax-highlighting"
# ! suppress
zinit ice lucid mv"kube-ps1.sh -> kube_ps1" pick"kube_ps1"
zinit ${ZINIT_LOAD} "jonmosco/kube-ps1"


zinit ${ZINIT_LOAD} "popstas/zsh-command-time"

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/rsync/rsync.plugin.zsh
# add aliases like rsync-copy
# zinit snippet OMZ::plugins/rsync/rsync.plugin.zsh

zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

# zinit snippet OMZP::docker/docker.plugin.zsh
# zinit snippet OMZP::docker
# zinit snippet PZT::modules/helper/init.zsh
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

## ↓ fzf is used instead
# zinit light zdharma-continuum/history-search-multi-word
# zinit light zsh-users/zsh-history-substring-search
