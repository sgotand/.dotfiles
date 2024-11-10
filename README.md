# dotfiles

## how to use

```sh
wget https://raw.githubusercontent.com/progrunner17/.dotfiles/master/init.sh -q -O -  | sudo sh
```

```bash
docker build . -t dotfiles-test
docker run  -v $PWD:/home/sgotand/.dotfiles -it --rm dotfiles-test
```
