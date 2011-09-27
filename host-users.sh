#!/bin/bash
case "`uname`" in
	SunOS*)
		echo "[`expr \`ps -a -o user | tail +2 | sort | uniq | wc -l | sed 's/^[ \t]*//' \` - 1`] other users currently logged into this host [`uname -n`]"
		echo "Current CPU load: `uptime|awk '{print $9" "$10" "$11" "$12;}'`"
	;;
	*)
		echo "[`expr \`users | sed 's:[ ]:\n:g' | sort | uniq | wc -l\` - 1`] other users currently logged into this host [`uname -n`]"
		echo "Current CPU load: `uptime|awk '{print $9" "$10" "$11" "$12;}'`"
	;;
esac

