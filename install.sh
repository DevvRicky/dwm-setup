#!/usr/bin/env bash
#
# install.sh - automated installer for the fierzza-dotfiles setup
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#
# What it does:
#   1. Checks the OS and (optionally) installs dependencies.
#   2. Backs up any existing dotfiles that would be overwritten (.bak).
#   3. Rewrites hardcoded "/home/fierzza" paths to your current $HOME.
#   4. Copies all configs, scripts, and the wallpaper into place.
#   5. Builds and installs dwm, dwmblocks-async, and dmenu.
#
# Designed for Void Linux (xbps-install). For other distros, install the
# equivalent packages yourself and pass --skip-deps.

set -euo pipefail

# ---------- helpers ----------

log()  { printf '\033[1;32m[*]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; }

die() { err "$*"; exit 1; }

# Back up $1 to $1.bak if it exists (and isn't already a backup).
backup() {
    local f="$1"
    if [ -e "$f" ] && [ ! -e "$f.bak" ]; then
        cp -r "$f" "$f.bak"
        log "Backed up $f -> $f.bak"
    fi
}

# ---------- options ----------

SKIP_DEPS=0
SKIP_BUILD=0
REPO=""

for arg in "$@"; do
    case "$arg" in
        --skip-deps) SKIP_DEPS=1 ;;
        --skip-build) SKIP_BUILD=1 ;;
        --repo=*) REPO="${arg#--repo=}" ;;
        -h|--help)
            echo "Usage: $0 [--skip-deps] [--skip-build] [--repo=PATH]"
            exit 0
            ;;
        *) die "Unknown option: $arg" ;;
    esac
done

# ---------- environment detection ----------

HOME_DIR="${HOME:-$HOME}"
USER_NAME="${USER:-$(id -un)}"

REPO="${REPO:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
cd "$REPO"

[ -f README.md ] || die "Run this script from inside the dotfiles repo root."

log "Repo:        $REPO"
log "Home:        $HOME_DIR"
log "User:        $USER_NAME"

# ---------- 1. dependencies ----------

if [ "$SKIP_DEPS" -eq 0 ]; then
    if command -v xbps-install >/dev/null 2>&1; then
        log "Detected Void Linux - installing dependencies (sudo prompt may appear)"
        sudo xbps-install -Syu xorg-server base-devel \
            libX11-devel libXinerama-devel libXft-devel freetype-devel \
            fontconfig-devel xcb-util-devel kitty rofi fastfetch picom feh \
            dmenu dunst playerctl iwd wireplumber pipewire scrot xclip \
            btop impala xcolor nerd-fonts-ttf nerd-fonts 2>/dev/null || \
            sudo xbps-install -Syu xorg-server base-devel \
                libX11-devel libXinerama-devel libXft-devel freetype-devel \
                fontconfig-devel xcb-util-devel kitty rofi fastfetch picom feh \
                dmenu dunst playerctl iwd wireplumber pipewire scrot xclip \
                btop xcolor nerd-fonts-ttf || true
    else
        warn "xbps-install not found - skipping dependency install."
        warn "Install the packages listed in README.md for your distro."
    fi
else
    log "--skip-deps: not installing dependencies."
fi

# ---------- 2. rewrite hardcoded paths ----------

# Source templates already in the repo may contain "/home/fierzza". The install
# stage below rewrites each copied file to use $HOME. If the repo was cloned
# from a fork by a different user, replace whatever original user appears.

OLD_USER_DIR="/home/fierzza"
if [ "$HOME_DIR" != "$OLD_USER_DIR" ]; then
    log "Rewriting '$OLD_USER_DIR' -> '$HOME_DIR' in configs/scripts."
else
    log "Home already matches template; no path rewriting needed."
fi

# ---------- 3. copy dotfiles + configs ----------

backup "$HOME_DIR/.bashrc"
backup "$HOME_DIR/.bash_profile"
backup "$HOME_DIR/.xinitrc"

mkdir -p "$HOME_DIR/.config" "$HOME_DIR/.local/bin/status" \
         "$HOME_DIR/.Scripts" "$HOME_DIR/Pictures/Wallpapers"

# Shell files
cp .bashrc "$HOME_DIR/.bashrc"
cp .bash_profile "$HOME_DIR/.bash_profile"
cp .xinitrc "$HOME_DIR/.xinitrc"

# Neovim
backup "$HOME_DIR/.config/nvim"
cp -r config/nvim "$HOME_DIR/.config/nvim"

