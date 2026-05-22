#!/bin/bash
# =============================================================================
#  Dotfiles Installer — by EF
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}${BOLD}[•]${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}[✓]${RESET} $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[!]${RESET} $*"; }
error()   { echo -e "${RED}${BOLD}[✗]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}\n"; }

# ── Banner ────────────────────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
cat << 'EOF'
  ____        _    __ _ _
 |  _ \  ___ | |_ / _(_) | ___  ___
 | | | |/ _ \| __| |_| | |/ _ \/ __|
 | |_| | (_) | |_|  _| | |  __/\__ \
 |____/ \___/ \__|_| |_|_|\___||___/

EOF
echo -e "${RESET}"

# ── Sanity checks ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR. Aborting."
    exit 1
fi

if ! command -v paru &>/dev/null; then
    error "'paru' AUR helper not found. Please install it first."
    exit 1
fi

# ── Shared helpers ────────────────────────────────────────────────────────────

backup_config() {
    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"

    local items=(
        "$HOME/.config:$HOME/.config_backup_${timestamp}"
        "$HOME/.icons:$HOME/.icons_backup_${timestamp}"
        "$HOME/wallpapers:$HOME/wallpapers_backup_${timestamp}"
    )

    local backed_up=false

    for item in "${items[@]}"; do
        local source_path="${item%%:*}"
        local backup_path="${item#*:}"

        if [ -e "$source_path" ]; then
            info "Backing up $(basename "$source_path") → $backup_path"
            mkdir -p "$backup_path"
            cp -a "$source_path/." "$backup_path/"
            success "Backed up $(basename "$source_path")"
            backed_up=true
        else
            warn "$(basename "$source_path") not found — skipping backup."
        fi
    done

    if $backed_up; then
        success "Backups created for .config, .icons, and wallpapers"
    else
        warn "No dotfiles were backed up."
    fi
}

backup_bashrc() {
    local backup_dir="${HOME}/.bashrc_backup_$(date +%Y%m%d_%H%M%S)"

    if [ ! -f "$HOME/.bashrc" ]; then
        warn "~/.bashrc not found — skipping backup."
        return
    fi

    info "Backing up .bashrc → $backup_dir"
    mkdir -p "$backup_dir"
    cp -a "$HOME/.bashrc" "$backup_dir/.bashrc"
    success "Backup created at $backup_dir/.bashrc"
}

apply_dotfiles() {
    section "Applying Dotfiles"
    info "Copying wallpapers..."
    cp -a "$DOTFILES_DIR/wallpapers" "$HOME/"

    info "Copying .icons..."
    cp -a "$DOTFILES_DIR/.icons" "$HOME/"

    info "Copying .config files..."
    cp -a "$DOTFILES_DIR/.config/." "$HOME/.config/"

    info "Copying .bashrc..."
    cp -a "$DOTFILES_DIR/.bashrc" "$HOME/"

    if [ -f "$DOTFILES_DIR/.gtkrc-2.0" ]; then
        info "Copying .gtkrc-2.0..."
        cp -a "$DOTFILES_DIR/.gtkrc-2.0" "$HOME/"
    fi

    fix_wofi_paths
    success "Dotfiles applied."
}

fix_wofi_paths() {
    local config_dir="$HOME/.config/wofi"

    if [ ! -d "$config_dir" ]; then
        warn "Wofi config directory not found at $config_dir — skipping path fix."
        return
    fi

    info "Fixing wofi CSS paths for user: $USER"
    find "$config_dir" -maxdepth 1 -type f -name "*.css" -print0 \
    | while IFS= read -r -d '' file; do
        sed -i -E \
            "s|/home/[^/]+/\.cache/wal/colors-waybar\.css|../../.cache/wal/colors-waybar.css|g" \
            "$file"
        success "Updated: $file"
    done
}

