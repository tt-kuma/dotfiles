#!/usr/bin/env bash

set -eu -o pipefail

OS=$(uname -s)

log() {
    echo "$(date '+%Y%m%dT%H:%M:%S') $*"
}

log_err() {
    echo "$(date '+%Y%m%dT%H:%M:%S') $*" 1>&2
}
log "Detected os is $OS."

# install packages
base_packages=(
    "zsh"
    "fzf"
    "tmux"
    "jq"
    "colordiff"
    "tree"
    "emacs"
)
log "===== Installing packages ====="
case "$OS" in
"Linux")
    packages=(
        "${base_packages[@]}"
        golang
        xsel
    )
    if type apt > /dev/null; then
        sudo apt update
        sudo apt install -y "${packages[@]}"
    elif type dnf > /dev/null; then
        sudo dnf check-update
        c sudo dnf install -y "${packages[@]}"
    else
        log_err "Unsupported linux distribution."
        exit 1
    fi

    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
    go install github.com/x-motemen/ghq@latest

    curl -fsSLO "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    ;;
"Darwin")
    if type ! brew > /dev/null; then
        log "===== Installing brew ====="
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    packages=(
        "${base_packages[@]}"
        go
        ghq
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
chsh -s /bin/zsh

log "===== Setup ghq ====="
git config --global ghq.root "$HOME/repos"

log "===== Create symbolic links of dotfiles ====="
pushd "$(dirname "$0")"
src_dir=$(pwd)
popd
dotfiles=$(ls -Ad "$src_dir"/.[^.]*)
for f in $dotfiles; do
    dst="$HOME/$(basename "$f")"
    if [[ $(readlink "$dst") == "$f" ]]; then
        log "Already up to date: $dst"
        continue
    fi
    mv "$dst" "$dst.$(date '+%Y%m%d').bak"
    ln -s "$f" "$dst"
    log "Updated $dst (backup: $dst.$(date '+%Y%m%d').bak)."
done
