#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "SDDM Login Manager Installer"
ensure_prereqs

THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
THEME_CONFIG="$THEME_DIR/Themes/dotfiles.conf"
THEME_METADATA="$THEME_DIR/metadata.desktop"
THEME_WALLPAPER="$THEME_DIR/Backgrounds/dotfiles.jpg"

install_packages \
    sddm \
    sddm-astronaut-theme \
    qt6-5compat \
    qt6-declarative \
    qt6-multimedia-ffmpeg \
    qt6-svg \
    qt6-virtualkeyboard \
    bibata-cursor-theme-bin

section "Configuring SDDM Theme"

sudo install -Dm644 \
    "$DOTFILES_DIR/sddm/etc/sddm.conf.d/10-dotfiles-theme.conf" \
    "/etc/sddm.conf.d/10-dotfiles-theme.conf"
sudo install -Dm644 \
    "$DOTFILES_DIR/sddm/etc/sddm.conf.d/20-dotfiles-virtual-keyboard.conf" \
    "/etc/sddm.conf.d/20-dotfiles-virtual-keyboard.conf"
success "Installed SDDM config snippets."

if [ -d "$THEME_DIR" ]; then
    sudo install -Dm644 "$DOTFILES_DIR/sddm/themes/dotfiles.conf" "$THEME_CONFIG"

    if [ -f "$DOTFILES_DIR/wallpapers/pywallpaper.jpg" ]; then
        sudo install -Dm644 "$DOTFILES_DIR/wallpapers/pywallpaper.jpg" "$THEME_WALLPAPER"
    else
        warn "Default wallpaper not found; the SDDM theme background may be blank."
    fi

    if [ -f "$THEME_METADATA" ]; then
        if [ ! -f "$THEME_METADATA.dotfiles.bak" ]; then
            sudo cp "$THEME_METADATA" "$THEME_METADATA.dotfiles.bak"
        fi

        sudo sed -i -E 's|^ConfigFile=.*|ConfigFile=Themes/dotfiles.conf|' "$THEME_METADATA"
        if ! grep -q '^ConfigFile=' "$THEME_METADATA"; then
            echo "ConfigFile=Themes/dotfiles.conf" | sudo tee -a "$THEME_METADATA" >/dev/null
        fi
    else
        warn "Theme metadata not found; SDDM may not pick up the custom variant."
    fi

    success "Applied the Dotfiles SDDM theme variant."
else
    warn "Theme directory not found at $THEME_DIR."
fi

section "Enable Login Manager"

enable_choice="y"
display_manager_link="/etc/systemd/system/display-manager.service"
current_target="$(readlink -f "$display_manager_link" 2>/dev/null || true)"

if [ -n "$current_target" ] && [[ "$current_target" != */sddm.service ]]; then
    warn "Current display manager points to $(basename "$current_target")."
    read -rp "Replace it with SDDM for next boot? (y/N): " enable_choice
    enable_choice="${enable_choice:-n}"
else
    read -rp "Enable SDDM for next boot? (Y/n): " enable_choice
    enable_choice="${enable_choice:-y}"
fi

if [[ "$enable_choice" =~ ^[Yy]$ ]]; then
    sudo systemctl enable --force sddm.service
    success "SDDM enabled for next boot."
else
    warn "Skipped enabling SDDM. Run 'sudo systemctl enable sddm.service' when ready."
fi

info "Preview without logging out: sddm-greeter-qt6 --test-mode --theme $THEME_DIR"
success "SDDM login manager component installed."
