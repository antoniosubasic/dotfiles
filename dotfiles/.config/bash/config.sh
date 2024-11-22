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

# shutdown
alias shutdown='shutdown -h now'

# quit
alias :q='exit'

# diff
alias diff='diff --color=always'

# neovim
alias vim='nvim'
sudo() {
    if [ "$1" = "nvim" ] || [ "$1" = "vim" ]; then
        shift
        command sudo -E nvim $@
    else
        command sudo $@
    fi
}

# fzf reverse search
reverse-fzf-search() {
    selected=$(history | sed -E 's| *[0-9]+ +||' | fzf --tac --no-sort --no-multi --reverse --query "$READLINE_LINE" \
        --bind "ctrl-r:down" \
        --bind "ctrl-p:up" \
    )
    
    if [ -n "$selected" ]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#READLINE_LINE}
    fi
}

bind -x '"\C-r": reverse-fzf-search'

# locate image position
locate() {
    if [ -z "$1" ]; then
        echo "usage: locate <image>"
        return 1
    fi

    if [ -f "$1" ]; then
        pos=$(exiftool -GPSPosition "$1" | awk -F": " '{print $2}' | sed -e "s| deg|°|g")
        if [ -z "$pos" ]; then
            echo "no GPS position found"
            return 1
        fi
        url="https://www.google.com/maps/place/$(echo "$pos" | sed -e "s|°|%C2%B0|g" -e "s|'|%27|g" -e "s|\"|%22|g" -e "s|,|+|g" -e "s| ||g")"
        printf "%s\n%s\n" "$pos" "$url"
    else
        echo "file not found: $1"
        return 2
    fi
}

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
