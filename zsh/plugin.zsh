echo "=====start scriptting $0===="
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
###########plugin###############
if [ -z "${ZPLUG_HOME}" ]; then
    export ZPLUG_HOME=$HOME/.zplug
fi

if [ ! -e "${ZPLUG_HOME}" ]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

if [ -e "$ZPLUG_HOME/init.zsh" ]; then
    echo '######### start zplug init.zsh source #########'
    source $ZPLUG_HOME/init.zsh
    echo '######### finish zplug init.zsh source #########'
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'
    zplug "zsh-users/zsh-completions"

    zplug "zsh-users/zsh-history-substring-search"
    if zplug check "zsh-users/zsh-history-substring-search"; then
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey -M emacs '^P' history-substring-search-up
        bindkey -M emacs '^N' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
    fi

    zplug "zsh-users/zsh-syntax-highlighting", defer:2
    zplug "zsh-users/zsh-autosuggestions", defer:2 # 履歴を薄く表示
    if [ -f ~/.fzf.zsh ]; then
      zplug "kwhrtsk/docker-fzf-completion", defer:2
    fi

    zplug "jonmosco/kube-ps1", defer:2, use:"*.sh"

    zplug "plugins/cargo", from:oh-my-zsh, defer:2
    zplug "plugins/fd", from:oh-my-zsh, defer:2
    zplug "plugins/ripgrep", from:oh-my-zsh, defer:2
    zplug "plugins/ansible", from:oh-my-zsh, defer:2
    zplug "plugins/systemd", from:oh-my-zsh, defer:2
    zplug "plugins/sudo", from:oh-my-zsh, defer:2
    zplug "plugins/rsync", from:oh-my-zsh, defer:2
    zplug "plugins/git", from:oh-my-zsh, defer:2
    zplug "plugins/history", from:oh-my-zsh, defer:2
    zplug "plugins/colored-man-pages", from:oh-my-zsh

    echo '######### zplug check ##########'
    zplug check --verbose || zplug install
    echo '######### zplug load ##########'
    zplug load --verbose
    echo '######### zplug list ##########'
    zplug list

# NOTE: if you encountered load duplication problem, do zplug update
fi
echo "====finish scriptting $0===="
