# this file is processed on each interactive invocation of bash

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# avoid problems with scp -- don't process the rest of the file if non-interactive
[[ $- != *i* ]] && return

HISTSIZE=50

if [ `uname -n | grep purdue` ]; then
	alias mail=mailx #default for purdue cs students

	#if we are on a xinu machine, include the bin in path
	if [ -n `uname -n | grep "xinu"` ]; then
		PATH=/p/xinu/bin:"${PATH}"
	fi
fi

# enable color support based on OS
if [ "$TERM" != "dumb" ]; then

	#gnome terminal is running, were compatible with xterm-color
	#if [ "$COLORTERM" = "gnome-terminal" ]; then
	#	export TERM=xterm-color
	#fi

	#Enable colors
	if [ "`uname`" != "SunOS" ]; then
		eval `dircolors -b`
		alias ls="ls --color=auto"
		alias grep="grep --color=auto"
	fi

	#nice pretty color prompt with the current host and our current directory
	PS1="\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]$ "
fi

#ease of use
alias ..="cd .."
