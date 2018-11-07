#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

sleep 0.1

# Set environment variable
sed -i '11s/.*/export PBAR_APPLET=false/' $HOME/.bash_profile
source $HOME/.bash_profile

# Set all monitors in env
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload -c=$HOME/.config/polybar/config mainbar &
  done
else
  polybar --reload mainbar &
fi

ln -f -s /tmp/polybar_mqueue.$(pidof polybar | awk '{print$1}') /tmp/ipc-mainbar
/usr/bin/python3 ~/.config/polybar/py_spotify_listener.py
