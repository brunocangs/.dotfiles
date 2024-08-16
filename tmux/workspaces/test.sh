while read line
do
  echo "Running $line"
  tmux neww $line
done < /Users/brunocangussu/.dotfiles/tmux/workspaces/marketplace-base.txt
