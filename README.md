# dotfiles

Personal configuration files and development environment setup.

## Features

- Shell configuration (Bash and Zsh)
- Git configuration with useful aliases
- Vim/Neovim configuration
- Cross-platform compatibility
- Easy installation and backup

## Quick Start

```bash
git clone https://github.com/jaypatrick/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

```
├── install.sh          # Installation script
├── uninstall.sh        # Uninstallation script
├── shell/              # Shell configurations
│   ├── .bashrc
│   ├── .zshrc
│   └── aliases
├── git/                # Git configuration
│   └── .gitconfig
├── vim/                # Vim configuration
│   └── .vimrc
└── backups/            # Backup directory (auto-created)
```

## Installation

The installation script will:
1. Backup existing dotfiles to `~/.dotfiles/backups/`
2. Create symlinks from your home directory to these dotfiles
3. Source the new configurations

## Uninstallation

To remove all symlinks and restore backups:

```bash
./uninstall.sh
```

## Customization

Feel free to modify any configuration files to suit your preferences. After making changes, the configurations will be automatically active since they're symlinked to your home directory.