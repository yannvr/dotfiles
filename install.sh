#!/usr/bin/env zsh

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

echo -e '\n\n\n\n\n\n\n\n\n\n'
if [ -f "$DOTFILES_DIR/banner.txt" ]; then
    cat "$DOTFILES_DIR/banner.txt"
else
    echo "========== MODERN DOTFILES INSTALLER (2025) =========="
fi
echo -e '\n\n\n\n\n\n\n\n\n\n'

# unalias date just in case
unalias date 2>/dev/null || true

date=$(date +%d_%m_%Y)
mkdir -p "$DOTFILES_DIR/bkp"
bkpDir="$DOTFILES_DIR/bkp/dotfiles-${date}"

cd "$HOME" || { echo "Failed to change to home directory"; exit 1; }

mkdir -p "${bkpDir}"
echo "Backing up overridden dotfiles in ${bkpDir}"

# Function to backup existing files or symlinks
backup_if_exists() {
    local file="$1"
    if [ -e "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
        echo "Backing up $file"
        if [ -L "$HOME/$file" ]; then
            # It's a symlink, remove it instead of moving
            rm "$HOME/$file"
        else
            # It's a regular file, move it to backup
            mv "$HOME/$file" "${bkpDir}/" 2>/dev/null || true
        fi
    fi
}

# Function to create symlink safely
create_symlink() {
    local source_file="$1"
    local target_file="$2"

    if [ -f "$DOTFILES_DIR/$source_file" ]; then
        ln -sf "$DOTFILES_DIR/$source_file" "$HOME/$target_file"
        echo "Linked $source_file -> $target_file"
    else
        echo "Warning: Source file $source_file not found in dotfiles directory"
    fi
}

# Backup existing dotfiles first
echo "Finding files to backup..."
dotfiles=(.zshrc .vimrc .bashrc .bash_profile .gitconfig .tmux.conf .zshenv .zshrc-e .zshrc.alias .zshrc.local)
for file in "${dotfiles[@]}"; do
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
echo "Do you want to install Oh My Zsh? (y/n)"
read -r install_ohmyzsh

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
create_symlink ".zshenv" ".zshenv"
create_symlink ".zshrc" ".zshrc"
create_symlink ".zshrc-e" ".zshrc-e"
create_symlink ".zshrc.alias" ".zshrc.alias"
create_symlink ".zshrc.local" ".zshrc.local"

# Git config (only if it doesn't exist to avoid overwriting user settings)
if [ ! -f "$HOME/.gitconfig" ]; then
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
    features = side-by-side line-numbers decorations
    whitespace-error-style = 22 reverse
    navigate = true
    light = false
[pull]
    rebase = false
[interactive]
    diffFilter = delta --color-only
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
EOF
    echo "✅ .gitconfig created with your user info and recommended settings."
else
    echo "Warning: .gitconfig already exists, skipping creation."
fi

# Other configs
create_symlink ".tmux.conf" ".tmux.conf"

# Link other config directories if they exist
if [ -d "$DOTFILES_DIR/.config" ]; then
    echo "Linking additional config directories..."
    mkdir -p ~/.config

    # Link individual config subdirectories to avoid conflicts
    for config_dir in "$DOTFILES_DIR/.config"/*; do
        if [ -d "$config_dir" ]; then
            dir_name=$(basename "$config_dir")
            # Skip nvim as it's handled separately below
            if [ "$dir_name" != "nvim" ]; then
                ln -sf "$config_dir" ~/.config/ 2>/dev/null || echo "Warning: Could not link $dir_name config"
                echo "Linked ~/.config/$dir_name"
            fi
        fi
    done
fi

echo -e "\n✅ Dotfiles are linked!"

# Git configuration
echo "Do you want to configure git user and email? (y/n)"
read -r gituser

if [[ "$gituser" = "y" ]]; then
    echo "What is your name?"
    read -r gitname
    echo "What is your email?"
    read -r gitemail

    git config --global user.name "${gitname}"
    git config --global user.email "${gitemail}"
    echo "✅ Git user configured"
fi

# Vim-plug installation
echo "Do you wish to install vim-plug (modern Vim plugin manager)? (y/n)"
read -r vimplug

if [[ "$vimplug" = "y" ]]; then
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "✅ vim-plug installed successfully"
fi

# Development tools installation (macOS)
if [[ "$OSTYPE" == darwin* ]]; then
    echo "Install essential development tools via Homebrew? (y/n)"
    read -r install_tools

    if [[ "$install_tools" = "y" ]]; then
        echo "Updating Homebrew..."
        brew update

        echo "Installing essential development tools..."
        # Install fortune first (needed for Oh My Zsh hitchhiker plugin)
        brew install fortune

        # Essential dev tools
        brew install git nvm neovim fzf the_silver_searcher jq wget curl tree htop imagemagick gnupg pinentry-mac gh tmux

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
        echo "Configure GPG for Git commit signing? (y/n)"
        read -r setup_gpg

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
            echo "Setting up Starship with Nerd Font Symbols preset..."
            starship preset nerd-font-symbols -o ~/.config/starship.toml
            echo "✅ Starship configuration created with Nerd Font Symbols preset"
        else
            echo "ℹ️  Starship config already exists, keeping your custom configuration"
        fi
    fi

    # Optional: BetterTouchTool
    echo "Install BetterTouchTool for advanced macOS automation? (y/n)"
    echo "(Note: BetterTouchTool is a paid app but offers powerful gesture and automation features)"
    read -r btt

    if [[ "$btt" = "y" ]]; then
        echo "Installing BetterTouchTool..."
        brew install --cask bettertouchtool
        echo "✅ BetterTouchTool installed! You'll need to purchase a license from folivora.ai"
    fi
fi

# Vim plugins installation
echo "Install vim plugins now? (y/n)"
read -r vimplugins

if [[ "$vimplugins" = "y" ]] && command -v vim &>/dev/null; then
    echo "Installing vim plugins..."
    vim +PlugInstall +qall
    echo "✅ Vim plugins installed"
fi

# Programming fonts
echo "Install modern programming fonts? (y/n)"
echo "(Includes JetBrains Mono Nerd Font, Cascadia Code, and other developer favorites)"
read -r fonts

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
    echo "Setup Node.js LTS via NVM? (y/n)"
    read -r node_setup

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

# Neovim configuration
echo "Setup Neovim configuration? (y/n)"
echo "(This will add modern Lua-based Neovim config alongside your Vim setup)"
read -r neovim_setup

if [[ "$neovim_setup" = "y" ]]; then
    echo "Setting up Neovim configuration..."
    mkdir -p ~/.config/nvim

    # Remove any existing conflicting symlinks
    [ -L ~/.config/nvim/.vim ] && rm ~/.config/nvim/.vim
    [ -L ~/.config/nvim/init.vim ] && rm ~/.config/nvim/init.vim
    [ -L ~/.config/nvim/init.lua ] && rm ~/.config/nvim/init.lua
    [ -L ~/.config/nvim/lua ] && rm ~/.config/nvim/lua

    if [ -f "$DOTFILES_DIR/.config/nvim/init.lua" ]; then
        # Link modern Neovim configuration
        ln -sf "$DOTFILES_DIR/.config/nvim/init.lua" ~/.config/nvim/init.lua 2>/dev/null || echo 'Warning: Could not link init.lua'

        # Link lua directory if it exists
        if [ -d "$DOTFILES_DIR/.config/nvim/lua" ]; then
            ln -sf "$DOTFILES_DIR/.config/nvim/lua" ~/.config/nvim/lua 2>/dev/null || echo 'Warning: Could not link lua directory'
        fi

        echo "✅ Modern Neovim configuration linked (init.lua + lazy.nvim)"
    else
        echo "❌ No modern Neovim configuration found in .config/nvim/"
        # Fallback: link vim config to neovim
        ln -sf "$DOTFILES_DIR/.vimrc" ~/.config/nvim/init.vim 2>/dev/null || echo 'Warning: Could not link .vimrc as init.vim'
    fi
fi

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
echo "   ✅ Vim/Neovim with modern plugin management"
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
echo "   3. Try Starship prompt: 'eval \"\$(starship init zsh)\"' (temporary test)"
echo "   4. Try modern tools: 'eza -la', 'bat filename', 'rg search-term'"
echo "   5. Use FZF: Ctrl+R (history), Ctrl+T (files), Alt+C (directories)"
if [[ "$neovim_setup" = "y" ]]; then
    echo "   6. Run 'nvim' to start Neovim with your modern configuration"
fi

echo ""
echo "💡 QUICK TEST COMMANDS:"
echo "   • starship --version                    # Test Starship prompt"
echo "   • eval \"\$(starship init zsh)\"         # Try Starship temporarily"
echo "   • fzf --version                         # Test fuzzy finder"
echo "   • rg --version                          # Test ripgrep"
echo "   • eza --version                         # Test modern ls replacement"
echo "   • nvim --version                        # Test Neovim"
echo "   • gpg --version                         # Test GPG for security/signing"
echo ""
echo "🔧 Your development environment is ready! Happy coding! 🧑‍💻"

