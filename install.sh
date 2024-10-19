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

# package installation
install() {
    package="$1"

    case "$2" in
        apt) command="sudo apt install -y" ;;
        cargo) command="cargo install --locked" ;;
        *)
            printf "\n\n${RED}invalid package manager${NC}\n"
            exit 1
            ;;
    esac

    $command "$package" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        printf "\n\n${RED}failed to install ${CYAN}$package${NC}\n"
        exit 1
    fi
}

# ---------------------------------- log handling ----------------------------------
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

    if [ "$2" = true ]; then
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
    prefix="     "

    if [ $logs -eq 0 ]; then
        printf "%s%b\033[K" "$prefix" "$1"
    else
        if [ $(( logs % 2 )) -eq 0 ] || [ "$deletelogs" = false ]; then
            printf "\n%s%b\033[K" "$prefix" "$1"
        else
            printf "\r%s%b\033[K" "$prefix" "$1"
        fi
    fi

    logs=$(( logs + 1 ))
}
# ---------------------------------- log handling ----------------------------------

if [ "$(id -u)" -eq 0 ]; then
    printf "must not be run as root\n" 
    exit 1
fi

sudo -v

# ----------------------------------    system    ----------------------------------
startlog "system"

log "updating ${CYAN}system${NC}"
sudo apt update > /dev/null 2>&1
if [ $? -ne 0 ]; then
    log "${RED}failed to update ${CYAN}system${NC}"
    exit 1
else
    log "${CYAN}system${NC} updated"
fi

essential_packages="build-essential libssl-dev curl wget"
for package in $essential_packages; do
    log "installing ${CYAN}$package${NC}"
    install "$package" apt
    log "${CYAN}$package${NC} installed"
done

log "upgrading ${CYAN}system${NC}"
sudo apt upgrade -y > /dev/null 2>&1
if [ $? -ne 0 ]; then
    log "${RED}failed to upgrade ${CYAN}system${NC}"
    exit 1
else
    log "${CYAN}system${NC} upgraded"
fi

endlog "system" true
# ----------------------------------    system    ----------------------------------

# ----------------------------------  languages   ----------------------------------
startlog "languages"

log "installing ${CYAN}dotnet${NC}"
dotnet_version=$(eval curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json | \
    grep -Eo '"latest-release": "[0-9]\.[0-9]+\.[0-9]+"' | \
    awk -F '"' '{print $4}' | \
    sort -V | \
    tail -n 1 | \
    awk -F '.' '{print $1"."$2}')
install "dotnet-sdk-$dotnet_version" apt
if [ $? -ne 0 ]; then
    log "${RED}failed to install ${CYAN}dotnet${NC}"
else
    log "${CYAN}dotnet $dotnet_version${NC} installed"
fi

log "installing ${CYAN}rust${NC}"
curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
if [ $? -ne 0 ]; then
    log "${RED}failed to install ${CYAN}rust${NC}"
    exit 1
else
    . $HOME/.cargo/env
    . $HOME/.profile
    . $HOME/.bashrc
    log "${CYAN}rust${NC} installed"
fi

# install latest typescript
log "installing ${CYAN}typescript${NC}"
if command -v bash >/dev/null 2>&1; then
    curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "${RED}failed to install ${CYAN}typescript${NC}"
    else
        if [ -z "$XDG_CONFIG_HOME" ]; then
            nvm_dir="$HOME/.nvm"
        else
            nvm_dir="$XDG_CONFIG_HOME/nvm"
        fi

        [ -s "$nvm_dir/nvm.sh" ] && . "$nvm_dir/nvm.sh"

        nvm install 20 >/dev/null 2>&1

        if [ $? -ne 0 ]; then
            log "${RED}failed to install ${CYAN}typescript${NC}"
        else
            npm install -g typescript >/dev/null 2>&1
            
            if [ $? -ne 0 ]; then
                log "${RED}failed to install ${CYAN}typescript${NC}"
            else
                log "${CYAN}typescript${NC} installed"
            fi
        fi
    fi
else
    log "${RED}unsupported shell for installing typescript (bash required)${NC}"
fi

endlog "languages" true
# ----------------------------------  languages   ----------------------------------

# ----------------------------------   packages   ----------------------------------
startlog "packages"

apt_packages="git xsel ripgrep bat jq sl asciidoctor"
for package in $apt_packages; do
    log "installing ${CYAN}$package${NC}"
    install "$package" apt
    log "${CYAN}$package${NC} installed"
done

cargo_packages="eza sd zoxide"
for package in $cargo_packages; do
    log "installing ${CYAN}$package${NC}"
    install "$package" cargo
    log "${CYAN}$package${NC} installed"
done

endlog "packages" true
# ----------------------------------   packages   ----------------------------------

# ---------------------------------- dotfiles repo ---------------------------------
startlog "dotfiles repo"

if [ -d $dotfiles_path ]; then
    log "pulling ${CYAN}repo${NC}"
    git -C $dotfiles_path pull origin main > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "${RED}failed to pull ${CYAN}repo${NC}"
    else
        log "${CYAN}repo${NC} pulled"
    fi
else
    log "cloning ${CYAN}repo${NC}"
    git clone https://github.com/antoniosubasic/dotfiles.git $dotfiles_path > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "${RED}failed to clone ${CYAN}repo${NC}"
        exit 1
    else
        log "${CYAN}repo${NC} cloned"
    fi
fi

endlog "dotfiles repo" true
# ---------------------------------- dotfiles repo ---------------------------------

# ----------------------------------   symlinks   ----------------------------------
# directories with / at the end are expanded 
startlog "symlinks" false

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
            else
                log "${CYAN}$local_log_symlink ${YELLOW}already exists${NC}"
            fi
        else
            [ ! -d "$local_base_dir" ] && mkdir -p "$local_base_dir"
            ln -sfn "$local_target" "$local_symlink"
            log "${CYAN}$local_log_symlink${NC} -> ${MAGENTA}$local_log_target${NC}"
        fi
    else
        log "${RED}invalid target ${YELLOW}'$local_log_target'${NC}"
    fi
}

while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    symlink=$(printf "%s" "$line" | cut -d':' -f1 | sed "s|^~|$HOME|")
    expand=$( [ "$(printf "%s" "$symlink" | rev | cut -c1)" = "/" ] && echo true || echo false )
    symlink=$(realpath -sm "$symlink")

    target=$(printf "%s" "$line" | cut -d':' -f2- | sed "s|^~|$HOME|")
    target=$(realpath -sm "$target")

    if [ "$expand" = true ]; then
        for sub_target in $(find "$target" -mindepth 1 -maxdepth 1 -print); do
            sub_target_item="${sub_target#$target}"
            local_symlink="${symlink%/}/${sub_target_item#/}"
            symlink "$local_symlink" "$sub_target"
        done
    else
        symlink "$symlink" "$target"
    fi
done < "$dotfiles_path/symlinks"

# add bash configuration to .bashrc
signature="# -------------- antoniosubasic:dotfiles ---------------"
if ! grep -qF "$signature" "$HOME/.bashrc"; then
    {
        printf "\n%s\n" "$signature"
        printf "source ~/.config/bash/init.sh\n"
        printf "%s\n" "$signature"
    } >> "$HOME/.bashrc"
    log "${CYAN}init.sh${NC} included in ${MAGENTA}.bashrc${NC}"
else
    log "${CYAN}init.sh${NC} already included"
fi

endlog "symlinks" true
# ----------------------------------   symlinks   ----------------------------------

printf "\033[1A"
