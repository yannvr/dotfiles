export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
# ZSH_THEME="steeef"
# ZSH_THEME="Soliah"
# ZSH_THEME="candy"
# ZSH_THEME="juanghurtado"
# ZSH_THEME="kphoen"
# ZSH_THEME="mortalscumbag"
# ZSH_THEME="murilasso"
# ZSH_THEME="nicoulaj"
# ZSH_THEME="sorin"
# ZSH_THEME="tjkirch"
# ZSH_THEME="nicoulaj"
# ZSH_THEME="candy"
# ZSH_THEME="wezm"
# ZSH_THEME="candy"
# ZSH_THEME="wezm"
# ZSH_THEME="peepcode"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"
# plugins=(fzf colored-man-pages yarn brew cp git gitfast history node npm nvm themes web-search zsh-navigation-tools z zsh_reload pip themes)
plugins=(yarn brew cp git gitfast history zsh-navigation-tools z pip hitchhiker git zsh-syntax-highlighting)

# Load Oh My Zsh if it exists
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source $ZSH/oh-my-zsh.sh
fi

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH
# De-duplicate PATH and history
typeset -U path PATH
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
export LANG=en_US.UTF-8

#eval $(docker-machine env default)

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh  # DISABLED (causing hangs)
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias
[ -f ~/.zshenv ] && source ~/.zshenv
# excluded from dotfiles.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc.private ] && source ~/.zshrc.private
[ -f ~/.zprofile ] && source ~/.zprofile

# eval "`npm completion`"

# export PATH="$HOME/.yarn/bin:$PATH"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# autoload -U promptinit; promptinit

# # optionally define some options
# PURE_CMD_MAX_EXEC_TIME=10

# prompt pure
autoload -U promptinit; promptinit
# prompt pure

# bind keys

bindkey ® znt-history-widget
# bindkey ç fzf-cd-widget
# bindkey † fzf-cd-widget

autoload znt-cd-widget
zle -N znt-cd-widget
autoload znt-history-widget
zle -N znt-history-widget
# FZF removed - using SKIM instead
bindkey "^T" znt-cd-widget

# bindkey '^T' fzf-completion
# bindkey '^I' expand-or-complete

# eval $(thefuck --alias)

autoload -U add-zsh-hook
# set rtp+=/usr/local/opt/fzf  # DISABLED (fzf causing hangs)

# bun completions
[ -s "$HOME/.oh-my-zsh/completions/_bun" ] && source "$HOME/.oh-my-zsh/completions/_bun"

# FZF ALTERNATIVES - Better than fzf
# ===================================

# SKIM (sk) - Primary fzf replacement
if command -v sk >/dev/null 2>&1; then
    source <(sk --zsh) 2>/dev/null || true

    # Create custom functions for skim (fzf-compatible)
    skim-file-widget() {
        local result=$(find . -type f | sk --preview "bat --color=always {} 2>/dev/null || cat {}")
        if [[ -n "$result" ]]; then
            LBUFFER+="$result"
        fi
        zle reset-prompt
    }
    zle -N skim-file-widget

    skim-history-widget() {
        local result=$(history | sk --tac --no-sort | sed 's/^[ ]*[0-9]*[ ]*//')
        if [[ -n "$result" ]]; then
            LBUFFER="$result"
        fi
        zle reset-prompt
    }
    zle -N skim-history-widget

    # Key bindings (same as fzf)
    bindkey '^T' skim-file-widget
    bindkey '^R' skim-history-widget
fi

# MCFLY - Smart history search
if command -v mcfly >/dev/null 2>&1; then
    eval "$(mcfly init zsh)" 2>/dev/null || true
fi

# ZOXIDE - Smart directory jumping
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)" 2>/dev/null || true
fi

# Environment variables moved to .zshenv for all shells
# See .zshenv for: BUN_INSTALL, PNPM_HOME, Windsurf path, PostgreSQL path

eval "$(fnm env --use-on-cd)"

