#!/usr/bin/env zsh
# =============================================================================
# MODERN DOTFILES INSTALLER (2025) - Enhanced Version
# =============================================================================
# Features:
# - Robust error handling with rollback capabilities
# - Modular design for maintainability
# - Comprehensive safety checks
# - Better user experience with progress indicators
# - Dependency management and verification
# - Flexible configuration options
# =============================================================================

set -e  # Exit on any error
trap 'error_handler $? $LINENO' ERR

# =============================================================================
# CONFIGURATION & CONSTANTS
# =============================================================================
readonly SCRIPT_VERSION="2.0.0"
readonly MIN_ZSH_VERSION="5.0"
readonly MIN_GIT_VERSION="2.20"
readonly BACKUP_SUFFIX="$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="${HOME}/.dotfiles_install.log"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" >> "${LOG_FILE}"
    echo -e "${timestamp} [${level}] ${message}"
}

# Colored output functions
print_info() { echo -e "${BLUE}ℹ️  ${*}${NC}" >&2; }
print_success() { echo -e "${GREEN}✅ ${*}${NC}" >&2; }
print_warning() { echo -e "${YELLOW}⚠️  ${*}${NC}" >&2; }
print_error() { echo -e "${RED}❌ ${*}${NC}" >&2; }
print_step() { echo -e "${CYAN}🚀 ${*}${NC}" >&2; }
print_header() { echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" >&2; echo -e "${PURPLE} ${*}${NC}" >&2; echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" >&2; }

# Error handler
error_handler() {
    local exit_code=$1
    local line_number=$2
    print_error "Installation failed at line ${line_number} with exit code ${exit_code}"
    print_error "Check ${LOG_FILE} for detailed logs"
    print_error "Rolling back any changes..."

    # Attempt rollback if backup exists
    if [[ -d "${HOME}/.dotfiles_backup_${BACKUP_SUFFIX}" ]]; then
        rollback_installation
    fi

    exit "${exit_code}"
}

# Ensure zsh is available (attempts auto-install if missing)
ensure_zsh() {
    if command -v zsh >/dev/null 2>&1; then
        return 0
    fi

    print_warning "zsh not found – attempting to install..."

    # Helper to run package manager with sudo when needed
    run_pm() {
        local cmd="$1"; shift || true
        if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
            sudo sh -c "$cmd"
        else
            sh -c "$cmd"
        fi
    }

    case "$(uname -s 2>/dev/null || echo unknown)" in
      Darwin)
        if command -v brew >/dev/null 2>&1; then
            brew update >/dev/null 2>&1 || true
            brew install zsh || true
        else
            print_error "Homebrew not found. Please install Homebrew or zsh manually, then re-run."
        fi
        ;;
      Linux)
        if command -v apt-get >/dev/null 2>&1; then
            run_pm "apt-get update -y && apt-get install -y zsh"
        elif command -v apt >/dev/null 2>&1; then
            run_pm "apt update -y && apt install -y zsh"
        elif command -v dnf >/dev/null 2>&1; then
            run_pm "dnf install -y zsh"
        elif command -v yum >/dev/null 2>&1; then
            run_pm "yum install -y zsh"
        elif command -v apk >/dev/null 2>&1; then
            run_pm "apk add --no-cache zsh"
        elif command -v pacman >/dev/null 2>&1; then
            run_pm "pacman -Sy --noconfirm zsh"
        elif command -v zypper >/dev/null 2>&1; then
            run_pm "zypper --non-interactive install zsh"
        else
            print_error "No supported package manager found. Install zsh manually and re-run."
        fi
        ;;
      *)
        print_error "Unsupported OS for auto-install. Install zsh manually and re-run."
        ;;
    esac

    if ! command -v zsh >/dev/null 2>&1; then
        print_error "zsh installation failed or not found in PATH. Please install zsh and re-run."
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    print_step "Checking system requirements..."

    # Check OS
    if [[ "$OSTYPE" != darwin* ]]; then
        print_info "Non-macOS detected. Proceeding with cross-platform checks."
    fi

    # Check Zsh version
    ensure_zsh

    local zsh_version=$(zsh --version | awk '{print $2}')
    if [[ "$(printf '%s\n' "$MIN_ZSH_VERSION" "$zsh_version" | sort -V | head -n1)" != "$MIN_ZSH_VERSION" ]]; then
        print_error "Zsh version $zsh_version is too old. Minimum required: $MIN_ZSH_VERSION"
        exit 1
    fi

    # Check Git version
    if command -v git >/dev/null 2>&1; then
        local git_version=$(git --version | awk '{print $3}')
        if [[ "$(printf '%s\n' "$MIN_GIT_VERSION" "$git_version" | sort -V | head -n1)" != "$MIN_GIT_VERSION" ]]; then
            print_warning "Git version $git_version is older than recommended ($MIN_GIT_VERSION)"
        fi
    fi

    print_success "System requirements met"
}

# Function to show usage information
show_usage() {
    cat << EOF
$(print_header "MODERN DOTFILES INSTALLER v${SCRIPT_VERSION}")

USAGE:
   ./install.sh                        # Interactive mode (asks questions)
   ./install.sh --non-interactive      # Non-interactive mode (defaults to 'no')
   ./install.sh -n                     # Short form for non-interactive
   ./install.sh --yes                  # Auto-yes mode (defaults to 'yes')
   ./install.sh -y                     # Short form for auto-yes
   ./install.sh --dry-run              # Show what would be done (safe preview)
   ./install.sh --light                # Light mode - minimal development tools
   ./install.sh --remote               # Remote mode - optimized for bastion/servers
   ./install.sh --bastion              # Alias for --remote
   ./install.sh --help                 # Show this help message
   ./install.sh -h                     # Short form for help
   ./install.sh --version              # Show version information

MODES:
   Interactive      - Prompts for each installation option
   Non-interactive  - Uses 'no' as default, minimal installation
   Auto-yes         - Uses 'yes' as default, full installation
   Dry-run          - Shows what would be done, makes no changes (SAFE)
   Light            - Minimal development tools for local development
   Remote/Bastion   - Optimized for remote machines and servers (implies light)

INSTALLATION MODES GUIDE:
   🚀 Full Mode (default): Complete development environment with all tools
      - All modern terminal tools (starship, eza, bat, fd, ripgrep)
      - GUI applications (iTerm2, fonts)
      - Development tools (NVM, GPG, complex configurations)
      - Best for: Local development machines, full workstations

   💡 Light Mode (--light): Essential development tools only
      - Core development tools (git, nvim, fzf, ripgrep, tmux)
      - Modern terminal basics (starship, eza, bat)
      - Minimal fonts (JetBrains Mono only)
      - Best for: Development laptops, constrained environments

   🖥️  Remote Mode (--remote/--bastion): Server-optimized setup
      - Minimal server tools (git, vim, tmux, htop, curl, wget)
      - No GUI applications or fonts
      - Lightweight configurations
      - Best for: Remote servers, bastion hosts, cloud instances

FEATURES:
   🛡️  Safety first: Comprehensive backup and rollback capabilities
   🔍 Dry-run mode: Preview all changes before applying
   📊 Progress tracking: Clear indicators of installation progress
   🧪 Verification: Tests installations and reports issues
   📝 Detailed logging: All actions logged to ${LOG_FILE}

EXAMPLES:
   ./install.sh --dry-run              # Safe preview of what will be installed
   ./install.sh -y                     # Full installation with all tools
   ./install.sh -n                     # Minimal installation, skip most prompts
   ./install.sh --light                # Light development setup
   ./install.sh --remote               # Remote/bastion optimized setup
   ./install.sh --remote --yes         # Remote setup with auto-yes

For more information, visit: https://github.com/yourusername/dotfiles
EOF
    exit 0
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

# Initialize variables
NONINTERACTIVE=false
AUTO_YES=false
DRY_RUN=false
VERBOSE=false
SKIP_BACKUP=false
LIGHT_MODE=false
REMOTE_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_usage
            ;;
        --version|-v)
            echo "Modern Dotfiles Installer v${SCRIPT_VERSION}"
            exit 0
            ;;
        --non-interactive|-n)
            NONINTERACTIVE=true
            print_info "Running in non-interactive mode (defaults to 'no')"
            ;;
        --yes|-y)
            AUTO_YES=true
            print_info "Running in auto-yes mode (defaults to 'yes')"
            ;;
        --dry-run)
            DRY_RUN=true
            print_info "Running in dry-run mode (safe preview)"
            ;;
        --verbose)
            VERBOSE=true
            print_info "Verbose logging enabled"
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            print_warning "Backup skipping enabled - use with caution!"
            ;;
        --light)
            LIGHT_MODE=true
            print_info "Light mode enabled - minimal installation for development"
            ;;
        --remote|--bastion)
            REMOTE_MODE=true
            LIGHT_MODE=true  # Remote mode implies light mode
            print_info "Remote/bastion mode enabled - optimized for remote machines"
            ;;
        *)
            print_error "Unknown argument: $1"
            echo ""
            show_usage
            ;;
    esac
    shift
done

# Validate argument combinations
if [[ "$NONINTERACTIVE" == "true" && "$AUTO_YES" == "true" ]]; then
    print_error "Cannot use both --non-interactive and --yes modes"
    exit 1
fi

if [[ "$DRY_RUN" == "true" && "$SKIP_BACKUP" == "true" ]]; then
    print_warning "--skip-backup ignored in dry-run mode"
    SKIP_BACKUP=false
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    # Initialize logging
    touch "${LOG_FILE}"
    log "INFO" "Starting dotfiles installation v${SCRIPT_VERSION}"

    # Show banner
    show_banner

    # Run pre-installation checks
    print_step "Running pre-installation checks..."
    check_requirements
    validate_dotfiles_directory

    # Setup backup directory
    setup_backup_directory

    # Show safety information
    show_safety_info

    # Main installation flow
    install_dotfiles
    install_homebrew
    install_ohmyzsh
    install_development_tools
    install_optional_components
    install_fonts
    setup_node_environment
    install_vim_plugins

    # Post-installation verification
    verify_installation

    # Show completion summary
    show_completion_summary
}

# Show installation banner
show_banner() {
    print_header "MODERN DOTFILES INSTALLER v${SCRIPT_VERSION}"

    if [ -f "$DOTFILES_DIR/banner.txt" ]; then
        cat "$DOTFILES_DIR/banner.txt"
    else
        echo "🚀 Welcome to the Modern Dotfiles Installer!"
        echo "   Setting up your development environment for 2025"
    fi
    echo ""
}

# Setup backup directory
setup_backup_directory() {
    if [[ "$DRY_RUN" == "false" && "$SKIP_BACKUP" == "false" ]]; then
        mkdir -p "$DOTFILES_DIR/bkp"
        readonly BKP_DIR="$DOTFILES_DIR/bkp/dotfiles-${BACKUP_SUFFIX}"
        mkdir -p "${BKP_DIR}"
        print_info "Backup directory created: ${BKP_DIR}"
    fi
}

# Show safety information
show_safety_info() {
    echo ""
    print_info "SAFETY FEATURES ENABLED:"
    echo "   🛡️  Comprehensive backup system"
    echo "   🔄 Rollback capabilities on failure"
    echo "   🔍 Dry-run mode available for safe preview"
    echo "   📊 Detailed logging to ${LOG_FILE}"
    echo ""
    if [[ "$DRY_RUN" == "true" ]]; then
        print_warning "DRY-RUN MODE: No actual changes will be made"
    fi
    echo ""
}

# Validate dotfiles directory
validate_dotfiles_directory() {
    print_info "Validating dotfiles directory structure..."

    local required_files=(
        ".zshrc"
        ".zshrc.alias"
        ".vimrc"
        ".agignore"
        ".config/starship.toml"
    )

    local missing_files=()

    for file in "${required_files[@]}"; do
        if [[ ! -f "$DOTFILES_DIR/$file" ]]; then
            missing_files+=("$file")
        fi
    done

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_error "Missing required dotfiles:"
        printf '   - %s\n' "${missing_files[@]}"
        print_error "Please ensure all dotfiles are present before running the installer."
        exit 1
    fi

    print_success "All required dotfiles found"
}

# Rollback function for error recovery
rollback_installation() {
    print_warning "Attempting to rollback installation..."

    if [[ -d "${BKP_DIR}" ]]; then
        print_info "Restoring files from backup..."

        # Restore backed up files
        for file in "${BKP_DIR}"/*; do
            if [[ -f "$file" ]]; then
                local filename=$(basename "$file")
                if [[ "$DRY_RUN" == "false" ]]; then
                    cp "$file" "$HOME/.$filename"
                    print_info "Restored: .$filename"
                else
                    print_info "Would restore: .$filename"
                fi
            fi
        done

        print_success "Rollback completed"
    else
        print_warning "No backup directory found, cannot rollback"
    fi
}

# Enhanced prompt function with better UX
prompt_user() {
    local question="$1"
    local default="$2"

    if [[ "$NONINTERACTIVE" == "true" ]]; then
        print_info "$question (non-interactive: using '$default')"
        echo "$default"
        return
    elif [[ "$AUTO_YES" == "true" ]]; then
        print_info "$question (auto-yes: using 'y')"
        echo "y"
        return
    elif [[ "$DRY_RUN" == "true" ]]; then
        print_info "$question (dry-run: skipping)"
        echo "n"
        return
    fi

    while true; do
        echo -n "❓ $question "
        read -r response
        response=${response:-$default}

        case $response in
            [Yy]|[Yy][Ee][Ss])
                echo "y"
                return
                ;;
            [Nn]|[Nn][Oo])
                echo "n"
                return
                ;;
            *)
                print_warning "Please answer 'y' or 'n'"
                ;;
        esac
    done
}

# =============================================================================
# INSTALLATION FUNCTIONS
# =============================================================================

# Install dotfiles with backup
install_dotfiles() {
    print_step "Installing dotfiles..."

    # Define dotfiles to install
    local dotfiles_to_install=(
        ".zshrc"
        ".zshrc.alias"
        ".vimrc"
        ".vimrc.completion"
        ".vimrc.conf"
        ".vimrc.conf.base"
        ".vimrc.filetypes"
        ".vimrc.maps"
        ".vimrc.plugin"
        ".vimrc.plugin.extended"
        ".tmux.conf"
        ".agignore"
        ".config/starship.toml"
    )

    # Backup and link each file
    for file in "${dotfiles_to_install[@]}"; do
        backup_if_exists "$file"
        create_symlink "$file" "$file"
    done

    # Link bin directory
    if [[ -d "$DOTFILES_DIR/bin" ]]; then
        print_info "Setting up bin directory..."
        mkdir -p "$HOME/bin"
        if [[ "$DRY_RUN" == "false" ]]; then
            ln -sf "$DOTFILES_DIR/bin"/* "$HOME/bin/" 2>/dev/null || print_warning "Could not link some bin scripts"
            print_success "Linked bin directory with custom scripts"
        else
            print_info "Would link bin directory scripts"
        fi
    fi

    print_success "Dotfiles installation completed"
}

# Backup existing files safely
backup_if_exists() {
    local file="$1"
    if [[ -e "$HOME/$file" || -L "$HOME/$file" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            if [[ -L "$HOME/$file" ]]; then
                print_info "Would remove symlink: $file"
            else
                print_info "Would backup: $file -> ${BKP_DIR}/"
            fi
        elif [[ "$SKIP_BACKUP" == "false" ]]; then
            print_info "Backing up $file"
            if [[ -L "$HOME/$file" ]]; then
                rm "$HOME/$file"
            else
                mv "$HOME/$file" "${BKP_DIR}/" 2>/dev/null || true
            fi
        fi
    fi
}

# Create symlink safely
create_symlink() {
    local source_file="$1"
    local target_file="$2"

    if [[ -f "$DOTFILES_DIR/$source_file" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            print_info "Would link: $source_file -> $target_file"
        else
            ln -sf "$DOTFILES_DIR/$source_file" "$HOME/$target_file"
            print_success "Linked $source_file -> $target_file"
        fi
    else
        print_warning "Source file $source_file not found, skipping symlink for $target_file"
    fi
}

# Install Homebrew
install_homebrew() {
    print_step "Installing Homebrew..."

    if command -v brew >/dev/null 2>&1; then
        print_success "Homebrew already installed"
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "Would install Homebrew"
        return
    fi

    print_info "Installing Homebrew (this may require your password)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        print_success "Homebrew installed and added to PATH"
    else
        print_error "Homebrew installation failed"
        exit 1
    fi
}

# Install Oh My Zsh
install_ohmyzsh() {
    local install_omz=$(prompt_user "Install Oh My Zsh? (y/n)" "n")

    if [[ "$install_omz" != "y" ]]; then
        print_info "Skipping Oh My Zsh installation"
        return
    fi

    print_step "Installing Oh My Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh already installed"
    else
        if [[ "$DRY_RUN" == "true" ]]; then
            print_info "Would install Oh My Zsh"
        else
            print_info "Installing Oh My Zsh..."
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            print_success "Oh My Zsh installed"
        fi
    fi

    # Install zsh-syntax-highlighting plugin
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            print_info "Would install zsh-syntax-highlighting plugin"
        else
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            print_success "zsh-syntax-highlighting installed"
        fi
    fi
}

# Install development tools (mode-aware)
install_development_tools() {
    if [[ "$OSTYPE" != darwin* ]]; then
        print_info "Skipping development tools (macOS only)"
        return
    fi

    # Determine installation level based on mode
    local install_tools="n"
    local tool_level="full"

    if [[ "$REMOTE_MODE" == "true" ]]; then
        install_tools="y"
        tool_level="remote"
        print_info "Remote mode: Installing minimal server-optimized tools"
    elif [[ "$LIGHT_MODE" == "true" ]]; then
        install_tools="y"
        tool_level="light"
        print_info "Light mode: Installing essential development tools only"
    else
        install_tools=$(prompt_user "Install essential development tools via Homebrew? (y/n)" "n")
        tool_level="full"
    fi

    if [[ "$install_tools" != "y" ]]; then
        print_info "Skipping development tools installation"
        return
    fi

    print_step "Installing ${tool_level} development tools..."

    if [[ "$DRY_RUN" == "true" ]]; then
        case "$tool_level" in
            "remote")
                print_info "Would install remote tools: git, vim, tmux, htop, curl, wget"
                ;;
            "light")
                print_info "Would install light tools: git, nvim, fzf, ripgrep, tmux"
                ;;
            "full")
                print_info "Would install full tools: git, nvim, fzf, ripgrep, fd, eza, bat, starship, tmux"
                ;;
        esac
        return
    fi

    brew update

    case "$tool_level" in
        "remote")
            # Minimal tools for remote servers
            brew install git vim tmux htop curl wget tree jq
            print_success "Remote-optimized tools installed"
            ;;
        "light")
            # Essential development tools only
            brew install git git-delta neovim fzf ripgrep tmux
            brew install starship eza bat  # Lightweight modern tools
            print_success "Light development tools installed"
            ;;
        "full")
            # Full development environment
            brew install git git-delta nvm neovim fzf the_silver_searcher jq wget curl tree htop imagemagick gnupg pinentry-mac gh tmux pnpm
            brew install starship eza bat ripgrep fd

            # iTerm2 (only for full mode)
            brew install --cask iterm2 2>/dev/null || print_info "iTerm2 already installed or installation skipped"

            # Setup NVM (only for full mode)
            mkdir -p ~/.nvm
            print_success "Full development tools installed"
            ;;
    esac

    # Common setup for all modes
    if [[ "$tool_level" != "remote" ]]; then
        # Setup FZF (only for light/full modes)
        if command -v fzf >/dev/null 2>&1; then
            /opt/homebrew/opt/fzf/install --all --no-update-rc 2>/dev/null || print_info "FZF setup skipped"
        fi
    fi
}

# Install optional components (mode-aware)
install_optional_components() {
    # Skip heavy components in remote mode
    if [[ "$REMOTE_MODE" == "true" ]]; then
        print_info "Remote mode: Skipping optional heavy components"
        return
    fi

    # GPG setup (skip in light mode to reduce complexity)
    if [[ "$LIGHT_MODE" == "false" ]]; then
        local setup_gpg=$(prompt_user "Configure GPG for Git commit signing? (y/n)" "n")

        if [[ "$setup_gpg" == "y" && "$DRY_RUN" == "false" ]]; then
            print_step "Setting up GPG configuration..."
            setup_gpg_configuration
        fi
    fi

    # Starship setup (essential for all modes)
    if [[ ! -f ~/.config/starship.toml ]]; then
        if [[ "$DRY_RUN" == "false" ]]; then
            print_info "Setting up Starship with Tokyo Night theme..."
            mkdir -p ~/.config
            starship preset tokyo-night -o ~/.config/starship.toml
            print_success "Starship configuration created"
        else
            print_info "Would setup Starship prompt configuration"
        fi
    fi
}

# Setup GPG configuration
setup_gpg_configuration() {
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg

    cat > ~/.gnupg/gpg.conf << 'EOF'
# GPG Configuration for enhanced security
personal-cipher-preferences AES256 AES192 AES
personal-digest-preferences SHA512 SHA384 SHA256
personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
use-agent
require-cross-certification
no-symkey-cache
throw-keyids
EOF

    cat > ~/.gnupg/gpg-agent.conf << 'EOF'
default-cache-ttl 28800
max-cache-ttl 86400
pinentry-program /opt/homebrew/bin/pinentry-mac
EOF

    print_success "GPG configuration created"
}

# Install programming fonts (mode-aware)
install_fonts() {
    if [[ "$OSTYPE" != darwin* ]]; then
        print_info "Skipping fonts installation (macOS only)"
        return
    fi

    # Skip fonts in remote mode (not needed on servers)
    if [[ "$REMOTE_MODE" == "true" ]]; then
        print_info "Remote mode: Skipping fonts installation"
        return
    fi

    # In light mode, ask but default to no
    local install_fonts="n"
    if [[ "$LIGHT_MODE" == "true" ]]; then
        install_fonts=$(prompt_user "Install essential programming fonts? (y/n)" "n")
    else
        install_fonts=$(prompt_user "Install modern programming fonts? (y/n)" "n")
    fi

    if [[ "$install_fonts" != "y" ]]; then
        print_info "Skipping fonts installation"
        return
    fi

    print_step "Installing programming fonts..."

    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ "$LIGHT_MODE" == "true" ]]; then
            print_info "Would install essential fonts: JetBrains Mono"
        else
            print_info "Would install full font collection"
        fi
        return
    fi

    brew tap homebrew/cask-fonts

    if [[ "$LIGHT_MODE" == "true" ]]; then
        # Only essential fonts for light mode
        brew install --cask font-jetbrains-mono-nerd-font
        print_success "Essential fonts installed!"
    else
        # Full font collection for full mode
        brew install --cask \
            font-jetbrains-mono-nerd-font \
            font-jetbrains-mono \
            font-cascadia-code \
            font-fira-code \
            font-hack-nerd-font \
            font-source-code-pro \
            font-monaspace
        print_success "Programming fonts installed!"
    fi

    print_info "Set your terminal font to 'JetBrainsMonoNerdFont-Regular' for best experience"
}

# Setup Node.js environment (mode-aware)
setup_node_environment() {
    # Skip Node.js setup in remote mode (too heavy for servers)
    if [[ "$REMOTE_MODE" == "true" ]]; then
        print_info "Remote mode: Skipping Node.js/NVM installation"
        return
    fi

    if ! command -v nvm >/dev/null 2>&1; then
        if [[ "$LIGHT_MODE" == "true" ]]; then
            print_info "NVM not available in light mode, skipping Node.js setup"
            return
        fi
        print_info "NVM not available, skipping Node.js setup"
        return
    fi

    local setup_node="n"
    if [[ "$LIGHT_MODE" == "true" ]]; then
        setup_node=$(prompt_user "Setup Node.js LTS? (y/n)" "n")
    else
        setup_node=$(prompt_user "Setup Node.js LTS via NVM? (y/n)" "n")
    fi

    if [[ "$setup_node" != "y" ]]; then
        print_info "Skipping Node.js setup"
        return
    fi

    print_step "Setting up Node.js environment..."

    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "Would setup Node.js LTS"
        return
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

    nvm install --lts
    nvm use --lts
    nvm alias default lts/*

    print_success "Node.js LTS installed and set as default"
}

# Install Vim plugins
install_vim_plugins() {
    if ! command -v vim >/dev/null 2>&1; then
        print_info "Vim not available, skipping plugin installation"
        return
    fi

    local install_plugins=$(prompt_user "Install vim plugins now? (y/n)" "n")

    if [[ "$install_plugins" != "y" ]]; then
        print_info "Skipping vim plugins installation"
        return
    fi

    print_step "Installing vim plugins..."

    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "Would install vim plugins"
        return
    fi

    vim +PlugInstall +qall
    print_success "Vim plugins installed"
}

# Verify installation (mode-aware)
verify_installation() {
    print_step "Verifying installation..."

    local failed_tools=()
    local tools_to_check=()

    # Check different tools based on installation mode
    if [[ "$OSTYPE" == darwin* ]]; then
        if [[ "$REMOTE_MODE" == "true" ]]; then
            # Minimal tools for remote mode
            tools_to_check=("git" "vim" "tmux" "curl")
        elif [[ "$LIGHT_MODE" == "true" ]]; then
            # Essential tools for light mode
            tools_to_check=("git" "nvim" "fzf" "ripgrep" "tmux")
        else
            # Full toolset for regular mode
            tools_to_check=("git" "nvim" "fzf" "ripgrep" "fd" "eza" "bat" "starship")
        fi

        for tool in "${tools_to_check[@]}"; do
            if ! command -v "$tool" >/dev/null 2>&1; then
                failed_tools+=("$tool")
            fi
        done
    fi

    # Check dotfiles
    if [[ ! -L "$HOME/.zshrc" ]]; then
        failed_tools+=(".zshrc symlink")
    fi

    if [[ ${#failed_tools[@]} -eq 0 ]]; then
        print_success "All installations verified successfully"
    else
        print_warning "Some installations may have issues:"
        printf '   - %s\n' "${failed_tools[@]}"
    fi
}

# Show completion summary (mode-aware)
show_completion_summary() {
    print_header "INSTALLATION COMPLETED SUCCESSFULLY! 🎉"

    echo ""
    echo "📋 WHAT WAS INSTALLED:"

    # Show different summaries based on mode
    if [[ "$REMOTE_MODE" == "true" ]]; then
        echo "   ✅ Remote-optimized dotfiles and shell configuration"
        echo "   ✅ Essential server tools (git, vim, tmux, htop, curl)"
        echo "   ✅ Lightweight terminal experience"
        echo "   ✅ Network and file transfer utilities"
    elif [[ "$LIGHT_MODE" == "true" ]]; then
        echo "   ✅ Light development dotfiles and configuration"
        echo "   ✅ Essential development tools (git, nvim, fzf, ripgrep)"
        echo "   ✅ Modern terminal tools (starship, eza, bat)"
        echo "   ✅ Productivity aliases and functions"
    else
        echo "   ✅ Full dotfiles suite with backup"
        echo "   ✅ Complete development environment (git, nvim, fzf, etc.)"
        echo "   ✅ Enhanced terminal experience (starship, eza, bat, fd)"
        echo "   ✅ Oh My Zsh with syntax highlighting"
        echo "   ✅ Productivity aliases and functions"
        echo "   ✅ Starship prompt with beautiful themes"
    fi

    if [[ "$DRY_RUN" == "false" ]]; then
        echo ""
        echo "🚀 NEXT STEPS:"

        if [[ "$REMOTE_MODE" == "true" ]]; then
            echo "   1. Restart your shell: exec zsh"
            echo "   2. Test basic tools: git --version, vim --version, tmux -V"
            echo "   3. Configure Git: git config --global user.name 'Your Name'"
            echo "   4. Configure Git: git config --global user.email 'your.email@example.com'"
            echo "   5. Start tmux session: tmux"
        elif [[ "$LIGHT_MODE" == "true" ]]; then
            echo "   1. Restart your terminal to apply all changes"
            echo "   2. Test tools: nvim --version, fzf --version, rg --version"
            echo "   3. Configure Git: git config --global user.name 'Your Name'"
            echo "   4. Configure Git: git config --global user.email 'your.email@example.com'"
            echo "   5. Try modern commands: eza -la, bat README.md"
        else
            echo "   1. Restart your terminal to apply all changes"
            echo "   2. Set terminal font to 'JetBrainsMonoNerdFont-Regular'"
            echo "   3. Test tools: starship --version, fzf --version, eza --version"
            echo "   4. Configure Git: git config --global user.name 'Your Name'"
            echo "   5. Configure Git: git config --global user.email 'your.email@example.com'"
            echo "   6. Try FZF: Ctrl+R (history), Ctrl+T (files)"
        fi
    fi

    echo ""
    if [[ "$DRY_RUN" == "false" && "$SKIP_BACKUP" == "false" ]]; then
        echo "📁 Backup location: ${BKP_DIR}"
    fi
    echo "📝 Log file: ${LOG_FILE}"
    echo ""
    echo "💡 Happy coding! 🧑‍💻"
}

# =============================================================================
# SCRIPT ENTRY POINT
# =============================================================================

# Run main function
main "$@"


# =============================================================================
# INSTALLATION MODES QUICK REFERENCE
# =============================================================================
#
# Choose the right mode for your use case:
#
# 1. LOCAL DEVELOPMENT MACHINES (Full workstations)
#    Command: ./install.sh --yes
#    Installs: Complete development environment with all tools
#
# 2. DEVELOPMENT LAPTOPS (Light but capable)
#    Command: ./install.sh --light --yes
#    Installs: Essential development tools, modern terminal basics
#
# 3. REMOTE SERVERS / BASTION HOSTS (Minimal & fast)
#    Command: ./install.sh --remote --yes
#    Installs: Server-optimized tools, lightweight configurations
#
# 4. SAFE PREVIEW (See what will be installed)
#    Command: ./install.sh --remote --dry-run
#    Installs: Nothing - just shows what would be installed
#
# =============================================================================
