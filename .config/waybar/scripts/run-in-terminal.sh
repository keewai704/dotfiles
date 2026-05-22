#!/usr/bin/env bash

notify_user() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    else
        printf '%s\n' "$*" >&2
    fi
}

if [ "$#" -eq 0 ]; then
    notify_user "Waybar" "No command was provided for the terminal."
    exit 64
fi

if [ -n "${TERMINAL:-}" ] && command -v "$TERMINAL" >/dev/null 2>&1; then
    case "$(basename "$TERMINAL")" in
        alacritty|ghostty|konsole|xterm)
            exec "$TERMINAL" -e "$@"
            ;;
        gnome-terminal|ptyxis)
            exec "$TERMINAL" -- "$@"
            ;;
        wezterm)
            exec "$TERMINAL" start -- "$@"
            ;;
        *)
            exec "$TERMINAL" "$@"
            ;;
    esac
fi

for terminal in kitty foot alacritty wezterm ghostty konsole gnome-terminal ptyxis xterm; do
    if command -v "$terminal" >/dev/null 2>&1; then
        case "$terminal" in
            alacritty|ghostty|konsole|xterm)
                exec "$terminal" -e "$@"
                ;;
            gnome-terminal|ptyxis)
                exec "$terminal" -- "$@"
                ;;
            wezterm)
                exec "$terminal" start -- "$@"
                ;;
            *)
                exec "$terminal" "$@"
                ;;
        esac
    fi
done

notify_user "Waybar" "No supported terminal emulator was found."
exit 127
