#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

notify_user() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    else
        printf '%s\n' "$*" >&2
    fi
}

if command -v nmtui >/dev/null 2>&1; then
    exec "$SCRIPT_DIR/run-in-terminal.sh" nmtui
fi

if command -v nm-connection-editor >/dev/null 2>&1; then
    exec nm-connection-editor
fi

notify_user "Waybar" "NetworkManager tools are not installed."
exit 127
