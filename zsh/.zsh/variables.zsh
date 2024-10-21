# kubectl
export KUBE_EDITOR='emacs'

# golang
export GOPATH="$HOME/go"

# fzf
export FZF_DEFAULT_OPTS="--reverse"
FZF_CTRL_R_OPTS="--with-nth 2.."
FZF_CTRL_T_OPTS="--preview 'if [[ -d {} ]]; then tree -C {}; else cat {}; fi'"
FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# less
export LESS="-R"

# path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
