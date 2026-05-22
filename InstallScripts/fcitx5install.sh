#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Fcitx5 Input Method Installer"
ensure_prereqs

install_packages fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-hazkey-bin matugen
copy_config_dir "matugen" "matugen"
copy_config_dir "fcitx5" "fcitx5"
copy_config_file "gtk-3.0/settings.ini" "gtk-3.0/settings.ini"
copy_config_file "gtk-4.0/settings.ini" "gtk-4.0/settings.ini"
copy_home_file ".gtkrc-2.0" ".gtkrc-2.0"
apply_default_matugen

hypr_conf="$CONFIG_DIR/hypr/hyprland.conf"
if [ -f "$hypr_conf" ]; then
    info "Adding Fcitx5 session lines to ~/.config/hypr/hyprland.conf"

    if ! grep -q "Fcitx5 input method" "$hypr_conf"; then
        printf '\n# Fcitx5 input method\n' >> "$hypr_conf"
    fi

    ensure_hypr_line() {
        local line="$1"
        grep -qxF "$line" "$hypr_conf" || printf '%s\n' "$line" >> "$hypr_conf"
    }

    ensure_hypr_line "env = XMODIFIERS,@im=fcitx"
    ensure_hypr_line "env = QT_IM_MODULE,fcitx"
    ensure_hypr_line "env = QT_IM_MODULES,wayland;fcitx;ibus"
    ensure_hypr_line "env = SDL_IM_MODULE,fcitx"
    ensure_hypr_line "env = GLFW_IM_MODULE,ibus"
    ensure_hypr_line "exec-once = fcitx5 -d"

    success "Fcitx5 Hyprland session lines are present."
else
    warn "Hyprland config not found at $hypr_conf; copy the Fcitx5 block from the repo config when ready."
fi

info "Open fcitx5-configtool after login if you want to change engines or shortcuts."
success "Fcitx5 input method component installed."
