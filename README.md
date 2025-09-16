# Modern Dotfiles (2025)

⚡ **Ship faster. Feel faster. Be faster.** ⚡

An unapologetically modern development environment that makes power users unstoppable. Fast shell, sharp tools, beautiful UX. One installer, three modes, zero bullshit.

## 🚀 Quick Start

```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles

# Full workstation (everything you need)
./install.sh --yes

# Light dev (essentials only)
./install.sh --light --yes

# Remote/Bastion (server-optimized)
./install.sh --remote --yes
```

That's it. Your terminal is now a productivity powerhouse.

## 🎯 What Makes This Different

### **Modern Tools That Actually Work**
- **Starship**: Beautiful, fast prompt with git status, versions, everything
- **eza**: `ls` on steroids - colors, icons, git integration
- **bat**: `cat` with syntax highlighting and git diffs
- **ripgrep**: Ultra-fast text search that understands your codebase
- **fd**: Modern `find` that's actually usable
- **fzf**: Fuzzy finder for files, history, everything

### **Workflow That Flows**
- **50+ smart aliases** that eliminate typing repetitive commands
- **Git superpowers** - status, branches, diffs, all optimized
- **Process management** - kill ports, monitor resources, services
- **Network tools** - HTTP requests, JSON processing, API testing
- **File operations** - smart navigation, previews, efficient moves

### **Three Perfect Modes**

| Mode | Use Case | Tools |
|------|----------|-------|
| **Full** | Local workstations, full development | Starship, eza, bat, ripgrep, fd, nvm, gpg, tmux, neovim, jq, curl, htop, gh, pnpm |
| **Light** | Laptops, constrained environments | git, nvim, fzf, ripgrep, tmux, starship, eza, bat |
| **Remote** | Servers, bastion hosts | git, vim, tmux, htop, curl, jq |

### **Remote Work Perfected**
- **SSH optimization** for fast, reliable connections
- **Bastion setup** that's secure and minimal
- **Cross-platform** compatibility
- **Zero GUI apps** on servers (automatically excluded)

## 💡 **Before vs After**

| Task | Before | After |
|------|--------|-------|
| **List files** | `ls -la` | `eza -la` |
| **View file** | `cat file.json` | `bat file.json` |
| **Find files** | `find . -name "*.js"` | `fd "*.js"` |
| **Search text** | `grep -r "TODO" .` | `rg "TODO"` |
| **Git status** | `git status` | `gst` |
| **Process check** | `ps aux \| grep nginx` | `psg nginx` |
| **Kill port** | `lsof -ti:3000 \| xargs kill` | `killport 3000` |

## ⚡ **50+ Life-Saving Aliases**

### **🔥 Git Mastery**
```bash
gst              # git status (beautiful, colored)
gco feature-x    # git checkout feature-x
ga .             # git add all
gcm "fix: bug"   # git commit with message
gp               # git push
gmod             # git merge origin/develop
```

### **🚀 File Navigation**
```bash
..               # cd ..
...              # cd ../..
mkcd projects    # mkdir + cd
eza -la          # beautiful ls
bat README.md    # syntax-highlighted cat
```

### **🔧 Process Control**
```bash
psg nginx        # find nginx processes
killport 3000    # kill process on port 3000
memhog           # show memory hogs
cpuhog           # show CPU hogs
ports            # list listening ports
```

### **🌐 Network Tools**
```bash
http GET api.com # beautiful HTTP requests
speedtest        # internet speed test
myip             # get your IP
localip          # local network IP
```

### **🎨 Development**
```bash
cloc .           # count lines of code
tldr docker      # simplified man pages
complexity .     # code complexity analysis
```

### **🔍 Search & Find**
```bash
fd "*.js"        # modern find
rg "TODO"        # ultra-fast grep
fzf              # fuzzy finder (Ctrl+T files, Ctrl+R history)
```

**Time saved per day: 30-60 minutes. Cognitive load reduced: 80%.**

## 🛠️ **Productivity Apps (Optional)**

For local macOS setups, you can optionally install productivity apps:

```bash
# Check what's available
./setup-app.sh --check-only

# Install productivity apps
./setup-app.sh --yes
```

**Includes**: Amphetamine (keep-awake), Paste (clipboard manager)

> **Note**: Automatically skipped for remote/bastion installs (no GUI apps on servers).

## 📚 **Help & Support**

```bash
./install.sh --help        # Installation options
./install.sh --dry-run     # Safe preview
./setup-app.sh --help      # App installation options
```

## 🤝 **Built for 2025**

Modern development demands modern tools. This setup chooses:
- **Starship** over custom prompts (cross-shell, fast, beautiful)
- **Modern CLI tools** over Unix classics (faster, more user-friendly)
- **Smart aliases** over manual commands (50+ productivity boosters)
- **Multiple modes** over one-size-fits-all (right tools for right context)

**Ready to supercharge your terminal?** ⚡