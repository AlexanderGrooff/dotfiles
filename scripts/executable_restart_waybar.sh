#!/usr/bin/env bash
# This file is managed by chezmoi. Do not edit directly.

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
    waybar &
    echo checking
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
