#!/usr/bin/env bash

# ==============================================================================
# GNU Stow Dotfiles Setup Script
# ==============================================================================
# This script automates the installation of dotfiles using GNU Stow.
# It safely handles existing config files by backing them up before stowing.
# ==============================================================================

set -e

# --- Configuration ---
DOTFILES_DIR="."
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
STOW_CMD="stow"
BACKGROUNDS_TARGET_DIR="$HOME/.config/omarchy/themes/dracula/backgrounds/"

# Folders inside $DOTFILES_DIR to ignore (space separated)
IGNORE_DIRS=".git .github .vscode .idea"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- Functions ---

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

cleanup_existing_theme_backgrounds() {
  # Only proceed if the directory actually exists
  if [ -d "$BACKGROUNDS_TARGET_DIR" ]; then
    # Use subshell ( ) to change directory without affecting the rest of the script
    (
      cd "$BACKGROUNDS_TARGET_DIR" || exit
      shopt -s nullglob
      for file in base* dracula*; do
        [ -f "$file" ] && rm "$file"
      done
    )
    echo "Theme background cleanup finished in $BACKGROUNDS_TARGET_DIR"
  else
    echo "Directory $BACKGROUNDS_TARGET_DIR not found; skipping theme background cleanup."
  fi
}

# Resolve conflicts for a specific package
# This simulates what stow does: looks at files in the package, checks target,
# and if a REAL file exists (not a symlink), backs it up.
resolve_conflicts() {
    local package=$1
    local package_dir="$DOTFILES_DIR/$package"

    log_info "Checking conflicts for $package..."

    # Find all files in the package directory
    # We cd into the dir so find gives relative paths (e.g., .bashrc or .config/nvim/init.lua)
    pushd "$package_dir" > /dev/null

    find . -type f | while read -r file; do

        # Strip leading ./
        clean_file="${file#./}"
        target_path="$TARGET_DIR/$clean_file"

        if [ -e "$target_path" ]; then
            if [ -L "$target_path" ]; then
                continue
            elif [ -f "$target_path" ]; then
                # It is a regular file. This causes Stow conflicts.
                log_warn "Conflict found: $target_path"
                
                # Create backup path
                backup_path="$BACKUP_DIR/$package/$clean_file"
                backup_parent=$(dirname "$backup_path")
                mkdir -p "$backup_parent"

                # Move file
                mv "$target_path" "$backup_path"
                log_success "Moved existing file to $backup_path"
            fi
        fi
    done

    popd > /dev/null
}

main() {
    if ! command_exists stow; then
        log_error "GNU Stow is not installed. Please install it first."
        exit 1
    fi

    if [ ! -d "$DOTFILES_DIR" ]; then
        log_error "Dotfiles directory not found at $DOTFILES_DIR"
        exit 1
    fi

    cleanup_existing_theme_backgrounds

    cd "$DOTFILES_DIR"

    # Determine which packages to install
    # If args are passed, use those. Otherwise, scan directories.
    if [ $# -gt 0 ]; then
        PACKAGES="$@"
    else
        # Find all directories that are not in the ignore list
        PACKAGES=$(find . -maxdepth 1 -mindepth 1 -type d -not -path '*/.*' | sed 's|^\./||')
        
        # Filter out ignored directories explicitly defined at top
        for ignore in $IGNORE_DIRS; do
            PACKAGES=$(echo "$PACKAGES" | grep -v "^$ignore$")
        done
    fi

    log_info "Stowing packages: $(echo $PACKAGES | tr '\n' ' ')"

    # 4. Iterate and Stow
    for package in $PACKAGES; do
        if [ -d "$package" ]; then
            # Step A: Clean up conflicts (backup existing files)
            resolve_conflicts "$package"

            # Step B: Run stow
            log_info "Stowing $package..."
            # -R: Restow (useful for updates)
            # -v: Verbose
            # -t: Target directory
            $STOW_CMD -R -v "$package"
            
            if [ $? -eq 0 ]; then
                log_success "$package stowed successfully."
            else
                log_error "Failed to stow $package."
            fi
        else
            log_warn "Package '$package' is not a directory. Skipping."
        fi
    done

    echo ""
    log_success "All done!"
    if [ -d "$BACKUP_DIR" ]; then
        log_info "Backups stored in: $BACKUP_DIR"
    fi
}

main "$@"
