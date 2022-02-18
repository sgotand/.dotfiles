
.PHONY:build_centos7 run_centos7
build_centos7:
	docker build -f Dockerfile.centos7 -t dotfiles-test:centos7 .

run_centos7:
	docker run \
	 --name dotfiles-centos7 \
	 --rm \
	 --workdir=/home/progrunner \
	 -it dotfiles-test:centos7 bash

