#
# RVM profile
#
# /etc/profile.d/rvm.sh # sh extension required for loading.
#

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.rvm/bin"

rvm_silence_path_mismatch_check_flag=1
