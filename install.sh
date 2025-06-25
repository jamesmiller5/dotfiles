#!/bin/bash

# TODO use something to bootstrap my 'seed'.


# TODO so try and see if `stow` is available, use that first
# ELSE
# TODO manual install fallback if `stow` doesn't exist.

# Manual install fallback.
function manual_install {
	# Dotfile install.
	echo "Installing new dotfile configurations:"
	# TODO handle new dirnames for stow and be compat(?)
	# TODO list directories? or at least get stow compiling & running.
	# >.< Ok I want to use STOW but not happy with unhosted source packages unknowns,
	# so falling back is a good option to implement, but still use STOW.
	for file in ".vimrc" ".screenrc" ".bashrc" ".bash_profile" ".profile"
	do
		#If we find a file, back it up
		if [ -e ~/"$file" ]; then
			#create backup directory if we need to
			if [ ! -d ~/dev-settings-backup ]; then
				echo "Creating configuration backup directory, ~/dev-settings-backup"
				mkdir ~/dev-settings-backup
			fi

			echo "Backing up $file to ~/dev-settings-backup"
			mv ~/"$file" ~/dev-settings-backup/"$file"
		fi

		#don't put the .profile back, just use .bash_profile
		if [ "$file" != ".profile" ]; then
			echo "Installing new configuration file $file"
			cp -r "$file" ~/"$file"
		fi
	done
}

# TODO replace this with $my-stuff AND utils (<-combine left) AND general bins.
function legacy_bin_install {
	if [ ! -d ~/bin ]; then
		echo "Creating ~/bin"
		mkdir ~/bin
	fi
	# TODO better yet link here and allow a natural overrun/override from ~/bin.
	echo "Creating ~/bin/host-users.sh"
	cp host-users.sh ~/bin/
	chmod a+rx ~/bin/host-users.sh
}

# TODO update name underscore and change for /bash compat.
# Legacy code that only worked on Purdue's campus. "Yellowpages" command isn't widely used.
function legacy_purdue {
	#change the default shell to bash, cs252 does bash programming
	echo "Changing the default shell to bash, please logout+login to see the changes"
	ypchsh $USER /usr/local/bin/bash
}
