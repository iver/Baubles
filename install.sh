#!/usr/bin/env bash

[ "$USER" == "root" ] && echo "You should not install this for the root account." && exit 1

CURRENT=$(pwd)
DOT_FILES="${CURRENT}/dotfiles"

create_vim_data() {
  if [ ! -d ~/.vim ]; then
    git clone https://github.com/iver/vitamine.git ~/.vim
    chmod +x ~/.vim/install.sh
    # shellcheck source=/dev/null
    source ~/.vim/install.sh
  fi

  if [ -d ~/.vim/bundle/vimproc ]; then
    cd ~/.vim/bundle/vimproc && make
  fi
}

link_dot_files() {
  [ -f ~/.gitconfig ] || ln -s "${DOT_FILES}/gitconfig" ~/.gitconfig
  [ -f ~/.gitignore_global ] || ln -s "${DOT_FILES}/gitignore_global" ~/.gitignore_global
  [ -f ~/.tmux.conf ] || ln -s "${DOT_FILES}/tmux.conf" ~/.tmux.conf
  [ -f ~/.nanorc ] || ln -s "${DOT_FILES}/nanorc" ~/.nanorc
  [ -f ~/.ctags ] || ln -s "${DOT_FILES}/ctags" ~/.ctags
  [ -f ~/.ssh/load_keys ] || cp "${CURRENT}/templates/load_keys" ~/.ssh/load_keys
}

fill_bash_profile() {
  if [ -f ~/.bash_profile ]; then
    cat ~/.bash_profile > ~/.bash_profile.bkp;
    cat ~/.bash_profile ${DOT_FILES}/bash_profile > ~/.bash_profile
  else
    ln -s "${DOT_FILES}/bash_profile" ~/.bash_profile
  fi
}

sync_submodule() {
  git submodule init .
  git submodule update
}

main() {
  create_vim_data
  link_dot_files
  fill_bash_profile
  sync_submodule
}

main
