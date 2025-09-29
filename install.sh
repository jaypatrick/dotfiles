#!/bin/bash

# Dotfiles installation script

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

echo -e "${BLUE}🔧 Installing dotfiles...${NC}"
echo -e "${BLUE}Dotfiles directory: $DOTFILES_DIR${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup and link files
backup_and_link() {
    local source_file="$1"
    local target_file="$2"
    local backup_name="$(basename "$target_file").backup.$(date +%Y%m%d_%H%M%S)"
    
    # Check if target exists and backup if needed
    if [[ -e "$target_file" ]] && [[ ! -L "$target_file" ]]; then
        echo -e "${YELLOW}📦 Backing up existing $target_file${NC}"
        mv "$target_file" "$BACKUP_DIR/$backup_name"
    elif [[ -L "$target_file" ]]; then
        echo -e "${YELLOW}🔗 Removing existing symlink $target_file${NC}"
        rm "$target_file"
    fi
    
    # Create symlink
    echo -e "${GREEN}🔗 Linking $source_file -> $target_file${NC}"
    ln -sf "$source_file" "$target_file"
}

# Install shell configurations
echo -e "${BLUE}📂 Installing shell configurations...${NC}"
backup_and_link "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"
backup_and_link "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"

# Install git configuration
echo -e "${BLUE}📂 Installing git configuration...${NC}"
backup_and_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Install vim configuration
echo -e "${BLUE}📂 Installing vim configuration...${NC}"
backup_and_link "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

# Create .gitignore_global if it doesn't exist
if [[ ! -f "$HOME/.gitignore_global" ]]; then
    echo -e "${GREEN}📝 Creating .gitignore_global${NC}"
    cat > "$HOME/.gitignore_global" << 'EOF'
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Logs
*.log

# Runtime data
pids
*.pid
*.seed

# Dependency directories
node_modules/
bower_components/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history
EOF
fi

echo ""
echo -e "${GREEN}✅ Dotfiles installation complete!${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo -e "  1. Update your git configuration with your name and email:"
echo -e "     ${BLUE}git config --global user.name \"Your Name\"${NC}"
echo -e "     ${BLUE}git config --global user.email \"your.email@example.com\"${NC}"
echo ""
echo -e "  2. Restart your terminal or run:"
echo -e "     ${BLUE}source ~/.bashrc${NC} (for bash)"
echo -e "     ${BLUE}source ~/.zshrc${NC} (for zsh)"
echo ""
echo -e "  3. Install Oh My Zsh (optional, for enhanced zsh experience):"
echo -e "     ${BLUE}sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"${NC}"
echo ""
echo -e "${GREEN}🎉 Happy coding!${NC}"