#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# dotfiles path
dotfiles_path="$HOME/.dotfiles"

if [ ! -z "${BASH_SOURCE[0]}" ]; then
    dotfiles_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

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

# ----------------------------------   symlinks   ----------------------------------
startlog "symlinks"

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
    fi
done

for target in "${targets[@]}"; do
    link="$HOME${target#$dotfiles_path}"

    log_link="${link/$HOME/"~"}"
    log_target="${target/$HOME/"~"}"

    log "removing ${CYAN}$link${NC}"

    if [[ -L "$link" ]]; then
        link_target=$(readlink "$link")
        if [[ "$link_target" == "$target" ]]; then
            rm "$link"
            log "${CYAN}$log_link${NC} removed"
        else
            log "${CYAN}$log_link ${RED}is not a symlink to ${MAGENTA}$log_target${NC}"
        fi
    elif [[ -e "$link" ]]; then
        log "${CYAN}$log_link ${RED}is not a symlink${NC}"
    else
        log "${CYAN}$log_link${NC} does not exist"
    fi
done

# remove bash configuration from .bashrc
log "removing ${CYAN}.bashrc${NC} configuration"
signature="# -------------- antoniosubasic:dotfiles ---------------"
if grep -q "$signature" "$HOME/.bashrc"; then
    sed -i '/^$/N;/\n'"$signature"'/D' "$HOME/.bashrc"
    sed -i '/'"$signature"'/,/'"$signature"'/d' "$HOME/.bashrc"
    log "${CYAN}.bashrc${NC} configuration removed"
else
    log "${CYAN}.bashrc${NC} configuration not found"
fi

endlog "symlinks" true
# ----------------------------------   symlinks   ----------------------------------

echo -ne "\033[1A"