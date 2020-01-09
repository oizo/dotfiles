#!/bin/bash

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# Set PATH to include private bin
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# enable bash completion in interactive shells
if ! shopt -oq posix; then
 if [ -f /usr/share/bash-completion/bash_completion ]; then
   . /usr/share/bash-completion/bash_completion
 elif [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
 fi
fi

# Android development tools
export ANDROID_HOME="${HOME}/android-sdk"
if [ -d "${ANDROID_HOME}" ]; then
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    build_tools_path=${ANDROID_HOME}/build-tools
    build_tools_latest=$(cd $build_tools_path; ls -td -- */ | head -n 1 | cut -d'/' -f1)
    export PATH=$PATH:${build_tools_path}/${build_tools_latest}
    unset build_tools_path build_tools_latest
fi

export USER_HOME=$HOME
export GRADLE_USER_HOME=$USER_HOME/.gradle

OS_NAME=`uname -s`
DISTRIBUTION="$OS_NAME"

case $OS_NAME in
    Darwin)
        echo "Applying configuration for ${OS_NAME}"
        if [ -f $(brew --prefix)/etc/bash_completion ]; then
            . $(brew --prefix)/etc/bash_completion
        fi
        ;;
    Linux)
        DISTRIBUTION=`lsb_release -si`
        echo "Applying configuration for ${OS_NAME} (${DISTRIBUTION})"
        case $DISTRIBUTION in
            Ubuntu|LinuxMint)
                if [ -d "/snap/bin" ]; then
                    export PATH=$PATH:"/snap/bin"
                fi
                ;;
            *)
                echo "${DISTRIBUTION} is unsupported" >&2;;
        esac;;
    *)
        echo "${OS_NAME} is unsupported" >&2;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
