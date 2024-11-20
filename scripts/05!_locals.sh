. "$1"

printf "setting up...\n"

printf "    ==> adding en_US.UTF-8 locale\n"
throwiferr sudo sed -i '/^#\s*en_US\.UTF-8\sUTF-8/s/^#\s*//' /etc/locale.gen

printf "    ==> adding de_AT.UTF-8 locale\n"
throwiferr sudo sed -i '/^#\s*de_AT\.UTF-8\sUTF-8/s/^#\s*//' /etc/locale.gen

printf "    ==> generating locales\n"
throwiferr sudo locale-gen de_AT.UTF-8 en_US.UTF-8 > /dev/null

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