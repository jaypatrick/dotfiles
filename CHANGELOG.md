# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-11-25

### Added

#### Core Infrastructure
- **Platform detection library** (`lib/platform.sh`) - Automatic detection of Linux, macOS, WSL, and Windows
- **Modular shell structure** - Organized shell configuration into reusable components

#### Shell Configuration
- **Environment variables file** (`shell/env`) - Centralized environment variable management
- **Shell functions library** (`shell/functions`) - 20+ useful functions (mkcd, extract, weather, backup, etc.)
- **PATH management** (`shell/path`) - Smart PATH configuration with automatic tool detection
- **Shell completion** (`shell/completion`) - Auto-completion for Git, Docker, kubectl, etc.
- **Readline configuration** (`shell/.inputrc`) - Better history search and completion behavior

#### Tools & Applications
- **Tmux configuration** (`tmux/.tmux.conf`) - Complete tmux setup with TPM, sensible keybindings, and plugins
- **SSH configuration** (`ssh/config`) - Secure SSH defaults with connection multiplexing
- **EditorConfig** (`.editorconfig`) - Consistent coding styles across all editors

#### Git Enhancements
- **Improved git configuration** - FSMonitor, untracked cache, rerere, better diff algorithm
- **Commit template** (`git/.gitmessage`) - Conventional commits format with guidelines
- **Pre-commit hook** (`git/hooks/pre-commit`) - Validates for whitespace, debug statements, and secrets
- **Git hooks README** - Documentation for hooks usage and customization

#### Installation & Management
- **Interactive installation** - Choose what to install with prompts
- **Dry-run mode** (`--dry-run`) - Preview changes without applying them
- **Non-interactive mode** (`-y`) - Install everything without prompts
- **Installation validation** - Automatic checks after installation
- **Dependency checking** - Verify required tools before installation
- **Neovim support** - Automatic configuration for Neovim
- **Bootstrap script** (`bootstrap.sh`) - Install development tools (NVM, Rust, Vim-Plug, etc.)
- **Update script** (`update.sh`) - Pull latest changes and re-run installation

#### Documentation
- **Comprehensive README** - Complete documentation with examples and troubleshooting
- **Secrets management guide** (`SECRETS.md`) - Best practices for handling sensitive data
- **This CHANGELOG** - Track all changes to the project

### Changed

#### Shell Configuration
- **.bashrc** - Rewritten for modularity and macOS compatibility
  - Added platform-specific color support
  - Fixed macOS `dircolors` issue
  - Load all modular components (env, path, functions, completion)
  - Increased history size to 10000

- **.zshrc** - Enhanced with modular structure
  - Load platform detection, env, path, functions, completion
  - Better history options (EXTENDED_HISTORY, HIST_REDUCE_BLANKS)
  - Modular configuration matching Bash

#### Git Configuration
- **Enhanced .gitconfig** with modern settings:
  - Performance: `untrackedCache`, `fsmonitor`
  - Better algorithms: `histogram` diff, `diff3` conflict style
  - Auto-prune deleted branches
  - Show stash count in status
  - Auto-stash during rebase
  - Rerere enabled
  - Git LFS support
  - Include local gitconfig

#### Installation
- **install.sh** - Complete rewrite with:
  - Command-line argument parsing (`--dry-run`, `-y`, `--help`)
  - Interactive component selection
  - Platform detection integration
  - Validation function
  - Better error handling
  - Git user configuration prompt
  - SSH directory permissions
  - Create required directories

### Enhanced

#### Cross-Platform Support
- **macOS compatibility** - Proper color support, Homebrew paths
- **Linux support** - All major distributions (Debian, Fedora, Arch)
- **WSL detection** - Automatic WSL environment detection
- **Package manager detection** - Support for apt, yum, dnf, pacman, brew

#### Security
- **Pre-commit hook** - Prevent committing sensitive files
- **SSH config** - Modern ciphers and security settings
- **Local configuration pattern** - Keep secrets out of repository

#### Developer Experience
- **Better error messages** - Clear, actionable error messages
- **Colored output** - Visual feedback during installation
- **Progress indicators** - Show what's being installed
- **Validation** - Verify installation success

### Fixed
- **macOS color support** - Use `CLICOLOR` and `LSCOLORS` instead of `dircolors`
- **Symlink handling** - Properly handle existing symlinks
- **Permission issues** - Set correct permissions for SSH config

## [1.0.0] - 2025-11-25

### Added
- Initial dotfiles implementation
- Basic shell configuration (Bash and Zsh)
- Git configuration with aliases
- Vim configuration
- Installation and uninstallation scripts
- Basic README

---

## Categories

Changes are categorized as follows:
- **Added** - New features or files
- **Changed** - Changes to existing functionality
- **Deprecated** - Soon-to-be-removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security improvements
- **Enhanced** - Improvements to existing features

## Version Format

We use Semantic Versioning (MAJOR.MINOR.PATCH):
- **MAJOR** - Incompatible changes
- **MINOR** - Backward-compatible new features
- **PATCH** - Backward-compatible bug fixes

## Links

- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
