#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Wofi Installer"
ensure_prereqs

install_packages wofi matugen
copy_config_dir "matugen" "matugen"
copy_config_dir "wofi" "wofi"
apply_default_matugen

success "Wofi component installed."
