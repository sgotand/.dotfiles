#!/bin/bash
set -e

DOTFILES_DIR="${HOME}/.dotfiles"

# Setup dotfiles symlinks
setup_dotfiles() {
    mkdir -p "${HOME}/.config/nvim"

    # Neovim
    [ -L "${HOME}/.config/nvim/init.lua" ] || \
        ln -sf "${DOTFILES_DIR}/init.lua" "${HOME}/.config/nvim/init.lua"

    # tmux
    [ -L "${HOME}/.tmux.conf" ] || \
        ln -sf "${DOTFILES_DIR}/tmux.conf" "${HOME}/.tmux.conf"

    # zsh
    [ -f "${HOME}/.zshrc" ] || \
        echo "source ${DOTFILES_DIR}/zshrc" > "${HOME}/.zshrc"
    [ -f "${HOME}/.zshenv" ] || \
        echo "source ${DOTFILES_DIR}/zshenv" > "${HOME}/.zshenv"

    # tmux plugin manager
    [ -d "${HOME}/.tmux/plugins/tpm" ] || \
        git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm" 2>/dev/null || true
}

setup_dotfiles

exec "$@"
