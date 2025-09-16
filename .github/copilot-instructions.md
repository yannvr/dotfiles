# GitHub Copilot Instructions for Dotfiles Repository

## Repository Overview

This is a comprehensive macOS dotfiles repository providing automated setup of a modern development environment. It uses a modular architecture with symlinked configurations, comprehensive installer with safety features, and template-based personalization.

## Architecture & Structure

### Core Components
- **Modular Configuration**: Vim/Neovim configs split across multiple files (`.vimrc.plugin`, `.vimrc.conf.base`, `.vimrc.maps`, etc.)
- **Shell Setup**: Zsh with Oh My Zsh integration, separate alias file (`.zshrc.alias`)
- **Installation System**: Comprehensive installer (`install.sh`) with multiple modes and safety features
- **Backup System**: Automatic backups in `bkp/dotfiles-{date}/` before any changes
- **Custom Scripts**: Utilities in `~/bin/` directory (e.g., `killport.sh` for port management)

### Key Patterns
- **Template Files**: `.example` files (`.zshrc.local.example`, `.zshenv.example`) for user customization
- **Gitignored Personal Configs**: User-specific files (`.zshrc.local`, `.zshenv`, `.zshrc.private`) are gitignored
- **Symlinked Dotfiles**: All configs are symlinked from repo to home directory
- **Modular Vim Config**: Plugin definitions in `.vimrc.plugin`, mappings in `.vimrc.maps`, etc.

## Critical Developer Workflows

### Installation Commands
```bash
./install.sh              # Interactive mode (recommended)
./install.sh --yes        # Auto-yes mode (full installation)
./install.sh --dry-run    # Safe preview (shows what would be done)
./install.sh -n           # Non-interactive mode (minimal)
```

### Post-Installation Setup
1. **Create personal configs** from templates:
   ```bash
   cp .zshenv.example .zshenv           # Environment variables
   cp .zshrc.local.example .zshrc.local # Local shell customizations
   cp .zshrc.private.example .zshrc.private  # Sensitive settings
   ```

2. **Essential tools**:
   ```bash
   ~/bin/killport.sh 3000    # Kill process on port 3000
   ~/bin/killport.sh 300*    # Kill processes on ports starting with 300
   ```

### Development Tools Integration
- **FZF shortcuts**: `Ctrl+R` (history), `Ctrl+T` (files), `Alt+C` (directories)
- **Modern CLI**: `eza -la` (ls), `bat filename` (cat), `rg search-term` (grep), `fd pattern` (find)
- **Vim plugins**: `vim +PlugInstall +qall` to install, `vim +PlugUpdate +qall` to update

## Project-Specific Conventions

### Configuration File Organization
- **Vim**: Modular config with separate files for plugins, mappings, completion, base settings
- **Zsh**: Main config in `.zshrc`, aliases in `.zshrc.alias`, personal customizations in `.zshrc.local`
- **Git**: Comprehensive `.gitconfig` with aliases, delta integration, GPG signing setup
- **Templates**: All user-customizable configs have `.example` versions

### Safety & Backup Patterns
- **Pre-installation verification**: Checks all dotfiles exist before backing up
- **Selective backup**: Only backs up files that will actually be replaced
- **Dry-run mode**: Safe preview showing exactly what would change
- **Backup location**: `bkp/dotfiles-{date}/` with timestamp

### Integration Points
- **Package Management**: Homebrew for tools, vim-plug for Vim plugins
- **Shell Enhancement**: Oh My Zsh with zsh-syntax-highlighting plugin
- **Prompt**: Starship with Tokyo Night theme configuration
- **Terminal**: iTerm2 with custom color schemes, programming fonts
- **External Tools**: GPG for commit signing, NVM for Node.js, FZF for fuzzy finding

## Key Files & Directories

- `install.sh`: Main installer with multiple modes and safety checks
- `bin/killport.sh`: Custom port management utility
- `.vimrc.plugin`: Vim plugin definitions using vim-plug
- `.zshrc.alias`: Custom shell aliases
- `iTerm2/`: Terminal color schemes
- `fonts/`: Programming fonts (JetBrains Mono, Cascadia Code, etc.)
- `*.example`: Template files for user customization (gitignored when copied)

## Development Environment Setup

### Essential Tools Installed
- **Editors**: Vim/Neovim with vim-plug plugin management
- **Shell**: Zsh with Oh My Zsh and Starship prompt
- **Version Control**: Git with delta, GPG signing, comprehensive aliases
- **Search**: ripgrep, fd, fzf for fast file/directory operations
- **Modern CLI**: eza (ls), bat (cat), modern replacements for Unix tools

### Configuration Philosophy
- **Non-destructive**: Preserves existing configurations with backups
- **Modular**: Separate concerns across multiple files
- **Personalizable**: Template system for user-specific customizations
- **Modern**: 2025-focused tool choices (JetBrains Mono, Starship, etc.)

## Common Tasks

### Adding New Configurations
1. Add config file to repository
2. Update `install.sh` backup and symlink arrays
3. Create `.example` template if user-customizable
4. Test with `--dry-run` mode

### Modifying Vim Setup
- Plugin additions: Edit `.vimrc.plugin`
- Key mappings: Edit `.vimrc.maps`
- Base settings: Edit `.vimrc.conf.base`
- Completion: Edit `.vimrc.completion`

### Updating Tool Versions
- Homebrew packages: Update `brews` file
- Vim plugins: Run `vim +PlugUpdate +qall`
- Oh My Zsh: `upgrade_ohmyzsh` command

## Troubleshooting Patterns

### Installation Issues
- Use `--dry-run` to preview changes
- Check backup directory for preserved configs
- Verify Homebrew PATH setup
- Ensure Oh My Zsh doesn't conflict with existing shell config

### Configuration Problems
- Personal configs override repo settings (`.zshrc.local`, etc.)
- Check symlink integrity: `ls -la ~/.zshrc` should show symlink
- Restart terminal after font installations
- Verify Nerd Font setup for Starship icons</content>
<parameter name="filePath">/Users/yann/dotfiles/.github/copilot-instructions.md
