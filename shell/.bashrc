# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History configuration
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Prompt configuration
if [ -f ~/.dotfiles/shell/prompt ]; then
    source ~/.dotfiles/shell/prompt
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Load aliases
if [ -f ~/.dotfiles/shell/aliases ]; then
    source ~/.dotfiles/shell/aliases
fi

# Load local bashrc if it exists
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi