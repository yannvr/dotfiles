#!/bin/zsh

# setup-tools.sh - Interactive tool installer for dotfiles aliases
# This script helps users install the tools referenced in the aliases

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIASES_FILE="$DOTFILES_DIR/.zshrc.alias"
VERBOSE=false
AUTO_YES=false

# Tool definitions with installation commands, descriptions, and homepages
declare -A TOOLS
declare -A TOOL_DESCRIPTIONS
declare -A TOOL_HOMEPAGES

# Core power dev tools
TOOLS["bat"]="brew install bat"
TOOL_DESCRIPTIONS["bat"]="A cat clone with syntax highlighting and Git integration"
TOOL_HOMEPAGES["bat"]="https://github.com/sharkdp/bat"

TOOLS["eza"]="brew install eza"
TOOL_DESCRIPTIONS["eza"]="Modern, maintained replacement for ls"
TOOL_HOMEPAGES["eza"]="https://github.com/eza-community/eza"

TOOLS["fd"]="brew install fd"
TOOL_DESCRIPTIONS["fd"]="Simple, fast and user-friendly alternative to find"
TOOL_HOMEPAGES["fd"]="https://github.com/sharkdp/fd"

TOOLS["fzf"]="brew install fzf"
TOOL_DESCRIPTIONS["fzf"]="Command-line fuzzy finder written in Go"
TOOL_HOMEPAGES["fzf"]="https://github.com/junegunn/fzf"

TOOLS["tldr"]="brew install tldr"
TOOL_DESCRIPTIONS["tldr"]="Simplified and community-driven man pages"
TOOL_HOMEPAGES["tldr"]="https://github.com/tldr-pages/tldr"

TOOLS["gh"]="brew install gh"
TOOL_DESCRIPTIONS["gh"]="GitHub's official command line tool"
TOOL_HOMEPAGES["gh"]="https://cli.github.com"

TOOLS["jq"]="brew install jq"
TOOL_DESCRIPTIONS["jq"]="Command-line JSON processor"
TOOL_HOMEPAGES["jq"]="https://stedolan.github.io/jq"

TOOLS["htop"]="brew install htop"
TOOL_DESCRIPTIONS["htop"]="Interactive process viewer"
TOOL_HOMEPAGES["htop"]="https://htop.dev"

TOOLS["ripgrep"]="brew install ripgrep"
TOOL_DESCRIPTIONS["ripgrep"]="Ultra-fast text search tool"
TOOL_HOMEPAGES["ripgrep"]="https://github.com/BurntSushi/ripgrep"

TOOLS["starship"]="brew install starship"
TOOL_DESCRIPTIONS["starship"]="Cross-shell prompt written in Rust"
TOOL_HOMEPAGES["starship"]="https://starship.rs"

TOOLS["lazygit"]="brew install lazygit"
TOOL_DESCRIPTIONS["lazygit"]="Simple terminal UI for git commands"
TOOL_HOMEPAGES["lazygit"]="https://github.com/jesseduffield/lazygit"

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

# Function to install a tool
install_tool() {
    local tool="$1"
    local install_cmd="$2"
    local description="$3"
    local homepage="$4"

    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║ Installing: $tool"
    echo "║ Description: $description"
    echo "║ Homepage: $homepage"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"

    if eval "$install_cmd"; then
        log_success "$tool installed successfully!"
        return 0
    else
        log_error "Failed to install $tool"
        return 1
    fi
}

# Function to load curated power tools
load_power_tools() {
    log "Loading curated power dev tools..."
    log_success "Loaded ${#TOOLS[@]} essential power dev tools with homepage links"
}

