#python
if [[ -d $HOME/.pyenv ]] ; then
    export PATH=$HOME/.pyenv/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

#ruby
if [[ -d $HOME/.rbenv  ]] ; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

#rust
if [[ -d $HOME/.cargo ]] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

#direnv
if type direnv 1> /dev/null 2>&1; then
 eval "$(direnv hook zsh)"
fi

#node
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
