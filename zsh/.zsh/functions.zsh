# ghq + fzf
fghq() {
    local repo=$(ghq list | fzf-tmux --reverse --preview "if [[ -n $(ghq root)/{}/README.md ]]; then cat $(ghq root)/{}/README.md; else tree -C {}; fi")
    if [[ -n "$repo" ]]; then
        cd "$(ghq root)/$repo"
    fi
}

gover() {
    local go_version=$(ls "$HOME/sdk" | grep go | fzf --reverse)
    if [[ -n $go_version ]]; then
        ln -nfs "$GOPATH/bin/$go_version" "$GOPATH/bin/go"
    fi
}
