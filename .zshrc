# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_PLUGINS=$ZSH/plugins;
export DOT_FILES=$HOME/.dotfiles ## The location of this .zshrc file

## Copy the theme file to the zsh/themes folder.
## Comment/change this part if you want to use another theme
if [ ! -f $ZSH/themes/geometry-modified.zsh-theme ]; then
    cp $DOT_FILES/geometry-modified.zsh-theme $ZSH/themes/
fi

## Install zsh-autosuggestions plugin.
if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

## Install zsh-autosuggestions plugin.
if [ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ]; then
    echo "Installing zsh-syntax-highlighting plugin"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

ZSH_THEME="geometry-modified"

# git config --global user.name "Pavel Racu"
# git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
# git config --global core.hooksPath ~/.dotfiles/hooks

# source $ZSH/oh-my-zsh.sh

# Unncoment this line to set JAVA_HOME JAVA 
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# ANDROID
export ANDROID_HOME=/home/pp/Android/Sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH

# DART
export PATH=$PATH:$HOME/.pub-cache/bin

# Flutter
export PATH="$PATH:$HOME/tools/flutter/bin"

# Personal
export DEV_HOME="$HOME/work/"

# NVM directory
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


plugins=(
  git
  docker
  docker-compose
  zsh-syntax-highlighting
  zsh-autosuggestions
  node
)

source $ZSH/oh-my-zsh.sh
echo -e "\nLoading custom functions..."
source $DOT_FILES/.functions.sh

echo -e "\nLoading custom aliases..."
source $DOT_FILES/.aliases.sh
