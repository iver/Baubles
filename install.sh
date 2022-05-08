#!/usr/bin/env bash
# --
# (c) Iver!
# Iván Jaimes <ivan.iver@gmail.com>
#

set -o errexit
set -o nounset
set -o pipefail

[ "$USER" == "root" ] && echo "You should not install this for the root account." && exit 1

PROJECT_PATH=$(pwd)
SCRIPTS_PATH="${PROJECT_PATH}/scripts"
UTILS_PATH="${SCRIPTS_PATH}/utils"
TARGET_SCRIPT="${SCRIPTS_PATH}/install"

export PROJECT_PATH
export SCRIPTS_PATH
export UTILS_PATH

main() {
    # Detect the platform.
    case "$OSTYPE" in
        darwin*)
            osx_script="${TARGET_SCRIPT}_osx.sh"
            if [ -f "${osx_script}" ]; then
                # shellcheck source=/dev/null
                source "${osx_script}"
                parse "$@"
            fi
            ;;

        linux*)
            linux_script="${TARGET_SCRIPT}_linux.sh"
            if [ -f "${linux_script}" ]; then
                # shellcheck source=/dev/null
                source "${linux_script}"
            fi
            ;;

        msys*)
            # Load windows script?
            ;;
    esac
}

if [ $# -eq 0 ]; then
    # shellcheck source=/dev/null
    . "${UTILS_PATH}/colors"
    # shellcheck source=/dev/null
    . "${UTILS_PATH}/menu"
    show_help
else
    main "$@"
fi;
