files=($(find "$HOME/.config/bash/" -type f -name "*.sh"))

for file in "${files[@]}"; do
    if [[ "$file" != "$HOME/.config/bash/init.sh" ]]; then
        source $file
    fi
done