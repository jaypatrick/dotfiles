#!/bin/bash
# Platform detection and OS-specific utilities

# Detect the current platform
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if grep -q Microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if running on macOS
is_macos() {
    [[ "$(detect_platform)" == "macos" ]]
}

# Check if running on Linux
is_linux() {
    [[ "$(detect_platform)" == "linux" ]]
}

# Check if running on WSL
is_wsl() {
    [[ "$(detect_platform)" == "wsl" ]]
}

# Check if running on Windows (Git Bash, Cygwin, etc.)
is_windows() {
    [[ "$(detect_platform)" == "windows" ]]
}

# Get package manager
get_package_manager() {
    if command -v brew &> /dev/null; then
        echo "brew"
    elif command -v apt-get &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Install packages using the appropriate package manager
install_packages() {
    local pm=$(get_package_manager)

    case "$pm" in
        brew)
            brew install "$@"
            ;;
        apt)
            sudo apt-get update && sudo apt-get install -y "$@"
            ;;
        yum)
            sudo yum install -y "$@"
            ;;
        dnf)
            sudo dnf install -y "$@"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$@"
            ;;
        *)
            echo "Unknown package manager, cannot install packages"
            return 1
            ;;
    esac
}

# Export platform information
export DOTFILES_PLATFORM="$(detect_platform)"
export DOTFILES_PKG_MANAGER="$(get_package_manager)"
