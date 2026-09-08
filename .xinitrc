#!/bin/sh

eval "$(dbus-launch --sh-syntax)"
export DBUS_SESSION_BUS_ADDRESS

# Change the theme and size of the cursor if the user wants or needs
export XCURSOR_THEME=KryptonWhiteRH
export XCURSOR_SIZE=11

# Monitor setup, i have 3, but i let the native monitor off because its resolution is different
# Change these if you monitor have different configurations
xrandr \
  --output eDP-1 --off \
  --output DP-1 --mode 1920x1080 --rate 60 --primary \
  --output HDMI-1 --mode 1920x1080 --rate 75 --left-of DP-1

xrandr --output HDMI-1 --set "Broadcast RGB" "Full"

xset s off
xset -dpms
xset s noblank

# This disable the native keyboard from my laptop, remove or change if needed
xinput disable "$(xinput list --id-only 'AT Translated Set 2 keyboard')"

# feh is where i set my wallpaper, if you use a different application or uses it differently, change for your liking
feh --bg-fill /home/fierzza/Pictures/Wallpapers/sanae.jpg /home/fierzza/Pictures/Wallpapers/sanae.jpg

# picom to set my animations, my blurried topbar/terminal
picom --config ~/.config/picom/picom.conf --backend glx &

#Audio services, if you use it on your services configuration already (like on systemd, openrc, runit, etc...) delete these
pipewire &
wireplumber &
pipewire-pulse &

# Starts both dwm and dwmblocks-async
/usr/local/bin/dwmblocks &
exec dwm
