#!/bin/bash

[ $USER == "root" ] && echo "You should not install this for the root account." && exit 1

if [ ! -d ~/.vim ]; then
  git clone git@github.com:mockee/vitamine.git ~/.vim
  cd ~/.vim && git submodule init && git submodule update
fi

cp ~/Config/dotfiles/bash/vimrc ~/.vim/vimrc.vim
echo source ~/.vim/vimrc > ~/.vimrc
[ -f ~/.vimrc ] || ln -s ~/.vim/vimrc.vim ~/.vimrc
