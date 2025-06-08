#!/usr/bin/env zsh

echo "=== iTerm2 Alt/Option Key Configuration ==="
echo "Setting up proper Alt key behavior for vim and terminal applications"
echo ""

# Check if iTerm2 is installed
if ! command -v "/Applications/iTerm.app/Contents/MacOS/iTerm2" &> /dev/null; then
    echo "❌ iTerm2 not found. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install --cask iterm2
        echo "✅ iTerm2 installed"
    else
        echo "⚠️  Please install iTerm2 manually: https://iterm2.com/"
        exit 1
    fi
else
    echo "✅ iTerm2 is installed"
fi

# Configure iTerm2 preferences via defaults
echo "🔧 Configuring iTerm2 Alt key behavior..."

# Set left option key to send escape sequences (Meta)
defaults write com.googlecode.iterm2 OptionKeyAsMetaLeftAndRight -bool false
defaults write com.googlecode.iterm2 OptionKeyAsMetaLeft -bool true
defaults write com.googlecode.iterm2 OptionKeyAsMetaRight -bool false

echo "✅ iTerm2 preferences updated:"
echo "   • Left Option Key: Esc+ (sends escape sequences)"
echo "   • Right Option Key: Normal (for accents)"

# Check if iTerm2 is running and offer to restart
if pgrep -f "iTerm2" > /dev/null; then
    echo ""
    echo "⚠️  iTerm2 is currently running"
    echo "Would you like to restart iTerm2 to apply changes? (y/n)"
    read -r restart_iterm
    
    if [[ "$restart_iterm" = "y" ]]; then
        echo "🔄 Restarting iTerm2..."
        osascript -e 'tell application "iTerm2" to quit'
        sleep 2
        open -a iTerm2
        echo "✅ iTerm2 restarted"
    else
        echo "🔄 Please restart iTerm2 manually for changes to take effect"
    fi
else
    echo "🔄 Start iTerm2 to test the new configuration"
fi

echo ""
echo "=== Testing Your Configuration ==="
echo ""
echo "To test if Alt keys work correctly:"
echo ""
echo "1. Open a new iTerm2 window/tab"
echo "2. Type: cat > /dev/null"
echo "3. Press Alt+h (should show: ^[h)"
echo "4. Press Ctrl+C to exit"
echo ""
echo "In vim, try:"
echo "   :map <M-h> :echo \"Alt+h works!\"<CR>"
echo "   Then press Alt+h"
echo ""

# Offer to add vim configuration
echo "Add Alt key mappings to your vim configuration? (y/n)"
read -r add_vim_config

if [[ "$add_vim_config" = "y" ]]; then
    # Find vim config file
    VIMRC=""
    if [ -f "$HOME/.vimrc" ]; then
        VIMRC="$HOME/.vimrc"
    elif [ -f "$HOME/.config/nvim/init.vim" ]; then
        VIMRC="$HOME/.config/nvim/init.vim"
    fi
    
    if [ -n "$VIMRC" ]; then
        echo ""
        echo "📝 Adding Alt key mappings to $VIMRC..."
        
        # Check if mappings already exist
        if ! grep -q "Alt key mappings for iTerm2" "$VIMRC" 2>/dev/null; then
            cat >> "$VIMRC" << 'EOF'

" Alt key mappings for iTerm2
if !has('gui_running')
  " Alt+hjkl for window navigation
  nnoremap <M-h> <C-w>h
  nnoremap <M-j> <C-w>j
  nnoremap <M-k> <C-w>k
  nnoremap <M-l> <C-w>l
  
  " Alt+arrows for window resizing
  nnoremap <M-Left>  <C-w><
  nnoremap <M-Right> <C-w>>
  nnoremap <M-Up>    <C-w>+
  nnoremap <M-Down>  <C-w>-
  
  " Alt+b/f for word movement in insert mode
  inoremap <M-b> <C-o>b
  inoremap <M-f> <C-o>f
endif
EOF
            echo "✅ Vim Alt key mappings added to $VIMRC"
        else
            echo "✅ Vim Alt key mappings already exist"
        fi
    else
        echo "⚠️  No vim config file found. Create ~/.vimrc or ~/.config/nvim/init.vim first"
    fi
fi

# Offer to configure tmux
if command -v tmux &> /dev/null; then
    echo ""
    echo "Add Alt key mappings to tmux configuration? (y/n)"
    read -r add_tmux_config
    
    if [[ "$add_tmux_config" = "y" ]]; then
        TMUX_CONF="$HOME/.tmux.conf"
        
        echo "📝 Adding Alt key mappings to $TMUX_CONF..."
        
        # Check if mappings already exist
        if ! grep -q "Alt key mappings for iTerm2" "$TMUX_CONF" 2>/dev/null; then
            cat >> "$TMUX_CONF" << 'EOF'

# Alt key mappings for iTerm2
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
EOF
            echo "✅ Tmux Alt key mappings added to $TMUX_CONF"
            echo "🔄 Restart tmux sessions or run: tmux source-file ~/.tmux.conf"
        else
            echo "✅ Tmux Alt key mappings already exist"
        fi
    fi
fi

echo ""
echo "🎉 iTerm2 Alt key configuration complete!"
echo ""
echo "📚 For more details, see: iterm2-alt-key-setup.md" 