# --
# (c) Iver!
# Iván Jaimes <ivan.iver@gmail.com>
#
# This is a setup profile enviroment file for unix-like systems.
# See bash_rc or bash_profile for more information.

. ~/Config/dotfiles/bash/env
. ~/Config/dotfiles/bash/alias

. ~/Config/dotfiles/git/git-completion.bash
source ~/Config/dotfiles/git/git-prompt.sh
. ~/Config/dotfiles/bash/go_path
. ~/Config/dotfiles/bash/paths

# Uncomment this line if you want to load ssh-id
. ~/Config/dotfiles/bash/load_keys.sh

# [ -z "$SP1" ] && return

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -f ~/.profile ]; then
  . ~/.profile
fi

# The next line updates PATH for the Google Cloud SDK.
source '/Users/Iver/Workspace/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/Iver/Workspace/google-cloud-sdk/completion.bash.inc'
