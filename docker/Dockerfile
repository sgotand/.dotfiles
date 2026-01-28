# dotfiles development environment
FROM rockylinux:9

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

ENV TERM=xterm-256color
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8

# Locale setup
RUN dnf install -y glibc-langpack-en

# Basic packages (combined for layer efficiency)
RUN dnf -y install --allowerasing \
    git \
    curl \
    wget \
    unzip \
    sudo \
    zsh \
    python3 \
    python3-pip \
    gcc \
    libevent-devel \
    ncurses-devel \
    make \
    byacc \
    && dnf clean all

# Node.js via n
RUN dnf -y install epel-release && \
    dnf -y install nodejs && \
    npm install -g n && \
    n stable && \
    npm install -g yarn && \
    dnf clean all

# Neovim
RUN mkdir -p /usr/local && \
    curl -fsSL https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz \
    | tar xzv --strip-components=1 -C /usr/local

# tmux (build from source)
ARG TMUX_VERSION=3.5
RUN mkdir -p /usr/local/src/tmux && \
    curl -fsSL https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz \
    | tar xzv -C /usr/local/src/tmux/ && \
    cd /usr/local/src/tmux/tmux-${TMUX_VERSION} && \
    ./configure && make -j$(nproc) && make install && \
    rm -rf /usr/local/src/tmux

# Python/Neovim integration
RUN pip3 install neovim pynvim

# Create user with dynamic UID/GID
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /usr/bin/zsh ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Entrypoint
COPY docker/scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["zsh"]
