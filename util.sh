log() {
    echo "$(date '+%Y%m%dT%H:%M:%S') $*"
}

log_err() {
    echo "$(date '+%Y%m%dT%H:%M:%S') $*" >&2
}

cpu_arch() {
    local arch

    case $(uname -m) in
    "x86_64" | "x64" | "amd64")
        arch="amd64"
        ;;
    "arm64" | "aarch64")
        arch="arm64"
        ;;
    *)
        arch=""
        ;;
    esac

    echo "$arch"
}

create_symbolic_link_and_backup() {
    local src=$1
    local dst=$2

    if [[ $(readlink "$dst") == "$src" ]]; then
        log "Already up to date: $dst"
        return
    fi

    backup_message="no original file"
    if [[ -e $dst || -L $dst ]]; then
        mv "$dst" "$dst.$(date '+%Y%m%d').bak"
        backup_message="$dst.$(date '+%Y%m%d').bak"
    fi
    ln -s "$src" "$dst"
    log "Updated $dst (backup: $backup_message)."
}

full_dirname() {
    local dir=$1

    pushd "$(dirname "$dir")" > /dev/null || exit
    full_path=$(pwd)
    popd > /dev/null || exit

    echo "$full_path"
}
