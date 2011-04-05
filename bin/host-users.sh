#!/bin/bash
case "`uname`" in
	SunOS)
		echo "[`expr \`ps -a -o user | tail +2 | sort | uniq | wc -l | sed 's/^[ \t]*//' \` - 1`] other users currently logged into this host [`uname -n`]"
	;;
	*)
		echo "[`expr \`users | sed 's:[ ]:\n:g' | sort | uniq | wc -l\` - 1`] other users currently logged into this host [`uname -n`]"
	;;
esac
