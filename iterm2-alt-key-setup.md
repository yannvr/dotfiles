# iTerm2 Alt/Option Key Configuration Guide (Updated for iTerm2 3.5.14)

## Problem
Alt/Option key combinations (like `Alt+h`, `Alt+j`, etc.) don't work properly in iTerm2 with vim, tmux, or other terminal applications.

## Quick Diagnosis
Run this to check your current iTerm2 version and settings:
```bash
# Check iTerm2 version
/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" /Applications/iTerm.app/Contents/Info.plist

# Check current Alt key settings
defaults read com.googlecode.iterm2 OptionKeyAsMetaLeft
defaults read com.googlecode.iterm2 OptionKeyAsMetaRight

# Check for conflicting profile settings
defaults read com.googlecode.iterm2 | grep "Option Key Sends"
```

Expected output for correct configuration:
- Version: 3.5.14 (or newer)
- Left Option: 1 (true)
- Right Option: 0 (false)
- Option Key Sends: Should NOT be 2 (this blocks Alt+arrows)

## 🎯 Perfect Solution: Natural Text Editing Preset

**For Alt+Left/Right word navigation, use iTerm2's built-in preset:**

1. Open iTerm2 → Preferences → Profiles → Keys
2. Click "Presets..." dropdown (bottom right)
3. Select "Natural Text Editing"
4. Click "Save"

**That's it!** This preset automatically enables:
- ✅ **Alt+Left/Right**: Word navigation (skip words)
- ✅ **Alt+Up/Down**: Line navigation
- ✅ **Cmd+Left/Right**: Line start/end
- ✅ **Other macOS-style key bindings**

### Method 1: Manual Configuration (Alternative)

1. **Open iTerm2 Preferences** (`Cmd+,`)
2. **Go to Profiles → Keys → General**
3. **Set Option Key Behavior:**
   - **Left Option Key**: `Esc+` (recommended)
   - **Right Option Key**: `Normal` (keeps accents working)

**Why this works:**
- `Esc+` makes Option+key send escape sequences that terminal apps understand
- Keeps right Option for typing accents (é, ñ, etc.)

### Method 2: Key Mapping Approach

If you need more granular control:

1. **Go to Profiles → Keys → Key Mappings**
2. **Click "+" to add new mappings**
3. **Add these common vim mappings:**

| Key Combination | Action | Send |
|----------------|--------|------|
| `⌥h` | Send Escape Sequence | `h` |
| `⌥j` | Send Escape Sequence | `j` |
| `⌥k` | Send Escape Sequence | `k` |
| `⌥l` | Send Escape Sequence | `l` |
| `⌥b` | Send Escape Sequence | `b` |
| `⌥f` | Send Escape Sequence | `f` |

### Method 3: Terminal Settings for Specific Apps

For applications that need specific escape sequences:

1. **Go to Profiles → Keys → Key Mappings**
2. **Add application-specific mappings:**

| Key | Action | Send | Use Case |
|-----|--------|------|----------|
| `⌥←` | Send Escape Sequence | `[1;3D` | Word left |
| `⌥→` | Send Escape Sequence | `[1;3C` | Word right |
| `⌥↑` | Send Escape Sequence | `[1;3A` | Line up |
| `⌥↓` | Send Escape Sequence | `[1;3B` | Line down |

## Testing Your Configuration

### Test 1: Basic Alt Key Recognition
```bash
# In terminal, type this and press Alt+h
cat > /dev/null
# Should show: ^[h (where ^[ represents escape)
# If you see: √ or other characters, configuration is incorrect
```

### Test 2: Vim Alt Mappings
```vim
# In vim, try these commands
:map <M-h> :echo "Alt+h works!"<CR>
:map <M-j> :echo "Alt+j works!"<CR>
# Then press Alt+h - should show "Alt+h works!"
```

