#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# dotfiles path
dotfiles_path="$HOME/.dotfiles"

if [ ! -z "${BASH_SOURCE[0]}" ]; then
    dotfiles_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# package installation
install() {
    local package=$1

    local command
    case $2 in
        apt) command="sudo apt install -y" ;;
        cargo) command="cargo install --locked" ;;
        *) echo -e "\n\n${RED}invalid package manager${NC}"; exit 1 ;;
    esac

    $command $package > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "\n\n${RED}failed to install ${CYAN}$package${NC}"
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
    deletelogs=$2
    echo -e "[${YELLOW}IP${NC}] $section"
}

endlog() {
    move_cursor_n=$(( logs / 2 ))

    if [[ "$deletelogs" == false ]]; then
        move_cursor_n=$(( logs ))
    fi

    echo -ne "\033[${move_cursor_n}A"

    if [[ $2 == true ]]; then
        status="OK"
        color=$GREEN
    else
        status="ER"
        color=$RED
    fi
    echo -ne "\r[${color}${status}${NC}] $section"

    echo -e "\033[${move_cursor_n}B\n"
}

log() {
    if (( logs == 0 )); then
        echo -ne "\t$1\033[K"
    else
        if (( logs % 2 == 0 )) || [ "$deletelogs" == false ]; then
            echo -ne "\n\t$1\033[K"
        else
            echo -ne "\r\t$1\033[K"
        fi
    fi

    (( logs++ ))
}
# ---------------------------------- log handling ----------------------------------

if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}must not be run as root${NC}" 
    exit 1
fi

sudo -v

# ----------------------------------    system    ----------------------------------
startlog "system"

log "updating ${CYAN}system${NC}"
sudo apt update > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    log "${RED}failed to update ${CYAN}system${NC}"
    exit 1
else
    log "${CYAN}system${NC} updated"
fi

essential_packages=(build-essential libssl-dev curl wget)
for package in ${essential_packages[@]}; do
    log "installing ${CYAN}$package${NC}"
    install $package apt
    log "${CYAN}$package${NC} installed"
done

log "upgrading ${CYAN}system${NC}"
sudo apt upgrade -y > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    log "${RED}failed to upgrade ${CYAN}system${NC}"
    exit 1
else
    log "${CYAN}system${NC} upgraded"
fi

endlog "system" true
# ----------------------------------    system    ----------------------------------

# ----------------------------------  languages   ----------------------------------
startlog "languages"

# install dotnet
log "installing ${CYAN}dotnet${NC}"
dotnet_version=$(eval curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json | \
    grep -Eo '"latest-release": "[0-9]\.[0-9]+\.[0-9]+"' | \
    awk -F '"' '{print $4}' | \
    sort -V | \
    tail -n 1 | \
    awk -F '.' '{print $1"."$2}')
install "dotnet-sdk-$dotnet_version" apt
if [[ $? -ne 0 ]]; then
    log "${RED}failed to install ${CYAN}dotnet${NC}"
else
    log "${CYAN}dotnet $dotnet_version${NC} installed"
fi

# install latest rust
log "installing ${CYAN}rust${NC}"
curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    log "${RED}failed to install ${CYAN}rust${NC}"
    exit 1
else
    source $HOME/.cargo/env
    source $HOME/.profile
    source $HOME/.bashrc
    log "${CYAN}rust${NC} installed"
fi

# install latest typescript
log "installing ${CYAN}typescript${NC}"
curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    log "${RED}failed to install ${CYAN}typescript${NC}"
else
    nvm_dir="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$nvm_dir/nvm.sh" ] && \. "$nvm_dir/nvm.sh"
    nvm install 20 >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        log "${RED}failed to install ${CYAN}typescript${NC}"
    else
        npm install -g typescript >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            log "${RED}failed to install ${CYAN}typescript${NC}"
        else
            log "${CYAN}typescript${NC} installed"
        fi
    fi
fi

endlog "languages" true
# ----------------------------------  languages   ----------------------------------

# ----------------------------------   packages   ----------------------------------
startlog "packages"

apt_packages=(git xsel ripgrep bat jq)
for package in ${apt_packages[@]}; do
    sectionlog "installing ${CYAN}$package${NC}"
    install $package apt
    log "${CYAN}$package${NC} installed"
done

cargo_packages=(eza sd zoxide)
for package in ${cargo_packages[@]}; do
    log "installing ${CYAN}$package${NC}"
    install $package cargo
    log "${CYAN}$package${NC} installed"
done

endlog "packages" true
# ----------------------------------   packages   ----------------------------------

# ---------------------------------- dotfiles repo ---------------------------------
startlog "dotfiles repo"

if [[ -d $dotfiles_path ]]; then
    log "pulling ${CYAN}repo${NC}"
    git -C $dotfiles_path pull > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        log "${RED}failed to pull ${CYAN}repo${NC}"
    else
        log "${CYAN}repo${NC} pulled"
    fi
else
    log "cloning ${CYAN}repo${NC}"
    git clone https://github.com/antoniosubasic/dotfiles.git $dotfiles_path > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        log "${RED}failed to clone ${CYAN}repo${NC}"
        exit 1
    else
        log "${CYAN}repo${NC} cloned"
    fi
fi

endlog "dotfiles repo" true
# ---------------------------------- dotfiles repo ---------------------------------

# ----------------------------------   symlinks   ----------------------------------
startlog "symlinks" false

# files and directories to symlink - directories with / at the end are expanded
mapfile -t symlinks < "$dotfiles_path/symlinks"

targets=()
contains() {
    local element
    for element in "${targets[@]}"; do
        if [[ "$element" == "$1" ]]; then
            return 0
        fi
    done
    return 1
}
for symlink in "${symlinks[@]}"; do
    item="$dotfiles_path/$symlink"
    if [[ -d "$item" && "$item" == */ ]]; then
        for entry in $(find "$item" -mindepth 1 -maxdepth 1); do
            if ! contains "$entry"; then
                targets+=("$entry")
            fi
        done
    elif [[ -d "$item" || -f "$item" ]]; then
        if ! contains "$item"; then
            targets+=("$item")
        fi
    else
        log "${RED}$item not found${NC}"
    fi
done

for target in "${targets[@]}"; do
    link="$HOME${target#$dotfiles_path}"

    log_link="${link/$HOME/"~"}"
    log_target="${target/$HOME/"~"}"

    base_dir=$(dirname $link)
    if [[ ! -d $base_dir ]]; then
        mkdir -p $base_dir
    fi

    if [[ -f $target || -d $target ]]; then
        link_options="-sf"
        if [[ -d $target ]]; then
            link_options="-sfn"
        fi

        if [[ -e $link ]]; then
            link_target=$(readlink "$link")
            if [[ "$link_target" == "$target" ]]; then
                log "${CYAN}$log_link${NC} -> ${MAGENTA}$log_target${NC}"
            else
                log "${CYAN}$log_link ${YELLOW}already exists${NC}"
            fi
        else
            ln $link_options "$target" "$link"
            log "${CYAN}$log_link${NC} -> ${MAGENTA}$log_target${NC}"
        fi
    else
        log "${RED}invalid target type: $target${NC}"
    fi
done

# add bash configuration to .bashrc
signature="# -------------- antoniosubasic:dotfiles ---------------"
if ! grep -q "$signature" "$HOME/.bashrc"; then
    echo -e "\n$signature" >> "$HOME/.bashrc"
    echo "source ~/.config/bash/init.sh" >> "$HOME/.bashrc"
    echo "$signature" >> "$HOME/.bashrc"
    log "${CYAN}init.sh${NC} included in ${MAGENTA}.bashrc${NC}"
else
    log "${CYAN}init.sh${NC} already included"
fi

endlog "symlinks" true
# ----------------------------------   symlinks   ----------------------------------

echo -ne "\033[1A"
