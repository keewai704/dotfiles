#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Wallpaper + Matugen Installer"
ensure_prereqs

install_packages swww matugen fd wofi kvantum kvantum-qt5 qt5ct qt6ct qt5-wayland qt6-wayland
copy_config_dir "matugen" "matugen"
copy_config_file "hypr/wallpaper.sh" "hypr/wallpaper.sh"

# Required by wallpaper.sh launcher styles and menu config.
copy_config_file "wofi/config" "wofi/config"
copy_config_file "wofi/style-wallpaper.css" "wofi/style-wallpaper.css"

read -rp "Install optional Pywalfox integration package? (Y/n): " pywalfox_choice
if [[ "${pywalfox_choice:-y}" =~ ^[Yy]$ ]]; then
	install_packages python-pywalfox
fi

apply_default_matugen
success "Wallpaper solution installed."
