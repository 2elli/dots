#!/usr/bin/env bash
pidof -q waybar
waybar_status=$?
if [[ $waybar_status -ne 0 ]]; then
    waybar -c ~/.config/sway/waytray/config.jsonc -s ~/.config/sway/waytray/style.css &>/dev/null &
else
    killall waybar
fi
