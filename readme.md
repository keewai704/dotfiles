# Dotfiles

Personal Arch Linux dotfiles for a Hyprland Wayland desktop.

This repository contains configuration files, install scripts, wallpaper assets, and a few system snippets for rebuilding my desktop environment. The setup is centered on Hyprland, Matugen-generated colors, Waybar, Wofi, SwayNC, Neovim, Starship, and SDDM.

## What Is Included

- Hyprland session config, keybinds, window rules, idle/lock config, and wallpaper tooling
- Matugen templates for Waybar, Wofi, SwayNC, Wlogout, GTK, Qt/Kvantum, Kitty, Cava, Fcitx5, Starship, Neovim, and Pywal-compatible cache files
- Waybar themes, scripts, and selectable layouts
- Wofi launcher styles for app launching, wallpaper selection, and Waybar theme selection
- SwayNC notification center styling and reload helper
- Neovim Lua config with plugin definitions and keybind documentation
- Starship prompt config
- GTK, Qt, cursor, font, and Fcitx5 input method defaults
- Wlogout power menu assets and styling
- SDDM theme configuration snippets
- Tailscale exit-node system config snippets
- Udev rule for the Everglide SU75 Pro keyboard
- Wallpaper collection used by the theme scripts

## Target System

These dotfiles are written for Arch Linux and assume `paru` is available for package installation. They are intended for a Hyprland Wayland session.

The scripts can install packages and copy config files, but they are personal setup scripts. Read them before running on a machine you care about, especially the full installer and anything that writes under `/etc`.

## Quick Start

Clone the repository:

```bash
git clone https://github.com/keewai704/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the menu installer:

```bash
cd InstallScripts
./install.sh
```

The menu currently exposes:

- Full install
- Waybar
- Wofi
- SwayNC
- Hyprlock
- Neovim
- Wlogout
- Wallpaper and Matugen setup
- Starship
- SDDM login manager
- Fcitx5 input method
- Udev rules
- Tailscale exit node
- GTK themes

## Manual Install

You can also copy pieces by hand. Examples:

```bash
cp -a .config/hypr ~/.config/
cp -a .config/waybar ~/.config/
cp -a .config/wofi ~/.config/
cp -a .config/matugen ~/.config/
cp -a .config/nvim ~/.config/
cp -a wallpapers ~/
cp -a .bashrc ~/
```

After copying Matugen config, generate the initial theme:

```bash
matugen image ~/dotfiles/wallpapers/pywallpaper.jpg \
  --config ~/.config/matugen/config.toml \
  --mode dark \
  --type scheme-vibrant \
  --base16-backend wal \
  --continue-on-error
```

## Theming

Matugen is the main source of colors. The wallpaper script at `.config/hypr/wallpaper.sh` selects a wallpaper, runs Matugen, and updates generated color files.

Generated outputs include:

- `~/.config/hypr/colors.conf`
- `~/.config/waybar/colors.css`
- `~/.config/wofi/colors.css`
- `~/.config/swaync/colors.css`
- `~/.config/wlogout/colors.css`
- `~/.config/gtk-3.0/colors.css`
- `~/.config/gtk-4.0/colors.css`
- `~/.config/starship.toml`
- `~/.cache/wal/colors-waybar.css`
- `~/.cache/wal/colors.sh`
- `~/.cache/wal/colors.json`
- `~/.cache/wal/colors-wal.vim`

Some configs still read from `~/.cache/wal` for compatibility with Pywal-style tools and plugins.

## Hyprland Defaults

Primary applications:

- Terminal: `foot`
- File manager: `thunar`
- App launcher: `wofi --show drun -n`
- Browser: `zen-browser`
- Editor: `nvim`

Session helpers started by Hyprland include Waybar, SwayNC, Pyprland, Hypridle, SwayOSD, Fcitx5, and the wallpaper daemon when available.

## Keybinds

Common Hyprland binds:

- `Super + T`: open terminal
- `Super + R` or `Super + Space`: open Wofi
- `Super + E`: open Thunar
- `Super + W`: open browser
- `Super + C`: open Neovim
- `Super + Q`: close focused window
- `Super + L`: lock session
- `Super + Shift + E`: open Wlogout
- `Super + Shift + R`: reload Hyprland
- `Super + Shift + M`: exit Hyprland
- `Super + F`: fullscreen
- `Super + V`: toggle floating
- `Super + H/J/K/L` or arrows: move focus
- `Super + Shift + H/J/K/L` or arrows: move window
- `Super + Ctrl + H/J/K/L` or arrows: resize window
- `Super + 1-0`: switch workspaces
- `Super + Shift + 1-0`: move window to workspace
- `Super + Grave`: toggle scratch workspace
- `Super + G`: toggle music scratchpad
- `Super + N`: toggle notification center
- `Super + X`: color picker
- `Alt + Tab`: cycle windows
- `Alt + W`: wallpaper selector
- `Alt + A`: reload/toggle Waybar helper
- `Alt + B`: Waybar theme selector
- `Alt + R`: reload SwayNC
- `Print`: region screenshot
- `Shift + Print`: window screenshot
- `Ctrl + Print`: output screenshot
- `Alt + PageUp/PageDown`: brightness up/down

See `.config/hypr/hyprland.conf` for the complete list.

## Component Notes

### Waybar

Waybar uses Matugen-generated colors and includes helper scripts for network actions, color picking, update counts, theme selection, and refresh behavior. Theme variants live under `.config/waybar/themes`.

### Wofi

Wofi has separate styles for app launching, wallpaper selection, and Waybar theme selection. The wallpaper and Waybar selectors depend on files in `.config/wofi`.

### SwayNC

SwayNC is styled through `.config/swaync/style.css` and reloads through `.config/swaync/refresh.sh`.

### Neovim

Neovim is configured in Lua under `.config/nvim`. Keybind notes are in `.config/nvim/KEYBINDS.md`.

### SDDM

The SDDM installer writes config snippets under `/etc/sddm.conf.d`, installs a custom `sddm-astronaut-theme` variant, and can enable `sddm.service` for the next boot.

Preview command:

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme
```

### Fcitx5

Hyprland exports Fcitx5 environment variables and starts `fcitx5 -d`. The included profile keeps `keyboard-us` available and uses Hazkey for Japanese input.

### Tailscale Exit Node

The Tailscale installer can install `tailscale` and `ethtool`, enable forwarding, install NetworkManager dispatcher tuning for UDP GRO forwarding, enable `tailscaled`, and advertise the machine as an exit node.

## Repository Layout

```text
.config/          User application and desktop configs
InstallScripts/   Interactive and component install scripts
sddm/             SDDM system config and theme snippets
tailscale/        Exit-node sysctl and NetworkManager dispatcher files
udev/             Local udev rules
wallpapers/       Default wallpaper and wallpaper collection
```

## Maintenance

Use normal Git flow:

```bash
git status
git add -A
git commit -m "Update dotfiles"
git push
```

Avoid committing generated files from `~/.cache`, machine-specific monitor layouts, private keys, tokens, browser profiles, or local application state.
