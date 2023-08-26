# ghq + fzf
function fghq() {
  local _repo=$(ghq list | fzf --reverse --preview "ls -lap $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [[ -n "$_repo" ]]; then
    cd "$(ghq root)/$_repo"
  fi
}

function gover() {
  local _go_version=$(ls "$HOME/sdk" | grep go | fzf --reverse)
  if [[ -n $GOPATH ]] && [[ -n $_go_version ]] && [[ -L $GOPATH/bin/go ]]; then
    ln -nfs "$GOPATH/bin/$_go_version" "$GOPATH/bin/go"
  fi
}
