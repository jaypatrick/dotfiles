#!/bin/bash

# Dotfiles installation script with advanced features

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

# Installation options
DRY_RUN=false
INTERACTIVE=true
INSTALL_SHELL=true
INSTALL_GIT=true
INSTALL_VIM=true
INSTALL_TMUX=true
INSTALL_SSH=true
INSTALL_INPUTRC=true
INSTALL_EDITORCONFIG=true

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            echo -e "${YELLOW}Running in dry-run mode (no changes will be made)${NC}"
            shift
            ;;
        --non-interactive|-y)
            INTERACTIVE=false
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run              Preview changes without making them"
            echo "  --non-interactive, -y  Skip all prompts (install everything)"
            echo "  --help, -h             Show this help message"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Load platform detection
source "$DOTFILES_DIR/lib/platform.sh"

echo -e "${BLUE}🔧 Installing dotfiles...${NC}"
echo -e "${BLUE}Dotfiles directory: $DOTFILES_DIR${NC}"
echo -e "${BLUE}Platform: $DOTFILES_PLATFORM${NC}"
echo -e "${BLUE}Package Manager: $DOTFILES_PKG_MANAGER${NC}"
echo ""

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"
    local missing_deps=()

    local required_commands=("git" "curl")

    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${RED}Missing required dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Install them with:${NC}"
        case "$DOTFILES_PKG_MANAGER" in
            brew) echo "  brew install ${missing_deps[*]}" ;;
            apt) echo "  sudo apt-get install ${missing_deps[*]}" ;;
            yum) echo "  sudo yum install ${missing_deps[*]}" ;;
            dnf) echo "  sudo dnf install ${missing_deps[*]}" ;;
            pacman) echo "  sudo pacman -S ${missing_deps[*]}" ;;
        esac
        return 1
    fi

    echo -e "${GREEN}✅ All dependencies satisfied${NC}"
    return 0
}

# Interactive configuration
if [[ "$INTERACTIVE" == "true" ]]; then
    echo -e "${YELLOW}Select what to install:${NC}"
    echo "Press Enter to accept defaults or type 'n' to skip"
    echo ""

    read -p "Install shell configurations (bash, zsh)? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_SHELL=false

    read -p "Install git configuration? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_GIT=false

    read -p "Install vim/nvim configuration? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_VIM=false

    read -p "Install tmux configuration? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_TMUX=false

    read -p "Install SSH configuration? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_SSH=false

    read -p "Install inputrc (readline) configuration? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_INPUTRC=false

    read -p "Install editorconfig? [Y/n]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && INSTALL_EDITORCONFIG=false

    echo ""
fi

# Check dependencies (unless in dry-run mode)
if [[ "$DRY_RUN" == "false" ]]; then
    if ! check_dependencies; then
        echo -e "${RED}Please install missing dependencies and try again${NC}"
        exit 1
    fi
    echo ""
fi

# Create backup directory
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "$BACKUP_DIR"
    # Create SSH sockets directory for multiplexing
    mkdir -p "$HOME/.ssh/sockets"
fi

# Function to backup and link files
backup_and_link() {
    local source_file="$1"
    local target_file="$2"
    local backup_name="$(basename "$target_file").backup.$(date +%Y%m%d_%H%M%S)"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BLUE}[DRY-RUN] Would link: $source_file -> $target_file${NC}"
        return
    fi

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
if [[ "$INSTALL_SHELL" == "true" ]]; then
    echo -e "${BLUE}📂 Installing shell configurations...${NC}"
    backup_and_link "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"
    backup_and_link "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
fi

# Install git configuration
if [[ "$INSTALL_GIT" == "true" ]]; then
    echo -e "${BLUE}📂 Installing git configuration...${NC}"
    backup_and_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    backup_and_link "$DOTFILES_DIR/git/.gitmessage" "$HOME/.gitmessage"

    # Set up git hooks path
    if [[ "$DRY_RUN" == "false" ]]; then
        git config --global core.hooksPath "$DOTFILES_DIR/git/hooks"
        echo -e "${GREEN}✅ Git hooks configured${NC}"
    else
        echo -e "${BLUE}[DRY-RUN] Would configure git hooks path${NC}"
    fi

    # Prompt for git user configuration
    if [[ "$INTERACTIVE" == "true" ]] && [[ "$DRY_RUN" == "false" ]]; then
        echo ""
        read -p "Configure git user.name and user.email now? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter your name: " git_name
            read -p "Enter your email: " git_email
            git config --global user.name "$git_name"
            git config --global user.email "$git_email"
            echo -e "${GREEN}✅ Git user configured${NC}"
        fi
    fi
fi

# Install vim configuration
if [[ "$INSTALL_VIM" == "true" ]]; then
    echo -e "${BLUE}📂 Installing vim configuration...${NC}"
    backup_and_link "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

    # Create required vim directories
    if [[ "$DRY_RUN" == "false" ]]; then
        mkdir -p "$HOME/.vim/"{backup,swap,undo}
        echo -e "${GREEN}✅ Vim directories created${NC}"
    fi

    # Neovim support
    if command -v nvim &> /dev/null || [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BLUE}Setting up Neovim configuration...${NC}"
        if [[ "$DRY_RUN" == "false" ]]; then
            mkdir -p "$HOME/.config/nvim"
            backup_and_link "$DOTFILES_DIR/vim/.vimrc" "$HOME/.config/nvim/init.vim"
            echo -e "${GREEN}✅ Neovim configured${NC}"
        else
            echo -e "${BLUE}[DRY-RUN] Would configure Neovim${NC}"
        fi
    fi
