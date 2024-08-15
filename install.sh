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

# package installation
install() {
    local package=$1

    local command
    case $2 in
        apt) command="sudo apt install -y" ;;
        cargo) command="cargo install" ;;
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
release_index=$(eval curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json)
dotnet_versions=$(echo "$release_index" | grep -Eo '"latest-release": "[0-9]\.[0-9]+\.[0-9]+"' | awk -F '"' '{print $4}')
dotnet_version=$(echo "$dotnet_versions" | sort -r -t '"' -k4,4n | head -n 1 | awk -F '.' '{print $1"."$2}')
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

endlog "languages" true
# ----------------------------------  languages   ----------------------------------

# ----------------------------------   packages   ----------------------------------
startlog "packages"

apt_packages=(git xsel ripgrep bat)
for package in ${apt_packages[@]}; do
    sectionlog "installing ${CYAN}$package${NC}"
    install $package apt
    log "${CYAN}$package${NC} installed"
done

cargo_packages=(eza sd)
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

# create symlinks for dotfiles
dotfiles=(.gitconfig $(find .config -mindepth 1 -maxdepth 1))
for dotfile in "${dotfiles[@]}"; do
    target="$dotfiles_path/$dotfile"
    link="$HOME${target#$dotfiles_path}"

    if [[ -f $target || -d $target ]]; then
        link_options="-sf"
        if [[ -d $target ]]; then
            link_options="-sfn"
        fi

        if [[ -e $link && ($1 == "-f" || $1 == "--force") ]]; then
            link_target=$(readlink "$link")
            if [[ "$link_target" == "$target" ]]; then
                log "${CYAN}${link/$HOME/"~"}${NC} -> ${MAGENTA}${target/$HOME/"~"}${NC}"
            else
                log "${CYAN}$(basename $link) ${YELLOW}already exists${NC}"
            fi
        else
            ln $link_options "$target" "$link"
            log "${CYAN}${link/$HOME/"~"}${NC} -> ${MAGENTA}${target/$HOME/"~"}${NC}"
        fi
    else
        log "${RED}$target not found${NC}"
    fi
done

# add bash configuration to .bashrc
if ! grep -q "# custom dotfiles configuration" "$HOME/.bashrc"; then
    echo -e "\n# custom dotfiles configuration" >> "$HOME/.bashrc"
    echo "source ~/.config/bash/init.sh" >> "$HOME/.bashrc"
    log "${CYAN}init.sh${NC} included in ${MAGENTA}.bashrc${NC}"
else
    log "${CYAN}init.sh${NC} already included"
fi

endlog "symlinks" true
# ----------------------------------   symlinks   ----------------------------------

echo -ne "\033[1A"
