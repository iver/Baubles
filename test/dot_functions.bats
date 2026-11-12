#!/usr/bin/env bats
# Specification for the shell startup files created by scripts/utils/dot_functions.

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  DOT_FILES="${REPO_ROOT}/dotfiles"
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "${HOME}"
  PROFILE_LINE=". \"${DOT_FILES}/iver_profile\""
  BASHRC_LINE=". \"${DOT_FILES}/bashrc\""
  # shellcheck source=/dev/null
  . "${REPO_ROOT}/scripts/utils/dot_functions"
}

@test "create_bashrc keeps existing content and adds the line only once" {
  printf 'eval "$(direnv hook bash)"\n' > "${HOME}/.bashrc"

  create_bashrc "${DOT_FILES}"
  create_bashrc "${DOT_FILES}"

  [ "$(cat "${HOME}/.bashrc")" = 'eval "$(direnv hook bash)"
'"${BASHRC_LINE}" ]
}

@test "interactive non-login shells get the repository PATH" {
  mkdir -p "${HOME}/.asdf/shims"
  create_bashrc "${DOT_FILES}"

  run env -i HOME="${HOME}" TERM=dumb PATH="/usr/bin:/bin" \
    bash -i -c 'printf "%s" "$PATH"'

  [[ ":${output}:" == *":${HOME}/.asdf/shims:"* ]]
  [[ ":${output}:" != *":.:"* ]]
  [[ ":${output}:" != *"::"* ]]
}
