#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if [[ "$(tty)" == "/dev/tty1" ]] then
	hyprland
fi

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

PS1='\[\e[1m\]╭ \[\e[0;90m\]\[\e[97;100;1m\]󰇅\[\e[22;39m\] \[\e[97;1m\]\h \[\e[0;90;47m\]\[\e[30;1m\] \[\e[30m\]\[\e[30m\] \[\e[30m\]\u\[\e[30m\] \[\e[0;37;48;5;208m\]\[\e[39m\] \[\e[30;1m\]\[\e[22;39m\] \[\e[30m\]\w\[\e[30;1m\] \[\e[0;38;5;208m\]\n\[\e[0;1m\]╰ \[\e[0m\]\$ '


