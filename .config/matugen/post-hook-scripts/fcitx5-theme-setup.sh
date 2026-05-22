#!/usr/bin/env bash
set -euo pipefail

theme_dir="$HOME/.local/share/fcitx5/themes/Matugen"
classicui_conf="$HOME/.config/fcitx5/conf/classicui.conf"
default_dark="/usr/share/fcitx5/themes/default-dark"

mkdir -p "$theme_dir" "$(dirname "$classicui_conf")"

for asset in arrow.png next.png prev.png radio.png; do
    if [[ -f "$default_dark/$asset" ]]; then
        cp -f "$default_dark/$asset" "$theme_dir/$asset"
    fi
done

cat > "$classicui_conf" <<'EOF'
# Vertical Candidate List
Vertical Candidate List=True
# Use mouse wheel to go to prev or next page
WheelForPaging=True
# Font
Font="HackGen35 Console NF 10"
# Menu Font
MenuFont="HackGen35 Console NF 10"
# Tray Font
TrayFont="HackGen35 Console NF 10"
# Theme
Theme=Matugen
# Dark Theme
Dark Theme=Matugen
# Follow system light/dark color scheme
UseDarkTheme=True
# Follow system accent color if it is supported by theme and desktop
UseAccentColor=False
# Use Per Screen DPI on X11
PerScreenDPI=True
EOF

fcitx5-remote -r >/dev/null 2>&1 || true
