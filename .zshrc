export ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="steeef"
ZSH_THEME="peepcode"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(fzf colored-man-pages yarn aws brew cp fuck fzf-marks git history node npm nvm themes web-search zsh-navigation-tools)
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:"
export EDITOR='vim'

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically.
zle-line-init() {
    zle autosuggest-start
}

#eval $(docker-machine env default)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc.private ] && source ~/.zshrc.private

# eval "`npm completion`"

export PATH="$HOME/.yarn/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -f ~/.zshrc-e ] && source ~/.zshrc-e

