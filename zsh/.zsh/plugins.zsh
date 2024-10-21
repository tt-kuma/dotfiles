ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"

source "$ZSH_PLUGINS_DIR/zsh-completions/zsh-completions.plugin.zsh"
fpath=("$ZSH_PLUGINS_DIR/zsh-completions/src" $fpath)
source "$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.plugin.zsh"
source "$ZSH_PLUGINS_DIR/fzf-zsh-completions/fzf-zsh-completions.plugin.zsh"
source "$ZSH_PLUGINS_DIR/forgit/forgit.plugin.zsh"
export PATH="$ZSH_PLUGINS_DIR/forgit/bin:$PATH"
source "$ZSH_PLUGINS_DIR/kube-ps1/kube-ps1.sh"
source "$ZSH_PLUGINS_DIR/ohmyzsh/plugins/globalias/globalias.plugin.zsh"

[[ -f $HOME/.fzf.zsh ]] && source "$HOME/.fzf.zsh"
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
