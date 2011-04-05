# this file is processed only when sh is running as a login (top-level) shell
# and should contain commands to be run once per session, e.g. setting
# environment variables and terminal-specific settings

# set PATH and MANPATH based on machine type
if [ -r /usr/local/bin/defaultpaths ]; then
	eval `/usr/local/bin/defaultpaths`
else
	if [ -n "`uname -n | grep purdue`" ]; then
		echo "Couldn't find '/usr/local/bin/defaultpaths', things may be broken";
	fi
fi

# set default file/directory creation protection for better security
umask 077

# avoid problems with scp -- don't process the rest of the file if non-interactive
[[ $- != *i* ]] && return

#include our normal shell settings
[ -r $HOME/.bashrc ] && . $HOME/.bashrc

#show the amount of users on this host, as well as the load average
[ -r $HOME/bin/host-users.sh ] && source ~/bin/host-users.sh
echo "Current CPU load: `uptime|awk '{print $10" "$11" "$12;}'`"

EDITOR=vim; export EDITOR

case `uname -a` in
*inux)
	PAGER=less; export PAGER
	;;
SunOS*)
	PAGER=less; export PAGER
	;;
*)
	PAGER=more; export PAGER
esac

#Standard backspace
stty erase  intr 
