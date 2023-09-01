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
)
log "===== Installing packages ====="
case "$OS" in
"Linux")
    packages=(
        "${base_packages[@]}"
        golang
        xsel
        emacs-nox
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
    if ! type brew > /dev/null; then
        log "===== Installing brew ====="
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    packages=(
        "${base_packages[@]}"
        go
        ghq
        kubectl
        emacs
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
pushd "$(dirname "$0")" > /dev/null
src_dir=$(pwd) > /dev/null
popd
dotfiles=$(find "$src_dir" -maxdepth 1 -name ".*")
for src in $dotfiles; do
    dst="$HOME/$(basename "$src")"
    if [[ $(readlink "$dst") == "$src" ]]; then
        log "Already up to date: $dst"
        continue
    fi

    backup_message="no original file"
    if [[ -e $dst ]]; then
        mv "$dst" "$dst.$(date '+%Y%m%d').bak"
        backup_message="$dst.$(date '+%Y%m%d').bak"
    fi
    ln -s "$src" "$dst"
    log "Updated $dst (backup: $backup_message)."
done
