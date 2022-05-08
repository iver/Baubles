#!/usr/bin/env bash
# --
# Author
# --
# Iván Jaimes <ivan@iver.mx>
#
# Goal script:
# * Install Golang on the /usr/local/go path
# * Set the privileges to run as non-root user.

set -o errexit
set -o nounset

GO_VERSION="1.18.1"
TARGET_PATH="/usr/local/go${GO_VERSION}"

request_auth() {
    if [ "$EUID" != 0 ]; then
        echo "Privileges are required to run the installation."
        exec sudo "$0" "${USER}"
        exit "$?"
    fi
}

get_golang() {
    local URL

    URL="https://go.dev/dl/go${GO_VERSION}.darwin-arm64.tar.gz"

    mkdir -p "${TARGET_PATH}"
    curl -L ${URL} | tar -C ${TARGET_PATH} -xz
}

authorize_access() {
    chown -R ${CONTEXT_USER}:wheel ${TARGET_PATH}
}

link_binary() {
    [ -f /usr/local/go ] && unlink /usr/local/go && echo "listo"
    ln -sf ${TARGET_PATH}/go /usr/local/
}

main() {
    export CONTEXT_USER="${1:-}"
    request_auth
    get_golang
    authorize_access
    link_binary
}

main "$@"