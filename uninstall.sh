#!/bin/bash

# Dotfiles uninstallation script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backups"

echo -e "${BLUE}🗑️  Uninstalling dotfiles...${NC}"
echo -e "${BLUE}Dotfiles directory: $DOTFILES_DIR${NC}"

# Function to remove symlinks and restore backups
remove_and_restore() {
    local target_file="$1"
    local file_basename="$(basename "$target_file")"
    
    # Check if target is a symlink pointing to our dotfiles
    if [[ -L "$target_file" ]]; then
        local link_target="$(readlink "$target_file")"
        if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
            echo -e "${YELLOW}🔗 Removing symlink $target_file${NC}"
            rm "$target_file"
            
            # Look for the most recent backup
            local latest_backup=$(find "$BACKUP_DIR" -name "${file_basename}.backup.*" -type f 2>/dev/null | sort -r | head -n1)
            
            if [[ -n "$latest_backup" ]]; then
                echo -e "${GREEN}📦 Restoring backup $latest_backup -> $target_file${NC}"
                cp "$latest_backup" "$target_file"
            else
                echo -e "${YELLOW}⚠️  No backup found for $file_basename${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️  $target_file is a symlink but not pointing to our dotfiles, skipping${NC}"
        fi
    elif [[ -f "$target_file" ]]; then
        echo -e "${YELLOW}⚠️  $target_file exists but is not a symlink, skipping${NC}"
    else
        echo -e "${BLUE}ℹ️  $target_file does not exist, skipping${NC}"
    fi
}

# Uninstall shell configurations
echo -e "${BLUE}📂 Uninstalling shell configurations...${NC}"
remove_and_restore "$HOME/.bashrc"
remove_and_restore "$HOME/.zshrc"

# Uninstall git configuration
echo -e "${BLUE}📂 Uninstalling git configuration...${NC}"
remove_and_restore "$HOME/.gitconfig"

# Uninstall vim configuration
echo -e "${BLUE}📂 Uninstalling vim configuration...${NC}"
remove_and_restore "$HOME/.vimrc"

# Ask about .gitignore_global
if [[ -f "$HOME/.gitignore_global" ]]; then
    echo ""
    read -p "$(echo -e "${YELLOW}Do you want to remove .gitignore_global? (y/N): ${NC}")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🗑️  Removing .gitignore_global${NC}"
        rm "$HOME/.gitignore_global"
    fi
fi

echo ""
echo -e "${GREEN}✅ Dotfiles uninstallation complete!${NC}"
echo ""
echo -e "${YELLOW}📋 Notes:${NC}"
echo -e "  • Backup files are preserved in: ${BLUE}$BACKUP_DIR${NC}"
echo -e "  • You may want to restart your terminal to apply changes"
echo ""

# Show backup files if any exist
if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
    echo -e "${BLUE}📦 Available backup files:${NC}"
    ls -la "$BACKUP_DIR"
    echo ""
fi

echo -e "${GREEN}👋 Goodbye!${NC}"