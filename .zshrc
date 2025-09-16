# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# zmodllad zsh/zprof
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
ZSH_THEME="steeef"
ZSH_THEME="Soliah"
ZSH_THEME="candy"
ZSH_THEME="juanghurtado"
ZSH_THEME="kphoen"
ZSH_THEME="mortalscumbag"
ZSH_THEME="murilasso"
ZSH_THEME="nicoulaj"
ZSH_THEME="sorin"
ZSH_THEME="tjkirch"
ZSH_THEME="nicoulaj"
ZSH_THEME="candy"
ZSH_THEME="wezm"
# ZSH_THEME="peepcode"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"
# plugins=(fzf colored-man-pages yarn brew cp git gitfast history node npm nvm themes web-search zsh-navigation-tools z zsh_reload pip themes)
plugins=(fzf yarn brew cp git gitfast history zsh-navigation-tools z pip hitchhiker git zsh-syntax-highlighting)

# Load Oh My Zsh if it exists
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source $ZSH/oh-my-zsh.sh
fi

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8

#eval $(docker-machine env default)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
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
bindkey "^R" fzf-history-widget
bindkey "^T" znt-cd-widget

# bindkey '^T' fzf-completion
# bindkey '^I' expand-or-complete

# eval $(thefuck --alias)

autoload -U add-zsh-hook
set rtp+=/usr/local/opt/fzf

# bun completions
[ -s "$HOME/.oh-my-zsh/completions/_bun" ] && source "$HOME/.oh-my-zsh/completions/_bun"

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

# ZSH Plugins - Load only if installed
# ====================================

# zsh-syntax-highlighting
if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-autosuggestions
if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-history-substring-search
if [ -f "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
    source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# fast-syntax-highlighting
if [ -f "/opt/homebrew/share/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
    source /opt/homebrew/share/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# ZSH Completions - Load only if directory exists
if [ -d "/opt/homebrew/share/zsh-completions" ]; then
    FPATH=/opt/homebrew/share/zsh-completions:$FPATH
fi

# Oh My Zsh plugins (existing)
FPATH=/Users/yann/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting:/Users/yann/.oh-my-zsh/plugins/git:/Users/yann/.oh-my-zsh/plugins/hitchhiker:/Users/yann/.oh-my-zsh/plugins/pip:/Users/yann/.oh-my-zsh/plugins/z:/Users/yann/.oh-my-zsh/plugins/zsh-navigation-tools:/Users/yann/.oh-my-zsh/plugins/history:/Users/yann/.oh-my-zsh/plugins/gitfast:/Users/yann/.oh-my-zsh/plugins/git:/Users/yann/.oh-my-zsh/plugins/cp:/Users/yann/.oh-my-zsh/plugins/brew:/Users/yann/.oh-my-zsh/plugins/yarn:/Users/yann/.oh-my-zsh/plugins/fzf:/Users/yann/.oh-my-zsh/functions:/Users/yann/.oh-my-zsh/completions:/Users/yann/.oh-my-zsh/custom/functions:/Users/yann/.oh-my-zsh/custom/completions:/Users/yann/.oh-my-zsh/cache/completions:/usr/local/share/zsh/site-functions:/usr/share/zsh/site-functions:/usr/share/zsh/5.9/functions:/opt/homebrew/share/zsh/site-functions:$FPATH

# Fix insecure directories warning
autoload -Uz compinit
compinit -i