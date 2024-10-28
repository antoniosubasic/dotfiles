. "$1"

printf "installing...\n"

release_url="https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"
font_dir="$HOME/.local/share/fonts"
if [ ! -d "$font_dir" ]; then
    mkdir -p "$font_dir"
fi

for font in CascadiaCode JetBrainsMono; do
    printf "    ==> %s\n" "$font"

    if [ ! -d "$font_dir/$font" ]; then
        download_url=$(curl -s "$release_url" | jq -r ".assets | .[] | select(.name == \"$font.zip\") | .browser_download_url")
        if [ -z "$download_url" ]; then
            printf "Failed to fetch download URL for %s\n" "$font"
            exit 1
        fi

        tempdir=$(mktemp -d)
        throwiferr curl -sSL "$download_url" -o "$tempdir/$font.zip"
        throwiferr unzip -q "$tempdir/$font.zip" -d "$font_dir/$font"
    fi
done
