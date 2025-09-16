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
| **Full** | Local workstations, full development | Starship, eza, bat, ripgrep, fd, nvm, gpg, tmux, neovim, jq, curl, htop, gh, pnpm, Warp/iTerm2 |
| **Light** | Laptops, constrained environments | git, nvim, fzf, ripgrep, tmux, starship, eza, bat |
| **Remote** | Servers, bastion hosts | git, vim, tmux, htop, curl, jq |

### **Terminal Setup** (Full Mode)

#### **🔥 BOTH TERMINALS INSTALLED BY DEFAULT!**

Your setup installs **both terminals** for maximum productivity:

```bash
# Install script automatically installs both:
brew install --cask iterm2  # Fast & customizable
brew install --cask warp    # AI-powered & modern
```

#### **⚡ iTerm2: FAST & CUSTOMIZABLE (Daily Driver)**
- ✅ **Lightning fast** - No bloat, pure speed
- ✅ **Highly customizable** - Themes, shortcuts, plugins
- ✅ **Power user features** - Advanced configuration
- ✅ **Natural Text Editing** preset for Alt+arrow keys

**Use iTerm2 daily for maximum productivity!**

#### **🤖 Warp: AI-POWERED (For Beginners & AI Help)**
- ✅ **AI assistance** - Get help with commands and explanations
- ✅ **Modern UI** - Beautiful design with command blocks
- ✅ **Built-in features** - No configuration needed
- ✅ **Alt+arrow keys** - Work out-of-the-box!
- ✅ **Warp Drive** - Share terminal sessions

**Use Warp when you need AI help or modern UI!**

> **Note:** If you don't know how to use a shell, you'll go to hell. Learn it! 🚀

**For iTerm2 Alt+arrow navigation:**
1. **Preferences** → **Profiles** → **Keys**
2. Click **"Presets..."** → Select **"Natural Text Editing"**
3. **Save** - Done! Alt+Left/Right skip words perfectly ✨

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