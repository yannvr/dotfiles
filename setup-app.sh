#!/bin/zsh

# setup-app.sh - Simple app installer for dotfiles
# Installs essential development apps via Homebrew

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
AUTO_YES=false

# Essential productivity apps
APPS=(
    "amphetamine:appstore:Powerful keep-awake utility for macOS"
    "paste:appstore:Advanced clipboard manager with unlimited history and cross-device sync"
)

# Function to log messages
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install an app
install_app() {
    local name="$1"
    local method="$2"
    local description="$3"

    echo ""
    log "Installing $name - $description"

    case $method in
        "cask")
            if brew install --cask "$name"; then
                log_success "$name installed successfully via Homebrew!"
                return 0
            else
                log_error "Failed to install $name via Homebrew"
                return 1
            fi
            ;;
        "appstore")
            log "📱 $name is available on the Mac App Store"
            if [[ "$name" == "amphetamine" ]]; then
                echo "   Please install manually from: https://apps.apple.com/us/app/amphetamine/id937984704"
                echo "   Or use: mas install 937984704 (if mas CLI is installed)"
            elif [[ "$name" == "paste" ]]; then
                echo "   Please install manually from: https://pasteapp.io"
                echo "   Or use: brew install --cask paste (if available via Homebrew)"
            fi
            return 1  # Return 1 to indicate manual installation needed
            ;;
        *)
            log_error "Unknown installation method: $method"
            return 1
            ;;
    esac
}

# Function to check what's already installed
check_installed_apps() {
    log "Checking which apps are already installed..."

    local installed_count=0
    local total_count=${#APPS[@]}

    echo ""
    for app_info in "${APPS[@]}"; do
        IFS=':' read -r name method description <<< "$app_info"

        if [[ "$method" == "appstore" ]]; then
            # Check if App Store app is installed by looking for the app in /Applications
            local app_path="/Applications/$name.app"
            if [[ "$name" == "amphetamine" ]]; then
                app_path="/Applications/Amphetamine.app"
            elif [[ "$name" == "paste" ]]; then
                app_path="/Applications/Paste.app"
            fi

            if [[ -d "$app_path" ]]; then
                echo -e "  ✅ $name - $description"
                ((installed_count++))
            else
                echo -e "  ❌ $name - $description (Mac App Store)"
            fi
        else
            if command_exists "$name"; then
                echo -e "  ✅ $name - $description"
                ((installed_count++))
            else
                echo -e "  ❌ $name - $description"
            fi
        fi
    done

    echo ""
    log_success "$installed_count/$total_count apps already installed"
    return $((total_count - installed_count))
}

# Function to install all missing apps
install_missing_apps() {
    local installed_count=0
    local total_missing=0

    # Count missing apps first
    for app_info in "${APPS[@]}"; do
        IFS=':' read -r name method description <<< "$app_info"

        if [[ "$method" == "appstore" ]]; then
            local app_path="/Applications/$name.app"
            if [[ "$name" == "amphetamine" ]]; then
                app_path="/Applications/Amphetamine.app"
            elif [[ "$name" == "paste" ]]; then
                app_path="/Applications/Paste.app"
            fi

            if [[ ! -d "$app_path" ]]; then
                ((total_missing++))
            fi
        else
            if ! command_exists "$name"; then
                ((total_missing++))
            fi
        fi
    done

    if [[ $total_missing -eq 0 ]]; then
        log_success "All apps are already installed! 🎉"
        return 0
    fi

    log "Installing $total_missing missing apps..."

    for app_info in "${APPS[@]}"; do
        IFS=':' read -r name method description <<< "$app_info"

        if [[ "$method" == "appstore" ]]; then
            # Check if App Store app is installed
            local app_path="/Applications/$name.app"
            if [[ "$name" == "amphetamine" ]]; then
                app_path="/Applications/Amphetamine.app"
            elif [[ "$name" == "paste" ]]; then
                app_path="/Applications/Paste.app"
            fi

            if [[ ! -d "$app_path" ]]; then
                echo ""
                echo "[$((installed_count + 1))/$total_missing] Installing $name..."

                if install_app "$name" "$method" "$description"; then
                    ((installed_count++))
                fi
            fi
        else
            # Check if command-line app is installed
            if ! command_exists "$name"; then
                echo ""
                echo "[$((installed_count + 1))/$total_missing] Installing $name..."

                if install_app "$name" "$method" "$description"; then
                    ((installed_count++))
                fi
            fi
        fi
    done

    echo ""
    log_success "Installed $installed_count/$total_missing apps successfully!"
}

# Function to show available apps
show_available_apps() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                          📦 Available Apps                                ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    for app_info in "${APPS[@]}"; do
        IFS=':' read -r name method description <<< "$app_info"

        if [[ "$method" == "appstore" ]]; then
            # Check if App Store app is installed by looking for the app in /Applications
            local app_path="/Applications/$name.app"
            if [[ "$name" == "amphetamine" ]]; then
                app_path="/Applications/Amphetamine.app"
            elif [[ "$name" == "paste" ]]; then
                app_path="/Applications/Paste.app"
            fi

            if [[ -d "$app_path" ]]; then
                echo -e "  ✅ $name - $description"
            else
                echo -e "  ❌ $name - $description (Mac App Store)"
            fi
        else
            if command_exists "$name"; then
                echo -e "  ✅ $name - $description"
            else
                echo -e "  ❌ $name - $description"
            fi
        fi
    done

    echo ""
    echo "These productivity apps will enhance your macOS experience and complement built-in features."
}

