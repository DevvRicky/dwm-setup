# dwm-dotfiles

My personal Linux setup — a dynamic tiling window manager (dwm) rice on **Void Linux** with a dark green/sage aesthetic, the Sanae wallpaper, and a fully configured developer environment.

## Table of contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Repository layout](#repository-layout)
- [Dependencies](#dependencies)
- [Manual installation](#manual-installation)
  - [1. Cloning](#1-cloning)
  - [2. Configuration files](#2-configuration-files)
  - [3. Build and install](#3-build-and-install)
  - [4. Final steps](#4-final-steps)
- [Automated installation](#automated-installation)
- [Keybindings](#keybindings)
- [Notes / customization](#notes--customization)

---

## Overview

- **OS:** Void Linux (glibc)
- **WM:** [dwm](https://dwm.suckless.org) 6.x, patched (gaps, alwayscenter, attachaside, actualfullscreen)
- **Terminal:** kitty (transparent, blurred)
- **Shell:** bash
- **Launcher / notifications:** rofi
- **Status bar:** dwmblocks-async
- **System info:** fastfetch (custom Void ASCII logo) + fetch
- **Editor:** Neovim (Lua config, Lazy-style modules)
- **Compositor:** picom (GLX, blur)
- **Theme:** custom dark green "DarkGreen" GTK theme for GTK 3.0 + 4.0
- **Wallpaper:** `wallpapers/sanae.jpg`

---

## Screenshots

| | |
|:---:|:---:|
| ![dwm1](Videos%20and%20ScreenShots/dwm1.png) | ![dwm2](Videos%20and%20ScreenShots/dwm2.png) |
| ![dwm3](Videos%20and%20ScreenShots/dwm3.png) | ![dwm4](Videos%20and%20ScreenShots/dwm4.png) |
| ![image](Videos%20and%20ScreenShots/image.png) | |

---

## Repository layout

```
dotfiles/
├── .bash_profile          # login shell: sources .bashrc, auto-starts X on tty1
├── .bashrc                # aliases, prompt, env (nvm, cargo, android, etc.)
├── .xinitrc               # X startup: dwm, dwmblocks, picom, pipewire, feh
├── config/
│   ├── nvim/              # Neovim Lua config (plugins, theme, mappings)
│   ├── kitty/             # kitty.conf + greenish-theme.conf
│   ├── rofi/              # config.rasi + themes (green, blue, test, dunst)
│   ├── fastfetch/         # config.jsonc + Arts/ ASCII logos
│   ├── gtk-3.0/           # settings.ini
│   ├── gtk-4.0/           # settings.ini + gtk.css (pavucontrol theme)
│   └── picom/             # picom.conf
├── dwm/                   # dwm source (config.h with my binds/rules/colors)
├── dwmblocks-async/       # async status bar with blocks (status/ scripts)
├── dmenu/                 # dynamic menu launcher
├── fetch/                 # fetch (system info) source
├── pipes/                 # pipes.sh screensaver
├── unimatrix/             # Matrix-style screensaver
├── scripts/
│   ├── status/            # dwmblocks block scripts (audio, cpu, wifi, ...)
│   ├── screenshot         # focused monitor screenshot -> clipboard
│   ├── screenshot-region  # region screenshot -> clipboard
│   ├── screenrecord       # GPU screen recording toggle
│   ├── powermenu          # rofi shutdown/restart menu
│   ├── setwpp             # change wallpaper in .xinitrc + apply
│   └── create-project     # language scaffold menu
├── wallpapers/            # sanae.jpg
├── install.sh             # automated installer
└── README.md
```

---

## Dependencies

> Installed via `xbps-install` on Void Linux. Adapt the package names for your
> distro's package manager.

### Core (window manager / X)
- `Xorg` / `xorg-server` (X11)
- `base-devel` (make, gcc, etc.)
- `libX11-devel`, `libXinerama-devel`, `libXft-devel`, `freetype-devel`,
  `fontconfig-devel`, `xcb-util-devel` (dwm / dwmblocks / dmenu build deps)
- `dmenu` (or build from this repo)
- `xrandr`, `xset`, `xdpyinfo`, `xwininfo`, `feh` (background), `picom` (compositor)

### Terminal & shell
- `kitty`
- `bash`

### Status bar scripts
- `wireplumber` + `wireplumber-pulse` / `pipewire` (audio/volume: `wpctl`)
- `iwd` (wifi: `iwctl`), `iwd` package
- `playerctl` (spotify block)
- `dunst` + `dunstctl` (notifications)
- `btop` (cpu block click)
- `impala` (wifi block click network manager)
- `scrot`, `xclip` (screenshots)
- `gpu-screen-recorder` (screen recording)
- `notify-send` (part of `libnotify`)

### Tools / launcher
- `rofi`
- `fastfetch`
- `nvim` + `lazygit`/`fzf`/`rg`/`fd` (neovim config uses these)
- `xcolor` (color picker)

### Fonts & icons (important for the look)
- `nerd-fonts` (JetBrainsMono Nerd Font)
- An icon/cursor theme such as `YAMIS` and `KryptonWhiteRH` (referenced in GTK settings)

### Optional (from this repo)
- `pipes.sh`, `unimatrix` — build/install from source in this repo
- `fetch` — build from source in this repo

---

## Manual installation

### 1. Cloning

```sh
git clone https://github.com/DevvRicky/dwm-setup.git ~/dotfiles
cd ~/dotfiles
```

### 2. Configuration files

Copy the dotfiles and configs into place (direct paths, not symlinks — some
scripts hardcode `~/dotfiles` paths):

```sh
cp .bashrc ~/.bashrc
cp .bash_profile ~/.bash_profile
cp .xinitrc ~/.xinitrc

mkdir -p ~/.config
cp -r config/nvim     ~/.config/nvim
cp -r config/kitty    ~/.config/kitty
cp -r config/rofi     ~/.config/rofi
cp -r config/fastfetch ~/.config/fastfetch
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
cp config/gtk-4.0/settings.ini ~/.config/gtk-4.0/settings.ini
cp config/gtk-4.0/gtk.css      ~/.config/gtk-4.0/gtk.css
cp config/picom/picom.conf      ~/.config/picom/picom.conf

mkdir -p ~/.local/bin ~/.local/bin/status ~/.Scripts
cp scripts/status/*  ~/.local/bin/status/
cp scripts/screenshot scripts/screenshot-region scripts/screenrecord \
   scripts/powermenu scripts/setwpp ~/.local/bin/
cp scripts/create-project ~/.Scripts/

mkdir -p ~/Pictures/Wallpapers
cp wallpapers/sanae.jpg ~/Pictures/Wallpapers/sanae.jpg
```

**Important:** `.bashrc` and `dwm/config.h` reference several absolute paths that
you must adjust to your own username/home:

- `~/.local/bin`, `~/.Scripts`, `~/.cargo`, `~/.nvm` in `.bashrc`
- `/home/<user>/Pictures/Wallpapers` in `.xinitrc` and `scripts/setwpp`
- `/home/<user>/dotfiles/...` and `/home/<user>/.local/bin/...` in `dwm/config.h`
  and `dwmblocks-async/config.h`

### 3. Build and install

Build and install dwm, dwmblocks-async, and dmenu (run from the repo root):

```sh
# dwm
make -C dwm clean install
# dwmblocks-async
make -C dwmblocks-async clean install
# dmenu
make -C dmenu clean install
```

Optional extras:

```sh
make -C pipes install          # or copy pipes.sh into ~/.local/bin
pip install --user ./unimatrix # or use setup.py/run unimatrix.py
# fetch: follow its own Makefile / docs
```

### 4. Final steps

1. Set up the DCVS/stage dirs and GTK themes referenced by settings.ini
   (`DarkGreen`, `YAMIS`, `KryptonWhiteRH`).
2. Make sure `fierzza` in `dwmblocks-async/config.h` block paths is replaced with
   your own user.
3. Log out, then log in on tty1 — `.bash_profile` auto-starts X with your
   `.xinitrc` (dwm + status bar + compositor + wallpaper).

---

## Automated installation

Simply run the script from the repo root (it does everything in the manual
section, replacing hardcoded users with your current `$USER`), then rebuild the
suckless programs:

```sh
chmod +x install.sh
./install.sh
```

The script:

- Detects your home and `$USER` and rewrites hardcoded `/home/fierzza` paths.
- Backs up any existing config files (`.bak`) before overwriting.
- Installs dependencies via `xbps-install` (you will be prompted for sudo).
- Copies all config, scripts, and the wallpaper into place.
- Builds and installs dwm, dwmblocks-async, and dmenu.

---

## Keybindings

`MOD` = `Super` (Mod4). Full list in `dwm/config.h`, highlights:

| Keys              | Action                              |
|-------------------|-------------------------------------|
| `MOD` + `Return`  | Terminal (kitty)                    |
| `MOD` + `Space`   | rofi app menu                       |
| `MOD+Shift` + `Space` | dmenu run                       |
| `MOD` + `p`       | Full screenshot / clipboard         |
| `MOD+Alt` + `p`   | Region screenshot / clipboard       |
| `MOD` + `y`       | Toggle screen recording             |
| `MOD` + `w`       | Kill focused window                 |
| `MOD` + `m`       | Toggle bar                          |
| `MOD+Shift+Ctrl` + `w` | Power menu (rofi)              |
| `MOD` + `1`–`7`   | Switch tags                         |
| `MOD` + `j`/`k`   | Cycle focus                         |
| `MOD` + `t`       | Tile layout                         |
| `MOD` + `f`       | Firefox                             |
| `MOD` + `n`       | Neovim                              |

---

## Notes / customization

- **Theme switching:** dwm colors live in `dwm/colors/` (`green.h` default).
  Switch by editing the `#include "colors/green.h"` line in `config.h`, then
  `make -C dwm clean install`.
- **GTK theme:** `config/gtk-4.0/gtk.css` is a custom pavucontrol/GTK4 dark
  green theme. The `gtk-theme-name=DarkGreen` in `settings.ini` expects an
  installed GTK theme with that name (or edit it to your installed theme).
- **Neovim:** the `compile.lua` hardcodes a Java home path
  (`/usr/lib/jvm/openjdk21`); adjust `java_home` to your JDK.
- The `saved_theme` file in the nvim config is runtime state and is not tracked
  in git.
