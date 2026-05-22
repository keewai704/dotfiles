#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "GTK Themes Installer"
ensure_prereqs

install_packages nwg-look qogir-icon-theme materia-gtk-theme adw-gtk-theme bibata-cursor-theme-bin matugen \
    kvantum kvantum-qt5 qt5ct qt6ct qt5-wayland qt6-wayland
copy_config_dir "matugen" "matugen"
copy_config_dir "gtk-3.0" "gtk-3.0"
copy_config_dir "gtk-4.0" "gtk-4.0"
copy_home_file ".gtkrc-2.0" ".gtkrc-2.0"
apply_default_matugen

info "GTK is set to dark mode; Qt uses qt6ct/qt5ct with the Matugen Kvantum theme."
success "GTK theme dependencies installed."
