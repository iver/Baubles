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

@test "create_profile writes a local file that sources the repository profile" {
  create_profile "${DOT_FILES}"

  [ -f "${HOME}/.bash_profile" ]
  [ ! -L "${HOME}/.bash_profile" ]
  [ "$(cat "${HOME}/.bash_profile")" = "${PROFILE_LINE}" ]
}

@test "create_profile replaces a symlink into the repository" {
  ln -s "${DOT_FILES}/iver_profile" "${HOME}/.bash_profile"

  create_profile "${DOT_FILES}"

  [ ! -L "${HOME}/.bash_profile" ]
  [ "$(cat "${HOME}/.bash_profile")" = "${PROFILE_LINE}" ]
}

@test "create_profile keeps existing content and adds the line only once" {
  printf 'export FOO=bar\n' > "${HOME}/.bash_profile"

  create_profile "${DOT_FILES}"
  create_profile "${DOT_FILES}"

  [ "$(cat "${HOME}/.bash_profile")" = "export FOO=bar
${PROFILE_LINE}" ]
}

@test "create_bashrc keeps existing content and adds the line only once" {
  printf 'eval "$(direnv hook bash)"\n' > "${HOME}/.bashrc"

  create_bashrc "${DOT_FILES}"
  create_bashrc "${DOT_FILES}"

  [ "$(cat "${HOME}/.bashrc")" = 'eval "$(direnv hook bash)"
'"${BASHRC_LINE}" ]
}

@test "remove_dot_files removes only the lines added by the installer" {
  printf 'export FOO=bar\n%s\n' "${PROFILE_LINE}" > "${HOME}/.bash_profile"
  printf 'export BAZ=qux\n%s\n' "${BASHRC_LINE}" > "${HOME}/.bashrc"

  remove_dot_files "${DOT_FILES}"

  [ "$(cat "${HOME}/.bash_profile")" = "export FOO=bar" ]
  [ "$(cat "${HOME}/.bashrc")" = "export BAZ=qux" ]
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
