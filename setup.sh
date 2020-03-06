#!/bin/bash

mkdir -p $HOME/.config/
if ! [ -e $HOME/.config/nvim ];then
  ln -s $(realpath $HOME/.dotfiles/.config/nvim) $HOME/.config/nvim
fi
if ! [ -e $HOME/.vimrc ]; then
  ln -s $(realpath $HOME/.dotfiles/.config/nvim/init.vim) $HOME/.vimrc
fi

if ! [ -e $HOME/.tmux/plugins/tpm ];then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

