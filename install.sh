#!/bin/bash

# colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# dotfiles path
dotfiles_path="$HOME/.dotfiles"

# option to force symlink creation
force=false
if [[ $1 == "-f" || $1 == "--force" ]]; then
    force=true
fi


print() {
    local message=$1
    local color=$2
    local delete=$3
    echo -ne "${delete:+\n}\r${color}${message}${NC}\033[K"
}

errorif() {
    if [[ $1 -ne 0 ]]; then
        echo -e "${RED}$2${NC}"
        exit 1
    fi
}

install() {
    local package=$1

    local command
    case $2 in
        apt) command="sudo apt-get install -y" ;;
        cargo) command="cargo install" ;;
        *) echo -e "${RED}invalid package manager${NC}"; exit 1 ;;
    esac

    print "installing $package" $YELLOW true
    $command $package > /dev/null 2>&1
    errorif $? "failed to install $package"
    print "$package installed" $CYAN
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
                echo -e "${CYAN}$base_link${NC} created"
            fi
            for item in $base_target/*; do
                target="$item"
                link="$base_link/$(basename $item)"
                if [[ -e $link && $force == false ]]; then
                    echo -e "${YELLOW}$(basename $link)${NC} already exists"
                elif [[ -e $target ]]; then
                    ln -sf $target $link
                    echo -e "${CYAN}$link${NC} -> ${GREEN}$target${NC}"
                else
                    echo -e "${YELLOW}$target${NC} not found"
                fi
            done
            shopt -u dotglob
        else
            echo -e "${YELLOW}$dir${NC} not found"
        fi

    # handle single file or directory
    elif [[ -f $target || -d $target ]]; then
        link_options="-sf"
        if [[ -d $target ]]; then
            link_options="-sfn"
        fi

        if [[ -e $link && $force == false ]]; then
            echo -e "${YELLOW}$(basename $link)${NC} already exists"
        else
            ln $link_options "$target" "$link"
            echo -e "${CYAN}$link${NC} -> ${GREEN}$target${NC}"
        fi

    # handle invalid
    else
        echo -e "${YELLOW}$target${NC} not found"
    fi
}

if [[ $EUID -eq 0 ]]; then
    echo "must not be run as root" 
    exit 1
fi

sudo -v

# update repositories
print "updating repositories" $YELLOW
sudo apt-get update > /dev/null 2>&1
errorif $? "failed to update repositories"
print "repositories updated" $CYAN

# install apt packages
packages=(build-essential libssl-dev curl git xsel ripgrep bat)
for package in ${packages[@]}; do
    install $package apt
done

# upgrade system
print "upgrading system" $YELLOW true
sudo apt-get upgrade -y > /dev/null 2>&1
errorif $? "failed to upgrade system"
print "system upgraded" $CYAN

# install latest dotnet
print "installing dotnet" $YELLOW true
release_index=$(eval curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json)
dotnet_versions=$(echo "$release_index" | grep -Eo '"latest-release": "[0-9]\.[0-9]+\.[0-9]+"' | awk -F '"' '{print $4}')
dotnet_version=$(echo "$dotnet_versions" | sort -r -t '"' -k4,4n | head -n 1 | awk -F '.' '{print $1"."$2}')
sudo apt-get install dotnet-sdk-$dotnet_version > /dev/null 2>&1
errorif $? "failed to install dotnet"
print "dotnet $dotnet_version installed" $CYAN

# install latest rust
print "installing rust" $YELLOW true
curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
errorif $? "failed to install rust"
source $HOME/.cargo/env
source $HOME/.profile
source $HOME/.bashrc
print "rust installed" $CYAN

# update dotfiles repository
if [[ -d $dotfiles_path ]]; then
    print "pulling dotfiles" $YELLOW true
    git -C $dotfiles_path pull > /dev/null 2>&1
    errorif $? "failed to pull dotfiles repository"
    print "dotfiles pulled" $CYAN
else
    print "cloning dotfiles" $YELLOW true
    git clone https://github.com/antoniosubasic/dotfiles.git $dotfiles_path > /dev/null 2>&1
    errorif $? "failed to clone dotfiles repository"
    print "dotfiles cloned" $CYAN
fi

echo -e "\n\n${GREEN}creating symlinks:${NC}"

# create symlinks for dotfiles
dotfiles=(.gitconfig .config/*)
for dotfile in ${dotfiles[@]}; do
    symlink $dotfile
done

# add bash configuration to .bashrc
if ! grep -q "# custom dotfiles configuration" "$HOME/.bashrc"; then
    echo -e "\n# custom dotfiles configuration" >> "$HOME/.bashrc"
    echo "source ~/.config/bash/init.sh" >> "$HOME/.bashrc"
    echo -e "${CYAN}init.sh${NC} included in ${GREEN}.bashrc${NC}"
else
    echo -e "${YELLOW}init.sh${NC} already included"
fi