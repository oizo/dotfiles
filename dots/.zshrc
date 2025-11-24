#!/usr/bin/env zsh

if [ -f "$HOME/.sharedrc" ] ; then
    source "$HOME/.sharedrc"
fi

logerr "TODO check if zsh completions are needed"

# Set history control to ignore duplicates and commands starting with a space
HISTCONTROL=ignoredups:ignorespace
# Enable history appending instead of overwriting when the shell exits
setopt histappend
# Set the maximum number of lines to save in the history file
SAVEHIST=2000
# Set the maximum number of lines in the history file
HISTSIZE=1000

if [ "$DISTRIBUTION" = "manjarolinux" ]; then
    # Use powerline
    USE_POWERLINE="true"
    # Has weird character width
    # Example:
    #    is not a diamond
    HAS_WIDECHARS="false"
    # Source manjaro-zsh-configuration
    if [ -e "/usr/share/zsh/manjaro-zsh-config" ]; then
        source "/usr/share/zsh/manjaro-zsh-config"
    fi
    # Use manjaro zsh prompt
    if [ -e "/usr/share/zsh/manjaro-zsh-prompt" ]; then
        source "/usr/share/zsh/manjaro-zsh-prompt"
    fi
fi