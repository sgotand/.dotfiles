# return eary for non-interactive mode (e.g scp/rsync)
[[ "$-" =~ i ]] || return

if which nvim >/dev/null 2>&1; then
  export EDITOR=nvim
elif which vim >/dev/null 2>&1; then
  export EDITOR=vim
fi
export SHELL=/usr/bin/zsh

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
export TIMEFMT=$(cat <<-EOF

%J
user (cpu):       %U
system (cpu):     %S
elapsed (cpu):    %E
cpu usage:        %P

swap: %W
shared text:      %XKB
unshared data:    %DKB
total:            %KKB
max:              %MKB

major page faults:%F
minor page faults:%R
filesystem inputs:         %I
filesystem outputs:        %O
received socket msg:       %r
sent     socket msg:       %s
delivered signal:          %k
forced context switch:     %c
voluntal context switch:   %w
EOF
)

export TIME=$(cat <<-EOF

%C
user (cpu):                %Us
system (cpu):              %Ss
elapsed (cpu):             %Es
elapsed (real):            %es
cpu usage:                 %P

system page size:          %ZB
major page faults:         %F
minor page faults:         %M

forced context switch:     %c
voluntal context switch:   %w
swap out:                  %W
filesystem inputs:         %I
filesystem outputs:        %O
received socket msg:       %r
sent     socket msg:       %s
delivered signal:          %k

shared text size avg:      %XKB
unshared size avg:         %DKB
unshared stack size avg:   %pKB
max resident size:         %MKB
avg rss:                   %tKB
total avg size:            %KKB

exit status:               %x
EOF
)


unsetopt global_rcs # avoid sourceing path_helper in /etc/z*
# PATH=/usr/bin:/bin:/usr/sbin:/sbin
export PATH="/usr/local/bin:$PATH"
# local
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi


#python
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
if [[ -d $HOME/.pyenv ]] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi
if (which pipenv >/dev/null 2>/dev/null); then
    export PIPENV_VENV_IN_PROJECT=true
fi

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
fi
#npm
export PATH=$PATH:./node_modules/.bin


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
