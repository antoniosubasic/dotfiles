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

errorif() {
    if [[ $1 -ne 0 ]]; then
        echo -e "${RED}$2${NC}"
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

# update repositories
sudo apt-get update > /dev/null
errorif $? "failed to update repositories"

# install essential packages
sudo apt-get install -y build-essential libssl-dev xsel ripgrep git > /dev/null
errorif $? "failed to install packages"

# upgrade system
sudo apt-get upgrade -y > /dev/null
errorif $? "failed to upgrade system"

# clone dotfiles repository
if [[ -d $dotfiles_path ]]; then
    echo -e "${YELLOW}$dotfiles_path${NC} already exists"
else
    git clone https://github.com/antoniosubasic/dotfiles.git $dotfiles_path > /dev/null
    errorif $? "failed to clone repository"
    echo -e "${CYAN}dotfiles${NC} cloned to ${GREEN}$dotfiles_path${NC}"
fi

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