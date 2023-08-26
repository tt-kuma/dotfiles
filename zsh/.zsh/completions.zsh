zstyle ':completion::complete:*' use-cache true

kubectl() {
    unfunction "$0"
    source <(kubectl completion zsh)
    $0 "$@"
}
