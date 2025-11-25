# dotfiles

Modern, modular dotfiles for productive development across Linux, macOS, and WSL.

[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20wsl-blue)]()
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-green)]()
[![License](https://img.shields.io/badge/license-MIT-orange)]()

## ✨ Features

### Shell Configuration
- 🐚 **Modular shell setup** - Bash and Zsh with organized, reusable components
- 🎨 **Cross-platform compatibility** - Works seamlessly on Linux, macOS, and WSL
- 🚀 **Smart PATH management** - Automatic detection of language tools (Rust, Go, Node, Python, etc.)
- 🔧 **Extensive functions library** - 20+ useful shell functions (extract, mkcd, weather, etc.)
- 📝 **Intelligent completions** - Auto-completion for Git, Docker, kubectl, and more
- 🎯 **Custom prompt** - Git-aware prompt with branch information

### Git Configuration
- 📊 **Powerful aliases** - Visual log graphs, branch cleanup, and shortcuts
- 🎨 **Colorized output** - Beautiful diffs and status displays
- 🪝 **Pre-commit hooks** - Prevent common mistakes (trailing whitespace, debug statements, secrets)
- 📝 **Commit template** - Conventional commits format with helpful guidelines
- ⚡ **Performance optimizations** - FSMonitor, untracked cache, and better algorithms
- 🔄 **Rerere enabled** - Remember and replay conflict resolutions

### Editor Configuration
- ⚡ **Vim/Neovim setup** - Sensible defaults with persistent undo and backups
- 📐 **EditorConfig** - Consistent coding styles across all editors
- 🎨 **Language-specific settings** - Tab sizes for Python, JavaScript, Go, etc.

### Tools
- 🖥️ **Tmux configuration** - Terminal multiplexing with sensible keybindings
- 🔒 **SSH config** - Secure defaults with connection multiplexing
- 📖 **Readline (inputrc)** - Better history search and completion behavior
- 🔐 **Secrets management** - Safe patterns for handling sensitive data

### Installation
- 🎯 **Interactive installer** - Choose what to install
- 🧪 **Dry-run mode** - Preview changes before applying
- ✅ **Validation** - Automatic checks after installation
- 🔄 **Update script** - Easy updates from the repository
- 🚀 **Bootstrap script** - Install common development tools

## 🚀 Quick Start

### Basic Installation

```bash
# Clone the repository
git clone https://github.com/jaypatrick/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installer (interactive mode)
./install.sh
```

### Options

```bash
# Preview changes without applying them
./install.sh --dry-run

# Non-interactive mode (install everything)
./install.sh -y

# Show help
./install.sh --help
```

### Bootstrap Development Environment

```bash
# Install common development tools
./bootstrap.sh
```

This will prompt you to install:
- Essential packages (git, vim, curl, wget, tmux, etc.)
- Oh My Zsh (if using Zsh)
- Tmux Plugin Manager
- Vim-Plug (Vim plugin manager)
- NVM (Node Version Manager)
- Rust (rustup)

## 📁 Repository Structure

```
dotfiles/
├── install.sh          # Main installation script
├── uninstall.sh        # Uninstallation script
├── update.sh           # Update from repository
├── bootstrap.sh        # Install development tools
│
├── lib/                # Utility libraries
│   └── platform.sh     # Platform detection
│
├── shell/              # Shell configurations
│   ├── .bashrc         # Bash configuration
│   ├── .zshrc          # Zsh configuration
│   ├── aliases         # Command aliases
│   ├── env             # Environment variables
│   ├── functions       # Useful shell functions
│   ├── path            # PATH management
│   ├── prompt          # Custom prompt
│   ├── completion      # Auto-completion
│   └── .inputrc        # Readline configuration
│
├── git/                # Git configuration
│   ├── .gitconfig      # Git settings and aliases
│   ├── .gitmessage     # Commit message template
│   └── hooks/          # Git hooks
│       ├── pre-commit  # Pre-commit validation
│       └── README.md   # Hooks documentation
│
├── vim/                # Vim/Neovim configuration
│   └── .vimrc          # Vim settings
│
├── tmux/               # Tmux configuration
│   └── .tmux.conf      # Tmux settings
│
├── ssh/                # SSH configuration
│   └── config          # SSH client settings
│
├── .editorconfig       # EditorConfig for all editors
├── .gitignore          # Files to ignore
├── SECRETS.md          # Secrets management guide
├── CHANGELOG.md        # Change history
└── backups/            # Backup directory (auto-created)
```

## 🔧 Configuration Details

### Shell Features

#### Aliases
Over 50 useful aliases organized by category:
- **Navigation**: `..`, `...`, `~`, `-`
- **Git**: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`
- **Docker**: `d`, `dc`, `docker-clean`
- **Kubernetes**: `k`, `kgp`, `kgs`, `kgd`
- **System**: `ll`, `la`, `df -h`, `free -h`

#### Functions
Powerful shell functions:
- `mkcd` - Create directory and cd into it
- `extract` - Extract any archive format
- `weather` - Get weather forecast
- `serve` - HTTP server in current directory
- `backup` - Create timestamped backup of a file
- `note` - Quick note taking
- Many more!

#### PATH Management
Automatically adds to PATH if directories exist:
- `~/bin`, `~/.local/bin`
- Homebrew (macOS)
- Rust, Go, Node, Python, Ruby, PHP, Deno
- Snap (Linux)

### Git Configuration

#### Useful Aliases
- `git lg` - Beautiful colored commit graph
- `git cleanup` - Delete merged branches
- `git unstage` - Unstage files
- `git last` - Show last commit

#### Features
- Rerere enabled (remember conflict resolutions)
- Auto-prune deleted remote branches
- Better diff algorithm (histogram)
- Detect renames and copies
- Show stash count in status
- Auto-stash during rebase

### Tmux Configuration

Key Features:
- Prefix changed to `Ctrl+A` (more ergonomic)
- Split panes with `|` and `-`
- Vim-style pane navigation
- Mouse support enabled
- Plugin manager (TPM) configured
- Session persistence (tmux-resurrect)

### SSH Configuration

Security Features:
- Connection multiplexing (faster connections)
- Modern ciphers and key exchange algorithms
- Keep-alive to prevent disconnections
- Visual host key verification

## 🎨 Customization

### Local Configuration Files

Create these files for machine-specific settings (not tracked in git):

- `~/.env.local` - Environment variables and secrets
- `~/.bashrc.local` - Bash-specific local config
- `~/.zshrc.local` - Zsh-specific local config
- `~/.gitconfig.local` - Git settings (work email, signing key)
- `~/.path.local` - Additional PATH entries
- `~/.ssh/config.local` - Private SSH hosts

See [SECRETS.md](SECRETS.md) for detailed secrets management guide.

### Modifying Configurations

Since configurations are symlinked, you can edit them directly:

```bash
# Edit in the repository
cd ~/.dotfiles
vim shell/aliases

# Or edit the symlink (same result)
vim ~/.bashrc
```

Changes take effect after:
```bash
source ~/.bashrc  # For Bash
source ~/.zshrc   # For Zsh
```

## 🔄 Updating

```bash
cd ~/.dotfiles
./update.sh
```

This will:
1. Stash any local changes
2. Pull latest from repository
3. Restore your changes
4. Optionally re-run installation

## 🗑️ Uninstallation

```bash
cd ~/.dotfiles
./uninstall.sh
```

This will:
1. Remove all symlinks
2. Restore backed up files
3. Preserve backups in `~/.dotfiles/backups/`

## 🧪 Testing

Test your installation:

```bash
# Preview what would be installed
./install.sh --dry-run

# Check if symlinks are correct
ls -la ~/ | grep "\.dotfiles"

# Verify shell functions
type mkcd extract weather

# Test git aliases
git lg -5
```

## 📚 Documentation

- **[SECRETS.md](SECRETS.md)** - Managing sensitive information
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and changes
- **[git/hooks/README.md](git/hooks/README.md)** - Git hooks documentation

## 💡 Tips & Tricks

### Shell Functions

```bash
# Extract any archive
extract file.tar.gz

# Create directory and enter it
mkcd ~/projects/new-project

# Get weather forecast
weather london

# Start HTTP server
serve 8080

# Create timestamped backup
backup important-file.txt

# Quick notes
note "Remember to review PR #123"
```

### Git Workflow

```bash
# Beautiful commit history
git lg

# Clean up merged branches
git cleanup

# View diff with better algorithm
git diff

# Create branch and switch
git checkout -b feature/new-feature
```

### Tmux

```bash
# Start tmux
tmux

# Prefix key: Ctrl+A (instead of Ctrl+B)
# Split horizontal: Prefix + |
# Split vertical: Prefix + -
# Navigate panes: Prefix + h/j/k/l (or Ctrl+Arrow)
# Reload config: Prefix + r
```

## 🐛 Troubleshooting

### Shell not loading new config

```bash
# Ensure symlinks are created
ls -la ~/.bashrc ~/.zshrc

# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc

# Check for errors
bash -x ~/.bashrc
```

### Git hooks not running

```bash
# Verify hooks path
git config --global core.hooksPath

# Check hook permissions
ls -la ~/.dotfiles/git/hooks/pre-commit
chmod +x ~/.dotfiles/git/hooks/pre-commit
```

### SSH config issues

```bash
# Verify SSH config syntax
ssh -G hostname

# Check permissions
chmod 600 ~/.ssh/config
chmod 700 ~/.ssh
```

## 🤝 Contributing

Feel free to fork and customize for your needs! If you find bugs or have suggestions:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

MIT License - Feel free to use and modify as you wish.

## 🙏 Acknowledgments

Inspired by dotfiles repositories from:
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Paul Irish](https://github.com/paulirish/dotfiles)
- [Thoughtbot](https://github.com/thoughtbot/dotfiles)

## 📞 Support

- 📖 Check the documentation files
- 🐛 Open an issue for bugs
- 💡 Open a discussion for questions

---

**Happy hacking!** 🚀
