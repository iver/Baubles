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
