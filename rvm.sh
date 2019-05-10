#
# RVM profile
#
# /etc/profile.d/rvm.sh # sh extension required for loading.
#

if
  [ -n "${BASH_VERSION:-}" -o -n "${ZSH_VERSION:-}" ] &&
  test "`\command \ps -p $$ -o ucomm=`" != dash &&
  test "`\command \ps -p $$ -o ucomm=`" != sh
then
  [[ -n "${rvm_stored_umask:-}" ]] || export rvm_stored_umask=$(umask)
  # Load user rvmrc configurations, if exist
  for file in "/etc/rvmrc" "$HOME/.rvmrc"
  do
    [[ -s "$file" ]] && source $file
  done
  if
    [[ -n "${rvm_prefix:-}" ]] &&
    [[ -s "${rvm_prefix}/.rvmrc" ]] &&
    [[ ! "$HOME/.rvmrc" -ef "${rvm_prefix}/.rvmrc" ]]
  then
    source "${rvm_prefix}/.rvmrc"
  fi

  # Load RVM if it is installed, try user then root install.
  if
    [[ -s "$rvm_path/scripts/rvm" ]]
  then
    source "$rvm_path/scripts/rvm"
  elif
    [[ -s "$HOME/.rvm/scripts/rvm" ]]
  then
    true ${rvm_path:="$HOME/.rvm"}
    source "$HOME/.rvm/scripts/rvm"
  elif
    [[ -s "/usr/local/rvm/scripts/rvm" ]]
  then
    true ${rvm_path:="/usr/local/rvm"}
    source "/usr/local/rvm/scripts/rvm"
  fi

  # Add $rvm_bin_path to $PATH if necessary. Make sure this is the last PATH variable change.
  if [[ -n "${rvm_bin_path}" && ! ":${PATH}:" == *":${rvm_bin_path}:"* ]]
  then PATH="${PATH}:${rvm_bin_path}"
  fi
fi
