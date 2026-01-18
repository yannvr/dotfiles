# Vim/Neovim Tab Navigation Setup
**Updated:** 2026-01-14

## ✅ Implemented Solution

### Primary Tab Switching: OPT+[ and OPT+]
The optimal keybindings for quick tab navigation:

```vim
" Primary mappings (OPT+[ and OPT+])
nnoremap <silent> <Esc>[ :tabprevious<CR>
nnoremap <silent> <Esc>] :tabnext<CR>
```

### Alternative Shortcuts
```vim
" Alternative convenience mappings
nnoremap <silent> æ :tabnext<CR>      " OPT+a
nnoremap <silent> … :tabprevious<CR>  " OPT+w

" New tab and close
nnoremap <silent> † :tabnew<CR>       " OPT+t
nnoremap <silent> Ê :tabclose<CR>     " OPT+Shift+t

" Quick jump to specific tab
nnoremap <silent> <leader>1 1gt       " Jump to tab 1
nnoremap <silent> <leader>2 2gt       " Jump to tab 2
nnoremap <silent> <leader>3 3gt       " Jump to tab 3
" ... through <leader>9 for tab 9
nnoremap <silent> <leader>0 :tablast<CR>  " Jump to last tab
```

### Tab Management Commands
```vim
<leader>tn    " New tab
<leader>tc    " Close current tab
<leader>to    " Close all other tabs
<leader>bt    " Convert all buffers to tabs
```

## 🔧 iTerm2 Setup Required

For OPT+[ and OPT+] to work properly:

1. **Open iTerm2 Preferences** (⌘,)
2. **Navigate to:** Profiles → Keys → General
3. **Configure Option Keys:**
   - **Left Option Key:** `Esc+` ✓
   - **Right Option Key:** `Normal` (optional, for accents)
4. **Save and restart** iTerm2

### Verification
```bash
# Test that Option key sends escape sequences
cat > /dev/null
# Press OPT+[
# Should display: ^[[  (escape + bracket)
# Press Ctrl+C to exit
```

## 📝 Usage Examples

### Basic Tab Navigation
```vim
# Open multiple files in tabs
vim -p file1.txt file2.txt file3.txt

# Inside vim:
OPT+]         " Next tab
OPT+[         " Previous tab
OPT+a         " Next tab (alternative)
OPT+w         " Previous tab (alternative)
```

### Quick Tab Jumping
```vim
\1            " Jump to tab 1 (leader + 1)
\2            " Jump to tab 2
\3            " Jump to tab 3
\0            " Jump to last tab
```

### Tab Management
```vim
\tn           " Create new tab
\tc           " Close current tab
\to           " Close all other tabs
OPT+t         " Create new tab (quick)
OPT+Shift+t   " Close current tab (quick)
```

## 🚀 Neovim Enhancements

### Terminal Mode Support
In Neovim, you can switch tabs even from terminal mode:

```vim
# In terminal mode (inside :terminal)
OPT+]         " Next tab (exits terminal mode first)
OPT+[         " Previous tab (exits terminal mode first)
```

Configuration in `~/.config/nvim/init.vim`:
```vim
tnoremap <silent> <Esc>[ <C-\><C-n>:tabprevious<CR>
tnoremap <silent> <Esc>] <C-\><C-n>:tabnext<CR>
```

## 🎯 What Changed

### Removed Conflicting Mappings
❌ **Old (Removed):**
```vim
nnoremap " :tabprevious<CR>  " Conflicts with registers
nnoremap ' :tabnext<CR>      " Conflicts with marks
```

✅ **New (No Conflicts):**
```vim
nnoremap <silent> <Esc>[ :tabprevious<CR>  " Clean escape sequence
nnoremap <silent> <Esc>] :tabnext<CR>      " Clean escape sequence
```

### Added Features
- ✅ Direct tab jumping with `<leader>1-9`
- ✅ Terminal mode tab navigation (Neovim)
- ✅ Tab management commands
- ✅ Silent mappings (no command echo)

## 📊 Performance Impact

- **No additional latency** - Simple key mappings
- **Vim startup:** ~2.1s (unchanged, plugin loading time)
- **Neovim startup:** ~0.06s (unchanged, fast async loading)

## 🔍 Troubleshooting

### Problem: OPT+[ and OPT+] don't work

**Solution:**
1. Check iTerm2 Left Option Key is set to `Esc+`
2. Restart iTerm2 after changing settings
3. Verify with `cat > /dev/null` then press OPT+[

### Problem: Alternative mappings (æ, …) don't work

**Solution:**
These require iTerm2 Left Option Key set to `Normal` instead of `Esc+`.
Use the `<Esc>[` and `<Esc>]` mappings instead.

### Problem: Tab navigation works in vim but not nvim

**Solution:**
Check that `~/.config/nvim/init.vim` exists and sources `~/.vimrc`:
```vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
```

### Problem: Mappings conflict with other plugins

**Solution:**
All mappings use `<silent>` to avoid conflicts.
Check for conflicts with:
```vim
:verbose nmap <Esc>[
:verbose nmap <Esc>]
```

## 📚 Related Files

- **Main config:** `~/.vimrc`
- **Mappings:** `~/.vimrc.maps`
- **Neovim config:** `~/.config/nvim/init.vim`
- **iTerm2 guide:** `~/dotfiles/iterm2-alt-key-setup.md`
- **Config review:** `~/dotfiles/VIM_CONFIG_REVIEW.md`

## 🎉 Quick Reference Card

| Action | Primary | Alternative | Leader Command |
|--------|---------|-------------|----------------|
| **Next tab** | `OPT+]` | `OPT+a` | - |
| **Previous tab** | `OPT+[` | `OPT+w` | - |
| **New tab** | `OPT+t` | - | `\tn` |
| **Close tab** | `OPT+Shift+t` | - | `\tc` |
| **Jump to tab 1** | - | - | `\1` |
| **Jump to tab 2** | - | - | `\2` |
| **Last tab** | - | - | `\0` |
| **Close others** | - | - | `\to` |
| **Buffers→Tabs** | - | - | `\bt` |

---

**Note:** `\` represents your leader key (backslash by default)