# pnpm
export PNPM_HOME="/Users/yann/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# 🚀 OPTIMIZED ZSH LOADING
# =======================

# Essential plugins - Load immediately (fast)
# -------------------------------------------

# zsh-syntax-highlighting (fast, essential)
if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-autosuggestions (fast, essential)
if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Optimized FPATH - Work with existing FPATH as colon-separated string
# -------------------------------------------------------------------
local -a existing_dirs=()

# Add core ZSH directories (only if they exist)
for dir in \
    "/opt/homebrew/share/zsh-completions" \
    "/opt/homebrew/share/zsh/site-functions" \
    "/usr/local/share/zsh/site-functions" \
    "/usr/share/zsh/site-functions" \
    "/usr/share/zsh/5.9/functions"; do
    [[ -d "$dir" ]] && existing_dirs+=("$dir")
done

# Add Oh My Zsh directories (only if they exist)
[[ -d "$HOME/.oh-my-zsh/functions" ]] && existing_dirs+=("$HOME/.oh-my-zsh/functions")
[[ -d "$HOME/.oh-my-zsh/completions" ]] && existing_dirs+=("$HOME/.oh-my-zsh/completions")

# Add Oh My Zsh plugins (only if they exist)
for plugin in git gitfast history zsh-navigation-tools; do
    local plugin_dir="$HOME/.oh-my-zsh/plugins/$plugin"
    [[ -d "$plugin_dir" ]] && existing_dirs+=("$plugin_dir")
done

# Add existing directories to FPATH (preserve existing entries)
for dir in "${existing_dirs[@]}"; do
    if [[ ":$FPATH:" != *":$dir:"* ]]; then
        FPATH="$dir:$FPATH"
    fi
done

# Async Plugin Loading - DISABLED (causing hangs)
# =======================================================
# Disabled async loading due to startup hangs
# async_load_plugins() {
#     # Load in background after shell is ready
#     {
#         # zsh-history-substring-search (can be lazy loaded)
#         if [ -f "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
#             source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
#         fi
#
#         # fast-syntax-highlighting (lazy load)
#         if [ -f "/opt/homebrew/share/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
#             source /opt/homebrew/share/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
#         fi
#
#         # Additional Oh My Zsh plugins (lazy load)
#         for plugin in pip hitchhiker cp brew yarn; do
#             local plugin_dir="$HOME/.oh-my-zsh/plugins/$plugin"
#             if [[ -d "$plugin_dir" && -f "$plugin_dir/$plugin.plugin.zsh" ]]; then
#                 source "$plugin_dir/$plugin.plugin.zsh"
#             fi
#         done
#
#         # Signal completion
#         echo "ZSH async loading complete" > /dev/null
#     } &
# }
#
# # Start async loading after a short delay
# {
#     sleep 0.1
#     async_load_plugins
# } &

# Lazy Loading Functions - Load on first use
# ===========================================

# Lazy load heavy tools
lazy_load_tools() {
    # These will be loaded when first used via aliases
    # nvm, rvm, pyenv, etc. can be lazy loaded

    # Example: Load nvm only when needed
    load_nvm() {
        if [ -f "$HOME/.nvm/nvm.sh" ]; then
            source "$HOME/.nvm/nvm.sh"
            # Cache the function
            load_nvm() { :; }
        fi
    }

    # Load pyenv only when needed
    load_pyenv() {
        if command -v pyenv >/dev/null 2>&1; then
            eval "$(pyenv init -)"
            # Cache the function
            load_pyenv() { :; }
        fi
    }

    # Load rvm only when needed
    load_rvm() {
        if [ -f "$HOME/.rvm/scripts/rvm" ]; then
            source "$HOME/.rvm/scripts/rvm"
            # Cache the function
            load_rvm() { :; }
        fi
    }
}

# Initialize lazy loading
lazy_load_tools

# Fix insecure directories warning - DISABLED (can cause hangs)
# autoload -Uz compinit
# compinit -i
export GIT_PAGER=cat
export PAGER=cat
