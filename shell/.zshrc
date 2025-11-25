# ~/.zshrc

# Get the dotfiles directory
DOTFILES_DIR="${HOME}/.dotfiles"

# Load platform detection
if [ -f "${DOTFILES_DIR}/lib/platform.sh" ]; then
    source "${DOTFILES_DIR}/lib/platform.sh"
fi

# Load environment variables
if [ -f "${DOTFILES_DIR}/shell/env" ]; then
    source "${DOTFILES_DIR}/shell/env"
fi

# Load PATH configuration
if [ -f "${DOTFILES_DIR}/shell/path" ]; then
    source "${DOTFILES_DIR}/shell/path"
fi

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git docker kubectl helm terraform aws)

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

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
if [ -f "${DOTFILES_DIR}/shell/aliases" ]; then
    source "${DOTFILES_DIR}/shell/aliases"
fi

# Load functions
if [ -f "${DOTFILES_DIR}/shell/functions" ]; then
    source "${DOTFILES_DIR}/shell/functions"
fi

# Load completions
if [ -f "${DOTFILES_DIR}/shell/completion" ]; then
    source "${DOTFILES_DIR}/shell/completion"
fi

# Load local zshrc if it exists (not tracked in git)
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi