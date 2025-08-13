# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modern dotfiles repository for setting up a comprehensive development environment on macOS. It provides automated installation and configuration of development tools, shell enhancements, and Vim/Neovim setups optimized for 2025 development workflows.

## Key Commands

### Installation and Setup
```bash
# Full interactive installation (recommended)
./install.sh

# Non-interactive mode (minimal installation)
./install.sh --non-interactive
./install.sh -n

# Auto-yes mode (full installation)
./install.sh --yes  
./install.sh -y

# Safe preview mode (shows what would be done)
./install.sh --dry-run

# Kill processes on specific ports
~/bin/killport.sh 3000        # Kill process on port 3000
~/bin/killport.sh 300*        # Kill all processes on ports starting with 300
~/bin/killport.sh 3000 8080   # Kill multiple specific ports
```

### Development Workflow
```bash
# Modern terminal tools (installed via installer)
eza -la                       # Modern ls replacement
bat filename                  # Syntax-highlighted cat
rg search-term                # Ultra-fast text search with ripgrep
fd filename                   # Fast and user-friendly find
fzf                          # Fuzzy finder

# FZF shortcuts (after installation)
# Ctrl+R - fuzzy search command history
# Ctrl+T - fuzzy search files
# Alt+C - fuzzy search directories

# Vim/Neovim plugin management
vim +PlugInstall +qall        # Install vim plugins
vim +PlugUpdate +qall         # Update vim plugins
```

## Architecture and Structure

### Core Components

**Dotfiles Management**: Modular Vim configuration split across multiple files:
- `.vimrc` - Main configuration loader
- `.vimrc.plugin` - Plugin definitions using vim-plug
- `.vimrc.conf.base` - Base editor settings
- `.vimrc.completion` - Completion and snippet configuration
- `.vimrc.conf` - Additional configuration
- `.vimrc.maps` - Key mappings and shortcuts

**Shell Configuration**: Zsh setup with Oh My Zsh integration:
- `.zshrc` - Main shell configuration with Oh My Zsh themes
- `.zshrc.alias` - Custom aliases and shortcuts
- `.zshenv.example`, `.zshrc.local.example`, `.zshrc.private.example` - Template files for user-specific configurations (not tracked in git)

**Installation System**: Comprehensive installer with safety features:
- `install.sh` - Main installation script with multiple modes
- Backup system in `bkp/dotfiles-{date}/` 
- Verification system to prevent data loss
- Support for dry-run mode for safe testing

### Key Features

**Modern Tool Integration**:
- Starship prompt with Tokyo Night theme for beautiful terminal UI
- FZF integration for fuzzy finding across files, history, and directories
- Modern CLI replacements (eza for ls, bat for cat, ripgrep for grep)
- NVM for Node.js version management
- GPG configuration for secure Git commit signing

**Development Environment**:
- vim-plug for modern Vim plugin management
- GitHub Copilot integration
- Material theme for Vim
- Deoplete/neocomplete for intelligent code completion
- Tab management configured to always show tabs when multiple files are open

**Safety and Reliability**:
- Comprehensive backup system before any changes
- Non-destructive installation (preserves existing configurations)
- Installation verification and testing
- Multiple installation modes for different scenarios

### Directory Structure

```
dotfiles/
├── install.sh              # Main installation script
├── bin/killport.sh         # Custom utility script for port management
├── brews                   # Homebrew packages list
├── .zshrc*                # Shell configuration files
├── .vimrc*                # Vim configuration modules
├── .tmux.conf             # Terminal multiplexer config
├── *.example              # Template files for user customization
├── iTerm2/                # Terminal color schemes
├── fonts/                 # Programming fonts
└── bkp/                   # Backup directory for replaced files
```

## Important Installation Notes

**Installation Order**: The installer follows a specific sequence to avoid conflicts:
1. Install Homebrew first (with proper PATH setup)
2. Install Oh My Zsh with safe flags to prevent shell override
3. Install required plugins (zsh-syntax-highlighting, fortune)
4. Create symlinks for dotfiles (after Oh My Zsh to prevent override)
5. Install development tools and modern CLI replacements

**Font Requirements**: For the best terminal experience with Starship prompt, install and configure a Nerd Font (recommended: JetBrains Mono Nerd Font) in your terminal application.

**User Configuration**: After installation, users should create personal config files from the provided templates:
- `.zshenv` for environment variables
- `.zshrc.local` for local shell customizations  
- `.zshrc.private` for sensitive settings (API keys, etc.)
- `.gitconfig` for Git user information

## Troubleshooting

If installation fails, check:
1. Homebrew installation and PATH configuration
2. Oh My Zsh conflicts with existing shell configuration
3. Missing dependencies (fortune, zsh-syntax-highlighting)
4. File permissions for symlink creation

The installer includes comprehensive error checking and will report specific issues with suggested solutions.