# Dotfiles

My personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Overview

This repository contains configuration for:
- **Window Manager**: [Hyprland](https://hyprland.org/)
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Shell**: Zsh with [Oh My Zsh](https://ohmyz.sh/) and [Oh My Posh](https://ohmyposh.dev/)
- **Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Editor & Tools**: Git, Lazydocker, Ack, SSH
- **Theming**: Dracula theme integrated across tools

## Prerequisites

Before stowing, ensure you have the following installed:
- `stow`
- `zsh`
- `kitty`
- `hyprland`
- `waybar`
- `oh-my-posh`
- `lazydocker`

## Installation

To install all configurations:

```bash
./setup.sh
```

To install specific packages:

```bash
./setup.sh hypr kitty zsh
```

## Structure

The project uses the standard Stow directory structure. Each top-level directory (except `.git`, etc.) represents a "package" that can be symlinked into your home directory.

- `hypr/`: Hyprland tiling window manager configs
- `kitty/`: Terminal emulator configuration
- `zsh/`: Zsh shell configuration (`.zshrc`, `.commonrc`)
- `waybar/`: Status bar configuration
- `git/`: Git configuration and global ignore
- `systemd/`: User-level systemd services (e.g., wallpaper rotation)

## Keybindings (Hyprland)

- `SUPER + SHIFT + B`: Launch/Focus Work Browser
- `SUPER + SHIFT + C`: Launch Basecamp
- `SUPER + SHIFT + D`: Launch Discord
- `SUPER + SHIFT + L`: Lock Screen
- `SUPER + SHIFT + M`: Launch Google Messages
- `SHIFT + ALT + 4`: Screenshot to Clipboard

## Contributing

These are my personal dotfiles, but feel free to fork them and adapt them to your needs!
