# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc
source "$HOME/.cargo/env"

# This function already executes the dwm if youre on tty1 whenever you login, because i dont have a Display Manager
# Exclude this in case your Display Manager already take care of it
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi
