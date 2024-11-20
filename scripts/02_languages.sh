. "$1"

printf "installing...\n"

if [ $OS = "ubuntu" ] || [ $OS = "linuxmint" ]; then
    throwiferr sudo add-apt-repository ppa:dotnet/backports -y
fi

latest_dotnet_version=$(\
    curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json | \
    jq -r '.["releases-index"][] | select((.["latest-release"] | contains("-rc") | not) and (.["latest-runtime"] | contains("-rc") | not) and (.["latest-sdk"] | contains("-rc") | not)) | .["channel-version"]' | \
    sort -V | \
    tail -n 1
)
dotnet_package="dotnet-sdk-$latest_dotnet_version"
printf "    ==> %s\n" "$dotnet_package"
install_package "$dotnet_package"

printf "    ==> rust\n"
rust_tempfile=$(mktemp)
throwiferr curl --proto '=https' --tlsv1.3 -s -o "$rust_tempfile" https://sh.rustup.rs
throwiferr sh "$rust_tempfile" -y

if command -v bash > /dev/null 2>&1; then
    printf "    ==> node\n"

    node_tempfile=$(mktemp)
    throwiferr curl -s -o "$node_tempfile" https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh
    throwiferr bash "$node_tempfile"

    [ -z "$XDG_CONFIG_HOME" ] && nvm_dir="$HOME/.nvm" || nvm_dir="$XDG_CONFIG_HOME/nvm"
    [ -s "$nvm_dir/nvm.sh" ] && . "$nvm_dir/nvm.sh"

    throwiferr nvm install 20

    [ -s "$nvm_dir/nvm.sh" ] && . "$nvm_dir/nvm.sh"

    printf "    ==> typescript\n"
    throwiferr npm install -g typescript
fi
