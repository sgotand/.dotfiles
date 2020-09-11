#!/bin/bash

version=0.22.0
os=linux
arch=amd64
file=fzf-${version}-${os}_${arch}.tgz
url=https://github.com/junegunn/fzf-bin/releases/download/${version}/${file}

curl -fsSL ${url} |sudo tar -C /usr/local/bin -xz
