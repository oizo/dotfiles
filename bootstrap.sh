#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

symlinkDotfiles() {
    cd "dots"
    ln -sfn "$(pwd)/.bash_aliases" "${HOME}/.bash_aliases"
    ln -sfn "$(pwd)/.bash_profile" "${HOME}/.bash_profile"
    ln -sfn "$(pwd)/.bashrc" "${HOME}/.bashrc"
    ln -sfn "$(pwd)/.gitconfig" "${HOME}/.gitconfig"
    ln -sfn "$(pwd)/.xmodmap/.danish-mac.xmodmap" "${HOME}/.Xmodmap"
    ln -sfn "$(pwd)/.xprofile" "${HOME}/.xprofile"
    ln -sfn "$(pwd)/.xinitrc" "${HOME}/.xinitrc"
    cd ..
}

symlinkBin() {
    target_dir="$HOME/bin"
    mkdir -p "$target_dir"
    for file in "bin"/*; do
        filename=$(basename "$file")
        ln -s "$file" "$target_dir/$filename"
    done
}

bootstrap() {
    # Check we're not running as root, to ensure we place dotfiles in the correct home dir
    if [[ "$EUID" -eq 0 ]]; then
        echo "Please do not run as root. The script will ask for elevated privileges when needed.";
        exit;
    fi;
    symlinkDotfiles
    symlinkBin
    source ~/.bash_profile

    # Run distribution specific bootstrap process
    OS_NAME=`uname -s`
    case $OS_NAME in
        Darwin)
            source ./bootstrap/macos;;
        Linux)
            DISTRIBUTION=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
            case $DISTRIBUTION in
                ubuntu|linuxmint)
                    source ./bootstrap/debian;;
                manjarolinux)
                    source ./bootstrap/arch;;
                *)
                    echo "${DISTRIBUTION} is unsupported" >&2;;
            esac;;
        *)
            echo "${OS_NAME} is unsupported" >&2;;
    esac
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    bootstrap;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
        bootstrap;
	fi;
fi;
unset copyDotfiles;
unset bootstrap;


