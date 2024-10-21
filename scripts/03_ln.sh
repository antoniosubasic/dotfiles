. "$1"

printf "=== symlinks ===\n"

symlink() {
    find "$1" -mindepth 1 -maxdepth 1 -type f -o -type d | while read -r entry; do
        name=$(basename "$entry")

        log_link=$(printf "%s" "$2/$name" | sed "s|^$HOME|~|")
        log_target=$(printf "%s" "$entry" | sed "s|^$HOME|~|")

        if [ -f "$entry" ]; then
            printf "%s -> %s\n" "$log_link" "$log_target"
            ln -sfn "$entry" "$2/$name"
        elif [ -d "$entry" ]; then
            if [ -d "$2/$name" ] && [ ! -L "$2/$name" ]; then
                symlink "$entry" "$2/$name"
            else
                printf "%s -> %s\n" "$log_link" "$log_target"
                ln -sfn "$entry" "$2/$name"
            fi
        fi
    done
}

symlink "$DOTFILES/config" "$HOME"

signature="# -------------- antoniosubasic:dotfiles ---------------"
if ! grep -qF "$signature" "$HOME/.bashrc"; then
    {
        printf "\n%s\n" "$signature"
        printf "[ -f ~/.config/bash/init.sh ] && source ~/.config/bash/init.sh\n"
        printf "%s\n" "$signature"
    } >> "$HOME/.bashrc"
    printf ".bashrc\n"
else
    printf ".bashrc (already linked)\n"
fi
