#!/usr/bin/env bash

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

moveDotConfig {
    echo "moveDotConfig is still missing!"
}

bootstrap() {
    symlinkDotfiles
    symlinkBin
    moveDotConfig
    source ~/.bash_profile

    # Run distribution specific bootstrap process
    os_name=`uname -s`
    case $os_name in
        Darwin)
            source ./bootstrap/macos;;
        Linux)
            distribution=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
            case $distribution in
                ubuntu|linuxmint)
                    source ./bootstrap/debian;;
                manjarolinux)
                    source ./bootstrap/arch;;
                *)
                    echo "${distribution} is unsupported" >&2;;
            esac;;
        *)
            echo "${os_name} is unsupported" >&2;;
    esac
}

# Check we're not running as root, to ensure we place dotfiles in the correct home dir
if [[ "$EUID" -eq 0 ]]; then
    echo "Please do not run as root. The script will ask for elevated privileges when needed.";
    exit;
fi;

# Ensure we're in the git repo folder
cd "$(dirname "${BASH_SOURCE}")";

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    bootstrap;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
        bootstrap;
	fi;
fi;
