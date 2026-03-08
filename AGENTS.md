# DOTFILES KNOWLEDGE BASE

**Generated:** 2026-03-08
**Commit:** f59fdb0
**Branch:** main

## OVERVIEW

Personal dotfiles using GNU Stow for symlink management. Configs for Hyprland (Wayland), Zsh/Oh-My-Zsh, OpenCode AI, and various CLI tools.

## STRUCTURE

```
dotfiles/
├── setup.sh          # Main installer - stows all packages
├── .stowrc           # Stow config (target=~, ignore DS_Store)
├── ack/              # ack search config
├── basecamp/         # Basecamp notifier
├── freshbooks/       # FreshBooks integration
├── git/              # Git config (~/.config/git/)
├── google-messages/  # Google Messages desktop
├── hypr/             # Hyprland WM (keybinds, monitors, windows)
├── kitty/            # Kitty terminal
├── lazydocker/       # Lazydocker TUI
├── ohmyposh/         # Oh My Posh prompt theme (Dracula)
├── omarchy/          # Omarchy themes/branding
├── opencode/         # OpenCode AI config (agents, skills) [HAS AGENTS.md]
├── ssh/              # SSH config
├── systemd/          # User systemd units
├── waybar/           # Waybar status bar
└── zsh/              # Zsh config (Oh-My-Zsh, aliases)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Install all dotfiles | `./setup.sh` | Requires `stow` installed |
| Install single package | `stow -R <package>` | e.g., `stow -R zsh` |
| Shell aliases | `zsh/.commonrc` | `lzd`, `lzg` |
| Zsh sourcing order | `zsh/.zshrc` | p10k → OMZ → .commonrc → omp |
| Hyprland keybinds | `hypr/.config/hypr/keybindings.conf` | |
| Hyprland monitors | `hypr/.config/hypr/monitors_custom.conf` | |
| AI agent config | `opencode/` | See opencode/AGENTS.md |

## CONVENTIONS

- **Directory structure**: Each package mirrors target path (e.g., `git/.config/git/config` → `~/.config/git/config`)
- **Stow packages**: One dir per tool/app at repo root
- **Conflicts**: setup.sh backs up existing files to `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`
- **Theme backgrounds**: setup.sh removes `base*` and `dracula*` from omarchy backgrounds before stow

## COMMANDS

```bash
# Install all dotfiles (backs up conflicts)
./setup.sh

# Install specific package
./setup.sh zsh git hypr

# Manual stow (restow mode)
stow -R -v <package>

# Check what stow would do (dry run)
stow -n -v <package>
```

## NOTES

- Requires GNU Stow installed (`apt install stow` / `pacman -S stow`)
- Oh-My-Zsh must be installed separately (`~/.oh-my-zsh`)
- Oh-My-Posh installed separately for prompt theming
- LM Studio CLI adds to PATH in .zshrc (may need removal if not using)
