#!/bin/bash
export BRANCH=`/usr/bin/git branch | grep '*'`

tmux setenv -g I_TMUX "${BRANCH}"
tmux showenv -g I_TMUX | sed 's/^.*=//'
