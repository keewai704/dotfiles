#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Udev Rules Installer"

if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

RULE_SRC="$DOTFILES_DIR/udev/rules.d/70-everglide-su75-pro.rules"
RULE_DEST="/etc/udev/rules.d/70-everglide-su75-pro.rules"

if [ ! -f "$RULE_SRC" ]; then
    error "Missing udev rule: $RULE_SRC"
    exit 1
fi

sudo install -Dm644 "$RULE_SRC" "$RULE_DEST"
success "Installed Everglide SU75 Pro udev rule."

sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=usb --attr-match=idVendor=1ca6 --attr-match=idProduct=3002
sudo udevadm trigger --subsystem-match=hidraw
success "Reloaded udev rules."

info "Restart your browser before opening the Everglide SU75 Pro web driver."
