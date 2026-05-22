#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

notify_user() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    else
        printf '%s\n' "$*" >&2
    fi
}

if [ -z "${WAYBAR_UPDATE_IN_TERMINAL:-}" ]; then
    exec "$SCRIPT_DIR/run-in-terminal.sh" env WAYBAR_UPDATE_IN_TERMINAL=1 "$0"
fi

if command -v yay >/dev/null 2>&1; then
    updater=(yay -Syu)
elif command -v paru >/dev/null 2>&1; then
    updater=(paru -Syu)
elif command -v pacman >/dev/null 2>&1 && command -v sudo >/dev/null 2>&1; then
    updater=(sudo pacman -Syu)
else
    notify_user "Waybar" "No supported package updater was found."
    printf 'No supported package updater was found.\n'
    printf '\nPress enter to exit'
    read -r _
    exit 127
fi

"${updater[@]}"
status=$?

pkill -SIGRTMIN+8 waybar 2>/dev/null || true
printf '\nDone - Press enter to exit'
read -r _
exit "$status"
