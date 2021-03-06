#!/bin/bash

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Recursively delete `.DS_Store` files
alias ds_store_cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

function xmodmap-setup-dk-keys() {
    XMOD_FILE=".danish-mac.xmodmap"
    if [ -f $XMOD_FILE ]; then
        xmodmap $XMOD_FILE
    fi
}

function vmware-sign-drivers() {
    echo "Failed to load vmmon kernel module - https://kb.vmware.com/s/article/2146460"
    mkdir ~/vmnet-fix
    cd ~/vmnet-fix
    sudo vmware-modconfig --console --install-all 
    openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware/"
    sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmmon)
    sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmnet)
    sudo mokutil --import MOK.der
    cd $HOME
    echo "Reboot your machine. Follow the instructions to complete the enrollment from the UEFI console."
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
        alias dkkeys=xmodmap-setup-dk-keys
        # Add an "alert" alias for long running commands.  Use like so:
        #   sleep 10; alert
        alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
        ;;
    *)
        echo "${OS_NAME} is unsupported" >&2;;
esac
