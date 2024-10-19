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

# asciidoctor
alias adoc='asciidoctor'

# aoc runtime
aoc() {
    local aoc_runtime_path="$HOME/projects/advent-of-code/runtime/main.sh"

    if [ ! -f "$aoc_runtime_path" ]; then
        echo "error: AoC runtime not found at location \033[1;33m$aoc_runtime_path\033[0m"
        exit 1
    else
        "$aoc_runtime_path" "$@"
    fi
}

# files
files() {
    local path="${1:-.}"

    if grep -qi '(microsoft|wsl)' /proc/version || grep -qi '(microsoft|wsl)' /proc/sys/kernel/osrelease; then
        explorer.exe "$(wslpath -w "$path")"
        exit 0
    else
        nohup xdg-open "$path" > /dev/null 2>&1
    fi
}
