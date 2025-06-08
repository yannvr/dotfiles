# Modern Dotfiles (2025)

A comprehensive, modern development environment setup for Vim, Neovim, Zsh, Git, and essential development tools. Optimized for 2024/2025 development workflows.

## ✨ What's New in 2025

- **Modern font choices**: JetBrains Mono, Cascadia Code, Monaspace instead of outdated FiraCode
- **Enhanced terminal experience**: Starship prompt, modern CLI tools (exa, bat, ripgrep, fd)
- **Better window management**: Rectangle, AltTab, Raycast instead of basic tools  
- **Development essentials**: Docker, Postman, TablePlus, UTM for local development
- **BetterTouchTool integration**: Advanced macOS automation and gesture support
- **Improved productivity**: Maccy clipboard manager, Shottr screenshots, ImageOptim

## 🚀 Quick Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yannvr/dotfiles ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The installer will guide you through setting up:
- Core dotfiles and configurations  
- Modern development tools via Homebrew
- Programming fonts and terminal enhancements
- Optional tools for enhanced productivity

## 📦 What's Included

### **Core Development Tools**
- **Vim/Neovim**: Modern editor configuration with vim-plug
- **Zsh**: Enhanced shell with Oh My Zsh and Starship prompt  
- **Git**: Optimized version control configuration
- **tmux**: Terminal multiplexer for efficient workflows

### **Modern CLI Tools** 
- `starship` - Beautiful, fast shell prompt
- `exa` - Modern replacement for `ls`
- `bat` - Syntax-highlighted `cat` replacement
- `ripgrep` - Ultra-fast text search
- `fd` - Fast and user-friendly alternative to `find`
- `fzf` - Fuzzy finder for files and commands
- `jq` - JSON processor for API work

### **GUI Applications**
- **Development**: VS Code, Docker, Postman, TablePlus, UTM
- **Productivity**: Rectangle (window management), Raycast (Spotlight replacement)
- **Communication**: Slack, Discord  
- **Utilities**: Maccy (clipboard), Shottr (screenshots), ImageOptim
- **Optional**: BetterTouchTool for advanced macOS automation

### **Programming Fonts** 
- **JetBrains Mono** - Recommended for most developers
- **Cascadia Code** - Microsoft's modern coding font  
- **Monaspace** - GitHub's innovative font system
- **Fira Code** - Classic option with programming ligatures
- **Hack Nerd Font** - Great for terminal work

## 🎯 Why These Choices?

### Fonts
- **JetBrains Mono**: Excellent readability, great ligatures, actively maintained
- **Cascadia Code**: Microsoft's modern take, excellent for Windows/cross-platform
- **Monaspace**: GitHub's innovative approach with texture healing
- **FiraCode still included** but no longer the primary recommendation

### Tools  
- **Raycast** over Alfred: Better integration, modern UI, built-in features
- **Rectangle** over Spectacle: Actively maintained, more features
- **Starship** over custom prompts: Cross-shell, fast, highly configurable
- **Modern CLI tools**: Significantly faster and more user-friendly than traditional Unix tools

### Development Environment
- **Docker**: Essential for modern development, isolated environments
- **TablePlus**: Beautiful database client for multiple database types
- **UTM**: Open-source virtualization for M1/M2 Macs (instead of expensive alternatives)

## 🔧 Customization

The installer is interactive and allows you to:
- Skip any component you don't want
- Choose between basic and extended tool sets
- Configure Git user information during setup
- Set up Node.js version management with nvm

## 💡 Post-Installation Tips

1. **Configure Raycast**: Set up with `CMD+Space` to replace Spotlight
2. **Set up Rectangle**: Configure your preferred window management shortcuts
3. **Choose your font**: Try JetBrains Mono first, then experiment with others
4. **Explore modern CLI tools**: Try `exa -la`, `bat filename`, `rg search-term`
5. **BetterTouchTool**: If installed, explore trackpad gestures and automation

## 🆕 Migration from Older Setups

If you're migrating from an older dotfiles setup:
- Your existing configurations are backed up automatically
- vim-plug replaces deprecated NeoBundle
- Modern alternatives are suggested for outdated tools
- Neovim configuration is optional and doesn't interfere with Vim

## 🛠 Manual Configuration

After installation, you may want to manually configure:
- **VS Code**: Install recommended extensions (GitLens, Prettier, etc.)
- **Terminal font**: Set your chosen programming font
- **BetterTouchTool**: Purchase license and configure gestures (if installed)
- **Raycast**: Set up as primary launcher

## 📚 Documentation

- **Starship**: [starship.rs](https://starship.rs) for prompt customization
- **Rectangle**: Built-in help and configuration options
- **Modern CLI tools**: Use `man` pages or `--help` flags for each tool

## 🤝 Contributing

Feel free to suggest improvements for the 2025 development landscape! This setup is designed to stay current with modern development practices.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding with modern tools!** 🧑‍💻✨
