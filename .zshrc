# zmodload zsh/zprof
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="minimal"
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
# plugins=(fzf colored-man-pages yarn brew cp git gitfast history node npm nvm themes web-search zsh-navigation-tools z pip)
plugins=(fzf yarn brew cp git gitfast history zsh-navigation-tools z pip)
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:"
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
export EDITOR='nvim'

# source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.zsh/zsh-autosuggestions/autosuggestions.zsh
# Enable autosuggestions automatically.
# zle-line-init() {
#     zle autosuggest-start
# }

#eval $(docker-machine env default)

# [ -f ~/.zshrc-e ] && source ~/.zshrc-e
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias
[ -f ~/.zshrc-e ] && source ~/.zshrc-e
# excluded from dotfiles.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc.private ] && source ~/.zshrc.private

# eval "`npm completion`"

# export PATH="$HOME/.yarn/bin:$PATH"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# autoload -U promptinit; promptinit

# # optionally define some options
# PURE_CMD_MAX_EXEC_TIME=10

# prompt pure
autoload -U promptinit; promptinit
prompt pure

# bind keys

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


eval $(thefuck --alias)

# place this after nvm initialization!
autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
set rtp+=/usr/local/opt/fzf

#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

if [[ -z `which pyenv` ]]
then
    eval "$(pyenv init -)"
fi

# zprof
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
