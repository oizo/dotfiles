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

# Android development tools
# This is a function call, so we can use local variables
android_dev () {
	local tmp="${HOME}/android-sdk-macos"
	if [ -d "${tmp}" ]; then
	  export ANDROID_HOME=${tmp}
	  export PATH=$PATH:$ANDROID_HOME/tools
	  export PATH=$PATH:$ANDROID_HOME/platform-tools
	  local build_tools_dir=${ANDROID_HOME}/build-tools
	  local build_tools_latest=$(cd $build_tools_dir; ls -td -- */ | head -n 1 | cut -d'/' -f1)
	  export PATH=$PATH:${build_tools_dir}/${build_tools_latest}
	fi  
}

# Apply development tools
android_dev

export USER_HOME=$HOME
export GRADLE_USER_HOME=$USER_HOME/.gradle

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

source .aliases

