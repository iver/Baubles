#!/usr/bin/env bats
# Specification for env/paths/pathrc and the per-language path files.

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  PATHRC="${REPO_ROOT}/env/paths/pathrc"
  PATHS_DIR="${REPO_ROOT}/env/paths"

  FIXTURE="${BATS_TEST_TMPDIR}/fixture"
  mkdir -p "${FIXTURE}/paths" "${FIXTURE}/bin/a" "${FIXTURE}/bin/b" "${FIXTURE}/bin/c"
  export HOME="${FIXTURE}/home"
  unset ASDF_DATA_DIR
  mkdir -p "${HOME}"
  BASE_PATH="/usr/bin:/bin"
}

# write_path_file <file name> <directory to prepend>
write_path_file() {
  printf 'LPATH=%s:${LPATH}\n' "$2" > "${FIXTURE}/paths/$1"
}

# load_pathrc <initial PATH> [extra commands]: prints the resulting PATH.
load_pathrc() {
  env PATH="$1" FIXTURE="${FIXTURE}" bash --noprofile --norc -c '
    . "$1" "$2"
    eval "$3"
    printf "%s" "$PATH"' _ "${PATHRC}" "${FIXTURE}/paths" "${2:-}"
}

@test "prepends path files in order without current directory or empty entries" {
  write_path_file 00_a_path "${FIXTURE}/bin/a"
  write_path_file 01_b_path "${FIXTURE}/bin/b"

  run load_pathrc "${BASE_PATH}"

  [ "$status" -eq 0 ]
  [ "$output" = "${FIXTURE}/bin/b:${FIXTURE}/bin/a:${BASE_PATH}" ]
}

@test "drops current directory and empty entries inherited from the caller" {
  write_path_file 00_a_path "${FIXTURE}/bin/a"

  run load_pathrc ".:${BASE_PATH}::"

  [ "$status" -eq 0 ]
  [ "$output" = "${FIXTURE}/bin/a:${BASE_PATH}" ]
}

@test "removes duplicate entries keeping the first occurrence" {
  write_path_file 00_a_path "${FIXTURE}/bin/a"

  run load_pathrc "/usr/bin:${FIXTURE}/bin/a:/usr/bin:/bin"

  [ "$status" -eq 0 ]
  [ "$output" = "${FIXTURE}/bin/a:${BASE_PATH}" ]
}

@test "is idempotent when sourced twice" {
  write_path_file 00_a_path "${FIXTURE}/bin/a"
  write_path_file 01_b_path "${FIXTURE}/bin/b"

  run load_pathrc "${BASE_PATH}" '. "$1" "$2"'

  [ "$status" -eq 0 ]
  [ "$output" = "${FIXTURE}/bin/b:${FIXTURE}/bin/a:${BASE_PATH}" ]
}

@test "loads path files in the same order regardless of locale" {
  write_path_file 00_a_path "${FIXTURE}/bin/a"
  write_path_file 0_c_path "${FIXTURE}/bin/c"

  c_locale="$(LC_ALL=C load_pathrc "${BASE_PATH}")"
  utf8_locale="$(LC_ALL=en_US.UTF-8 load_pathrc "${BASE_PATH}")"

  [ "${c_locale}" = "${utf8_locale}" ]
}

@test "path_normalize cleans entries added after pathrc" {
  write_path_file 00_a_path "${FIXTURE}/bin/a"

  run load_pathrc "${BASE_PATH}" \
    'PATH="${PATH}:/bin:.:${FIXTURE}/bin/a:"; path_normalize'

  [ "$status" -eq 0 ]
  [ "$output" = "${FIXTURE}/bin/a:${BASE_PATH}" ]
}

@test "asdf shims take precedence over homebrew and versioned kegs" {
  [ -d /opt/homebrew/bin ] || skip "homebrew is not installed"
  mkdir -p "${HOME}/.asdf/shims"

  run env PATH="${BASE_PATH}" HOME="${HOME}" bash --noprofile --norc -c \
    '. "$1" "$2"; printf "%s" "$PATH"' _ "${PATHRC}" "${PATHS_DIR}"

  [ "$status" -eq 0 ]
  entries="$(printf '%s\n' "${output//:/$'\n'}")"
  shims_line="$(grep -nxF "${HOME}/.asdf/shims" <<< "${entries}" | cut -d: -f1)"
  brew_line="$(grep -nxF /opt/homebrew/bin <<< "${entries}" | cut -d: -f1)"
  [ -n "${shims_line}" ]
  [ "${shims_line}" -lt "${brew_line}" ]
  erlang_line="$(grep -nxF /opt/homebrew/opt/erlang@24/bin <<< "${entries}" | cut -d: -f1)"
  if [ -n "${erlang_line}" ]; then
    [ "${shims_line}" -lt "${erlang_line}" ]
  fi
}

@test "normalizes PATH when sourced from zsh" {
  command -v zsh > /dev/null || skip "zsh is not installed"
  write_path_file 00_a_path "${FIXTURE}/bin/a"

  run env PATH=".:${BASE_PATH}::/usr/bin" zsh -f -c \
    '. "$1" "$2"; printf "%s" "$PATH"' _ "${PATHRC}" "${FIXTURE}/paths"

  [ "$status" -eq 0 ]
  [ "$output" = "${FIXTURE}/bin/a:${BASE_PATH}" ]
}
