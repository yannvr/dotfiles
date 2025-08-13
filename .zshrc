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

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

eval "$(fnm env --use-on-cd)"
