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
plugins=(fzf colored-man-pages yarn aws brew cp git gitfast history node npm nvm themes web-search zsh-navigation-tools)
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
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc.private ] && source ~/.zshrc.private
[ -f ~/.zshrc-e ] && source ~/.zshrc-e

# eval "`npm completion`"

# export PATH="$HOME/.yarn/bin:$PATH"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

ZSH_THEME=""
# autoload -U promptinit; promptinit

# # optionally define some options
# PURE_CMD_MAX_EXEC_TIME=10

# prompt pure

