. "$1"

printf "installing...\n"

for package in bash-completion xsel ripgrep asciidoctor sl neovim; do
    printf "    ==> %s\n" "$package"
    install_package "$package"
done

. "$HOME/.cargo/env"

for package in eza sd bat; do
    printf "    ==> %s\n" "$package"
    throwiferr cargo install --locked "$package"
done

printf "    ==> zoxide\n"
zoxide_tempfile=$(mktemp)
throwiferr curl -sSfL -o "$zoxide_tempfile" https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh
throwiferr sh "$zoxide_tempfile"
