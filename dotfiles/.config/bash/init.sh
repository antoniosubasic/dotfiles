for file in $(find "$HOME/.config/bash/" -type f -name "*.sh" ! -name "init.sh"); do
    source $file
done