setup_wallpaper() {
    section "Setting Wallpaper (matugen)"
    local wallpaper="$DOTFILES_DIR/wallpapers/pywallpaper.jpg"
    local matugen_config="$DOTFILES_DIR/.config/matugen/config.toml"

    if ! command -v matugen >/dev/null 2>&1; then
        warn "'matugen' command not found, skipping theme setup."
        return
    fi

    if [ ! -f "$wallpaper" ]; then
        warn "Wallpaper not found at $wallpaper — skipping."
        return
    fi

    if [ ! -f "$matugen_config" ]; then
        warn "Matugen config not found at $matugen_config — skipping."
        return
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
        --config "$matugen_config" \
        --mode dark \
        --type scheme-vibrant \
        --base16-backend wal \
        --continue-on-error

    if [ -x "$HOME/.config/matugen/post-hook-scripts/qt-themes-setup.sh" ]; then
        "$HOME/.config/matugen/post-hook-scripts/qt-themes-setup.sh" || true
    fi

    if [ -x "$HOME/.config/matugen/post-hook-scripts/fcitx5-theme-setup.sh" ]; then
        "$HOME/.config/matugen/post-hook-scripts/fcitx5-theme-setup.sh" || true
    fi
    success "Wallpaper theme generated."
}

setup_dynamic_cursors() {
    section "Dynamic Cursors"
    if hyprpm add https://github.com/virtcode/hypr-dynamic-cursors && \
       hyprpm enable dynamic-cursors; then
        success "Dynamic cursors enabled."
    else
        warn "Dynamic cursors setup failed — you may need to run this manually."
    fi
}

setup_mirrors() {
    section "Updating Pacman Mirrorlist (JAIST)"

    local mirrorlist="/etc/pacman.d/mirrorlist"
    local backup="${mirrorlist}.backup_$(date +%Y%m%d_%H%M%S)"

    if [ -f "$mirrorlist" ]; then
        sudo cp -a "$mirrorlist" "$backup" || warn "Could not back up existing mirrorlist."
    fi

    sudo tee "$mirrorlist" >/dev/null <<'EOF'
## Japan - JAIST
Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
EOF

    sudo pacman -Syy
    success "Mirrorlist updated to JAIST Japan mirror."
}

setup_bluetooth() {
    section "Bluetooth"
    paru -S --needed blueman bluez
    sudo systemctl enable --now bluetooth
    success "Bluetooth enabled."
}

setup_pipewire() {
    section "Pipewire & Audio"
    paru -S --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack \
        pavucontrol pulsemixer gnome-network-displays gst-plugins-bad
    systemctl --user enable --now pipewire.service
    systemctl --user enable --now pipewire-pulse.service
    success "Pipewire configured."
}

setup_uv_tools() {
    section "Python CLI Tools (uv)"

    if ! command -v uv >/dev/null 2>&1; then
        error "'uv' not found. Core package installation should install it first."
        exit 1
    fi

    mkdir -p "$HOME/.local/bin"
    uv tool install --force "yt-dlp[default,curl-cffi,secretstorage]"
    uv tool install --force pymobiledevice3
    success "uv tools installed: yt-dlp, pymobiledevice3"
}

setup_codex_desktop_linux() {
    section "Codex Desktop for Linux"

    local repo_url="https://github.com/ilysenko/codex-desktop-linux.git"
    local install_dir="$HOME/.local/src/codex-desktop-linux"

    if pacman -Q openai-codex-desktop >/dev/null 2>&1; then
        info "Removing existing openai-codex-desktop package..."
        sudo pacman -Rns --noconfirm openai-codex-desktop
    fi

    mkdir -p "$(dirname "$install_dir")"

    if [ -d "$install_dir/.git" ]; then
        info "Updating codex-desktop-linux checkout..."
        git -C "$install_dir" pull --ff-only
    else
        info "Cloning codex-desktop-linux..."
        git clone "$repo_url" "$install_dir"
    fi

    info "Building and installing Codex Desktop native package..."
    make -C "$install_dir" bootstrap-native
    success "Codex Desktop for Linux installed."
}

