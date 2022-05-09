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
BASE_PATH=/usr/local/golang
TARGET_PATH="${BASE_PATH}/go${GO_VERSION}"

request_auth() {
    if [ "$EUID" != 0 ]; then
        echo "Privileges are required to run the installation. ${USER}"
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
    chown -R ${CONTEXT_USER}:wheel ${BASE_PATH}
}

link_binary() {
    [ -f ${BASE_PATH}/go ] && unlink ${BASE_PATH}/go && echo "listo"
    ln -sf ${TARGET_PATH}/go ${BASE_PATH}/
}

main() {
    export CONTEXT_USER="${1:-}"

    request_auth
    get_golang
    authorize_access
    link_binary
    authorize_access
}

main "$@"