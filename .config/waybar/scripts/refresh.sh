#!/bin/bash

start_waybar() {
    if command -v hyprctl >/dev/null 2>&1 && hyprctl monitors >/dev/null 2>&1; then
        hyprctl dispatch exec waybar >/dev/null
    else
        nohup waybar >/tmp/waybar.log 2>&1 &
    fi
}

# Check if waybar is running
if pgrep -x "waybar" > /dev/null; then
    # If running, kill the waybar process
    pkill -x "waybar"
else
    # If not running, start waybar
    start_waybar
fi
