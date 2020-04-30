#!/bin/bash

sudo apt-get update

# install git, vim, maven and zsh in background
sudo bash -c 'apt install -y git vim maven zsh >/dev/null 2>&1 & disown'

## Install node js
curl -sL https://deb.nodesource.com/setup_12.x -o /home/pp/.dotfiles/nodesource_setup.sh
sudo bash -c 'bash nodesource_setup.sh  >/dev/null 2>&1 & disown '
sudo bash -c 'apt install -y nodejs >/dev/null 2>&1 & disown '

# install flutter
if [ ! -d ~/tools/flutter ]; then 
    echo "tools folder not created..will create"
    echo "...Installing flutter in background"
    mkdir -p ~/tools/flutter && sudo bash -c 'git clone https://github.com/flutter/flutter.git -b stable /home/pp/tools/flutter >/dev/null 2>&1 & disown'
else
    echo "...Installing flutter in background"
    bash -c 'git clone https://github.com/flutter/flutter.git -b stable ~/tools/ >/dev/null 2>&1 & disown'
fi

# install visual studio code
sudo bash -c 'echo "...Installing visual studio code in background " && sudo snap install --classic code >/dev/null 2>&1 & disown'

# install intellij
sudo bash -c 'echo "...Installing intellij in background " && sudo snap install intellij-idea-ultimate --classic >/dev/null 2>&1 & disown'

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git config --global user.name "Pavel Racu"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config core.hooksPath ~/.dotfiles/hooks
