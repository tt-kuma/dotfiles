# ghq + fzf
fghq() {
    local repo=$(ghq list | fzf --reverse --preview "if [[ -n $(ghq root)/{}/README.md ]]; then cat $(ghq root)/{}/README.md; else tree -C {}; fi")
    if [[ -n "$repo" ]]; then
        cd "$(ghq root)/$repo"
    fi
}

gover() {
    local go_version=$(ls "$HOME/sdk" | grep go | fzf --reverse)
    if [[ -n $GOPATH ]] && [[ -n $_go_version ]] && [[ -L $GOPATH/bin/go ]]; then
        ln -nfs "$GOPATH/bin/$go_version" "$GOPATH/bin/go"
    fi
}
