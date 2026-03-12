# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Configs for Hyprland, Zsh, Kitty, Waybar, and various CLI tools.

## Prerequisites

- GNU Stow (`pacman -S stow` or `apt install stow`)
- [Oh-My-Zsh](https://ohmyz.sh/) for shell config
- [Oh-My-Posh](https://ohmyposh.dev/) for prompt theming

## Installation

```bash
# Clone and cd into repo
git clone https://github.com/jturmel/dotfiles.git
cd dotfiles

# Install all dotfiles (backs up conflicts automatically)
./setup.sh

# Or install specific packages only
./setup.sh zsh git hypr nvim
```

Existing files are backed up to `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`.

## Structure

Each directory is a stow package that mirrors the target path in `~`:

| Package | Description |
|---------|-------------|
| `ack/` | ack search config |
| `git/` | Git config (`~/.config/git/`) |
| `hypr/` | Hyprland WM (keybinds, monitors, windows) |
| `kitty/` | Kitty terminal |
| `nvim/` | Extra Neovim plugin files layered into `~/.config/nvim/` |
| `ohmyposh/` | Oh My Posh prompt theme (Dracula) |
| `omarchy/` | Omarchy themes/branding |
| `opencode/` | OpenCode AI config |
| `systemd/` | User systemd units (wallpaper rotation) |
| `waybar/` | Waybar status bar |
| `zsh/` | Zsh config (Oh-My-Zsh, aliases) |

## Reloading Configs

After changing configs, apply them:

| Config | Reload Command |
|--------|----------------|
| **Hyprland** | `hyprctl reload` |
| **Waybar** | Auto-reloads on change (or `killall waybar && waybar &`) |
| **Kitty** | Changes apply on new window (or `ctrl+shift+f5`) |
| **Neovim** | Restart Neovim or run `:Lazy sync` after plugin changes |
| **Zsh/Oh-My-Posh** | `source ~/.zshrc` or open new terminal |
| **Systemd units** | `systemctl --user daemon-reload && systemctl --user restart <service>` |

## Common Tasks

```bash
# Re-stow a package after pulling changes
stow -R zsh nvim

# Preview what stow would do (dry run)
stow -n -v hypr nvim

# Check aliases defined
cat ~/.commonrc
```

## Shell Aliases

Defined in `zsh/.commonrc`:

- `lzd` → lazydocker
- `lzg` → lazygit
