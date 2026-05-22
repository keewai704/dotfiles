#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Tailscale Exit Node Installer"

SYSCTL_SRC="$DOTFILES_DIR/tailscale/etc/sysctl.d/99-tailscale.conf"
SYSCTL_DEST="/etc/sysctl.d/99-tailscale.conf"
DISPATCHER_SRC="$DOTFILES_DIR/tailscale/etc/NetworkManager/dispatcher.d/50-tailscale-udp-gro"
DISPATCHER_DEST="/etc/NetworkManager/dispatcher.d/50-tailscale-udp-gro"

missing=false
for source_file in "$SYSCTL_SRC" "$DISPATCHER_SRC"; do
    if [ ! -f "$source_file" ]; then
        error "Missing source file: $source_file"
        missing=true
    fi
done

if $missing; then
    exit 1
fi

install_pkg_choice="${TAILSCALE_INSTALL_PACKAGES:-y}"
if [ -t 0 ]; then
    read -rp "Install/upgrade tailscale and ethtool with paru? (Y/n): " install_pkg_choice
    install_pkg_choice="${install_pkg_choice:-y}"
fi

if [[ "$install_pkg_choice" =~ ^[Yy]$ ]]; then
    ensure_prereqs
    install_packages tailscale ethtool
else
    warn "Skipped package installation."
fi

section "Kernel Forwarding"
sudo install -Dm644 "$SYSCTL_SRC" "$SYSCTL_DEST"
sudo sysctl -p "$SYSCTL_DEST"
success "Installed and applied $SYSCTL_DEST."

section "UDP GRO Forwarding"
sudo install -Dm755 "$DISPATCHER_SRC" "$DISPATCHER_DEST"

if systemctl list-unit-files NetworkManager-dispatcher.service >/dev/null 2>&1; then
    sudo systemctl enable --now NetworkManager-dispatcher.service >/dev/null 2>&1 || \
        warn "Could not enable NetworkManager-dispatcher.service."
fi

primary_netdev="$(
    ip -o route get 8.8.8.8 2>/dev/null |
        awk '{ for (i = 1; i <= NF; i++) if ($i == "dev") { print $(i + 1); exit } }'
)"

if [ -n "$primary_netdev" ]; then
    sudo "$DISPATCHER_DEST" "$primary_netdev" up
    success "Applied UDP GRO forwarding tuning to $primary_netdev."
else
    warn "Could not determine the default network interface; dispatcher will apply it on the next NetworkManager event."
fi

section "Tailscale Service"
if systemctl list-unit-files tailscaled.service >/dev/null 2>&1; then
    sudo systemctl enable --now tailscaled.service
    success "tailscaled.service is enabled and running."
else
    warn "tailscaled.service was not found. Install Tailscale before enabling this node."
fi

configure_choice="${TAILSCALE_CONFIGURE_NODE:-y}"
if [ -t 0 ]; then
    read -rp "Enable Tailscale SSH and advertise this machine as an exit node now? (Y/n): " configure_choice
    configure_choice="${configure_choice:-y}"
fi

if [[ "$configure_choice" =~ ^[Yy]$ ]]; then
    if command -v tailscale >/dev/null 2>&1; then
        if sudo tailscale set --ssh=true --advertise-exit-node=true; then
            success "Tailscale SSH and exit-node advertisement enabled."
        else
            warn "Could not update current Tailscale preferences."
            info "If this device is not logged in yet, run: sudo tailscale up --ssh --advertise-exit-node"
        fi
    else
        warn "'tailscale' command not found; skipped node configuration."
    fi
else
    warn "Skipped Tailscale SSH and exit-node advertisement."
fi

section "Verification"
sysctl net.ipv4.ip_forward net.ipv6.conf.all.forwarding

if [ -n "$primary_netdev" ] && command -v ethtool >/dev/null 2>&1; then
    ethtool -k "$primary_netdev" | grep -E 'rx-gro-list:|rx-udp-gro-forwarding:' || true
fi

info "Approve 'Use as exit node' in the Tailscale admin console if it is not auto-approved."
success "Tailscale exit node system config applied."
