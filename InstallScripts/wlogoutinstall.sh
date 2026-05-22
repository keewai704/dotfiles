#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Wlogout Installer"
ensure_prereqs

install_packages wlogout matugen
copy_config_dir "matugen" "matugen"
copy_config_dir "wlogout" "wlogout"
apply_default_matugen

success "Wlogout component installed."
