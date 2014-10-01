#!/bin/bash

[ $USER == "root" ] && echo "You should not install this for the root account." && exit 1

if [ $(which git) ]; then
  [ ! -d ~/vim/ ] &&  mkdir -p ~/.vim
  [ ! -d ~/vim/bundle ] && mkdir -p ~/.vim/bundle
  [ ! -d ~/vim/conf ] && mkdir -p ~/.vim/conf

  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

  ln -s ~/Config/dotfiles/vim/vimrc ~/.vim/vimrc
  echo 'source ~/.vim/vimrc' > ~/.vimrc
  ln -s ~/Config/dotfiles/vim/conf/go.vim ~/.vim/go.vim
else
   echo 'Git is not installed.'
fi
