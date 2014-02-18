#!/usr/local/bin/zsh

- rm ~/.gitignore

cd ~/dev/gitignore

#TODO Update repo first

echo "#JetBrains\n" >> ~/.gitignore
cat Global/JetBrains.gitignore >> ~/.gitignore

echo "\n#OS X\n" >> ~/.gitignore
cat Global/OSX.gitignore >> ~/.gitignore

echo "\n#vim\n" >> ~/.gitignore
echo "_vimrc_local.vim" >> ~/.gitignore

git config --global core.excludesfile ~/.gitignore

- rm ~/dev/dotfiles/.gitignore
ln ~/.gitignore ~/dev/dotfiles/.gitignore
