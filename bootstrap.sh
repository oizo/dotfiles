#!/usr/bin/env bash

symlinkDotfiles() {
    ln -sfn "$(pwd)/dots/.profile" "${HOME}/.profile"
    ln -sfn "$(pwd)/dots/.sharedrc" "${HOME}/.sharedrc"
    ln -sfn "$(pwd)/dots/.bashrc" "${HOME}/.bashrc"
    ln -sfn "$(pwd)/dots/.zshrc" "${HOME}/.zshrc"
    ln -sfn "$(pwd)/dots/.aliases" "${HOME}/.aliases"
    ln -sfn "$(pwd)/dots/.fiftytwo" "${HOME}/.fiftytwo"
    ln -sfn "$(pwd)/dots/.gitconfig" "${HOME}/.gitconfig"
    ln -sfn "$(pwd)/dots/.danish-mac.xmodmap" "${HOME}/.xmodmap"
}

symlinkBin() {
    src="bin"
    dest="$HOME/bin"
    mkdir -p "$dest"
    for file in "$src"/*; do
        filename=$(basename "$file")
        ln -sfn "$(pwd)/$file" "$dest/$filename"
    done
}

symlinkDotConfig() {
    mkdir -p "$HOME/.config/autostart"
    for file in "dots/.config/autostart"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            ln -sfn "$(pwd)/$file" "$HOME/.config/autostart/$filename"
        fi
    done
}

bootstrap() {
    symlinkDotfiles
    symlinkBin
    symlinkDotConfig

    # Run distribution specific bootstrap process
    case $OS in
        Darwin)
            source ./bootstrap/macos;;
        Linux)
            case $DISTRIBUTION in
                ubuntu|linuxmint)
                    source ./bootstrap/debian;;
                manjarolinux)
                    # source ./bootstrap/arch;;
                    log "Ignoring $DISTRIBUTION changes";;
                *)
                    logerr "${DISTRIBUTION} is unsupported";;
            esac;;
        *)
            logerr "${OS} is unsupported";;
    esac
    echo "Done. For changes to take effect please reboot"
}

# Check we're not running as root, to ensure we place dotfiles in the correct home dir
if [ "$(id -u)" -eq 0 ]; then
    logerr "Please do not run as root. The script will ask for elevated privileges when needed.";
    exit 1
fi;

# Ensure we're in the git repo folder
cd "$(dirname "$0")"

# Enable logging via .bash_alias
source dots/.aliases

# Main
if [ "$1" == "-f" ]; then
    bootstrap
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bootstrap
    else
        echo "$(basename $0) exited without changes."
    fi;
fi;
