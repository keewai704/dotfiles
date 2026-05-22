#!/bin/bash

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}${BOLD}[•]${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}[✓]${RESET} $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[!]${RESET} $*"; }
error()   { echo -e "${RED}${BOLD}[✗]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}\n"; }

SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="${HOME}/.config"

ensure_prereqs() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        error "Dotfiles directory not found at $DOTFILES_DIR"
        exit 1
    fi

    if ! command -v paru >/dev/null 2>&1; then
        error "'paru' not found. Install paru first and rerun."
        exit 1
    fi

    mkdir -p "$CONFIG_DIR"
}

install_packages() {
    local packages=("$@")
    if [ "${#packages[@]}" -eq 0 ]; then
        return
    fi
    info "Installing packages: ${packages[*]}"
    paru -S --needed "${packages[@]}"
}

backup_existing_path() {
    local path="$1"
    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"

    if [ -e "$path" ] || [ -L "$path" ]; then
        local backup="${path}.backup_${timestamp}"
        warn "Moving existing $path -> $backup"
        mv "$path" "$backup"
    fi
}

link_path() {
    local src="$1"
    local dest="$2"
    local label="$3"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local src_real dest_real
        src_real="$(readlink -f "$src")"
        dest_real="$(readlink -f "$dest" 2>/dev/null || true)"

        if [ "$src_real" = "$dest_real" ]; then
            success "Linked $label"
            return
        fi

        backup_existing_path "$dest"
    fi

    ln -s "$src" "$dest"
    success "Linked $label"
}

link_system_path() {
    local src="$1"
    local dest="$2"
    local label="$3"

    sudo mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local src_real dest_real
        src_real="$(readlink -f "$src")"
        dest_real="$(readlink -f "$dest" 2>/dev/null || true)"

        if [ "$src_real" = "$dest_real" ]; then
            success "Linked $label"
            return
        fi

        local timestamp backup
        timestamp="$(date +%Y%m%d_%H%M%S)"
        backup="${dest}.backup_${timestamp}"
        warn "Moving existing $dest -> $backup"
        sudo mv "$dest" "$backup"
    fi

    sudo ln -s "$src" "$dest"
    success "Linked $label"
}

copy_config_dir() {
    local src_rel="$1"
    local dest_rel="$2"
    local src="$DOTFILES_DIR/.config/$src_rel"
    local dest="$CONFIG_DIR/$dest_rel"

    if [ ! -d "$src" ]; then
        warn "Missing source directory: $src"
        return
    fi

    link_path "$src" "$dest" "$src_rel -> ~/.config/$dest_rel"
}

copy_config_file() {
    local src_rel="$1"
    local dest_rel="$2"
    local src="$DOTFILES_DIR/.config/$src_rel"
    local dest="$CONFIG_DIR/$dest_rel"

    if [ ! -f "$src" ]; then
        warn "Missing source file: $src"
        return
    fi

    link_path "$src" "$dest" "$src_rel -> ~/.config/$dest_rel"
}

copy_home_file() {
    local src_rel="$1"
    local dest_rel="$2"
    local src="$DOTFILES_DIR/$src_rel"
    local dest="$HOME/$dest_rel"

    if [ ! -f "$src" ]; then
        warn "Missing source file: $src"
        return
    fi

    link_path "$src" "$dest" "$src_rel -> ~/$dest_rel"
}

copy_home_dir() {
    local src_rel="$1"
    local dest_rel="$2"
    local src="$DOTFILES_DIR/$src_rel"
    local dest="$HOME/$dest_rel"

    if [ ! -d "$src" ]; then
        warn "Missing source directory: $src"
        return
    fi

    link_path "$src" "$dest" "$src_rel -> ~/$dest_rel"
}

apply_default_matugen() {
    local wallpaper="$DOTFILES_DIR/wallpapers/pywallpaper.jpg"
    local matugen_config="$CONFIG_DIR/matugen/config.toml"

    if [ ! -f "$matugen_config" ]; then
        matugen_config="$DOTFILES_DIR/.config/matugen/config.toml"
    fi

    if ! command -v matugen >/dev/null 2>&1; then
        warn "'matugen' command not found, skipping initial theme setup."
        return
    fi

    if [ ! -f "$wallpaper" ]; then
        warn "Wallpaper not found at $wallpaper, skipping matugen theme setup."
        return
    fi

    if [ ! -f "$matugen_config" ]; then
        warn "Matugen config not found, skipping theme setup."
        return
    fi

    mkdir -p \
        "$CONFIG_DIR/Kvantum/Matugen" \
        "$CONFIG_DIR/qt5ct/colors" \
        "$CONFIG_DIR/qt6ct/colors" \
        "$HOME/.local/share/color-schemes" \
        "$CONFIG_DIR/color-schemes" \
        "$HOME/.local/share/fcitx5/themes/Matugen" \
        "$CONFIG_DIR/fcitx5/conf"

    info "Applying default matugen theme."
    if ! matugen image "$wallpaper" \
        --config "$matugen_config" \
        --mode dark \
        --type scheme-vibrant \
        --base16-backend wal \
        --continue-on-error; then
        warn "Matugen finished with warnings or post-hook errors; continuing."
    fi

    if [ -x "$CONFIG_DIR/matugen/post-hook-scripts/qt-themes-setup.sh" ]; then
        "$CONFIG_DIR/matugen/post-hook-scripts/qt-themes-setup.sh" || true
    fi

    if [ -x "$CONFIG_DIR/matugen/post-hook-scripts/fcitx5-theme-setup.sh" ]; then
        "$CONFIG_DIR/matugen/post-hook-scripts/fcitx5-theme-setup.sh" || true
    fi
}
