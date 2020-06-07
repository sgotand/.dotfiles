#!/bin/bash
set -eux

DOTFILES_ROOT=$HOME/.dotfiles

mkdir -p $HOME/.config/
[ -e $HOME/.config/nvim ] || mkdir -p $HOME/.config/nvim
[ -e $HOME/.config/nvim/init.vim ] || ln -s ${DOTFILES_ROOT}/vimrc $HOME/.config/nvim/init.vim
[ -e $HOME/.vimrc ] || ln -s ${DOTFILES_ROOT}/vimrc $HOME/.vimrc

VIM=vim
if which nvim > /dev/null 2>/dev/null; then
  VIM=nvim
fi

${VIM} -N -u ${DOTFILES_ROOT}/vimrc -c \
	"try | call dein#update() | finally | qall! | endtry" -V1 -es


[ -e $HOME/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[ -e $HOME/.tmux.conf ] || ln -s ${DOTFILES_ROOT}/tmux.conf $HOME/.tmux.conf

if ! [ -e $HOME/.zshrc ] ; then
cat > $HOME/.zshrc <<EOF
source ${DOTFILES_ROOT}/zshrc
EOF
fi

if ! [ -e $HOME/.zshenv ]; then
cat > $HOME/.zshenv <<EOF
source ${DOTFILES_ROOT}/zshenv
EOF
fi

