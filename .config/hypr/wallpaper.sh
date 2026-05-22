#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/wallpapers/walls}"
MATUGEN_CONFIG="${MATUGEN_CONFIG:-$HOME/.config/matugen/config.toml}"

menu() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
        | sort \
        | awk '{print "img:"$0}'
}

set_wallpaper() {
    local wallpaper="$1"

    if command -v swww >/dev/null 2>&1 && command -v swww-daemon >/dev/null 2>&1; then
        if ! swww query >/dev/null 2>&1; then
            swww-daemon >/dev/null 2>&1 &
            sleep 0.2
        fi
        swww img "$wallpaper" --resize crop --transition-type any --transition-fps 60 --transition-duration .5
    elif command -v awww >/dev/null 2>&1 && command -v awww-daemon >/dev/null 2>&1; then
        if ! awww query >/dev/null 2>&1; then
            awww-daemon >/dev/null 2>&1 &
            sleep 0.2
        fi
        awww img "$wallpaper" --resize crop --transition-type any --transition-fps 60 --transition-duration .5
    else
        notify-send "Wallpaper" "Install swww or awww to apply wallpapers." 2>/dev/null || true
        return 1
    fi
}

generate_theme() {
    local wallpaper="$1"

    if ! command -v matugen >/dev/null 2>&1; then
        notify-send "Matugen" "matugen is not installed; colors were not regenerated." 2>/dev/null || true
        return 1
    fi

    mkdir -p \
        "$HOME/.config/Kvantum/Matugen" \
        "$HOME/.config/qt5ct/colors" \
        "$HOME/.config/qt6ct/colors" \
        "$HOME/.local/share/color-schemes" \
        "$HOME/.config/color-schemes" \
        "$HOME/.local/share/fcitx5/themes/Matugen" \
        "$HOME/.config/fcitx5/conf"

    matugen image "$wallpaper" \
        --config "$MATUGEN_CONFIG" \
        --mode dark \
        --type scheme-vibrant \
        --base16-backend wal \
        --continue-on-error
}

reload_desktop_bits() {
    if command -v swayosd-server >/dev/null 2>&1; then
        pkill swayosd-server 2>/dev/null || true
        swayosd-server -s "$HOME/.config/swayosd/style.css" >/dev/null 2>&1 &
    fi

    swaync-client --reload-css 2>/dev/null || true
    pkill -SIGUSR2 waybar 2>/dev/null || true
    pkill -USR2 cava 2>/dev/null || true
}

main() {
    local choice selected_wallpaper
    choice="$(menu | wofi -c "$HOME/.config/wofi/wallpaper" -s "$HOME/.config/wofi/style-wallpaper.css" --show dmenu --prompt "Select Wallpaper:" -n)" || exit 0
    selected_wallpaper="${choice#img:}"

    if [[ -z "$selected_wallpaper" || ! -f "$selected_wallpaper" ]]; then
        exit 0
    fi

    set_wallpaper "$selected_wallpaper"
    generate_theme "$selected_wallpaper"
    reload_desktop_bits

    mkdir -p "$HOME/wallpapers"
    cp -f "$selected_wallpaper" "$HOME/wallpapers/pywallpaper.jpg"
}

main