# kitty
backup "$HOME_DIR/.config/kitty"
cp -r config/kitty "$HOME_DIR/.config/kitty"

# rofi
backup "$HOME_DIR/.config/rofi"
cp -r config/rofi "$HOME_DIR/.config/rofi"

# fastfetch
backup "$HOME_DIR/.config/fastfetch"
cp -r config/fastfetch "$HOME_DIR/.config/fastfetch"

# GTK 3.0 / 4.0
mkdir -p "$HOME_DIR/.config/gtk-3.0" "$HOME_DIR/.config/gtk-4.0"
cp config/gtk-3.0/settings.ini "$HOME_DIR/.config/gtk-3.0/settings.ini"
cp config/gtk-4.0/settings.ini "$HOME_DIR/.config/gtk-4.0/settings.ini"
cp config/gtk-4.0/gtk.css      "$HOME_DIR/.config/gtk-4.0/gtk.css"

# picom
mkdir -p "$HOME_DIR/.config/picom"
cp config/picom/picom.conf "$HOME_DIR/.config/picom/picom.conf"

# scripts
cp scripts/status/* "$HOME_DIR/.local/bin/status/"
cp scripts/screenshot scripts/screenshot-region scripts/screenrecord \
   scripts/powermenu scripts/setwpp "$HOME_DIR/.local/bin/"
cp scripts/create-project "$HOME_DIR/.Scripts/"
chmod +x "$HOME_DIR"/.local/bin/status/* "$HOME_DIR/.local/bin"/{screenshot,screenshot-region,screenrecord,powermenu,setwpp} \
         "$HOME_DIR/.Scripts/create-project"

# wallpaper
cp wallpapers/sanae.jpg "$HOME_DIR/Pictures/Wallpapers/sanae.jpg"

# Rewrite hardcoded user paths in the freshly copied files (new user).
if [ "$HOME_DIR" != "$OLD_USER_DIR" ]; then
    # Text files that may reference the old user path.
    for f in \
        "$HOME_DIR/.bashrc" \
        "$HOME_DIR/.xinitrc" \
        "$HOME_DIR/.config/rofi/config.rasi" \
        "$HOME_DIR/.config/rofi/dunst.rasi" \
        "$HOME_DIR/.config/rofi/themes"/*.rasi \
        "$HOME_DIR/.config/nvim/lua/config/compile.lua" \
        "$HOME_DIR/.local/bin"/{powermenu,screenshot,screenshot-region,screenrecord,setwpp} \
        "$HOME_DIR/.local/bin/status"/* ; do
        [ -f "$f" ] || continue
        sed -i "s|$OLD_USER_DIR|$HOME_DIR|g" "$f" || true
    done
fi

log "Configs, scripts, and wallpaper installed."

# ---------- 4. build the suckless tools ----------

# Build from a private copy of the sources so the repo (and its config.h
# templates, authored with the original user) is never mutated. The copied
# config.h gets the new user's paths rewritten before compiling.

BUILD_DIR="$HOME_DIR/.local/src/suckless"
mkdir -p "$BUILD_DIR"

stage_source() {
    local name="$1"
    rm -rf "$BUILD_DIR/$name"
    cp -r "$name" "$BUILD_DIR/$name"
    rm -rf "$BUILD_DIR/$name/.git" "$BUILD_DIR/$name"/build
    if [ "$HOME_DIR" != "$OLD_USER_DIR" ]; then
        [ -f "$BUILD_DIR/$name/config.h" ] && \
            sed -i "s|$OLD_USER_DIR|$HOME_DIR|g" "$BUILD_DIR/$name/config.h"
    fi
}

if [ "$SKIP_BUILD" -eq 1 ]; then
    log "--skip-build: not compiling dwm/dwmblocks/dmenu."
    log "  Build manually (from the repo):"
    log "    make -C dwm clean install"
    log "    make -C dwmblocks-async clean install"
    log "    make -C dmenu clean install"
else
    log "Staging sources under $BUILD_DIR"

    log "Building and installing dwm..."
    stage_source dwm
    ( cd "$BUILD_DIR/dwm" && sudo make clean install )

    log "Building and installing dwmblocks-async..."
    stage_source dwmblocks-async
    ( cd "$BUILD_DIR/dwmblocks-async" && make clean && sudo make install )

    log "Building and installing dmenu..."
    stage_source dmenu
    ( cd "$BUILD_DIR/dmenu" && sudo make clean install )
fi

log "Done! Log out and log back in on tty1 to start X (dwm)."
log "Rebind any absolute paths in config.h if your layout differs from $HOME_DIR."
