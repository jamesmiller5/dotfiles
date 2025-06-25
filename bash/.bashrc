# this file is processed on each interactive invocation of bash

# avoid problems with scp -- don't process the rest of the file if non-interactive
[[ $- != *i* ]] && return

# enable color support, should work with all modern terminals
if [ "$TERM" != "dumb" ]; then

	#Enable colors only when System is running Linux (SunOS and Darwin(mac) doesn't have GNU dicolors)
	if [ "`uname`" == "Linux" ]; then
		eval `dircolors -b`
		alias ls="ls --color=auto"
		alias grep="grep --color=auto"
	fi

	#nice pretty color prompt with the current host and our current directory
	PS1="\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]$ "
fi

#ease of use
alias ..="cd .."
alias l="ls -lah"

#bash ease of use tweaks
set show-all-if-ambiguous on
set show-all-if-unmodified on
set completion-ignore-case on

# Stuff only related to purdue systems.
function legacy-purdue {
	#default for Purdue CS students
	alias mail=mailx
}
