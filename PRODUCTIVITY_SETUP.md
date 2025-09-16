# 🚀 Ultimate Productivity Setup Guide

This guide contains mind-blowing productivity enhancements for your development environment.

## 🎯 Quick Start

Run the productivity check to see what's missing:
```bash
productivity-check
```

Install everything at once:
```bash
install-productivity-tools
```

## 🛠️ Service Management CLI Tools

### Docker Management
```bash
d               # docker
dc              # docker-compose
dcu             # docker-compose up -d
dcd             # docker-compose down
dcl             # docker-compose logs -f
dcr             # docker-compose restart
dps             # docker ps (formatted)
```

### System Services (macOS)
```bash
services        # brew services list
start-service   # brew services start <service>
stop-service    # brew services stop <service>
restart-service # brew services restart <service>
```

### Process Management
```bash
psg firefox     # Find process by name
killport 3000   # Kill process on port 3000
memhog          # Show top memory consumers
cpuhog          # Show top CPU consumers
```

### Network Utilities
```bash
myip            # Get external IP
localip         # Get local IP
speedtest       # Test internet speed
ports           # Show listening ports
```

## 📱 Social Media CLI Tools

### Twitter/Bluesky
```bash
tweet           # rainbowstream (install: brew install rainbowstream)
bluesky         # @bluesky/cli (install: npm install -g @bluesky/cli)
```

### Mastodon & Reddit
```bash
mastodon        # toot (install: brew install toot)
reddit          # reddit-cli (install: pip3 install reddit-cli)
```

### GitHub CLI Enhancements
```bash
gh-pr           # Create PR
gh-issue        # Create issue
gh-repo         # Create repository
gh-clone        # Clone repository
gh-fork         # Fork repository
```

## 🤖 Mind-Blowing Productivity Tools

### AI/ML Tools
```bash
chatgpt         # OpenAI CLI integration
grok            # Grok AI assistant
aider           # AI pair programming (pip3 install aider-chat)
copilot-cli     # GitHub Copilot CLI
```

### TUI Applications
```bash
tui-cal         # Calendar (khal)
tui-music       # Music player (ncmpcpp)
tui-file        # File manager (ranger)
tui-mail        # Email client (neomutt)
```

### Terminal Power Tools
```bash
tldr tar        # Simplified man pages
cheat tar       # Community cheatsheets
howdoi "extract tar file"  # Stack Overflow search
fzf             # Fuzzy finder
fd pattern      # Modern find
eza -la         # Modern ls
bat file.txt    # Syntax-highlighted cat
```

### Development Workflow
```bash
serve           # Start HTTP server (port 8000)
jsonpp          # Pretty-print JSON
urlencode       # URL encode text
urldecode       # URL decode text
lazygit         # TUI Git client
gh-dash         # GitHub dashboard
```

### Advanced Networking
```bash
ngrok http 3000 # Expose local server
wireshark-cli   # Packet analyzer
http GET https://api.github.com/user  # HTTP client
curl-time https://example.com  # Timing info
```

### Database Management
```bash
redis-cli       # Redis client
mongo           # MongoDB client
pgcli           # PostgreSQL client
```

### Cloud CLI Tools
```bash
aws             # AWS CLI
gcloud          # Google Cloud
azure           # Azure CLI
k               # kubectl
```

### Code Quality
```bash
cloc .          # Count lines of code
complexity      # Code complexity analysis
license-checker # Check licenses
```

## 🔌 Essential ZSH Plugins

### Installation
```bash
setup-zsh-plugins
```

### Manual Installation
```bash
brew install \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    zsh-completions \
    fast-syntax-highlighting \
    zsh-history-substring-search
```

### Configuration (add to ~/.zshrc)
```bash
# ZSH Plugins
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
FPATH=/opt/homebrew/share/zsh-completions:$FPATH
autoload -Uz compinit && compinit
```

### Plugin Features
- **zsh-syntax-highlighting**: Real-time syntax highlighting
- **zsh-autosuggestions**: Auto-complete based on history
- **zsh-completions**: Enhanced tab completion
- **fast-syntax-highlighting**: Faster, better highlighting
- **zsh-history-substring-search**: Search through history with arrows

## 🎮 Fun & Productivity

### Entertainment
```bash
weather         # Weather info (curl wttr.in)
moon            # Moon phase
fortune         # Random quotes
cowsay "Hello"  # ASCII art cow
lolcat          # Rainbow colors
```

### The Fuck
```bash
# Auto-correct last command
fuck
```

## ⚡ System Monitoring

### Hardware Info
```bash
sysinfo         # System information
diskusage       # Disk usage
battery         # Battery status (macOS)
```

## 🚀 Installation Commands

### One-Command Install
```bash
install-productivity-tools
```

### Manual Installation

#### Core Tools
```bash
brew install \
    tldr fzf fd eza bat ripgrep jq yq httpie \
    lazygit git-flow gh fortune cowsay lolcat \
    ngrok/ngrok/ngrok thefuck
```

#### ZSH Plugins
```bash
brew install \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    zsh-completions \
    fast-syntax-highlighting \
    zsh-history-substring-search
```

#### Python Tools
```bash
pip3 install howdoi cheat pgcli mycli litecli
```

#### Node.js Tools
```bash
npm install -g \
    @githubnext/copilot-cli \
    license-checker \
    complexity-report
```

## 🎯 Productivity Workflow Examples

### Daily Development
```bash
# Start development environment
dcu && lazygit &

# Check system status
sysinfo && battery

# Quick documentation
tldr docker && howdoi "docker compose up"

# Code analysis
cloc . && complexity-report -f json .
```

### Social Media & Communication
```bash
# Post to social media
rainbowstream -i  # Twitter
toot post "Hello from CLI!"  # Mastodon

# GitHub workflow
gh pr create && gh dash
```

### System Administration
```bash
# Monitor services
services && dps

# Network troubleshooting
ports && speedtest

# Process management
psg chrome && memhog
```

## 🔧 Configuration Files

- **Starship**: Enhanced git status indicators
- **ZSH Aliases**: Comprehensive productivity aliases
- **Git Ignore**: Smart search exclusions
- **Install Script**: Automated setup

## 📚 Resources

- [tldr-pages](https://tldr.sh/) - Simplified man pages
- [HTTPie](https://httpie.org/) - User-friendly HTTP client
- [lazygit](https://github.com/jesseduffield/lazygit) - Terminal UI for git
- [GitHub CLI](https://cli.github.com/) - GitHub from the command line
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [eza](https://github.com/eza-community/eza) - Modern replacement for ls
- [bat](https://github.com/sharkdp/bat) - Cat with syntax highlighting

## 🎉 Next Steps

1. Run `productivity-check` to see what's installed
2. Run `install-productivity-tools` to install everything
3. Run `setup-zsh-plugins` for ZSH enhancements
4. Restart your terminal to load new configurations
5. Try commands like `tldr tar`, `fd pattern`, `eza -la`

Your terminal is now a productivity powerhouse! 🚀
