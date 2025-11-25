#!/bin/bash

# Update script to pull latest changes and re-run installation

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🔄 Updating dotfiles...${NC}"

# Check if we're in a git repository
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    echo -e "${RED}Error: Not a git repository${NC}"
    exit 1
fi

cd "$DOTFILES_DIR"

# Stash any local changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Stashing local changes...${NC}"
    git stash push -m "Auto-stash before update $(date +%Y-%m-%d_%H:%M:%S)"
    STASHED=true
else
    STASHED=false
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}Current branch: $CURRENT_BRANCH${NC}"

# Pull latest changes
echo -e "${BLUE}Pulling latest changes...${NC}"
if git pull origin "$CURRENT_BRANCH"; then
    echo -e "${GREEN}✅ Successfully pulled latest changes${NC}"
else
    echo -e "${RED}Failed to pull changes${NC}"
    if [[ "$STASHED" == "true" ]]; then
        echo -e "${YELLOW}Restoring stashed changes...${NC}"
        git stash pop
    fi
    exit 1
fi

# Restore stashed changes
if [[ "$STASHED" == "true" ]]; then
    echo -e "${YELLOW}Restoring stashed changes...${NC}"
    if git stash pop; then
        echo -e "${GREEN}✅ Stashed changes restored${NC}"
    else
        echo -e "${RED}Failed to restore stashed changes${NC}"
        echo -e "${YELLOW}Your changes are still in the stash. Run 'git stash pop' manually.${NC}"
    fi
fi

# Ask if user wants to re-run installation
echo ""
read -p "$(echo -e "${YELLOW}Re-run installation to apply changes? (y/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ -x "$DOTFILES_DIR/install.sh" ]]; then
        echo -e "${BLUE}Running installation...${NC}"
        "$DOTFILES_DIR/install.sh"
    else
        echo -e "${RED}install.sh not found or not executable${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Skipping installation. Run ./install.sh manually when ready.${NC}"
fi

echo ""
echo -e "${GREEN}✅ Update complete!${NC}"
echo ""

# Show recent commits
echo -e "${BLUE}Recent changes:${NC}"
git log --oneline --graph --decorate -10

echo ""
echo -e "${BLUE}Tip: Restart your terminal to apply all changes${NC}"
