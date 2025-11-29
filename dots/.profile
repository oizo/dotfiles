#!/bin/sh

# Source .xprofile for X11 settings if running under X
if [ -n "$DISPLAY" ] && [ -f ~/.xprofile ]; then
    . ~/.xprofile
fi

if [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -n "$ZSH_VERSION" ] && [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi
