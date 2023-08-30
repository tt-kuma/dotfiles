# alias
alias fgit='git forgit'
if type colordiff > /dev/null; then
    alias diff='colordiff'
fi

# abbr
{
    if type abbr; then
        abbr "git c"='git commit -m ""'
        abbr k="kubectl"
    fi
} 1> /dev/null 2> /dev/null
