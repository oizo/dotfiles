#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    array=(
        .aliases
        .bash_profile
        .bashrc
        .gitconfig
    )
    for i in "${array[@]}"; do
        echo "Doing this ${i}"
        yes | cp -rf $i ~/
        sudo chmod a+x ~/$i
    done
	source ~/.bash_profile

	OS_NAME=`uname -s`
    case $OS_NAME in
        Darwin)
            source ./bootstrap/macos;;
        Linux)
            DISTRIBUTION=`lsb_release -si`
            case $DISTRIBUTION in
                Ubuntu|LinuxMint)
                    source ./bootstrap/debian
                *)
                    echo "${DISTRIBUTION} is unsupported" >&2
            esac;;
        *)
            echo "${OS_NAME} is unsupported" >&2
    esac
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;


