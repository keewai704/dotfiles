#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Hyprlock Installer"
ensure_prereqs

install_packages hyprlock matugen
copy_config_dir "matugen" "matugen"
copy_config_file "hypr/colors.conf" "hypr/colors.conf"
copy_config_file "hypr/hyprlock.conf" "hypr/hyprlock.conf"
copy_config_file "hypr/hypridle.conf" "hypr/hypridle.conf"
apply_default_matugen

success "Hyprlock component installed."
