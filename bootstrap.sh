#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function copyDotfiles() {
    array=(
        .bash_aliases
        .bash_profile
        .bashrc
        .gitconfig
        xmodmap/.danish-mac.xmodmap
        .xprofile
        .xmodmap-setup
    )
    for i in "${array[@]}"; do
        echo "Moving: ${i}"
        yes | cp -rf $i ~/
        sudo chmod a+x ~/$i
    done
	source ~/.bash_profile
}

function bootstrap() {
    # Check we're not running as root, to ensure we place dotfiles in the correct home dir
    if [[ "$EUID" -eq 0 ]]; then
        echo "Please do not run as root. The script will ask for elevated privileges when needed.";
        exit;
    fi;
    copyDotfiles;

    # Run distribution specific bootstrap process
    OS_NAME=`uname -s`
    case $OS_NAME in
        Darwin)
            source ./bootstrap/macos;;
        Linux)
            DISTRIBUTION=`lsb_release -si`
            case $DISTRIBUTION in
                Ubuntu|LinuxMint|Linuxmint)
                    source ./bootstrap/debian;;
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


