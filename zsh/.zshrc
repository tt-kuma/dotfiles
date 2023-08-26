typeset -U path PATH
autoload -Uz compinit
compinit

if [[ ! -n $TMUX && $- == *l* ]]; then
  session_count=$(tmux list-sessions 2>/dev/null | wc -l | sed "s/ //g")
  case "$session_count" in
  0) tmux new-session ;;
  1) tmux a ;;
  *)
    session=$(tmux list-sessions | fzf | cut -d ":" -f 1)
    if [[ -n $session ]]; then
      tmux attach-session -t "$session" && exit
    fi
    ;;
  esac
fi

[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
source $HOME/.zsh/plugins.zsh
for f in $HOME/.zsh/*.zsh; do
  source "$f"
done
