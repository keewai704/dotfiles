#!/usr/bin/env bash
set -euo pipefail

if ! command -v gsettings >/dev/null 2>&1; then
    exit 0
fi

theme=""
for candidate in Materia-dark adw-gtk3-dark Adwaita-dark; do
    if [[ -d "$HOME/.themes/$candidate" \
        || -d "$HOME/.local/share/themes/$candidate" \
        || -d "/usr/share/themes/$candidate" ]]; then
        theme="$candidate"
        break
    fi
done

gsettings set org.gnome.desktop.interface color-scheme prefer-dark

if [[ -n "$theme" ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme "" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme "$theme"
fi
