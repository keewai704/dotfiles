#!/bin/bash
WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
ASSETS="$WAYBAR_DIR/assets"
THEMES="$WAYBAR_DIR/themes"

restart_waybar() {
    pkill -x waybar 2>/dev/null || true
    if command -v hyprctl >/dev/null 2>&1 && hyprctl monitors >/dev/null 2>&1; then
        hyprctl dispatch exec waybar >/dev/null
    else
        nohup waybar >/tmp/waybar.log 2>&1 &
    fi
}

menu() {
    find "${ASSETS}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}
main() {
    command -v wofi >/dev/null 2>&1 || {
        notify-send "Waybar" "wofi is not installed" 2>/dev/null || true
        exit 127
    }

    choice=$(menu | wofi -c "$HOME/.config/wofi/waybar" -s "$HOME/.config/wofi/style-waybar.css" --show dmenu --prompt "  Select Waybar (Scroll with Arrows)" -n) || exit 0
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    echo "$selected_wallpaper"
    if [[ "$selected_wallpaper" == "$ASSETS/experimental.png" ]]; then
        cp "$THEMES/experimental/style-experimental.css" "$STYLECSS"
        cp "$THEMES/experimental/config-experimental" "$CONFIG"
        restart_waybar
    elif [[ "$selected_wallpaper" == "$ASSETS/main.png" ]]; then
        cp "$THEMES/default/style-default.css" "$STYLECSS"
        cp "$THEMES/default/config-default" "$CONFIG"
        restart_waybar
    elif [[ "$selected_wallpaper" == "$ASSETS/line.png" ]]; then
        cp "$THEMES/line/style-line.css" "$STYLECSS"
        cp "$THEMES/line/config-line" "$CONFIG"
        restart_waybar
    elif [[ "$selected_wallpaper" == "$ASSETS/zen.png" ]]; then
        cp "$THEMES/zen/style-zen.css" "$STYLECSS"
        cp "$THEMES/zen/config-zen" "$CONFIG"
        restart_waybar
    fi

}
main
