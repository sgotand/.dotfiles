############## global ##################
export LANG=ja_JP.UTF-8
export LD_LIBRARY_PATH=/usr/local/lib

export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'
export LESS='-gj10 --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'

export EDITOR='/usr/bin/vim'
export PATH=~/.local/bin/:$PATH

# TODO: check the vim directory structure !!
if type vim > /dev/null 2>&1; then
   VIM_VER=$(vim --version | head -n1 | awk 'match($0, /[0-9]+\.[0-9]/) {print substr($0, RSTART, RLENGTH)}' | sed 's/\.//')
   export VIMRUNTIME="/usr/share/vim/vim$VIM_VER"
fi 

export ZPLUG_HOME="$HOME/.zplug"
