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

# ----------------------------------   symlinks   ----------------------------------
# directories with / at the end are expanded 
startlog "symlinks" false
symlinks_success=true

remove_symlink() {
    local_symlink="$1"
    local_target="$2"

    local_log_symlink=$(printf "%s" "$local_symlink" | sed "s|^$HOME|~|")
    local_log_target=$(printf "%s" "$local_target" | sed "s|^$HOME|~|")

    if [ -L "$local_symlink" ]; then
        local_symlink_target=$(readlink "$local_symlink")

        if [ "$local_symlink_target" = "$local_target" ]; then
            rm "$local_symlink"
            log "${CYAN}$local_log_symlink${NC} removed"
            return 0
        else
            log "${YELLOW}$local_log_symlink${RED} does not point to ${YELLOW}$local_log_target${NC}"
            return 1
        fi
    elif [ -e "$local_symlink" ]; then
        log "${YELLOW}$local_log_symlink${RED} is not a symbolic link${NC}"
        return 1
    else
        log "${CYAN}$local_log_symlink${NC} does not exist"
        return 0
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
            remove_symlink "$local_symlink" "$sub_target"
            [ $? -ne 0 ] && symlinks_success=false
        done
    else
        remove_symlink "$symlink" "$target"
        [ $? -ne 0 ] && symlinks_success=false
    fi
done < "$dotfiles_path/symlinks"

signature="# -------------- antoniosubasic:dotfiles ---------------"
if grep -qF "$signature" "$HOME/.bashrc"; then
    sed -i '/^$/N;/\n'"$signature"'/D' "$HOME/.bashrc"
    sed -i '/'"$signature"'/,/'"$signature"'/d' "$HOME/.bashrc"
    log "${CYAN}.bashrc${NC} config removed"
else
    log "${CYAN}.bashrc${NC} does not include config"
fi

endlog "$symlinks_success"
# ----------------------------------   symlinks   ----------------------------------

printf "\033[1A"
