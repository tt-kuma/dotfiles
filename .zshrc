# completion
FPATH="/usr/share/zsh-completions/:$FPATH"
autoload -Uz compinit
compinit

# prompt
PS1='$(kube_ps1) %F{green}%m%f:%F{cyan}%c%f %F{red}$(__git_ps1 "(%s)")%f
$ '

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE="1000"
export HISTFILESIZE="10000"
setopt SHARE_HISTORY

# git
source /usr/share/git-core/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE="true"
setopt PROMPT_SUBST


# kubernetes
## kubectl
kubectl completion zsh > "$fpath[1]/_kubectl"
alias k=kubectl
export KUBE_EDITOR="emacs"
## kube-ps1
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
KUBE_PS1_SYMBOL_ENABLE="false"
KUBE_PS1_CTX_COLOR="green"
KUBE_PS1_NS_COLOR="cyan"
KUBE_PS1_PREFIX="("
KUBE_PS1_SUFFIX=")"

# golang
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
FZF_CTRL_R_OPTS="--reverse --with-nth 2.."
## plugins
source "$(ghq root)/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"


# aliases
[[ -x colordiff ]] && alias diff="colordiff"
export LESS="-R"


# ghq + fzf
function ghf() {
  local _repo=$(ghq list | fzf --reverse --preview "ls -aTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [[ -n "$_repo" ]]; then
    cd "$(ghq root)/$_repo"
  fi
}

# change go version
function gover() {
  local _go_version=$(ls "$HOME/sdk" | grep go | fzf --reverse)
  if [[ -n "$GOPATH" ]] && [[ -n "$_go_version" ]] && [[ -L "$GOPATH"/bin/go ]]; then
      ln -nfs "$GOPATH/bin/$_go_version" "$GOPATH/bin/go"
  fi
}