# Function to show usage
show_usage() {
    cat << EOF
setup-app.sh - Productivity apps installer for macOS

USAGE:
    ./setup-app.sh [OPTIONS]

OPTIONS:
    --help, -h          Show this help message
    --yes, -y          Install all missing apps automatically
    --check-only       Only check and show status, don't install

DESCRIPTION:
    This script installs essential productivity apps via Homebrew Cask.
    These apps enhance your macOS experience and complement built-in features.

    Designed for local macOS environments - automatically skipped
    for remote/bastion installations to avoid installing GUI apps on servers.

    It can be run standalone or integrated into your main install.sh script.

EXAMPLES:
    ./setup-app.sh                    # Interactive installation
    ./setup-app.sh --yes             # Install all automatically
    ./setup-app.sh --check-only      # Just check status

PRODUCTIVITY APPS INCLUDED:
    • Amphetamine - Powerful keep-awake utility ([apps.apple.com/us/app/amphetamine/id937984704](https://apps.apple.com/us/app/amphetamine/id937984704))
    • Paste - Advanced clipboard manager with unlimited history ([pasteapp.io](https://pasteapp.io))

EOF
}

# Main function
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_usage
                exit 0
                ;;
            --yes|-y)
                AUTO_YES=true
                shift
                ;;
            --check-only)
                CHECK_ONLY=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    📦 Dotfiles App Installer                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Check if brew is available
    if ! command_exists "brew"; then
        log_error "Homebrew not found. Please install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    # Show available apps
    show_available_apps

    # If check-only mode, exit here
    if [[ "$CHECK_ONLY" == "true" ]]; then
        exit 0
    fi

    # Check what's installed and offer installation
    if [[ "$AUTO_YES" == "true" ]]; then
        install_missing_apps
    else
        echo ""
        echo "Options:"
        echo "1) Install all missing apps automatically"
        echo "2) Show status only (don't install)"
        echo ""

        echo -n "Choose option (1-2): "
        read choice

        case $choice in
            1)
                install_missing_apps
                ;;
            2)
                log "Showing status only"
                ;;
            *)
                log "Invalid choice. Showing status only."
                ;;
        esac
    fi

    echo ""
    log_success "Productivity apps setup complete! Enjoy your enhanced macOS experience! 🚀"
}

# Run main function
main "$@"
