# 🚀 Starship Prompt Setup Guide

[Starship](https://starship.rs/) is a modern, fast, and customizable prompt for any shell. It's included in your dotfiles installation and provides a beautiful, informative terminal experience.

## 🎯 Quick Setup

### 1. **Install via Dotfiles Script**
```bash
./install.sh
# Choose 'y' for both development tools and programming fonts
```

### 2. **Set Your Terminal Font**
**For iTerm2:**
1. Open iTerm2 → Settings (`Cmd + ,`)
2. Go to Profiles → Text
3. Change font to: `JetBrainsMonoNerdFont-Regular`
4. Size: 12-14pt

**For Terminal.app:**
1. Terminal → Preferences (`Cmd + ,`)
2. Profiles → Text → Change Font
3. Select: `JetBrainsMonoNerdFont-Regular`

### 3. **Test Starship**
```bash
# Test temporarily
eval "$(starship init zsh)"

# Navigate to a git repo to see full features
cd ~/dotfiles
```

## 🎨 What You'll See

With proper font setup, your prompt will show:

```
dotfiles on  master [✘!?] via 🌙 took 2s
❯ 
```

**Components:**
- 📁 **Directory**: Current folder name
- 🌿 **Git branch**: ` master` with proper icon
- 📊 **Git status**: `[✘!?]` (modified, added, untracked files)
- 🔧 **Language**: Detected language/runtime (🌙 for Lua, ⬢ for Node.js, etc.)
- ⏱️ **Duration**: Command execution time (for commands > 2s)
- ❯ **Prompt**: Green on success, red on error

## ⚙️ Configuration

Your Starship config is at `~/.config/starship.toml` and includes:

### **Features Enabled:**
- ✅ **Fast scanning** (10ms timeout)
- ✅ **No extra newlines** (compact)
- ✅ **Beautiful icons** (with Nerd Font)
- ✅ **Git integration** (branch, status, state)
- ✅ **Language detection** (Node.js, Python, Rust, Go, Java, Lua, Ruby, PHP)
- ✅ **Command duration** (for slow commands)
- ✅ **Right-side info** (language versions)

### **Customization Examples:**

**Want plain text instead of icons?**
```toml
[git_branch]
symbol = "git:"

[nodejs]
symbol = "node:"

[python]
symbol = "py:"
```

**Change colors:**
```toml
[git_branch]
style = "purple"

[directory]
style = "cyan"
```

**Show username/hostname:**
```toml
[username]
show_always = true
format = "[$user]($style)@"

[hostname]
ssh_only = false
format = "[$hostname]($style) in "
```

## 🔧 Making It Permanent

### **Option 1: Add to .zshrc**
Add this line to your `~/.zshrc`:
```bash
eval "$(starship init zsh)"
```

### **Option 2: Use Oh My Zsh Theme**
Comment out your current theme and add Starship:
```bash
# ZSH_THEME="wezm"  # Comment out existing theme
eval "$(starship init zsh)"
```

## 🐛 Troubleshooting

### **Missing Icons/Weird Characters?**
- ❌ Your terminal font doesn't support Nerd Font icons
- ✅ **Solution**: Install and use `JetBrainsMonoNerdFont-Regular`

### **Slow Prompt?**
- ❌ Large repository or slow filesystem
- ✅ **Solution**: Increase `scan_timeout` in `~/.config/starship.toml`

### **Want Different Icons?**
- 📖 **Reference**: [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)
- ⚙️ **Edit**: `~/.config/starship.toml` to change symbols

## 📚 Advanced Features

### **Git Status Symbols**
- `?` - Untracked files
- `!` - Modified files  
- `+` - Staged files
- `✘` - Deleted files
- `⇡` - Ahead of remote
- `⇣` - Behind remote

### **Language Detection**
Starship automatically detects:
- **Node.js**: `package.json` present
- **Python**: `.py` files or `requirements.txt`
- **Rust**: `Cargo.toml` present  
- **Go**: `go.mod` present
- **Java**: `.java` files or `pom.xml`
- **Lua**: `.lua` files present

### **Performance**
- ⚡ **Fast**: Written in Rust
- 🎯 **Smart**: Only scans what's needed
- 💾 **Lightweight**: Minimal memory usage

## 🔗 Resources

- 📖 **Official Docs**: https://starship.rs/
- 🎨 **Configuration**: https://starship.rs/config/
- 🔧 **Presets**: https://starship.rs/presets/
- 🎭 **Nerd Fonts**: https://www.nerdfonts.com/

---

**Enjoy your beautiful new prompt!** 🚀✨ 