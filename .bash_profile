
# Sourcing .bashrc from .bash_profile is recommended, so interactive and 
# non-onteractive login shells to avoid maintaining two profiles.
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
if [ -f ~/.bashrc ]; then
   . ~/.bashrc
fi
