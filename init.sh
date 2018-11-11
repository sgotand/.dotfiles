set -eu

RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"

echo $GREEN [[start apt update]] $RESET
apt update

echo $GREEN [[installing ansible]] $RESET
sudo apt install ansible


echo $GREEN [[start ansible]] $RESET
echo $RED !!!!!! please input your password !!!!! $RESET
ansible-playbook playbook.yml --ask-become-pass

