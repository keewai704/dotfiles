#!/usr/bin/env bash
set -euo pipefail

mkdir -p \
    "$HOME/.config/Kvantum" \
    "$HOME/.config/qt5ct/colors" \
    "$HOME/.config/qt6ct/colors" \
    "$HOME/.local/share/color-schemes" \
    "$HOME/.config/color-schemes"

cat > "$HOME/.config/Kvantum/kvantum.kvconfig" <<'EOF'
[General]
theme=Matugen
EOF

write_qtct_config() {
    local target="$1"
    local colors="$2"
    local font="${MATUGEN_QT_FONT:-HackGen35 Console NF,10,-1,5,50,0,0,0,0,0}"

    mkdir -p "$(dirname "$target")"
    cat > "$target" <<EOF
[Appearance]
color_scheme_path=$colors
custom_palette=true
icon_theme=Adwaita
standard_dialogs=default
style=kvantum

[Fonts]
fixed="$font"
general="$font"

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
keyboard_scheme=2
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3
EOF
}

write_qtct_config "$HOME/.config/qt5ct/qt5ct.conf" "$HOME/.config/qt5ct/colors/Matugen.conf"
write_qtct_config "$HOME/.config/qt6ct/qt6ct.conf" "$HOME/.config/qt6ct/colors/Matugen.conf"
