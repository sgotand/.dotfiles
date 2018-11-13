#! /bin/sh

set -eu

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"
DOTDIR=$HOME/.dotfiles

echo $GREEN [[start apt update]] $RESET
sudo apt update 

echo $GREEN [[installing ansible]] $RESET
sudo apt install ansible git -y

echo $GREEN [[clonning .dotfiels]] $RESET
ansible localhost --connection=local -m git -a "repo=https://github.com/progrunner17/.dotfiles.git dest=${DOTDIR} update=no"


echo $GREEN [[start ansible]] $RESET
echo $YELLOW !!!!!! please input your password !!!!! $RESET
ansible-playbook ${DOTDIR}/playbook.yml --ask-become-pass

