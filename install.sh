#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

dotfiles_path="$HOME/.dotfiles"
if [ -f "$0" ]; then
    dotfiles_path=$(dirname "$(realpath "$0")")
fi

# ---------------------------------- log handling ----------------------------------
log_prefix="     "
section=""
logs=0
deletelogs=true

startlog() {
    section=$1
    logs=0
    deletelogs="${2:-true}"
    printf "[%bIP%b] %s\n" "$YELLOW" "$NC" "$section"
}

endlog() {
    move_cursor_n=$(( logs / 2 ))

    if [ "$deletelogs" = false ]; then
        move_cursor_n=$(( logs ))
    fi

    printf "\033[%sA" "$move_cursor_n"

    if [ "$1" = true ]; then
        status="OK"
        color=$GREEN
    else
        status="ER"
        color=$RED
    fi
    printf "\r[%b%s%b] %s" "$color" "$status" "$NC" "$section"

    printf "\033[%sB\n\n" "$move_cursor_n"
}

log() {
    if [ $logs -eq 0 ]; then
        printf "%s%b\033[K" "$log_prefix" "$1"
    else
        if [ $(( logs % 2 )) -eq 0 ] || [ "$deletelogs" = false ]; then
            printf "\n%s%b\033[K" "$log_prefix" "$1"
        else
            printf "\r%s%b\033[K" "$log_prefix" "$1"
        fi
    fi

    logs=$(( logs + 1 ))
}

logif() {
    local_status=$1
    local_package_name=$2
    local_continue="${3:-true}"

    if [ $local_status -ne 0 ]; then
        log "${RED}failed to install ${YELLOW}$local_package_name${NC}"
        [ "$local_continue" = false ] && exit 1
    else
        log "${CYAN}$local_package_name${NC}"
        return $local_status
    fi
}
# ---------------------------------- log handling ----------------------------------

if [ "$(id -u)" -eq 0 ]; then
    printf "must not be run as root\n" 
    exit 1
fi

if ! sudo -v; then
    printf "sudo is required\n"
    exit 1
fi

# ----------------------------------  os handling  ----------------------------------
OS=$(uname -s)
USE_YAY=false

if [ "$OS" != "Linux" ] || [ ! -f /etc/os-release ]; then
    printf "unsupported OS: %b%s%b\n" "$YELLOW" "$OS" "$NC"
    exit 1
else
    . /etc/os-release
    OS=$ID
    case $OS in
        debian|ubuntu|linuxmint|arch|endeavouros) ;;
        *)
            printf "unsupported OS: %b%s%b\n" "$YELLOW" "$OS" "$NC"
            exit 1
            ;;
    esac
fi

system_update() {
    case "$OS" in
        debian|ubuntu|linuxmint)
            sudo apt update > /dev/null 2>&1
            [ $? -ne 0 ] && return $?
            sudo apt upgrade -y > /dev/null 2>&1
            return $?
            ;;
        arch|endeavouros)
            if [ "$USE_YAY" = true ]; then
                yay -Syu --noconfirm > /dev/null 2>&1
                return $?
            else
                sudo pacman -Syu --noconfirm > /dev/null 2>&1
                return $?
            fi
            ;;
    esac
}

install_package() {
    case "$OS" in
        debian|ubuntu|linuxmint)
            sudo apt install -y "$1" > /dev/null 2>&1
            return $?
            ;;
        arch|endeavouros)
            if [ "$USE_YAY" = true ]; then
                yay -S --noconfirm "$1" > /dev/null 2>&1
                return $?
            else
                sudo pacman -S --noconfirm "$1" > /dev/null 2>&1
                return $?
            fi
            ;;
    esac
}
# ----------------------------------  os handling  ----------------------------------

# ----------------------------------  essentials  ----------------------------------
startlog "essentials"

log "${YELLOW}system${NC}"
system_update
if [ $? -ne 0 ]; then
    log "${RED}failed to update ${YELLOW}system${NC}"
    exit 1
else
    log "${CYAN}system${NC}"
fi

case "$OS" in
    debian|ubuntu|linuxmint) os_dependent_packages="build-essential libssl-dev" ;;
    arch|endeavouros) os_dependent_packages="base-devel" ;;
esac
for package in curl wget git $os_dependent_packages; do
    log "${YELLOW}$package${NC}"
    install_package "$package"
    logif $? "$package" false
done

if [ "$OS" = "arch" ]; then
    log "${YELLOW}yay${NC}"

    if ! command -v yay >/dev/null 2>&1; then
        tempdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git $tempdir > /dev/null 2>&1
        logif $? "yay" false

        cd $tempdir
        makepkg -si --noconfirm > /dev/null 2>&1
        logif $? "yay" false
        cd -
    else
        log "${CYAN}yay${NC}"
    fi

    USE_YAY=true
fi

endlog true
# ----------------------------------  essentials  ----------------------------------

# ----------------------------------  languages   ----------------------------------
startlog "languages"
languages_success=true

log "${YELLOW}dotnet${NC}"
dotnet_version=$(eval curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json | \
    grep -Eo '"latest-release": "[0-9]\.[0-9]+\.[0-9]+"' | \
    awk -F '"' '{print $4}' | \
    sort -V | \
    tail -n 1 | \
    awk -F '.' '{print $1"."$2}')
install_package "dotnet-sdk-$dotnet_version"
logif $? "dotnet $dotnet_version"
[ $? -ne 0 ] && languages_success=false

log "${YELLOW}rust${NC}"
curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
logif $? "rust"
if [ $? -ne 0 ]; then
    languages_success=false
else
    . $HOME/.cargo/env
    . $HOME/.profile
    . $HOME/.bashrc
