#!/usr/bin/env bash

set -eu -o pipefail

source "$(dirname "$0")/../util.sh"

log "===== Create symbolic links of dotfiles ====="
src_dir=$(full_dirname "$0")
dotfiles=$(find "$src_dir" -maxdepth 1 -name ".*")
for src in $dotfiles; do
    dst="$HOME/$(basename "$src")"
    create_symbolic_link_and_backup "$src" "$dst"
done

log "Setup has successfully finished."
