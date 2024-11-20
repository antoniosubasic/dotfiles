. "$1"

printf "installing...\n"

for package in bash-completion xsel ripgrep asciidoctor sl neovim fzf; do
    printf "    ==> %s\n" "$package"
    install_package "$package"
done

if [ "$OS" = "arch" ]; then
    for package in man-db man-pages google-chrome dropbox jdk-temurin maven visual-studio-code-bin jetbrains-toolbox libreoffice-still; do
        printf "    ==> %s\n" "$package"
        install_package "$package"
    done
fi

. "$HOME/.cargo/env"

for package in eza sd bat; do
    printf "    ==> %s\n" "$package"
    throwiferr cargo install --locked "$package"
done

bat cache --build > /dev/null 2>&1

printf "    ==> zoxide\n"
zoxide_tempfile=$(mktemp)
throwiferr curl -sSfL -o "$zoxide_tempfile" https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh
throwiferr sh "$zoxide_tempfile"
