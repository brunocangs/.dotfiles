#!/bin/bash

sudo -v

if [[ -z $(command -v git) ]]; then
  echo "Setting up xcode command line tools"
  # Setup command line tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  softwareupdate -i -a
  rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
else 
  echo "CLI tools already installed"
fi

# Install oh my zsh
#
if [[ -z $(command -v zsh) ]]; then
  echo "Installing oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh my zsh already installed"
fi

Install and setup Homebrew
if [[ -n $(command -v brew) ]]; then
  echo "Brew already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -z $(command -v brew) ]]; then
  echo "Failed to install brew"
  exit 1
fi

# Setup fonts
if [[ -z $(ls "$HOME/Library/Fonts" | grep -i power) ]]; then
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

brew update
brew bundle install
brew upgrade

if [[ -z $(command -v asdf list nodejs) ]]; then
  asdf plugin add nodejs
  # Reads and parses node version list for latest lst                 From array return, find one with not lts = false an extract version. Then parse "vxx.xx.xx" into xx.xx.xx
  NODE_LTS=$(curl https://nodejs.org/download/release/index.json | jq '[.[] | select(.lts != false)] | .[0] | .version' | sed 's/"v\([^"]*\)"/\1/')
  asdf install nodejs $NODE_LTS && asdf global nodejs "$NODE_LTS"
  corepack enable
else
  echo "Node already installed"
fi


# Install all brew applications from Brewfile backup
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

echo "Finished setup, please restart your terminal"
exit 0
