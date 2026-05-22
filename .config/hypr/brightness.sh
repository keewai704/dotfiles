#!/usr/bin/env sh
set -eu

direction="${1:-up}"
step="${2:-5}"

case "$direction" in
    up|increase|+) sign="+" ;;
    down|decrease|-) sign="-" ;;
    *)
        echo "usage: $0 up|down [step]" >&2
        exit 2
        ;;
esac

case "$step" in
    ''|*[!0-9]*) step=5 ;;
esac

has_backlight() {
    command -v brightnessctl >/dev/null 2>&1 &&
        brightnessctl -c backlight --list 2>/dev/null | grep -q '^Device '
}

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
ddc_bus_cache="$cache_dir/brightness-ddc-bus"
ddc_lock="$cache_dir/brightness-ddc.lock"

detect_ddc_bus() {
    if [ -n "${BRIGHTNESS_DDC_BUS:-}" ]; then
        printf '%s\n' "$BRIGHTNESS_DDC_BUS"
        return 0
    fi

    if [ -r "$ddc_bus_cache" ]; then
        bus="$(sed -n '1p' "$ddc_bus_cache")"
        case "$bus" in
            *[!0-9]*|'') ;;
            *)
                printf '%s\n' "$bus"
                return 0
                ;;
        esac
    fi

    command -v ddcutil >/dev/null 2>&1 || return 1

    bus="$(
        ddcutil detect --brief 2>/dev/null |
            sed -n 's|.*I2C bus: */dev/i2c-\([0-9][0-9]*\).*|\1|p' |
            head -n 1
    )"

    [ -n "$bus" ] || return 1

    mkdir -p "$cache_dir"
    printf '%s\n' "$bus" >"$ddc_bus_cache"
    printf '%s\n' "$bus"
}

run_ddcutil() {
    mkdir -p "$cache_dir"

    if command -v flock >/dev/null 2>&1; then
        flock -n "$ddc_lock" ddcutil "$@"
        return
    fi

    ddcutil "$@"
}

set_ddc_brightness() {
    command -v ddcutil >/dev/null 2>&1 || return 1

    bus="$(detect_ddc_bus)" || return 1

    if ! run_ddcutil --bus "$bus" --noverify --skip-ddc-checks \
        --sleep-multiplier 0.5 setvcp 10 "$sign" "$step"; then
        rm -f "$ddc_bus_cache"
        return 1
    fi

    if command -v swayosd-client >/dev/null 2>&1; then
        swayosd-client --custom-message "Brightness ${sign}${step}" \
            --custom-icon display-brightness >/dev/null 2>&1 &
    fi

    return 0
}

if has_backlight && command -v swayosd-client >/dev/null 2>&1; then
    if [ "$sign" = "+" ]; then
        exec swayosd-client --brightness +"$step"
    fi

    exec swayosd-client --brightness -"$step"
fi

if has_backlight; then
    if [ "$sign" = "+" ]; then
        exec brightnessctl -c backlight set +"$step"%
    fi

    exec brightnessctl -c backlight set "$step"%-
fi

if command -v light >/dev/null 2>&1; then
    if [ "$sign" = "+" ]; then
        exec light -A "$step"
    fi

    exec light -U "$step"
fi

set_ddc_brightness && exit 0

if command -v notify-send >/dev/null 2>&1; then
    notify-send "Brightness control unavailable" \
        "Install swayosd, brightnessctl, light, or ddcutil."
fi

echo "brightness control unavailable: install swayosd, brightnessctl, light, or ddcutil" >&2
exit 1
