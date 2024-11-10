FROM rockylinux:9


ENV TERM=xterm-256color
# by default, only C C.utf8 and POSIX are available for locale
# run 'local -a' to check it
RUN dnf install -y glibc-langpack-en

ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8

RUN useradd sgotand

RUN dnf -y install git

# RUN dnf -y install epel-release && \
RUN dnf -y install python3 python3-pip

RUN dnf -y install epel-release && \
    dnf -y install nodejs && \
    npm install -g n && \
     n stable

# yarn is needed for coc
RUN pip3 install neovim && npm install -g yarn && yarn add neovim
# RUN npm -v && false

RUN mkdir -p /usr/local
RUN curl -fsSL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar xzv --strip-components=1 -C /usr/local

RUN mkdir -p $HOME/.config/nvim && \
    ln -s $HOME/.dotfiles/vimrc $HOME/.config/nvim/init.vim


RUN dnf install -y git gcc libevent-devel ncurses-devel make byacc

RUN mkdir -p /usr/local/src/tmux && chmod 777 /usr/local/src/tmux


RUN curl -fsSL https://github.com/tmux/tmux/releases/download/3.5/tmux-3.5.tar.gz | tar xzv -C /usr/local/src/tmux/
WORKDIR /usr/local/src/tmux/tmux-3.5
RUN ./configure
RUN make -j4
USER root:root
RUN make install


RUN dnf -y install zsh

RUN dnf -y install sudo
RUN echo 'sgotand ALL=(ALL) NOPASSWD:ALL' | tee -a /etc/sudoers

USER sgotand:sgotand
WORKDIR /home/sgotand


ADD --chown=sgotand:sgotand ./ .dotfiles/
RUN mkdir -p $HOME/.config/nvim
RUN ln -s $HOME/.dotfiles/init.lua $HOME/.config/nvim/init.lua
RUN ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
RUN echo "source ~/.dotfiles/zshrc" > ~/.zshrc
RUN echo "source ~/.dotfiles/zshenv" > ~/.zshenv

