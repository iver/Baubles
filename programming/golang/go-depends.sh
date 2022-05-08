#!/usr/bin/env bash
# --
# Author
# --
# Iván Jaimes <ivan@iver.mx>
#
# Goal script:
# * Install pre-requisites for spacemacs go-autocomplete layer.

set -o errexit
set -o nounset

export DEPS=(
    "github.com/mdempsky/gocode"
    "github.com/rogpeppe/godef"
    "golang.org/x/tools/cmd/guru"
    "golang.org/x/tools/cmd/gorename"
    "golang.org/x/tools/cmd/goimports"
    "golang.org/x/tools/cmd/godoc"
    "github.com/zmb3/gogetdoc"
    "github.com/cweill/gotests/..."
    "github.com/haya14busa/gopkgs/cmd/gopkgs"
    "github.com/davidrjenni/reftools/cmd/fillstruct"
    "github.com/josharian/impl"
    "golang.org/x/tools/cmd/godoc"
    "golang.org/x/tools/cmd/goimports"
    "golang.org/x/tools/cmd/gorename"
    "golang.org/x/tools/cmd/guru"
    "github.com/cweill/gotests/..."
    "github.com/davidrjenni/reftools/cmd/fillstruct"
    "github.com/fatih/gomodifytags"
    "github.com/godoctor/godoctor"
    "github.com/haya14busa/gopkgs/cmd/gopkgs"
    "github.com/josharian/impl"
    "github.com/mdempsky/gocode"
    "github.com/rogpeppe/godef"
    "github.com/zmb3/gogetdoc"
)

get_depends() {
    for pkg in "${DEPS[@]}"; do
        echo "dep->go get -u -v ${pkg}"
    done
}

go_11_settings() {
    GO111MODULE=on go get -v golang.org/x/tools/gopls@latest
    GO111MODULE=on CGO_ENABLED=0 go get -v -trimpath -ldflags '-s -w' github.com/golangci/golangci-lint/cmd/golangci-lint
}

get_depends