# ~/.zshrc

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git docker kubectl helm terraform aws)

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Auto completion
autoload -U compinit
compinit

# Key bindings
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Load Oh My Zsh if installed
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    source $ZSH/oh-my-zsh.sh
fi

# Load aliases
if [ -f ~/.dotfiles/shell/aliases ]; then
    source ~/.dotfiles/shell/aliases
fi

# Load local zshrc if it exists
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi