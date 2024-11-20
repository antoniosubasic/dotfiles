. "$1"

add_locale() {
    locale_pattern="\s*$1.UTF-8\sUTF-8\s*"

    if ! grep -qE "^$locale_pattern$" /etc/locale.gen; then
        if grep -qE "^\s*#$locale_pattern$" /etc/locale.gen; then
            throwiferr sudo sed -i "/^#\s*$locale_pattern/s/^#\s*//" /etc/locale.gen
        else
            throwiferr printf "$1 UTF-8\n" | sudo tee -a /etc/locale.gen > /dev/null
        fi
    fi
}

printf "setting up...\n"

if [ ! -f /etc/locale.gen ]; then
    sudo touch /etc/locale.gen
fi

case "$OS" in
    arch|endeavouros)
        if grep -qE "^NoExtract\s*=\s*usr/share/locale" /etc/pacman.conf; then
            throwiferr sudo sed -i "/^NoExtract\s*=\s*usr\/share\/locale/s/^/#/" /etc/pacman.conf
            install_package "glibc"
        fi
        ;;
esac

printf "    ==> adding en_US.UTF-8 locale\n"
add_locale "en_US"

printf "    ==> adding de_AT.UTF-8 locale\n"
add_locale "de_AT"

printf "    ==> setting locale settings\n"
throwiferr sudo tee /etc/locale.conf > /dev/null << EOF
LANG=en_US.UTF-8
LC_TIME=de_AT.UTF-8
LC_NUMERIC=de_AT.UTF-8
LC_MONETARY=de_AT.UTF-8
LC_COLLATE=de_AT.UTF-8
LC_MEASUREMENT=de_AT.UTF-8
LC_PAPER=de_AT.UTF-8
LC_NAME=de_AT.UTF-8
LC_ADDRESS=de_AT.UTF-8
LC_TELEPHONE=de_AT.UTF-8
LC_IDENTIFICATION=de_AT.UTF-8
EOF

printf "    ==> generating locales\n"
throwiferr sudo locale-gen > /dev/null
