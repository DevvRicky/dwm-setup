#!/bin/sh

eval "$(dbus-launch --sh-syntax)"
export DBUS_SESSION_BUS_ADDRESS

export XCURSOR_THEME=KryptonWhiteRH
export XCURSOR_SIZE=11

xrandr \
  --output eDP-1 --off \
  --output DP-1 --mode 1920x1080 --rate 60 --primary \
  --output HDMI-1 --mode 1920x1080 --rate 75 --left-of DP-1

xrandr --output HDMI-1 --set "Broadcast RGB" "Full"

xset s off
xset -dpms
xset s noblank

xinput disable "$(xinput list --id-only 'AT Translated Set 2 keyboard')"
feh --bg-fill /home/fierzza/Pictures/Wallpapers/sanae.jpg /home/fierzza/Pictures/Wallpapers/sanae.jpg
picom --config ~/.config/picom/picom.conf --backend glx &
pipewire &
wireplumber &
pipewire-pulse &

/usr/local/bin/dwmblocks &
exec dwm
