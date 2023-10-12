#!/usr/bin/env bash

# Ensure all services are started on boot

# Check if i3 is running
if [[ ! $(pgrep -x "i3") ]]; then
    # Load gnome keyring
    if [[ `command -v gnome-keyring-daemon` ]]; then
        eval $(gnome-keyring-daemon --components=pkcs11,secrets,ssh)
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
    fi
elif [[ ${XDG_CURRENT_DESKTOP} = "hyprland" ]]; then
    systemctl --user start waybar-reload.sevice
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
fi
