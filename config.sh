#!/bin/bash

# Check and install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
else
    echo "Homebrew already installed."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed."
fi

# Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
else
    echo "NVM already installed."
fi

# Install VSCode
if ! command -v code &> /dev/null; then
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
else
    echo "Visual Studio Code already installed."
fi

# Pyenv setup
if ! command -v pyenv &> /dev/null; then
    echo "Installing pyenv..."
    brew install pyenv
else
    echo "Pyenv already installed."
fi

# Add environment variables and paths
echo "Setting up environment variables..."
export ZSH="$HOME/.oh-my-zsh"
export ZSH_PLUGINS="$ZSH/plugins"
export DOT_FILES="$HOME/.dotfiles"
export PATH="/usr/local/bin/python3.12:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Plugins for Zsh
export ZSH_PLUGINS="nvm git docker docker-compose zsh-syntax-highlighting zsh-autosuggestions node python"

# Copy configuration files to home directory
echo "Copying configuration files..."
cp .gitconfig .vimrc .zshrc "$HOME/"

# Source Zsh configuration
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi
