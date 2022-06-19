echo "=====start scriptting $0===="
################# Aliases #######################
alias sudo='sudo -E '
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias l1='ls -1'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias less='less -XF'
alias mkdir='mkdir -p'

alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'

alias vs='vagrant status'
alias vss='vagrant ssh'
alias vssh='vagrant ssh'
alias vu='vagrant up'
alias vup='vagrant up'
alias vd='vagrant destroy'
alias vh='vagrant halt'
alias vhalt='vagrant halt'

alias m='make'
alias mc='make clean'
alias ma='make all'
alias mr='make run'

alias k='kubectl'

alias gtime='/usr/bin/time'
if [[ $(uname -s) =~ Linux ]]; then
alias open='xdg-open'
fi

alias apti='apt install'
alias apts='apt search'
alias aptu='apt update'
alias aptug='apt upgrade'
alias tmux='tmux -u'

alias bat=bat --theme zenburn

path() {
    echo $PATH | tr ':' '\n'
}
alias p=path

fpath() {
    echo $FPATH | tr ':' '\n'
}

md2pdf () {
  if ! [[ $1 =~ md$ ]] then
    echo "the source should be .*.md" >2
    return 1
  fi
  echo pandoc $1 -o ${1%md}pdf
  pandoc $1 -o ${1%md}pdf
}

man2pdf () {
man -t $1 | ps2pdf - ${1}.pdf
}

performance () {
if which cpufreq-set >/dev/null 2>/dev/null ; then
  for i in $(seq 0 7)
  do
  sudo cpufreq-set -c $i -g performance
  done
else
  echo cpufreq is not installed
  false
fi
}

powersave () {
if which cpufreq-set >/dev/null 2>/dev/null ; then
  for i in $(seq 0 7)
  do
  sudo cpufreq-set -c $i -g powersave
  done
else
  echo cpufreq is not installed
  false
fi
}


today(){
day=$(date --iso-8601)
day_path=$HOME/workspace/daily/${day}
[ -d "${day_path}" ] || mkdir -p $day_path
cd  $day_path
}


lfd(){

  locate "$1" | fzf
}

function review_pr(){
  git fetch origin pull/$1/head:pr-$1
  git checkout pr-$1
}

if which htop >/dev/null 2>&1; then
    alias top=htop
fi

case ${OSTYPE} in
darwin*)
    #Mac
    export CLICOLOR=1
    if which gls >/dev/null 2>/dev/null; then
      alias ls='gls -F --color=auto -h --group-directories-first'
    else
      alias ls='ls -G -F'
    fi

    ;;
linux*)
    #Linux
    alias ls='ls -F --color=auto'
    ;;
esac

# global aliases
alias -g L='| less'
alias -g G='| grep'
alias -g P='| peco'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sed'

# cf. mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1; then
    # Linux
    alias -g C='| xsel --input --clipboard'
  echo set C alias
elif which putclip >/dev/null 2>&1; then
    # Cygwin
    alias -g C='| putclip'
fi

# expand the global alias when " " is inputted
global_alias() {
    if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
        zle _expand_alias
        # zle expand-word
    fi
    zle self-insert
}
zle -N global_alias
bindkey " " global_alias

tmp-jupyter(){
docker run --rm -v $PWD:/work -p 8888:8888 my-jupyter
}

echo "====finish scriptting $0===="