### Test 3: Check Escape Sequences
```bash
# Use sed to see what sequences are sent
sed -n l
# Type Alt+h, should show: \033h$ or similar
# If you see: [1;3h or other sequences, configuration is working
```

### Test 4: Quick Verification Script
Create and run this test script:
```bash
#!/bin/bash
echo "Testing iTerm2 Alt key configuration..."
echo "Press Alt+h (should show ^[h):"
read -n 1
echo ""
echo "If you saw ^[h above, Alt keys are working correctly!"
echo "If you saw other characters, set the Natural Text Editing preset in iTerm2"
```

## Vim-Specific Configuration

Add these to your `.vimrc` to make use of Alt keys:

```vim
" Enable Alt key mappings in vim
if has('nvim') || has('gui_running')
  " Alt+hjkl for navigation
  nnoremap <M-h> <C-w>h
  nnoremap <M-j> <C-w>j
  nnoremap <M-k> <C-w>k
  nnoremap <M-l> <C-w>l
  
  " Alt+arrows for resizing
  nnoremap <M-Left>  <C-w><
  nnoremap <M-Right> <C-w>>
  nnoremap <M-Up>    <C-w>+
  nnoremap <M-Down>  <C-w>-
endif

" For terminal vim, map escape sequences
if !has('gui_running') && !has('nvim')
  " Map escape sequences to Alt combinations
  execute "set <M-h>=\eh"
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
  execute "set <M-l>=\el"
endif
```

## Tmux Configuration

Add to your `.tmux.conf`:

```bash
# Enable Alt key combinations in tmux
set-window-option -g xterm-keys on

# Alt+hjkl for pane navigation
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# Alt+arrows for pane resizing
bind -n M-Left resize-pane -L 5
bind -n M-Right resize-pane -R 5
bind -n M-Up resize-pane -U 5
bind -n M-Down resize-pane -D 5
```

## Common Issues & Solutions

### Issue 1: Alt Key Sends Special Characters
**Problem**: Alt+key types accents instead of escape sequences
**Solution**: Set Left Option to `Esc+` in iTerm2 preferences

### Issue 2: Some Apps Don't Recognize Alt Combinations
**Problem**: Specific applications ignore escape sequences
**Solution**: Add explicit key mappings in iTerm2 for those apps

### Issue 3: Inconsistent Behavior Across Sessions
**Problem**: Settings don't apply to all terminal sessions
**Solution**: Make sure settings are in the correct profile (Default or your custom profile)

### Issue 4: Right Option Key Behavior
**Problem**: Need accents but also want some Alt functionality
**Solution**: 
- Keep Right Option as `Normal`
- Use Left Option for escape sequences
- Or map specific keys individually

## Quick Setup Script

Add this to your dotfiles for automatic iTerm2 configuration:

```bash
#!/usr/bin/env zsh
# iTerm2 Alt key configuration

# Set iTerm2 preferences via defaults (requires iTerm2 restart)
if command -v defaults &> /dev/null; then
    # Set left option key to send escape sequences
    defaults write com.googlecode.iterm2 OptionKeyAsMetaLeftAndRight -bool false
    defaults write com.googlecode.iterm2 OptionKeyAsMetaLeft -bool true
    defaults write com.googlecode.iterm2 OptionKeyAsMetaRight -bool false
    
    echo "✅ iTerm2 Alt key configuration updated"
    echo "🔄 Restart iTerm2 for changes to take effect"
else
    echo "⚠️ Configure manually: iTerm2 → Preferences → Profiles → Keys"
fi
```

## Recommended Configuration

For the best experience with vim/nvim and terminal applications:

1. **Left Option Key**: `Esc+`
2. **Right Option Key**: `Normal`
3. **Add explicit mappings** for commonly used Alt combinations
4. **Configure vim/tmux** to recognize the escape sequences

This setup gives you:
- ✅ Alt+hjkl navigation in vim
- ✅ Alt+arrow word/line movement
- ✅ Right Option still works for accents
- ✅ Consistent behavior across applications 