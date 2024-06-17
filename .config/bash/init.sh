config_files=(aliases)
for file in "${config_files[@]}"; do
    source "$HOME/.config/bash/$file.sh"
done