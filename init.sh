#!/bin/bash

sudo -v
# Install and setup Homebrew
if [[ -n $(command -v brew) ]]; then
  echo "Brew already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -z $(command -v brew) ]]; then
  echo "Failed to install brew"
  exit 1
fi


brew update;
brew bundle install;
brew upgrade;
# Install all brew applications from Brewfile backup


# Setup fonts
if [[ -z ls $HOME/Library/Fonts | grep -i power ]]; then
  echo "No powerline font found"
  # clone
  git clone https://github.com/powerline/fonts.git --depth=1
  # install
  cd fonts
  ./install.sh
  # clean-up a bit
  cd ..
  rm -rf fonts
else 
  echo "Powerline fonts installed, skipping..."
fi

# Setup ASDF

# Stow folders and apply all configs
STOW_FOLDERS="nvim tmux zsh"
for folder in $STOW_FOLDERS
do
  echo "Stowing $folder"
  stow --adopt $folder
done

# This will make it so the target folder gets overriden even if it exists
# It will adopt, which will pull changes
# And then revert them, making them our changes
#
# Get owned
git restore .


