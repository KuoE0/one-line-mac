#!/usr/bin/env bash
#
# Copyright (C) 2017 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.

if [ "$#" != "1" ]; then
	echo
	echo "usage: ./boostrap-mac.sh <hostname>"
	echo
	echo "       <hostname>    the new hostname for this machine"
	echo
	exit
fi

###
### System Setup
###

# change hostname
hostname=$1
echo "$hostname" | sudo tee /etc/hostname

# install apt tools
python3 installAptPackage.py3

# brew does not exist
if ! which brew &> /dev/null; then
	# install homebrew
	echo "Install Homebrew..."
	# send ENTER keystroke to install automatically
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

# homebrew install failed
if ! which brew &> /dev/null; then
	echo "Homebrew failed to install!"
	exit 255
else
	brew doctor
	if [ "$?" != "0" ]; then
		echo "Something going wrong with Homebrew!"
		exit 255
	fi
fi

# install command line packages
ruby installPackages.rb

# use zsh as my defaut shell
chsh -s /usr/local/bin/zsh $USER

# setup dotfiles
curl https://raw.githubusercontent.com/kuoe0/kuoe0-dotfile/master/setup.sh | bash -s $HOME/Works
