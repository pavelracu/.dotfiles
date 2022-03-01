#!/bin/bash

sudo apt-get update

# install git, vim, maven and zsh in background
sudo apt install -y git vim maven zsh curl openjdk-11-jdk apt-transport-https

## Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# install flutter
if [ ! -d ~/tools/flutter ]; then 
    echo "tools folder not created..will create"
    echo "...Installing flutter in background"
    mkdir -p ~/tools/flutter && git clone https://github.com/flutter/flutter.git -b stable /home/pp/tools/flutter
    sudo chown pp -R flutter
else
    echo "...Installing flutter in background"
    git clone https://github.com/flutter/flutter.git -b stable /home/pp/tools/flutter
    sudo chown pp -R /home/pp/tools/flutter
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp .gitconfig .vimrc ~/
#cp geometry-modified.zsh-theme 
