# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

# History configuration
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell 2>/dev/null
shopt -s dirspell 2>/dev/null

# Enable color support (cross-platform)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    alias ls='ls -G'
elif [ -x /usr/bin/dircolors ]; then
    # Linux
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Common color aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Prompt configuration
if [ -f "${DOTFILES_DIR}/shell/prompt" ]; then
    source "${DOTFILES_DIR}/shell/prompt"
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# Load local bashrc if it exists (not tracked in git)
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi