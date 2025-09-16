#!/usr/bin/env zsh

# Function to show usage information
show_usage() {
    echo "MODERN DOTFILES INSTALLER"
    echo ""
    echo "USAGE:"
    echo "   ./install.sh                     # Interactive mode (asks questions)"
    echo "   ./install.sh --non-interactive   # Non-interactive mode (defaults to 'no')"
    echo "   ./install.sh -n                  # Short form for non-interactive"
    echo "   ./install.sh --yes               # Auto-yes mode (defaults to 'yes')"
    echo "   ./install.sh -y                  # Short form for auto-yes"
    echo "   ./install.sh --dry-run           # Show what would be done (safe preview)"
    echo "   ./install.sh --help              # Show this help message"
    echo "   ./install.sh -h                  # Short form for help"
    echo ""
    echo "MODES:"
    echo "   Interactive      - Prompts for each installation option"
    echo "   Non-interactive  - Uses 'no' as default, minimal installation"
    echo "   Auto-yes         - Uses 'yes' as default, full installation"
    echo "   Dry-run          - Shows what would be done, makes no changes (SAFE)"
    echo ""
    exit 0
}

# Parse command line arguments
NONINTERACTIVE=false
AUTO_YES=false
DRY_RUN=false
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
elif [[ "$1" == "--non-interactive" || "$1" == "-n" ]]; then
    NONINTERACTIVE=true
elif [[ "$1" == "--yes" || "$1" == "-y" ]]; then
    AUTO_YES=true
elif [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
elif [[ -n "$1" ]]; then
    echo "❌ Unknown argument: $1"
    echo ""
    show_usage
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

echo -e '\n\n\n\n\n\n\n\n\n\n'
if [ -f "$DOTFILES_DIR/banner.txt" ]; then
    cat "$DOTFILES_DIR/banner.txt"
else
    echo "========== MODERN DOTFILES INSTALLER (2025) =========="
fi

if [[ "$NONINTERACTIVE" == "true" ]]; then
    echo "🤖 RUNNING IN NON-INTERACTIVE MODE (all prompts will use default 'no')"
elif [[ "$AUTO_YES" == "true" ]]; then
    echo "🚀 RUNNING IN AUTO-YES MODE (all prompts will use default 'yes')"
elif [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 RUNNING IN DRY-RUN MODE (showing what would be done, no changes made)"
fi

echo -e '\n\n\n\n\n\n\n\n\n\n'

echo "🛡️  SAFETY FEATURES: This installer now includes safety checks to prevent data loss"
echo "   💡 Use --dry-run to preview changes before installing"
echo "   📦 Only files that will be replaced are backed up"
echo ""

# unalias date just in case
unalias date 2>/dev/null || true

date=$(date +%d_%m_%Y)
mkdir -p "$DOTFILES_DIR/bkp"
bkpDir="$DOTFILES_DIR/bkp/dotfiles-${date}"

# Helper function for prompts
prompt_user() {
    local question="$1"
    local default="$2"

    if [[ "$NONINTERACTIVE" == "true" ]]; then
        echo "$question (non-interactive mode: using default '$default')"
        echo "$default"
        return
    elif [[ "$AUTO_YES" == "true" ]]; then
        echo "$question (auto-yes mode: using default 'y')"
        echo "y"
        return
    fi

    echo "$question"
    read -r response
    echo "$response"
}

cd "$HOME" || { echo "Failed to change to home directory"; exit 1; }

mkdir -p "${bkpDir}"
echo "Backing up overridden dotfiles in ${bkpDir}"

# Verify all dotfiles exist before backing up anything
verify_dotfiles_exist

# Function to backup existing files or symlinks
backup_if_exists() {
    local file="$1"
    if [ -e "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            if [ -L "$HOME/$file" ]; then
                echo "🔍 Would remove symlink: $file"
            else
                echo "🔍 Would backup file: $file -> ${bkpDir}/"
            fi
        else
            echo "📦 Backing up $file"
            if [ -L "$HOME/$file" ]; then
                # It's a symlink, remove it instead of moving
                rm "$HOME/$file"
            else
                # It's a regular file, move it to backup
                mv "$HOME/$file" "${bkpDir}/" 2>/dev/null || true
            fi
        fi
    fi
}

# Function to create symlink safely
create_symlink() {
    local source_file="$1"
    local target_file="$2"

    if [ -f "$DOTFILES_DIR/$source_file" ]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "🔍 Would link: $source_file -> $target_file"
        else
            ln -sf "$DOTFILES_DIR/$source_file" "$HOME/$target_file"
            echo "✅ Linked $source_file -> $target_file"
        fi
    else
        echo "❌ Warning: Source file $source_file not found in dotfiles directory"
        echo "   → Skipping symlink for $target_file"
    fi
}

# Function to verify all symlinks will work before backing up anything
verify_dotfiles_exist() {
    local missing_files=()
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "🔍 Verifying dotfiles exist for dry-run preview..."
    else
        echo "🔍 Verifying dotfiles exist before backing up your current files..."
    fi
    
    for file in "${dotfiles_to_backup[@]}"; do
        if [ ! -f "$DOTFILES_DIR/$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        echo "❌ ERROR: The following dotfiles are missing from $DOTFILES_DIR:"
        printf '   - %s\n' "${missing_files[@]}"
        echo ""
        echo "This would result in backing up your files without replacing them!"
        echo "Please fix the dotfiles repository before running the installer."
        exit 1
    fi
    
    echo "✅ All dotfiles verified. Safe to proceed with backup and linking."
}

# Backup existing dotfiles first (ONLY files that will actually be symlinked)
echo "Finding files to backup..."
dotfiles_to_backup=(
    .zshrc
    .zshrc.alias
    .vimrc
    .vimrc.completion
    .vimrc.conf
    .vimrc.conf.base
    .vimrc.filetypes
    .vimrc.maps
    .vimrc.plugin
    .vimrc.plugin.extended
    .tmux.conf
    .agignore
)
for file in "${dotfiles_to_backup[@]}"; do
    backup_if_exists "$file"
done

# Install Homebrew FIRST (before anything else that might need it)
if [[ "$OSTYPE" == darwin* ]]; then
    echo "Checking if Homebrew is installed..."
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew (this may require your password)..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH immediately
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            echo "✅ Homebrew installed and added to PATH"
        else
            echo "❌ Homebrew installation failed"
            exit 1
        fi
    else
        echo "✅ Homebrew already installed"
        # Ensure it's in PATH
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
    fi
fi

# Install Oh My Zsh CAREFULLY (without overriding our dotfiles)
install_ohmyzsh=$(prompt_user "Do you want to install Oh My Zsh? (y/n)" "n")

if [[ "$install_ohmyzsh" = "y" ]]; then
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        # Install without changing shell or sourcing (to avoid script conflicts)
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "✅ Oh My Zsh installed"
    else
        echo "✅ Oh My Zsh already installed"
    fi

    # Install zsh-syntax-highlighting plugin
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        echo "✅ zsh-syntax-highlighting installed"
    fi
fi

# NOW create symlinks for dotfiles (after Oh My Zsh won't override them)
echo "Creating symlinks for dotfiles..."
create_symlink ".vimrc" ".vimrc"
create_symlink ".vimrc.completion" ".vimrc.completion"
create_symlink ".vimrc.conf" ".vimrc.conf"
create_symlink ".vimrc.conf.base" ".vimrc.conf.base"
create_symlink ".vimrc.filetypes" ".vimrc.filetypes"
create_symlink ".vimrc.maps" ".vimrc.maps"
create_symlink ".vimrc.plugin" ".vimrc.plugin"
create_symlink ".vimrc.plugin.extended" ".vimrc.plugin.extended"

# Zsh files (CRITICAL: Do this after Oh My Zsh install)
create_symlink ".zshrc" ".zshrc"
create_symlink ".zshrc.alias" ".zshrc.alias"
# Note: .zshenv and .zshrc.local are user-specific and not included in dotfiles
# Note: .zshrc-e has been consolidated into .zshrc.local.template
# See .zshenv.example, .zshrc.local.example, .zshrc.private.example, and .gitconfig.example for templates

# Development tool configurations
create_symlink ".agignore" ".agignore"

# Link bin directory for custom scripts
if [ -d "$DOTFILES_DIR/bin" ]; then
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "🔍 Would link bin directory scripts to ~/bin/"
        for script in "$DOTFILES_DIR/bin"/*; do
            if [ -f "$script" ]; then
                script_name=$(basename "$script")
                echo "🔍   Would link: bin/$script_name -> ~/bin/$script_name"
            fi
        done
    else
        echo "Linking bin directory..."
        mkdir -p "$HOME/bin"
        ln -sf "$DOTFILES_DIR/bin"/* "$HOME/bin/" 2>/dev/null || echo "Warning: Could not link some bin scripts"
        echo "✅ Linked ~/bin directory with custom scripts"
    fi
fi

# Git config (only if it doesn't exist to avoid overwriting user settings)
if [ ! -f "$HOME/.gitconfig" ]; then
    if [[ "$NONINTERACTIVE" == "true" ]]; then
        echo "No .gitconfig found. Skipping Git identity setup in non-interactive mode."
        echo "You can configure Git later with: git config --global user.name 'Your Name'"
        echo "                                 git config --global user.email 'your.email@example.com'"
    else
        echo "No .gitconfig found. Let's set up your Git identity."
        echo "What is your name?"
        read -r gitname
        echo "What is your email?"
        read -r gitemail
        cat > "$HOME/.gitconfig" <<EOF
[user]
    name = $gitname
    email = $gitemail
[core]
    editor = nvim
    excludesfile = ~/.gitignore_global
    pager = delta
    autocrlf = input
    whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
[color]
    ui = auto
    branch = auto
    diff = auto
    status = auto
    interactive = auto
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    ca = commit --amend
    cm = commit -m
    lg = log --oneline --graph --decorate --all
    last = log -1 HEAD
    unstage = reset HEAD --
    hist = log --pretty=format:'%C(yellow)%h%Creset %ad | %s%C(red)%d%Creset %C(blue)[%an]%Creset' --graph --date=short
    type = cat-file -t
    dump = cat-file -p
    fixup = commit --fixup
    squash = commit --squash
[push]
    default = current
    autoSetupRemote = true
[fetch]
    prune = true
[merge]
    tool = nvimdiff
    conflictstyle = diff3
[diff]
    tool = nvimdiff
    colorMoved = default
[rerere]
    enabled = true
[rebase]
    autoStash = true
[status]
    showUntrackedFiles = all
[log]
    date = short
[init]
    defaultBranch = main
[credential]
    helper = osxkeychain
[delta]
    # Use n and N to move between diff sections
    navigate = true
    # Set to true if you're in a terminal with a light background color
    light = false
    # Use side-by-side view for better readability
    side-by-side = true
    # Show line numbers
    line-numbers = true
    # Enhanced decorations
    decorations = true
    # Syntax highlighting theme (try: Dracula, GitHub, Monokai Extended, etc.)
    syntax-theme = Dracula
    # Better file headers
    file-style = bold yellow ul
    file-decoration-style = none
    file-added-label = [+]
    file-copied-label = [==]
    file-modified-label = [*]
    file-removed-label = [-]
    file-renamed-label = [->]
    # Hunk headers
    hunk-header-decoration-style = blue box
    hunk-header-file-style = red
    hunk-header-line-number-style = "#067a00"
    hunk-header-style = file line-number syntax
    # Line numbers
    line-numbers-left-style = cyan
    line-numbers-right-style = cyan
    line-numbers-minus-style = 124
    line-numbers-plus-style = 28
    # Changes
    minus-style = syntax "#450a15"
    minus-emph-style = syntax "#600818"
    plus-style = syntax "#0e2f0e"
    plus-emph-style = syntax "#174517"
    # Whitespace
    whitespace-error-style = 22 reverse
    # Zero line mode for better performance on large diffs
    max-line-length = 512
[pull]
    rebase = false
[interactive]
    diffFilter = delta --color-only
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
EOF
        echo "✅ .gitconfig created with your user info and recommended settings."
    fi
else
    echo "Warning: .gitconfig already exists, skipping creation."
fi

# Other configs
create_symlink ".tmux.conf" ".tmux.conf"

# Link other config directories if they exist
if [ -d "$DOTFILES_DIR/.config" ]; then
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "🔍 Would link additional config directories..."
        for config_dir in "$DOTFILES_DIR/.config"/*; do
            if [ -d "$config_dir" ]; then
                dir_name=$(basename "$config_dir")
                echo "🔍   Would link: .config/$dir_name -> ~/.config/$dir_name"
            fi
        done
    else
        echo "Linking additional config directories..."
        mkdir -p ~/.config

        # Link individual config subdirectories to avoid conflicts
        for config_dir in "$DOTFILES_DIR/.config"/*; do
            if [ -d "$config_dir" ]; then
                dir_name=$(basename "$config_dir")
                ln -sf "$config_dir" ~/.config/ 2>/dev/null || echo "Warning: Could not link $dir_name config"
                echo "✅ Linked ~/.config/$dir_name"
            fi
        done
    fi
fi

echo -e "\n✅ Dotfiles are linked!"

# Exit early for dry-run mode (just show what would be done for dotfiles)
if [[ "$DRY_RUN" == "true" ]]; then
    echo ""
    echo "🔍 DRY-RUN COMPLETE!"
    echo "   The above shows what would be backed up and symlinked."
    echo "   No actual changes were made to your system."
    echo ""
    echo "💡 To actually run the installation:"
    echo "   ./install.sh        # Interactive mode"
    echo "   ./install.sh -y     # Auto-yes mode (full installation)"
    echo "   ./install.sh -n     # Non-interactive mode (minimal)"
    exit 0
fi

# Git configuration is handled above during dotfiles linking

# Vim-plug installation
vimplug=$(prompt_user "Do you wish to install vim-plug (modern Vim plugin manager)? (y/n)" "n")

if [[ "$vimplug" = "y" ]]; then
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "✅ vim-plug installed successfully"
fi

# Development tools installation (macOS)
if [[ "$OSTYPE" == darwin* ]]; then
    install_tools=$(prompt_user "Install essential development tools via Homebrew? (y/n)" "n")

    if [[ "$install_tools" = "y" ]]; then
        echo "Updating Homebrew..."
        brew update

        echo "Installing essential development tools..."
        # Install fortune first (needed for Oh My Zsh hitchhiker plugin)
        brew install fortune

        # Essential dev tools
        brew install git git-delta nvm neovim fzf the_silver_searcher jq wget curl tree htop imagemagick gnupg pinentry-mac gh tmux pnpm

        # Modern terminal tools (note: exa is now eza)
        echo "Installing modern terminal enhancements..."
        brew install starship eza bat ripgrep fd

        # iTerm2 (handle case where it's already installed)
        echo "Installing iTerm2..."
        brew install --cask iterm2 2>/dev/null || echo "iTerm2 already installed or installation skipped"

        # Set up NVM
        mkdir -p ~/.nvm

        # Set up FZF shell integration
        echo "Setting up FZF shell integration..."
        /opt/homebrew/opt/fzf/install --all --no-update-rc

        echo "✅ Development tools installed"

        # Set up GPG for Git commit signing
        setup_gpg=$(prompt_user "Configure GPG for Git commit signing? (y/n)" "n")

        if [[ "$setup_gpg" = "y" ]]; then
            echo "Setting up GPG configuration..."

            # Create GPG directory with proper permissions
            mkdir -p ~/.gnupg
            chmod 700 ~/.gnupg

            # Configure GPG with secure defaults
            cat > ~/.gnupg/gpg.conf << 'EOF'
# GPG Configuration for enhanced security
# Use AES256, SHA512, and ZLIB
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

            # Configure GPG agent
            cat > ~/.gnupg/gpg-agent.conf << 'EOF'
# GPG Agent configuration
default-cache-ttl 28800
max-cache-ttl 86400
pinentry-program /opt/homebrew/bin/pinentry-mac
EOF

            echo "✅ GPG configuration created"
            echo "   📝 Next steps:"
            echo "   1. Generate a GPG key: gpg --full-generate-key"
            echo "   2. List keys: gpg --list-secret-keys --keyid-format=long"
            echo "   3. Configure Git: git config --global user.signingkey [KEY_ID]"
            echo "   4. Enable signing: git config --global commit.gpgsign true"
        fi

        # Set up Starship configuration
        echo "Setting up Starship prompt configuration..."
        mkdir -p ~/.config

        # Create a modern Starship config if it doesn't exist
        if [ ! -f ~/.config/starship.toml ]; then
            echo "Setting up Starship with Tokyo Night theme..."
            starship preset tokyo-night -o ~/.config/starship.toml
            echo "✅ Starship configuration created with Tokyo Night theme"
            echo "   🎨 Theme: Tokyo Night with beautiful colors and icons"
            echo "   💡 Tip: Make sure you have a Nerd Font installed for best experience"
        else
            echo "ℹ️  Starship config already exists, keeping your custom configuration"
            echo "   💡 To switch to Tokyo Night theme: starship preset tokyo-night -o ~/.config/starship.toml"
        fi
    fi

    # Optional: BetterTouchTool
    btt=$(prompt_user "Install BetterTouchTool for advanced macOS automation? (y/n) - Note: BetterTouchTool is a paid app but offers powerful gesture and automation features" "n")

    if [[ "$btt" = "y" ]]; then
        echo "Installing BetterTouchTool..."
        brew install --cask bettertouchtool
        echo "✅ BetterTouchTool installed! You'll need to purchase a license from folivora.ai"
    fi
fi

# Vim plugins installation
vimplugins=$(prompt_user "Install vim plugins now? (y/n)" "n")

if [[ "$vimplugins" = "y" ]] && command -v vim &>/dev/null; then
    echo "Installing vim plugins..."
    vim +PlugInstall +qall
    echo "✅ Vim plugins installed"
    echo "   📝 Note: Tabs are configured to always show when opening multiple files"
fi

# Programming fonts
fonts=$(prompt_user "Install modern programming fonts? (y/n) - Includes JetBrains Mono Nerd Font, Cascadia Code, and other developer favorites" "n")

if [[ "$fonts" = "y" ]] && [[ "$OSTYPE" == darwin* ]]; then
    echo "Installing modern programming fonts via Homebrew..."
    brew tap homebrew/cask-fonts
    brew install --cask \
        font-jetbrains-mono-nerd-font \
        font-jetbrains-mono \
        font-cascadia-code \
        font-fira-code \
        font-hack-nerd-font \
        font-source-code-pro \
        font-monaspace
    echo "✅ Programming fonts installed!"
    echo "   🎨 IMPORTANT: Set your terminal font to 'JetBrainsMonoNerdFont-Regular'"
    echo "      This enables all the beautiful icons in Starship prompt!"
fi

# Node.js setup
if command -v nvm &>/dev/null; then
    node_setup=$(prompt_user "Setup Node.js LTS via NVM? (y/n)" "n")

    if [[ "$node_setup" = "y" ]]; then
        echo "Setting up Node.js environment..."
        # Source NVM first
        export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

        nvm install --lts
        nvm use --lts
        nvm alias default lts/*
        echo "✅ Node.js LTS installed and set as default"
    fi
fi

# Neovim configuration is now automatically linked with other .config directories above

# Final verification and testing
echo -e "\n🧪 TESTING INSTALLATION..."

# Test that essential tools are available
echo "Verifying installations..."
failed_tools=()

if [[ "$OSTYPE" == darwin* ]] && [[ "$install_tools" = "y" ]]; then
    tools_to_check=("brew" "git" "nvim" "fzf" "rg" "fd" "eza" "bat" "gpg")
    for tool in "${tools_to_check[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            failed_tools+=("$tool")
        fi
    done
fi

# Test zsh configuration
if [ -f "$HOME/.zshrc" ] && [ -L "$HOME/.zshrc" ]; then
    echo "✅ Custom .zshrc is properly linked"
else
    echo "❌ .zshrc linking failed"
    failed_tools+=(".zshrc")
fi

# Test Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ] && [[ "$install_ohmyzsh" = "y" ]]; then
    echo "✅ Oh My Zsh is installed"
else
    echo "ℹ️  Oh My Zsh installation skipped"
fi

# Report results
if [ ${#failed_tools[@]} -eq 0 ]; then
    echo -e "\n🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉"
else
    echo -e "\n⚠️  INSTALLATION COMPLETED WITH SOME ISSUES:"
    printf '   - %s\n' "${failed_tools[@]}"
    echo "   You may need to restart your terminal and check these tools manually."
fi

echo ""
echo "📋 SUMMARY OF WHAT WAS INSTALLED:"
echo "   ✅ Dotfiles symlinked to custom configurations"
echo "   ✅ .agignore configured for The Silver Searcher (ag)"
echo "   ✅ Vim/Neovim with modern plugin management (tabs always visible)"
if [[ "$install_ohmyzsh" = "y" ]]; then
    echo "   ✅ Oh My Zsh for enhanced terminal experience"
    echo "   ✅ zsh-syntax-highlighting plugin"
fi
if [[ "$install_tools" = "y" ]] && [[ "$OSTYPE" == darwin* ]]; then
    echo "   ✅ Essential development tools (git, nvim, fzf, ripgrep, gpg, etc.)"
    echo "   ✅ Modern terminal tools (starship, eza, bat, fd)"
    echo "   ✅ Starship prompt configuration with beautiful icons"
    echo "   ✅ iTerm2 terminal application"
    echo "   ✅ FZF shell integration (Ctrl+R for history, Ctrl+T for files)"
    if [[ "$setup_gpg" = "y" ]]; then
        echo "   ✅ GPG configured for secure Git commit signing"
    fi
fi
if [[ "$fonts" = "y" ]]; then
    echo "   ✅ Modern programming fonts (JetBrains Mono, Cascadia Code, etc.)"
fi
if [[ "$node_setup" = "y" ]]; then
    echo "   ✅ Node.js LTS environment via NVM"
fi

echo ""
echo "🚀 NEXT STEPS:"
echo "   1. **Restart your terminal** to apply all changes"
echo "   2. **Set terminal font** to 'JetBrainsMonoNerdFont-Regular' for beautiful icons"
echo "   3. **Create local config files** (optional):"
echo "      • Copy .zshenv.example to .zshenv for environment variables"
echo "      • Copy .zshrc.local.example to .zshrc.local for local configurations"
echo "      • Copy .zshrc.private.example to .zshrc.private for sensitive settings"
echo "      • Copy .gitconfig.example to .gitconfig and customize with your details"
echo "   4. Try Starship prompt: 'eval \"\$(starship init zsh)\"' (temporary test)"
echo "   5. Try modern tools: 'eza -la', 'bat filename', 'rg search-term'"
echo "   6. Use FZF: Ctrl+R (history), Ctrl+T (files), Alt+C (directories)"
echo "   7. Run 'nvim' to start Neovim with your modern configuration"

echo ""
echo "💡 QUICK TEST COMMANDS:"
echo "   • starship --version                    # Test Starship prompt"
echo "   • eval \"\$(starship init zsh)\"         # Try Starship temporarily"
echo "   • fzf --version                         # Test fuzzy finder"
echo "   • rg --version                          # Test ripgrep"
echo "   • eza --version                         # Test modern ls replacement"
echo "   • nvim --version                        # Test Neovim"
echo "   • gpg --version                         # Test GPG for security/signing"
echo "   • vim file1 file2                       # Test vim with tabs (should show tab bar)"
echo "   • nvim file1 file2                      # Test neovim with tabs (should show tab bar)"
echo ""
echo "🔧 Your development environment is ready! Happy coding! 🧑‍💻"
echo ""
echo "💡 SCRIPT USAGE:"
echo "   ./install.sh                            # Interactive mode (asks questions)"
echo "   ./install.sh --non-interactive          # Non-interactive mode (defaults to 'no')"
echo "   ./install.sh -n                         # Short form for non-interactive"
echo "   ./install.sh --yes                      # Auto-yes mode (defaults to 'yes')"
echo "   ./install.sh -y                         # Short form for auto-yes"
echo "   ./install.sh --dry-run                  # Safe preview mode (no changes made)"

