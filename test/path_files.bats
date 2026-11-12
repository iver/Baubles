#!/usr/bin/env bats
# Specification for the per-language files under env/paths.

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  PATHS_DIR="${REPO_ROOT}/env/paths"
  export HOME="${BATS_TEST_TMPDIR}/home"
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
