. "$1"

printf "updating system...\n"
case "$OS" in
    ubuntu|linuxmint)
        throwiferr sudo apt update
        throwiferr sudo apt upgrade -y
        packages="build-essential libssl-dev"
        ;;
    arch|endeavouros)
        throwiferr sudo pacman -Syu --noconfirm
        packages="base-devel"
        ;;
esac

printf "installing...\n"
for package in $packages curl wget git jq; do
    printf "    ==> %s\n" "$package"
    install_package "$package"
done

if [ "$OS" = "arch" ] && ! command -v yay > /dev/null 2>&1; then
    printf "installing yay...\n"
    tempdir=$(mktemp -d)
    throwiferr git clone https://aur.archlinux.org/yay.git "$tempdir"

    cd "$tempdir"
    throwiferr makepkg -si --noconfirm
    cd - > /dev/null
fi