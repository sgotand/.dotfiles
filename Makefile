
.PHONY:build_neovim run_neovim

build_zsh:
	docker build -f Dockerfile.zsh.centos7 -t dotfiles-test:centos7-zsh .

build_neovim:
	docker build -f Dockerfile.neovim.centos7 -t dotfiles-test:centos7-neovim .

build_tmux:
	docker build -f Dockerfile.tmux.centos7 -t dotfiles-test:centos7-tmux .

run_neovim:
	docker run \
	 --name dotfiles-neovim \
	 --rm \
	 --workdir=/home/progrunner \
	 -it dotfiles-test:neovim bash

run_zsh:
	docker run \
	 --name dotfiles-zsh \
	 --rm \
	 --workdir=/home/progrunner \
	 -it dotfiles-test:centos7-zsh bash



run_tmux:
	docker run \
	 --name dotfiles-tmux \
	 --rm \
	 --workdir=/home/progrunner \
	 -it dotfiles-test:centos7-tmux bash

