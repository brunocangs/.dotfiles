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

brew update
brew bundle install
brew upgrade
# Install all brew applications from Brewfile backup


# Setup ASDF





