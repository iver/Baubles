#!/bin/bash

[ $USER == "root" ] && echo "You should not install this for the root account." && exit 1

export CURRENT=`pwd`

[ -f ~/.gitconfig ] || ln -s ${CURRENT}/dotfiles/git/config ~/.gitconfig
[ -f ~/.gitignore_global ] || ln -s ${CURRENT}/dotfiles/git/gitignore_global ~/.gitignore_global
[ -f ~/.bash_profile ] || ln -s ${CURRENT}/dotfiles/bash_profile ~/.bash_profile
[ -f ~/.tmux.conf ] || ln -s ${CURRENT}/dotfiles/tmux.conf ~/.tmux.conf
[ -f ~/.nanorc ] || ln -s ${CURRENT}/dotfiles/nanorc ~/.nanorc
[ -f ~/.ctags ] || ln -s ${CURRENT}/dotfiles/ctags ~/.ctags
[ -f ~/.ssh/load_keys ] || cp ${CURRENT}/templates/load_keys ~/.ssh/load_keys

if [ -d ~/.vim/bundle/vimproc ]; then
   cd ~/.vim/bundle/vimproc && make
fi

git submodule init .
git submodule update
