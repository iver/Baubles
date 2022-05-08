#!/usr/bin/env bash
# --
# (c) Iver!
# Iván Jaimes <ivan.iver@gmail.com>
#

set -o errexit
set -o nounset
set -o pipefail

[ $USER == "root" ] && echo "You should not install this for the root account." && exit 1

PROJECT_PATH=$(pwd)
SCRIPTS_PATH="${PROJECT_PATH}/scripts"
UTILS_PATH="${SCRIPTS_PATH}/utils"

# shellcheck source=/dev/null
. "${UTILS_PATH}/dot_functions"
remove_dot_files
