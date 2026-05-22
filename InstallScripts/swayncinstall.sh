#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Swaync Installer"
ensure_prereqs

install_packages swaync gvfs libnotify matugen
copy_config_dir "matugen" "matugen"
copy_config_dir "swaync" "swaync"
apply_default_matugen

success "Swaync component installed."
