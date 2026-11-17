#!/usr/bin/env bats
# Specification for the asdf 0.16+ shell setup.

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  FAKE_PREFIX="${BATS_TEST_TMPDIR}/asdf-prefix"
  mkdir -p "${FAKE_PREFIX}/etc/bash_completion.d"
  printf 'ASDF_COMPLETION_LOADED=1\n' > "${FAKE_PREFIX}/etc/bash_completion.d/asdf"
  export FAKE_PREFIX REPO_ROOT
}

# extract_function <file> <name>: prints the definition of a top-level function.
extract_function() {
  sed -n "/^$2() {/,/^}/p" "$1"
}

@test "asdf_init loads the bash completion without asdf.sh" {
  bats_require_minimum_version 1.5.0
  definition="$(extract_function "${REPO_ROOT}/dotfiles/iver_profile" asdf_init)"
  [ -n "${definition}" ]

  run --separate-stderr bash --noprofile --norc -c '
    brew() { printf "%s\n" "${FAKE_PREFIX}"; }
    eval "$1"
    asdf_init
    printf "%s" "${ASDF_COMPLETION_LOADED:-}"' _ "${definition}"

  [ "$status" -eq 0 ]
  [ -z "${stderr}" ]
  [ "$output" = "1" ]
}

@test "zsh set_tools does not source asdf.sh" {
  bats_require_minimum_version 1.5.0
  command -v zsh > /dev/null || skip "zsh is not installed"
  [ -x /opt/homebrew/bin/brew ] || skip "homebrew is not installed"
  definition="$(extract_function "${REPO_ROOT}/dotfiles/zshrc" set_tools)"
  [ -n "${definition}" ]

  run --separate-stderr zsh -f -c '
    brew() { if [ "$1" = "--prefix" ]; then printf "%s\n" "${FAKE_PREFIX}"; else command brew "$@"; fi; }
    eval "$1"
    set_tools' _ "${definition}"

  [ "$status" -eq 0 ]
  [[ "${stderr}" != *"asdf"* ]]
}

@test "no tracked file references the pre-0.16 asdf init scripts" {
  run git -C "${REPO_ROOT}" grep -nE 'libexec/asdf\.sh|bash_completion\.d/asdf\.bash' -- ':!test/'

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "validate_shell_env checks asdf 0.16 without ASDF_DIR" {
  command -v asdf > /dev/null || skip "asdf is not installed"
  definition="$(extract_function "${REPO_ROOT}/dotfiles/iver_profile" validate_shell_env)"
  [ -n "${definition}" ]
  shims="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims"
  [ -x "${shims}/python3" ] || skip "no python3 shim installed"

  run env -u ASDF_DIR PATH="${shims}:${PATH}" bash --noprofile --norc -c \
    'eval "$1"; validate_shell_env' _ "${definition}"

  asdf_section="$(sed -n '/^-- asdf --$/,/^$/p' <<< "${output}")"
  [[ "${asdf_section}" == *"python3 via asdf shim"* ]]
  [[ "${asdf_section}" != *"[FAIL]"* ]]
}

@test "java_use selects the version through ASDF_JAVA_VERSION" {
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "${HOME}"
  unset ASDF_DATA_DIR

  run bash --noprofile --norc -c '
    asdf() { printf "asdf %s\n" "$*" >> "${HOME}/asdf.calls"; }
    _asdf_java_update_java_home() { printf "java home updated\n"; }
    . "$1"
    java_use temurin-21.0.3+9
    printf "version=%s\n" "${ASDF_JAVA_VERSION}"
    cat "${HOME}/asdf.calls" 2>/dev/null || true' _ "${REPO_ROOT}/env/paths/04_java_path"

  [ "$status" -eq 0 ]
  [[ "$output" == *"version=temurin-21.0.3+9"* ]]
  [[ "$output" == *"java home updated"* ]]
  [[ "$output" != *"asdf shell"* ]]
}
