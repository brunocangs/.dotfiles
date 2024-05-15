#!/bin/sh


STOW_FOLDERS="nvim tmux zsh docker"
for folder in $STOW_FOLDERS
do
  stow -D $folder
done