finish() {
    success "Installation complete! 🎉"
    notify-send \
        "Dotfiles Installed" \
        "Open Terminal with MOD+Q\nHello $USER — Thanks for using my Dotfiles!\n-EF" \
        2>/dev/null || true
}

# ── Core packages ─────────────────────────────────────────────────────────────
CORE_PACKAGES=(
    matugen swww waybar swaync kitty starship myfetch neovim python-pywalfox
    hypridle hyprpicker hyprshot hyprlock hyprmon pacman-contrib pyprland wlogout fd
    fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-hazkey-bin
    cava brightnessctl clock-rs-git ttf-hackgen nwg-look qogir-icon-theme
    materia-gtk-theme adw-gtk-theme bibata-cursor-theme-bin
    kvantum kvantum-qt5 qt5ct qt6ct qt5-wayland qt6-wayland
    thunar gvfs tumbler eza bottom
    discord yazi lazygit hyprdvd swayosd-git
    uv ffmpeg aria2 atomicparsley rtmpdump gogcli
    git make
)

# Explicit/manual installs found in /var/log/pacman.log that are still installed.
PACMAN_LOG_PACKAGES=(
    foot ddcutil zoxide fzf github-cli
    zen-browser-bin ungoogled-chromium-bin vivaldi vivaldi-ffmpeg-codecs
    vesktop-bin rofi rofi-rbw
    tailscale steam proton-cachyos millennium-bin
    reflector rsync
)

OPTIONAL_PACKAGES=(blueman bluez pipewire pipewire-pulse pipewire-alsa
    pipewire-jack pavucontrol pulsemixer gnome-network-displays gst-plugins-bad)

# ── Installation modes ────────────────────────────────────────────────────────

auto_install() {
    section "Automatic Installation"

    setup_mirrors

    info "Installing all packages..."
    paru -S --needed "${CORE_PACKAGES[@]}" "${PACMAN_LOG_PACKAGES[@]}"
    success "Packages installed."

    sudo systemctl enable --now avahi-daemon

    setup_bluetooth
    setup_pipewire
    setup_uv_tools
    setup_codex_desktop_linux
    setup_dynamic_cursors
    apply_dotfiles
    setup_wallpaper
    finish
}

manual_install() {
    section "Manual Installation"

    read -rp "Update mirrorlist to Japan JAIST mirror? (Y/n): " m
    [[ "${m:-y}" =~ ^[Yy]$ ]] && setup_mirrors

    section "Installing Core Packages"
    paru -S --needed "${CORE_PACKAGES[@]}" "${PACMAN_LOG_PACKAGES[@]}"
    success "Packages installed."

    setup_uv_tools

    read -rp "Install Codex Desktop for Linux from ilysenko/codex-desktop-linux? (Y/n): " x
    [[ "${x:-y}" =~ ^[Yy]$ ]] && setup_codex_desktop_linux

    read -rp "Install Bluetooth support? (Y/n): " b
    [[ "${b:-y}" =~ ^[Yy]$ ]] && setup_bluetooth

    read -rp "Configure Pipewire & Network Displays? (Y/n): " p
    [[ "${p:-y}" =~ ^[Yy]$ ]] && setup_pipewire

    read -rp "Enable Dynamic Cursors? (Y/n): " c
    [[ "${c:-y}" =~ ^[Yy]$ ]] && setup_dynamic_cursors

    apply_dotfiles
    setup_wallpaper
    finish
}

# ── Entry point ───────────────────────────────────────────────────────────────

section "Welcome"

read -rp "Installation mode — (A)utomatic or (M)anual? [A]: " install_choice
install_choice="${install_choice:-a}"

read -rp "Backup your current dotfiles before installing? (Y/n): " backup_choice
[[ "${backup_choice:-y}" =~ ^[Yy]$ ]] && backup_config && backup_bashrc

case "${install_choice,,}" in
    a) auto_install  ;;
    m) manual_install ;;
    *) error "Unknown option '$install_choice'. Exiting."; exit 1 ;;
esac
