#!/bin/bash

echo "Installing new configuration"

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
	
if [ ! -d ~/bin ]; then
	echo "Creating ~/bin"
	mkdir ~/bin
fi

echo "Creating ~/bin/host-users.sh"
cp host-users.sh ~/bin/
chmod a+rx ~/bin/host-users.sh

#change the default shell to bash, cs252 does bash programming
echo "Changing the default shell to bash, please logout+login to see the changes"
ypchsh $USER /usr/local/bin/bash