# Function to check installed tools
check_installed_tools() {
    log "Checking which tools are already installed..."

    typeset -A INSTALLED_TOOLS
    typeset -A MISSING_TOOLS

    for tool in ${(k)TOOLS}; do
        if command_exists "$tool"; then
            INSTALLED_TOOLS[$tool]="${TOOLS[$tool]}"
        else
            MISSING_TOOLS[$tool]="${TOOLS[$tool]}"
        fi
    done

    echo ""
    log_success "${#INSTALLED_TOOLS} tools already installed:"
    for tool in ${(k)INSTALLED_TOOLS}; do
        echo -e "  ✅ $tool - ${TOOL_DESCRIPTIONS[$tool]}"
    done

    if [[ ${#MISSING_TOOLS} -gt 0 ]]; then
        echo ""
        log_warning "${#MISSING_TOOLS} tools missing:"
        for tool in ${(k)MISSING_TOOLS}; do
            echo -e "  ❌ $tool - ${TOOL_DESCRIPTIONS[$tool]}"
        done
    fi
}

# Function to offer installation choices
offer_installation() {
    if [[ ${#MISSING_TOOLS} -eq 0 ]]; then
        log_success "All tools are already installed! 🎉"
        return 0
    fi

    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                          🚀 Tool Installation Menu                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    echo "Choose installation option:"
    echo "1) Install ALL missing tools automatically"
    echo "2) Install tools interactively (choose which ones)"
    echo "3) Show installation commands only (don't install)"
    echo "4) Skip installation"
    echo ""

    if [[ "$AUTO_YES" == "true" ]]; then
        log "Auto-installing all missing tools..."
        install_all_tools
        return 0
    fi

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1)
            install_all_tools
            ;;
        2)
            install_interactive
            ;;
        3)
            show_commands_only
            ;;
        4)
            log "Skipping tool installation"
            ;;
        *)
            log_error "Invalid choice"
            offer_installation
            ;;
    esac
}

# Function to install all tools
install_all_tools() {
    log "Installing all missing tools..."

    local success_count=0
    local total_count=${#MISSING_TOOLS}

    for tool in ${(k)MISSING_TOOLS}; do
        echo ""
        echo "[$((success_count + 1))/$total_count] Installing $tool..."

        if install_tool "$tool" "${MISSING_TOOLS[$tool]}" "${TOOL_DESCRIPTIONS[$tool]}" "${TOOL_HOMEPAGES[$tool]}"; then
            ((success_count++))
        fi
    done

    echo ""
    log_success "Installed $success_count/$total_count tools successfully!"
}

# Function to install tools interactively
install_interactive() {
    log "Interactive installation mode"

    for tool in ${(k)MISSING_TOOLS}; do
        echo ""
        echo -e "${YELLOW}Tool: $tool${NC}"
        echo -e "Description: ${TOOL_DESCRIPTIONS[$tool]}"
        echo -e "Command: ${MISSING_TOOLS[$tool]}"
        echo ""

        read -p "Install $tool? (y/n): " answer
        case $answer in
            [Yy]*)
                install_tool "$tool" "${MISSING_TOOLS[$tool]}" "${TOOL_DESCRIPTIONS[$tool]}" "${TOOL_HOMEPAGES[$tool]}"
                ;;
            *)
                log "Skipping $tool"
                ;;
        esac
    done
}

# Function to show commands only
show_commands_only() {
    log "Installation commands for missing tools:"

    echo ""
    echo "Run these commands to install the missing tools:"
    echo ""

    for tool in ${(k)MISSING_TOOLS}; do
        echo -e "${GREEN}#$tool${NC} - ${TOOL_DESCRIPTIONS[$tool]}"
        echo -e "  ${MISSING_TOOLS[$tool]}"
        echo ""
    done

    echo "Or run this script again with --yes to install all automatically"
}

# Function to show usage
show_usage() {
    cat << EOF
setup-tools.sh - Interactive tool installer for dotfiles

USAGE:
    ./setup-tools.sh [OPTIONS]

OPTIONS:
    --help, -h          Show this help message
    --yes, -y          Install all missing tools automatically
    --verbose, -v      Show verbose output
    --check-only       Only check and show status, don't offer installation

DESCRIPTION:
    This script parses your .zshrc.alias file to find tools referenced in aliases,
    checks which ones are installed, and offers to install the missing ones.

    It can be run standalone or integrated into your main install.sh script.

EXAMPLES:
    ./setup-tools.sh                    # Interactive installation
    ./setup-tools.sh --yes             # Install all automatically
    ./setup-tools.sh --check-only      # Just check status

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
            --verbose|-v)
                VERBOSE=true
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
    echo "║                    🛠️  Dotfiles Tool Setup Wizard                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Check if aliases file exists
    if [[ ! -f "$ALIASES_FILE" ]]; then
        log_error "Aliases file not found: $ALIASES_FILE"
        exit 1
    fi

    # Load curated power tools
    load_power_tools

    # Check installed tools
    check_installed_tools

    # If check-only mode, exit here
    if [[ "$CHECK_ONLY" == "true" ]]; then
        exit 0
    fi

    # Offer installation
    offer_installation

    echo ""
    log_success "Tool setup complete! Enjoy your enhanced productivity! 🚀"
}

# Run main function
main "$@"
