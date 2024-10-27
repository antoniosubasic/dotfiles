. "$1"

printf "=== packages ===\n"

printf "installing...\n"

for package in xsel ripgrep asciidoctor sl; do
    printf "    ==> %s\n" "$package"
    install_package "$package"
done

. "$HOME/.cargo/env"

for package in eza sd bat zoxide; do
    printf "    ==> %s\n" "$package"
    throwiferr cargo install --locked "$package"
done