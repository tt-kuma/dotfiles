setopt PROMPT_SUBST

# git
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats "(%b)%c%u"
zstyle ':vcs_info:git:*' actionformats "(%b|%a)%c%u"
zstyle ':vcs_info:git:*' unstagedstr "-"
zstyle ':vcs_info:git:*' stagedstr "+"
precmd_vcs_info() { vcs_info; }
precmd_functions+=(precmd_vcs_info)

# kube-ps1
KUBE_PS1_SYMBOL_ENABLE="false"
KUBE_PS1_CTX_COLOR="green"
KUBE_PS1_NS_COLOR="cyan"
KUBE_PS1_PREFIX="("
KUBE_PS1_SUFFIX=")"

# prompt
PS1='$(kube_ps1) %F{green}%m%f:%F{cyan}%c%f %F{red}${vcs_info_msg_0_}%f
$ '
