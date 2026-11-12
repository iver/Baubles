#!/usr/bin/env bats
# Specification for the per-language files under env/paths.

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  PATHS_DIR="${REPO_ROOT}/env/paths"
  export HOME="${BATS_TEST_TMPDIR}/home"
  unset ASDF_DATA_DIR
  mkdir -p "${HOME}"
  BASE_PATH="/usr/bin:/bin"
}

# source_path_file <file name>: prints LPATH after sourcing the file.
source_path_file() {
  env PATH="${BASE_PATH}" bash --noprofile --norc -c \
    'LPATH=""; . "$1"; printf "%s" "$LPATH"' _ "${PATHS_DIR}/$1"
}

@test "ruby path file only prepends the rvm directory" {
  mkdir -p "${HOME}/.rvm/rubies/default/bin"

  run source_path_file 08_ruby_path

  [ "$status" -eq 0 ]
  [[ "$output" == "${HOME}/.rvm/rubies/default/bin"* ]]
  [[ "$output" != *"/usr/bin"* ]]
}

@test "python path file does not pin an asdf python install" {
  mkdir -p "${HOME}/.asdf/installs/python/3.10.3/bin"

  run source_path_file 07_python_path

  [ "$status" -eq 0 ]
  [[ "$output" != *".asdf/installs"* ]]
}

@test "only 99_asdf_path adds the asdf shims" {
  mkdir -p "${HOME}/.asdf/shims"

  for path_file in "${PATHS_DIR}"/[0-9]*_path; do
    name="$(basename "${path_file}")"
    [ "${name}" = "99_asdf_path" ] && continue
    run source_path_file "${name}"
    [[ "$output" != *".asdf/shims"* ]] || {
      echo "${name} adds the asdf shims"
      return 1
    }
  done
}

@test "asdf path file adds the shims and exports ASDF_DATA_DIR" {
  mkdir -p "${HOME}/.asdf/shims"

  run env PATH="${BASE_PATH}" bash --noprofile --norc -c \
    'LPATH=""; . "$1"; printf "%s|%s" "$LPATH" "$ASDF_DATA_DIR"' _ "${PATHS_DIR}/99_asdf_path"

  [ "$status" -eq 0 ]
  [[ "$output" == "${HOME}/.asdf/shims"*"|${HOME}/.asdf" ]]
}

@test "asdf shims take precedence over cargo" {
  mkdir -p "${HOME}/.asdf/shims" "${HOME}/.cargo/bin"

  run env PATH="${BASE_PATH}" HOME="${HOME}" bash --noprofile --norc -c \
    '. "$1" "$2"; printf "%s" "$PATH"' _ "${PATHS_DIR}/pathrc" "${PATHS_DIR}"

  [ "$status" -eq 0 ]
  [[ "$output" == "${HOME}/.asdf/shims:"* ]]
}
