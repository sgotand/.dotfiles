#!/bin/bash
set -eux
version=0.27.2
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     os=linux;;
    Darwin*)    os=darwin;;
#     CYGWIN*)    os=windows;;
#     MINGW*)     os=windows;;
    *)          os="UNKNOWN:${unameOut}"
esac
arch=amd64
file=fzf-${version}-${os}_${arch}.tar.gz
url=https://github.com/junegunn/fzf/releases/download/${version}/${file}

curl -fsSL ${url} |sudo tar -C /usr/local/bin -xz
