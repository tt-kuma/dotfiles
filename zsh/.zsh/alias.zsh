# alias
alias fgit='git forgit'
if type colordiff >/dev/null; then
    alias diff='colordiff'
fi

# abbr
{
    if type abbr; then
        abbr "git c"='git commit -a ""'
        abbr k="kubectl"
    fi
} >/dev/null
