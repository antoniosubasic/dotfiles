# ripgrep
alias grep='rg'

# bat
alias bat='bat --theme tokyonight'

# eza - https://github.com/eza-community/eza?tab=readme-ov-file#display-options
alias ls='eza --time-style=+"%d.%m.%Y %H:%M:%S" --color=always'
alias ll='ls -al'
alias tree='ls -T'

# zoxide
PATH="$HOME/.local/bin:$PATH"
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

# neovim
alias vim='nvim'
alias svim='sudo -E nvim'

# aoc runtime
if [ -f "$HOME/projects/advent-of-code/runtime/main.sh" ]; then
    aoc() {
        "$HOME/projects/advent-of-code/runtime/main.sh" $@
    }
fi

# open files
if grep -qi '(microsoft|wsl)' /proc/version || grep -qi '(microsoft|wsl)' /proc/sys/kernel/osrelease; then
    files() {
        explorer.exe "$(wslpath -w "${1:-.}")"
        return 0
    }
else
    case "$XDG_CURRENT_DESKTOP" in
        X-Cinnamon|KDE)
            files() {
                xdg-open "${1:-.}" > /dev/null 2>&1
            }
            ;;
    esac
fi