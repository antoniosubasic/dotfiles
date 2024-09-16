# ripgrep
alias grep='rg'

# bat
alias bat='batcat --theme "Visual Studio Dark+"'

# eza - https://github.com/eza-community/eza?tab=readme-ov-file#display-options
alias ls='eza --time-style=+"%d.%m.%Y %H:%M:%S" --color=always'
alias ll='ls -al'
alias tree='ls -T'

# zoxide
eval "$(zoxide init bash)"
alias cd='z'

# xsel
alias copy='xsel --input --clipboard'
alias paste='xsel --output --clipboard'

# cd
alias ..='cd ..'
alias ...='cd ../..'

# aoc runtime
aoc() {
    local aoc_runtime_path="$HOME/projects/aoc/runtime/aoc"
    if [ -f "${aoc_runtime_path}" ]; then
        "${aoc_runtime_path}" "$@"
    else
        echo "aoc: command not found" >&2
        return 127
    fi
}

# files
files() {
    xdg-open "${1:-.}" > /dev/null 2>&1 &
}
