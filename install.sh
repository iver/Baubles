#!/bin/bash

[ $USER == "root" ] && echo "You should not install this for the root account." && exit 1

export CURRENT=${HOME}/Config

if [ ! -d ~/.vim ]; then
  git clone https://github.com/iver/vitamine.git ~/.vim
  chmod +x ~/.vim/install.sh
  source ~/.vim/install.sh
fi

if [ ! -d ${HOME}/.vim/conf ]; then
   mkdir -p ${HOME}/.vim/conf
fi

if [ -L ~/.vimrc ]; then
   unlink ~/.vimrc
fi

ln -s ${CURRENT}/vim/vimrc ~/.vim/vimrc.vim
echo source ~/.vim/vimrc.vim > ~/.vimrc
cp ${CURRENT}/vim/conf/go.vim ${HOME}/.vim/conf/go.vim;

[ -f ~/.gitconfig ] || ln -s ${CURRENT}/git/config ~/.gitconfig
[ -f ~/.gitignore_global ] || ln -s ${CURRENT}/git/gitignore_global ~/.gitignore_global
[ -f ~/.bash_profile ] || ln -s ${CURRENT}/dotfiles/bash_profile ~/.bash_profile
[ -f ~/.tmux.conf ] || ln -s ${CURRENT}/dotfiles/tmux.conf ~/.tmux.conf
[ -f ~/.nanorc ] || ln -s ${CURRENT}/dotfiles/nanorc ~/.nanorc
[ -f ~/.ssh/load_keys ] || touch ~/.ssh/load_keys
if [ -d ~/.vim/bundle/vimproc ]; then
   cd ~/.vim/bundle/vimproc && make
fi

if [ -d ~/.vim/bundle/neobundle.vim ]; then
   cd ~/.vim/bundle/neobundle.vim && git pull
fi

git submodule init .
git submodule update
