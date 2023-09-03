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

log "===== Install Visual Studio Code ====="
declare dst_dir
case "$OS" in
"Linux")
    # Currently, support only Darwin
    # if [[ $(uname --kernel-release) == *microsoft*WSL* ]]; then
    #     dst_dir="/mnt/c/Users/$USER/AppData/Roaming/Code/User"
    # else
    #     dst_dir="$HOME/.config/Code/User"
    # fi
    ;;
"Darwin")
    if ! type code > /dev/null; then
        brew install --cask visual-studio-code
    fi
    dst_dir="$HOME/Library/Application Support/Code/User"
    ;;
*)
    log_err "Unsupported os."
    exit 1
    ;;
esac

log "===== Create symbolic links of setting files ====="
src_dir=$(full_dirname "$0")
for src in "$src_dir"/*.json; do
    dst="$dst_dir/$(basename "$src")"
    create_symbolic_link_and_backup "$src" "$dst"
done

log "===== Install extensions ====="
xargs -l code --install-extension < extensions

log "Setup has successfully finished."
