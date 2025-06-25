# this file is processed only when sh is running as a login (top-level) shell
# and should contain commands to be run once per session, e.g. setting
# environment variables and terminal-specific settings

# set PATH and MANPATH based on machine type
if [ -r /usr/local/bin/defaultpaths ]; then
	eval `/usr/local/bin/defaultpaths`
else
	if [ "`uname -n | grep purdue`" ]; then
		echo "Couldn't find '/usr/local/bin/defaultpaths', things may be broken";
	fi
fi

# set default file/directory creation protection for better security
umask 077

# avoid problems with scp -- don't process the rest of the file if non-interactive
[[ $- != *i* ]] && return

#Make sure screen windows all append command history and stay in sync between shared filesystems
HISTSIZE=100
export PROMPT_COMMAND="history -a"
shopt -s histappend

#our default text editor, could be emacs to
export EDITOR=vim

#better pager than more
export PAGER=less

#show the amount of users on this host as well as the load average
[ -x $HOME/bin/host-users.sh ] && ~/bin/host-users.sh

#System specific settings
case `uname -a` in
	
	#SunOS specific config
	SunOS*)
		if [ "$TERM" = "rxvt" ]; then
			#Lore doesn't have term definitions for rxvt (chromeos's terminal)
			export TERM=xterm
			export COLORTERM="rxvt -xpm"
		fi
	;;

esac


#Standard backspace
stty erase  intr 

#include our normal shell settings
[ -r $HOME/.bashrc ] && . $HOME/.bashrc
