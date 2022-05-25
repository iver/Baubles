#!/usr/bin/env bash
# --
# (c) Iver!
# Iván Jaimes <ivan.iver@gmail.com>
#

set -o errexit
set -o nounset
set -o pipefail

# shellcheck source=/dev/null
. "${UTILS_PATH}/extras"

# Default values
export DOT_FILES=0
export SHOW_HELP=0
export LOCAL_ENV=0
export VERBOSE=1
export INSTALL=0
export LIST=0
export TESTING=0
export PACKAGE=""
export PKGS_AVAILABLE=(
    "asdf"
    "ag"
    "automake"
    "bash-git-prompt"
    "bats-assert"
    "bats-core"
    "bats-file"
    "coreutils"
    "ctags"
    "delta"
    "gpg"
    "gs"
    "postgres"
    "redis"
    "mysql"
    "shellcheck"
    "unzip"
    "ethereum"
    "fop"
    "helm"
    "imagemagick"
    "kind"
    "libtool"
    "tilt"
    "tilt-dev/tap/ctlptl"
    "openvpn"
    "openjdk"
    "pyenv"
    "rar"
    "readline"
    "sqlite3"
    "socat"
    "ripgrep"
    "wget"
    "xz"
    "zlib"
    "wxwidgets"
    # automake libyaml readline libxslt libtool unixodbc unzip curl
)
export UNINSTALL=0

pcolor() {
    if [ $VERBOSE -eq 1 ]; then
        printc "$@"
    fi
}

dot_files() {
    DOT_FILES="${PROJECT_PATH}/dotfiles"
    # shellcheck source=/dev/null
    . "${UTILS_PATH}/dot_functions"
    link_dot_files "${DOT_FILES}"
    create_profile "${DOT_FILES}"
}

remove_dot_files() {
    # shellcheck source=/dev/null
    . "${UTILS_PATH}/dot_functions"
    remove_dot_files
}

install_homebrew() {
    if ! which -s brew ; then
        pcolor "STATUS" "brew is not installed    " "Install"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        pcolor "STATUS" "brew is already installed" "Update"
        brew update
    fi
}

install_xcode() {
    if ! xcode-select -p 1>/dev/null; then
        pcolor "STATUS" "command line tools are not installed" "Install"
        xcode-select --install
    else
        pcolor "STATUS" "command line tools are installed" "Skip  "
    fi
}

brew_install() {
    local PACK=$1
    pcolor "STATUS" "installing ${PACK}" "Start "
    if brew list "${PACK}" &>/dev/null; then
        pcolor "STATUS" "${PACK} is already installed" "Skip  "
    else
        brew install "${PACK}" && \
            pcolor "STATUS" "${PACK} is installed" "Done"
    fi
}

install_plugins_deps() {
    brew_install gpg
    brew_install gawk
}

install_plugins() {
    pcolor "STATUS" "installing asdf plugins" "Start "
    asdf plugin add erlang
    asdf plugin add elixir
    pcolor "STATUS" "installing asdf plugins" "Done  "
    pcolor "STATUS" "installing asdf languages" "Start "
    asdf install
    pcolor "STATUS" "installing asdf languages" "Done  "
}

configure_asdf() {
    local BINARY
    BINARY="\n. $(brew --prefix asdf)/libexec/asdf.sh"
    local COMPLETION
    COMPLETION="\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"
    add_to_dot_file "${BINARY}"
    add_to_dot_file "${COMPLETION}"
}

install_asdf() {
    if ! which -s asdf; then
        pcolor "STATUS" "asdf is not installed" "Install"
        brew_install asdf
        configure_asdf
        install_plugins_deps
        install_plugins
    else
        pcolor "STATUS" "asdf is already installed" "Skip  "
    fi
}

install_ethereum() {
    pcolor "STATUS" "adding ethereum tap" "Start "
    brew tap ethereum/ethereum
    pcolor "STATUS" "adding ethereum tap" "Done  "
    brew_install ethereum
}

install_docker() {
    if [ -x "$(command -v docker)" ]; then
        pcolor "STATUS" "docker is installed" "Skip  "
    else
        pcolor "STATUS" "adding docker cask" "Start "
        brew install --cask docker
        pcolor "STATUS" "adding docker cask" "Done  "
    fi
}

install_storage_tools(){
    brew_install postgresql
    brew_install redis
    brew_install mysql
}

install() {
    printc "STATUS" "Installation" "START "
    install_homebrew
    install_xcode
    [[ $LOCAL_ENV -eq 1 ]] && install_asdf
    # install_docker
    [[ $LOCAL_ENV -eq 1 ]] && install_storage_tools
    printc "STATUS" "Installation" "DONE  "

    exit $?;
}

install_extra(){
    install_docker
    brew_install tilt-dev/tap/ctlptl
    brew_install kind
    brew_install tilt
    brew_install helm
    brew_install kubectl
}

install_testing_bash() {
    printc "STATUS" "Installing testing framework for Bash" "START "
    brew_install bats-core
    brew tap kaos/shell
    brew_install bats-assert
    brew_install bats-file
    printc "STATUS" "Installing testing framework for Bash" "DONE  "
}

show_packages() {
    if [ $LIST -eq 1 ]; then
        printc "MENU" "Available packages are:"
        for element in "${PKGS_AVAILABLE[@]}"; do
            printc "MENU" "           - ${element}"
        done
        exit 0
    else
        printc "ERROR" "available packages are: ${PKGS_AVAILABLE[*]}"
        exit 1
    fi
}

install_package() {
    local PACK=$1
    contains "${PACK}" "${PKGS_AVAILABLE[@]}" || show_packages
    brew_install "${PACK}"
}

illegal_option_msg() {
    printc "ERROR" "Illegal option" "$@"
    show_help
    exit 1
}

parse() {
    set_options_variables "$@"

    # shellcheck source=/dev/null
    . "${UTILS_PATH}/colors"

    # shellcheck source=/dev/null
    . "${UTILS_PATH}/menu"

    [[ $SHOW_HELP -eq 1 ]] && show_help && exit 0;

    [[ $LIST -eq 1 ]] && show_packages && exit 0;

    [[ $LOCAL_ENV -eq 1 ]] && install_extra && exit 0;
    
    [[ $INSTALL -eq 1 ]] && install_package "${PACKAGE}" && exit 0;
    
    [[ $TESTING -eq 1 ]] && install_testing_bash && exit 0;

    [[ $DOT_FILES -eq 1 ]] && dot_files && exit 0;

    [[ $UNINSTALL -eq 1 ]] && remove_dot_files && exit 0;
    
    illegal_option_msg "$@"

}

