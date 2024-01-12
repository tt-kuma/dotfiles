#!/usr/bin/env bash

set -eu -o pipefail

source "$(dirname "$0")/../util.sh"

OS=$(uname -s)
ARCH=$(cpu_arch)
if [[ -z $ARCH ]]; then
    log_err "Unsupported cpu architecture."
    exit 1
fi

log "Detected os is $OS ($ARCH)."
# install packages
packages=(
    "colordiff"
    "docker"
    "fzf"
    "git"
    "jq"
    "tmux"
    "tree"
    "zsh"
)

log "===== Installing packages ====="
case "$OS" in
"Linux")
    packages+=(
        emacs-nox
        golang
        xsel
    )
    if type apt > /dev/null; then
        sudo apt update
        sudo apt install -y "${packages[@]}"
    # Currently, support only apt
    # elif type dnf > /dev/null; then
    #     package+=(
    #         epel-release
    #     )
    #     sudo dnf check-update || :
    #     sudo dnf install -y "${packages[@]}"
    # elif type yum > /dev/null; then
    #     package+=(
    #         epel-release
    #     )
    #     sudo yum check-update || :
    #     sudo yum install -y "${packages[@]}"
    else
        log_err "Unsupported linux distribution."
        exit 1
    fi

    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
    go install github.com/x-motemen/ghq@latest

    curl -fsSLO "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    ;;
"Darwin")
    if [[ $ARCH = "arm64" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    if ! type brew > /dev/null; then
        log "===== Installing brew ====="
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    packages+=(
        emacs
        ghq
        go
        kubectl
    )
    brew update
    brew install "${packages[@]}"
    "$(brew --prefix)"/opt/fzf/install
    ;;
*)
    log_err "Unsupported os."
    exit 1
    ;;
esac

log "===== Set zsh as a default shell ====="
if [[ $SHELL != */zsh ]]; then
    chsh -s /bin/zsh
fi

log "===== Setup ghq ====="
GHQ_ROOT=$HOME/repos
if [[ $GHQ_ROOT != $(ghq root) ]]; then
    log "Set $GHQ_ROOT as ghq root."
    git config --global ghq.root "$GHQ_ROOT"
fi

log "===== Create symbolic links of dotfiles ====="
src_dir=$(full_dirname "$0")
dotfiles=$(find "$src_dir" -maxdepth 1 -name ".*")
for src in $dotfiles; do
    dst="$HOME/$(basename "$src")"
    create_symbolic_link_and_backup "$src" "$dst"
done

log "Setup has successfully finished."
