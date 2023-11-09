#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Fetch and display the external IP address
whatismyip() {
  curl -s https://api.ipify.org
}

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

case $OS_NAME in
    Darwin)
        # Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
        alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup'

        # Show/hide hidden files in Finder
        alias show_all_files="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
        alias hide_all_files="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

        # Hide/show all desktop icons (useful when presenting)
        alias hide_desktop_icon="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
        alias show_desktop_icon="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

        # PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
        alias plistbuddy="/usr/libexec/PlistBuddy"
        ;;

    Linux)
        if [ -f ".bash_fiftytwo" ];
            source .bash_fiftytwo
        fi
        ;;
    *)
        echo "${OS_NAME} is unsupported" >&2;;
esac
