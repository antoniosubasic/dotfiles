#!/bin/bash

# ---------------------------------- colors ----------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
# ---------------------------------- colors ----------------------------------

# dotfiles path
dotfiles_path="$HOME/.dotfiles"

# force symlink creation
force=false
if [[ $1 == "-f" || $1 == "--force" ]]; then
    force=true
fi

install() {
    local package=$1

    local command
    case $2 in
        apt) command="sudo apt-get install -y" ;;
        cargo) command="cargo install" ;;
        *) echo -e "${RED}invalid package manager${NC}"; exit 1 ;;
    esac

    $command $package > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}failed to install ${CYAN}$package${NC}"
        exit 1
    fi
}

symlink() {
    target="$dotfiles_path/$1"
    link="$HOME/$1"

    # handle directory pattern (.config/*)
    if [[ $target == *"/*" ]]; then
        base_target="${target%/*}"
        base_link="$HOME${base_target#$dotfiles_path}"

        if [[ -d $base_target ]]; then
            shopt -s dotglob
            if [[ ! -d $base_link ]]; then
                mkdir -p $base_link
                echo -e "\t${CYAN}$base_link${NC} created"
            fi
            for item in $base_target/*; do
                target="$item"
                link="$base_link/$(basename $item)"
                if [[ -e $link && $force == false ]]; then
                    echo -e "\t${YELLOW}$(basename $link)${NC} already exists"
                elif [[ -e $target ]]; then
                    ln -sf $target $link
                    echo -e "\t${CYAN}$link${NC} -> ${GREEN}$target${NC}"
                else
                    echo -e "\t${YELLOW}$target${NC} not found"
                fi
            done
            shopt -u dotglob
        else
            echo -e "\t${YELLOW}$dir${NC} not found"
        fi

    # handle single file or directory
    elif [[ -f $target || -d $target ]]; then
        link_options="-sf"
        if [[ -d $target ]]; then
            link_options="-sfn"
        fi

        if [[ -e $link && $force == false ]]; then
            echo -e "\t${YELLOW}$(basename $link)${NC} already exists"
        else
            ln $link_options "$target" "$link"
            echo -e "\t${CYAN}$link${NC} -> ${GREEN}$target${NC}"
        fi

    # handle invalid
    else
        echo -e "\t${YELLOW}$target${NC} not found"
    fi
}

# ---------------------------------- section handling ----------------------------------
section=""

sectionlog() {
    if [[ $2 == "start" ]]; then
        section=$1
        echo -ne "---------------------------------------------------------------------------\n[${YELLOW}IP${NC}] $section"
    elif [[ $2 == "end" ]]; then
        echo ""

        if [[ $3 == true ]]; then
            echo -e "[${GREEN}OK${NC}] $section"
        else
            echo -e "[${RED}ER${NC}] $section"
        fi

        echo -e "---------------------------------------------------------------------------"
    else
        if [[ $2 == true ]]; then
            echo -ne "\r\t$1\033[K"
        else
            echo -ne "\n\t$1\033[K"
        fi
    fi
}
# ---------------------------------- section handling ----------------------------------

if [[ $EUID -eq 0 ]]; then
    echo "must not be run as root" 
    exit 1
fi

sudo -v

# ---------------------------------- system ----------------------------------
sectionlog "system" "start"

# update system
sectionlog "updating ${CYAN}system${NC}"
sudo apt-get update > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    sectionlog "${RED}failed to update ${CYAN}system${NC}" true
    exit 1
else
    sectionlog "${CYAN}system${NC} updated" true
fi

# install essential packages
packages=(build-essential libssl-dev curl wget)
for package in ${packages[@]}; do
    sectionlog "installing ${CYAN}$package${NC}"
    install $package apt
    sectionlog "${CYAN}$package${NC} installed" true
done

# upgrade system
sectionlog "upgrading ${CYAN}system${NC}"
sudo apt-get upgrade -y > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    sectionlog "${RED}failed to upgrade ${CYAN}system${NC}" true
    exit 1
else
    sectionlog "${CYAN}system${NC} upgraded" true
fi

sectionlog "system" "end" true
# ---------------------------------- system ----------------------------------

# ---------------------------------- languages ----------------------------------
sectionlog "languages" "start"

# install dotnet
sectionlog "installing ${CYAN}dotnet${NC}"
release_index=$(eval curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json)
dotnet_versions=$(echo "$release_index" | grep -Eo '"latest-release": "[0-9]\.[0-9]+\.[0-9]+"' | awk -F '"' '{print $4}')
dotnet_version=$(echo "$dotnet_versions" | sort -r -t '"' -k4,4n | head -n 1 | awk -F '.' '{print $1"."$2}')
install "dotnet-sdk-$dotnet_version" apt
if [[ $? -ne 0 ]]; then
    sectionlog "${RED}failed to install ${CYAN}dotnet${NC}" true
else
    sectionlog "${CYAN}dotnet $dotnet_version${NC} installed" true
fi

# install latest rust
sectionlog "installing ${CYAN}rust${NC}"
curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    sectionlog "${RED}failed to install ${CYAN}rust${NC}"
    exit 1
else
    source $HOME/.cargo/env
    source $HOME/.profile
    source $HOME/.bashrc
    sectionlog "${CYAN}rust${NC} installed" true
fi

sectionlog "languages" "end" true
# ---------------------------------- languages ----------------------------------

# ---------------------------------- packages ----------------------------------
sectionlog "packages" "start"

apt_packages=(git xsel ripgrep bat)
for package in ${apt_packages[@]}; do
    sectionlog "installing ${CYAN}$package${NC}"
    install $package apt
    sectionlog "${CYAN}$package${NC} installed" true
done

cargo_packages=(exa sd)
for package in ${cargo_packages[@]}; do
    sectionlog "installing ${CYAN}$package${NC}"
    install $package cargo
    sectionlog "${CYAN}$package${NC} installed" true
done

sectionlog "packages" "end" true
# ---------------------------------- packages ----------------------------------

# ---------------------------------- dotfiles repo ----------------------------------
sectionlog "dotfiles" "start"

if [[ -d $dotfiles_path ]]; then
    sectionlog "pulling ${CYAN}repo${NC}"
    git -C $dotfiles_path pull > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        sectionlog "${RED}failed to pull ${CYAN}repo${NC}" true
    else
        sectionlog "${CYAN}repo${NC} pulled" true
    fi
else
    sectionlog "cloning ${CYAN}repo${NC}"
    git clone https://github.com/antoniosubasic/dotfiles.git $dotfiles_path > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        sectionlog "${RED}failed to clone ${CYAN}repo${NC}" true
    else
        sectionlog "${CYAN}repo${NC} cloned" true
    fi
fi

sectionlog "dotfiles" "end" true
# ---------------------------------- dotfiles repo ----------------------------------

# ---------------------------------- symlinks ----------------------------------
sectionlog "symlinks" "start"

echo ""

# create symlinks for dotfiles
dotfiles=(.gitconfig .config/*)
for dotfile in ${dotfiles[@]}; do
    symlink $dotfile
done

# add bash configuration to .bashrc
if ! grep -q "# custom dotfiles configuration" "$HOME/.bashrc"; then
    echo -e "\n# custom dotfiles configuration" >> "$HOME/.bashrc"
    echo "source ~/.config/bash/init.sh" >> "$HOME/.bashrc"
    echo -ne "\t${CYAN}init.sh${NC} included in ${GREEN}.bashrc${NC}"
else
    echo -ne "\t${YELLOW}init.sh${NC} already included"
fi

sectionlog "symlinks" "end" true
# ---------------------------------- symlinks ----------------------------------
