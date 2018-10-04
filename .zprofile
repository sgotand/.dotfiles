############## global ##################
export LANG=ja_JP.UTF-8
export LD_LIBRARY_PATH=/usr/local/lib

export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'
export LESS='-gj10 --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'

export EDITOR='/usr/bin/vim'
export PATH=~/.local/bin/:$PATH

##############language###################
# rust
export PATH="$HOME/.cargo/bin:$PATH"

# python(pyenv)
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"

# node(nodebrew)
export PATH=$HOME/.nodebrew/current/bin:$PATH

# go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# c/c++(gcc)
export PATH=/usr/local/Cellar/gcc/8.1.0/bin:/usr/local/Cellar/llvm/6.0.0/bin:$PATH

###############terminal################

# vim
# TODO aliasを貼って、そこでなんとかすれば？
export VIMRUNTIME="/usr/share/vim/vim80"

# zsh(zplug)
export ZPLUG_HOME=/usr/local/opt/zplug
