#!/bin/bash

# Bootstrap script to install common development tools

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load platform detection
source "$DOTFILES_DIR/lib/platform.sh"

echo -e "${BLUE}🚀 Bootstrapping development environment...${NC}"
echo -e "${BLUE}Platform: $DOTFILES_PLATFORM${NC}"
echo -e "${BLUE}Package Manager: $DOTFILES_PKG_MANAGER${NC}"
echo ""

# Common packages to install
PACKAGES=(
    "git"
    "vim"
    "curl"
    "wget"
    "tmux"
    "htop"
    "tree"
    "jq"
    "ripgrep"
    "fzf"
)

# Ask user which packages to install
echo -e "${YELLOW}Select packages to install:${NC}"
echo "1. All recommended packages"
echo "2. Minimal (git, vim, curl, wget)"
echo "3. Custom selection"
echo "4. Skip package installation"
read -p "Choice [1-4]: " choice

case $choice in
    1)
        echo -e "${GREEN}Installing all recommended packages...${NC}"
        INSTALL_PACKAGES=("${PACKAGES[@]}")
        ;;
    2)
        echo -e "${GREEN}Installing minimal packages...${NC}"
        INSTALL_PACKAGES=("git" "vim" "curl" "wget")
        ;;
    3)
        echo -e "${GREEN}Select packages (space-separated numbers):${NC}"
        for i in "${!PACKAGES[@]}"; do
            echo "$((i+1)). ${PACKAGES[$i]}"
        done
        read -p "Selection: " selections
        INSTALL_PACKAGES=()
        for sel in $selections; do
            idx=$((sel-1))
            if [[ $idx -ge 0 && $idx -lt ${#PACKAGES[@]} ]]; then
                INSTALL_PACKAGES+=("${PACKAGES[$idx]}")
            fi
        done
        ;;
    4)
        echo -e "${YELLOW}Skipping package installation${NC}"
        INSTALL_PACKAGES=()
        ;;
    *)
        echo -e "${RED}Invalid choice, skipping package installation${NC}"
        INSTALL_PACKAGES=()
        ;;
esac

# Install selected packages
if [[ ${#INSTALL_PACKAGES[@]} -gt 0 ]]; then
    echo -e "${BLUE}Installing: ${INSTALL_PACKAGES[*]}${NC}"

    case "$DOTFILES_PKG_MANAGER" in
        brew)
            brew install "${INSTALL_PACKAGES[@]}"
            ;;
        apt)
            sudo apt-get update
            sudo apt-get install -y "${INSTALL_PACKAGES[@]}"
            ;;
        yum)
            sudo yum install -y "${INSTALL_PACKAGES[@]}"
            ;;
        dnf)
            sudo dnf install -y "${INSTALL_PACKAGES[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${INSTALL_PACKAGES[@]}"
            ;;
        *)
            echo -e "${RED}Unknown package manager, cannot install packages${NC}"
            ;;
    esac

    echo -e "${GREEN}✅ Packages installed${NC}"
fi

# Install Oh My Zsh (optional)
if command -v zsh &> /dev/null; then
    read -p "$(echo -e "${YELLOW}Install Oh My Zsh? (y/N): ${NC}")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            echo -e "${GREEN}✅ Oh My Zsh installed${NC}"
        else
            echo -e "${YELLOW}Oh My Zsh already installed${NC}"
        fi
    fi
fi

# Install Tmux Plugin Manager
read -p "$(echo -e "${YELLOW}Install Tmux Plugin Manager (TPM)? (y/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        echo -e "${GREEN}✅ TPM installed${NC}"
        echo -e "${BLUE}Run 'tmux source ~/.tmux.conf' and press prefix + I to install plugins${NC}"
    else
        echo -e "${YELLOW}TPM already installed${NC}"
    fi
fi

# Install Vim-Plug (Vim plugin manager)
read -p "$(echo -e "${YELLOW}Install Vim-Plug? (y/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo -e "${GREEN}✅ Vim-Plug installed${NC}"
    else
        echo -e "${YELLOW}Vim-Plug already installed${NC}"
    fi
fi

# Install NVM (Node Version Manager)
read -p "$(echo -e "${YELLOW}Install NVM (Node Version Manager)? (y/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -d "$HOME/.nvm" ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        echo -e "${GREEN}✅ NVM installed${NC}"
    else
        echo -e "${YELLOW}NVM already installed${NC}"
    fi
fi

# Install Rust (rustup)
read -p "$(echo -e "${YELLOW}Install Rust (rustup)? (y/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        echo -e "${GREEN}✅ Rust installed${NC}"
    else
        echo -e "${YELLOW}Rust already installed${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Bootstrap complete!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Run ./install.sh to set up dotfiles"
echo -e "  2. Restart your terminal"
echo ""
