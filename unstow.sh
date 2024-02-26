#!/bin/sh


STOW_FOLDERS="nvim tmux zsh"
for folder in $STOW_FOLDERS
do
  stow -D $folder
done
