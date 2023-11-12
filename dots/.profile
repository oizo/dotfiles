#!/bin/sh

touch "$HOME/log-profile-$(date +'%H:%M:%S').txt"

export MY_SHARED_VARIABLE="profile-shared-var"

if [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -n "$ZSH_VERSION" ] && [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi
