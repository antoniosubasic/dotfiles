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
        dir=$(dirname "$target")
        if [[ -d $dir ]]; then
            files=$(find $dir -type f)
            for file in $files; do
                link="$HOME/${file#$dir/}"
                if [[ -e $link && $force == false ]]; then
                    echo -e "${YELLOW}$(basename $link)${NC} already exists"
                elif [[ -e $file ]]; then
                    ln -sf $file $link
                    echo -e "${CYAN}$link${NC} -> ${GREEN}$file${NC}"
                else
                    echo -e "${YELLOW}$file${NC} not found"
                fi
            done
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
sudo apt-get install -y build-essential libssl-dev xsel ripgrep > /dev/null
errorif $? "failed to install packages"

# upgrade system
sudo apt-get upgrade -y > /dev/null
errorif $? "failed to upgrade system"

# create symlinks for dotfiles
dotfiles=(git/* .config/*)
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