#!/bin/bash

[ $USER == "root" ] && echo "You should not install this for the root account." && exit 1

export CURRENT=`pwd`

if [ ! -d ~/.vim ]; then
  git clone https://github.com/iver/vitamine.git ~/.vim
  chmod +x ~/.vim/install.sh
  source ~/.vim/install.sh
fi

[ -f ~/.gitconfig ] || ln -s ${CURRENT}/git/config ~/.gitconfig
[ -f ~/.gitignore_global ] || ln -s ${CURRENT}/git/gitignore_global ~/.gitignore_global
[ -f ~/.bash_profile ] || ln -s ${CURRENT}/dotfiles/bash_profile ~/.bash_profile
[ -f ~/.tmux.conf ] || ln -s ${CURRENT}/dotfiles/tmux.conf ~/.tmux.conf
[ -f ~/.nanorc ] || ln -s ${CURRENT}/dotfiles/nanorc ~/.nanorc
[ -f ~/.ssh/load_keys ] || touch ~/.ssh/load_keys
if [ -d ~/.vim/bundle/vimproc ]; then
   cd ~/.vim/bundle/vimproc && make
fi

git submodule init .
git submodule update