fi

log "${YELLOW}typescript${NC}"
if command -v bash >/dev/null 2>&1; then
    curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "${RED}failed to install ${YELLOW}typescript${NC}"
        languages_success=false
    else
        if [ -z "$XDG_CONFIG_HOME" ]; then
            nvm_dir="$HOME/.nvm"
        else
            nvm_dir="$XDG_CONFIG_HOME/nvm"
        fi

        [ -s "$nvm_dir/nvm.sh" ] && . "$nvm_dir/nvm.sh"

        nvm install 20 >/dev/null 2>&1

        if [ $? -ne 0 ]; then
            log "${RED}failed to install ${YELLOW}typescript${NC}"
            languages_success=false
        else
            npm install -g typescript >/dev/null 2>&1
            logif $? "typescript"
            [ $? -ne 0 ] && languages_success=false
        fi
    fi
else
    log "${RED}unsupported shell for installing ${YELLOW}typescript${NC} (bash required)"
    languages_success=false
fi

endlog "$languages_success"
# ----------------------------------  languages   ----------------------------------

# ----------------------------------   packages   ----------------------------------
startlog "packages"
packages_success=true

packages="xsel ripgrep bat jq sl asciidoctor"
for package in $packages; do
    log "${YELLOW}$package${NC}"
    install_package "$package"
    logif $? "$package"
    [ $? -ne 0 ] && packages_success=false
done

cargo_packages="eza sd zoxide"
for package in $cargo_packages; do
    log "${YELLOW}$package${NC}"
    cargo install --locked "$package" > /dev/null 2>&1
    logif $? "$package"
    [ $? -ne 0 ] && packages_success=false
done

endlog "$packages_success"
# ----------------------------------   packages   ----------------------------------

# ---------------------------------- dotfiles repo ---------------------------------
startlog "repository"
repository_success=true

if [ -d $dotfiles_path ]; then
    log "${YELLOW}pulling${NC}"
    git -C $dotfiles_path pull origin main > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "${RED}failed to ${YELLOW}pull${NC}"
        repository_success=false
    else
        log "${CYAN}pulled${NC}"
    fi
else
    log "${YELLOW}cloning${NC}"
    git clone https://github.com/antoniosubasic/dotfiles.git $dotfiles_path > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "${RED}failed to ${YELLOW}clone${NC}"
        exit 1
    else
        log "${CYAN}cloned${NC}"
    fi
fi

endlog "$repository_success"
# ---------------------------------- dotfiles repo ---------------------------------

# ----------------------------------   symlinks   ----------------------------------
# directories with / at the end are expanded 
startlog "symlinks" false
symlinks_success=true

symlink() {
    local_symlink="$1"
    local_target="$2"

    local_log_symlink=$(printf "%s" "$local_symlink" | sed "s|^$HOME|~|")
    local_log_target=$(printf "%s" "$local_target" | sed "s|^$HOME|~|")

    local_base_dir=$(dirname "$local_symlink")

    if [ -f "$local_target" ] || [ -d "$local_target" ]; then
        if [ -e "$local_symlink" ]; then
            if [ "$(readlink "$local_symlink")" = "$local_target" ]; then
                log "${CYAN}$local_log_symlink${NC} -> ${MAGENTA}$local_log_target${NC}"
                return 0
            else
                log "${YELLOW}$local_log_symlink ${RED}already exists${NC}"
                return 1
            fi
        else
            [ ! -d "$local_base_dir" ] && mkdir -p "$local_base_dir"
            ln -sfn "$local_target" "$local_symlink"
            log "${CYAN}$local_log_symlink${NC} -> ${MAGENTA}$local_log_target${NC}"
            return 0
        fi
    else
        log "${RED}invalid target ${YELLOW}'$local_log_target'${NC}"
        return 1
    fi
}

while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    symlink=$(printf "%s" "$line" | cut -d':' -f1 | sed "s|^~|$HOME|")
    case "$symlink" in
        /*) ;;
        *) symlink="$HOME/${symlink#./}" ;;
    esac
    expand=$( [ "$(printf "%s" "$symlink" | rev | cut -c1)" = "/" ] && echo true || echo false )
    symlink=$(realpath -sm "$symlink")

    target=$(printf "%s" "$line" | cut -d':' -f2- | sed "s|^~|$HOME|")
    case "$target" in
        /*) ;;
        *) target="$dotfiles_path/${target#./}" ;;
    esac
    target=$(realpath -sm "$target")

    if [ "$expand" = true ]; then
        for sub_target in $(find "$target" -mindepth 1 -maxdepth 1 -print); do
            sub_target_item="${sub_target#$target}"
            local_symlink="${symlink%/}/${sub_target_item#/}"
            symlink "$local_symlink" "$sub_target"
            [ $? -ne 0 ] && symlinks_success=false
        done
    else
        symlink "$symlink" "$target"
        [ $? -ne 0 ] && symlinks_success=false
    fi
done < "$dotfiles_path/symlinks"

signature="# -------------- antoniosubasic:dotfiles ---------------"
if ! grep -qF "$signature" "$HOME/.bashrc"; then
    {
        printf "\n%s\n" "$signature"
        printf "[ -f ~/.config/bash/init.sh ] && source ~/.config/bash/init.sh\n"
        printf "%s\n" "$signature"
    } >> "$HOME/.bashrc"
    log "${CYAN}init.sh${NC} included in ${MAGENTA}.bashrc${NC}"
else
    log "${CYAN}init.sh${NC} already included"
fi

endlog "$symlinks_success"
# ----------------------------------   symlinks   ----------------------------------

printf "\033[1A"
