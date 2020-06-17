autoload -Uz add-zsh-hook
autoload -Uz vcs_info
###########plugin###############
if [ -z "${ZPLUG_HOME}" ]; then
    export ZPLUG_HOME=$HOME/.zplug
fi

if [ ! -e "${ZPLUG_HOME}/init.zsh" ]; then
    echo "zplug not found"
    echo "Do you want to install zplug? (y or n :default: y)"
    read ANSWER
    case $ANSWER in
    "" | "Y" | "y")
        echo "start installing zplug"
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
        ;;
    *) ;;
    esac
fi

if [ -e "$ZPLUG_HOME/init.zsh" ] && source $ZPLUG_HOME/init.zsh; then
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'
    # additional completions
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
#
    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo
            zplug install
        fi
    fi
    zplug load --verbose
    zplug list
fi
