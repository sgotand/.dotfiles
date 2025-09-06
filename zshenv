# return eary for non-interactive mode (e.g scp/rsync)
[[ "$-" =~ i ]] || return
[ -n "${SHOW_SOURCE:-}" ] && echo "====start scriptting $0===="
export _TTY=$TTY # for vim yank
[[ $PATH =~ "(:|^)/usr/sbin(:|$)" ]] || export PATH="$PATH:/usr/sbin"
[[ $PATH =~ "(:|^)/usr/local/bin(:|$)" ]] || export PATH="/usr/local/bin:$PATH"
case ${OSTYPE} in
darwin*)
    if [ -f "/opt/homebrew/bin/zsh" ]; then
      export SHELL=/opt/homebrew/bin/zsh
    elif [ -f "/usr/local/bin/zsh" ]; then
      export SHELL=/usr/local/bin/zsh
    else
      export SHELL=/usr/bin/zsh
    fi
    ;;
linux*)
    if [ -f "/usr/local/bin/zsh" ]; then
      export SHELL=/usr/local/bin/zsh
    else
      export SHELL=/usr/bin/zsh
    fi
    ;;
esac

# Colors
default=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
purple=$(tput setaf 5)
orange=$(tput setaf 9)

# Less colors for man pages
export PAGER=less
# Begin blinking
export LESS_TERMCAP_mb=$red
# Begin bold
export LESS_TERMCAP_md=$orange
# End mode
export LESS_TERMCAP_me=$default
# End standout-mode
export LESS_TERMCAP_se=$default
# Begin standout-mode - info box
export LESS_TERMCAP_so=$purple
# End underline
export LESS_TERMCAP_ue=$default
# Begin underline
export LESS_TERMCAP_us=$green
export MANPAGER=less

# unsetopt global_rcs avoid sourceing path_helper in /etc/z*
# /etc/zprofile do "eval `/usr/libexec/path_helper -s`"

unsetopt global_rcs
# export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# local
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if which nvim >/dev/null 2>&1; then
  export EDITOR=nvim
elif which vim >/dev/null 2>&1; then
  export EDITOR=vim
fi

if [ -e ~/.fzf ]; then
  export PAHT=$PATH:~/.fzf/bin
fi

if which starship >/dev/null 2>/dev/null; then
  export STARSHIP_HOME=$HOME/.starship
  [ -d "${STARSHIP_HOME}" ] || mkdir ${STARSHIP_HOME}
  export STARSHIP_CONFIG=${STARSHIP_HOME}/config.toml
  export STARSHIP_CACHE=${STARSHIP_HOME}/cache
fi


#python
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
if [[ -d $HOME/.pyenv ]] || (which pyenv > /dev/null 2>/dev/null) ; then
    [ -n "${SHOW_SOURCE:-}" ] && echo init pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi
if (which pipenv >/dev/null 2>/dev/null); then
    export PIPENV_VENV_IN_PROJECT=true
fi
export PATH="$PATH:/opt/homebrew/opt/python/libexec/bin"

# ruby
# git clone https://github.com/rbenv/rbenv.git ~/.rbenv
if [[ -d $HOME/.rbenv  ]] ; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

#rust
if [[ -d $HOME/.cargo ]] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
  source $HOME/.cargo/env
fi

#go
export GOPATH=$HOME/go
export GO111MODULE=on
if [[ -d "/usr/local/go/bin" ]] ; then
  export PATH="/usr/local/go/bin:$PATH"
fi

if [[ -d "$GOPATH/bin" ]] ; then
  export PATH="$GOPATH/bin:$PATH"
fi

#direnv
if type direnv 1> /dev/null 2>&1; then
 eval "$(direnv hook zsh)"
fi

#node
export N_PREFIX="$HOME/n"
[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export MANPATH=/usr/local/man:/usr/local/share/man:/usr/share/man:/usr/man
if [[ -d "$HOME/.nodebrew" ]] ; then
  export PATH="$HOME/.nodebrew/current/bin:$PATH"
  export NODEBREW_ROOT=$HOME/.nodebrew
  export NODEBREW_ROOT=/usr/local/var/nodebrew
  export PATH=/usr/local/var/nodebrew/current/bin:$PATH
fi

if (which n >/dev/null 2>/dev/null); then
  export PATH=$HOME/n/bin:$PATH
fi

if ! [[ :$PATH: == *".nvm"* ]]; then
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

#npm
export PATH=$PATH:./node_modules/.bin


if [ -e "${KREW_ROOT:-$HOME/.krew}" ]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi



#haskell
# PATH=$PATH:$HOME/.local/bin # bellow
# set stack ghc aliases
#alias ghci='stack ghci'
#alias ghc='stack ghc --'
#alias runghc='stack runghc --'

#export USE_CCACHE=1
#export CC='ccache gcc'

export LIBVIRT_DEFAULT_URI="qemu:///system"
export DOCKER_BUILDKIT=1
export ZPLUG_HOME=~/.zplug
[ -n "${SHOW_SOURCE:-}" ] && echo "====finish scriptting $0===="