fi

# Install tmux configuration
if [[ "$INSTALL_TMUX" == "true" ]]; then
    echo -e "${BLUE}📂 Installing tmux configuration...${NC}"
    backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Install SSH configuration
if [[ "$INSTALL_SSH" == "true" ]]; then
    echo -e "${BLUE}📂 Installing SSH configuration...${NC}"
    if [[ "$DRY_RUN" == "false" ]]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
    fi
    backup_and_link "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    if [[ "$DRY_RUN" == "false" ]]; then
        chmod 600 "$HOME/.ssh/config"
    fi
fi

# Install inputrc
if [[ "$INSTALL_INPUTRC" == "true" ]]; then
    echo -e "${BLUE}📂 Installing inputrc configuration...${NC}"
    backup_and_link "$DOTFILES_DIR/shell/.inputrc" "$HOME/.inputrc"
fi

# Install editorconfig
if [[ "$INSTALL_EDITORCONFIG" == "true" ]]; then
    echo -e "${BLUE}📂 Installing editorconfig...${NC}"
    backup_and_link "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
fi

# Create .gitignore_global if it doesn't exist
if [[ "$INSTALL_GIT" == "true" ]] && [[ ! -f "$HOME/.gitignore_global" ]] && [[ "$DRY_RUN" == "false" ]]; then
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

# Python
__pycache__/
*.py[cod]
*$py.class
.pytest_cache/
.coverage

# Ruby
*.gem
.bundle/

# Rust
target/

# Go
/vendor/
EOF
fi

# Create local environment template
if [[ ! -f "$HOME/.env.local" ]] && [[ "$DRY_RUN" == "false" ]]; then
    echo -e "${GREEN}📝 Creating .env.local template${NC}"
    cat > "$HOME/.env.local" << 'EOF'
# Local environment variables (not tracked in git)
# Add your machine-specific environment variables here

# Example:
# export AWS_PROFILE=myprofile
# export DATABASE_URL=postgres://localhost/mydb
# export OPENAI_API_KEY=sk-...
EOF
fi

# Validation function
validate_installation() {
    echo -e "${BLUE}Validating installation...${NC}"
    local errors=0

    local files_to_check=()

    [[ "$INSTALL_SHELL" == "true" ]] && files_to_check+=("$HOME/.bashrc" "$HOME/.zshrc")
    [[ "$INSTALL_GIT" == "true" ]] && files_to_check+=("$HOME/.gitconfig")
    [[ "$INSTALL_VIM" == "true" ]] && files_to_check+=("$HOME/.vimrc")
    [[ "$INSTALL_TMUX" == "true" ]] && files_to_check+=("$HOME/.tmux.conf")
    [[ "$INSTALL_SSH" == "true" ]] && files_to_check+=("$HOME/.ssh/config")
    [[ "$INSTALL_INPUTRC" == "true" ]] && files_to_check+=("$HOME/.inputrc")
    [[ "$INSTALL_EDITORCONFIG" == "true" ]] && files_to_check+=("$HOME/.editorconfig")

    for file in "${files_to_check[@]}"; do
        if [[ ! -L "$file" ]]; then
            echo -e "${RED}✗ $file is not a symlink${NC}"
            ((errors++))
        else
            echo -e "${GREEN}✓ $file${NC}"
        fi
    done

    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✅ All checks passed!${NC}"
        return 0
    else
        echo -e "${RED}❌ $errors error(s) found${NC}"
        return 1
    fi
}

# Run validation unless in dry-run mode
if [[ "$DRY_RUN" == "false" ]]; then
    echo ""
    validate_installation
fi

echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${BLUE}Dry-run complete! Run without --dry-run to apply changes.${NC}"
else
    echo -e "${GREEN}✅ Dotfiles installation complete!${NC}"
fi
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"

if [[ "$INSTALL_GIT" == "true" ]] && [[ "$INTERACTIVE" == "false" ]]; then
    echo -e "  1. Update your git configuration with your name and email:"
    echo -e "     ${BLUE}git config --global user.name \"Your Name\"${NC}"
    echo -e "     ${BLUE}git config --global user.email \"your.email@example.com\"${NC}"
    echo ""
fi

echo -e "  • Restart your terminal or run:"
if [[ "$INSTALL_SHELL" == "true" ]]; then
    echo -e "     ${BLUE}source ~/.bashrc${NC} (for bash)"
    echo -e "     ${BLUE}source ~/.zshrc${NC} (for zsh)"
fi
echo ""

echo -e "  • Check out the README for more customization options"
echo -e "  • Run ${BLUE}./bootstrap.sh${NC} to install additional development tools"
echo -e "  • Run ${BLUE}./update.sh${NC} to pull the latest changes"
echo ""
echo -e "${GREEN}🎉 Happy coding!${NC}"
