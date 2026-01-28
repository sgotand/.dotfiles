.PHONY: build start shell run stop clean status list clean-all help

DOCKER_SCRIPT := ./docker/scripts/dotfiles-dev

build:
	@$(DOCKER_SCRIPT) build

start:
	@$(DOCKER_SCRIPT) start

shell:
	@$(DOCKER_SCRIPT) shell

run:
	@$(DOCKER_SCRIPT) run

stop:
	@$(DOCKER_SCRIPT) stop

clean:
	@$(DOCKER_SCRIPT) clean

status:
	@$(DOCKER_SCRIPT) status

list:
	@$(DOCKER_SCRIPT) list

clean-all:
	@$(DOCKER_SCRIPT) clean-all

help:
	@$(DOCKER_SCRIPT) help
