#!/usr/bin/env bash
#
# Copyright (C) 2017 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.

###
### System Setup
###

if [ "$1" != "" ]; then
	# change hostname
	HOSTNAME=$1
	echo "$HOSTNAME" | sudo tee /etc/hostname
fi

# install apt tools
python install.py apt

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
	# prevent the following warning from `brew doctor`
	# Warning: /usr/bin occurs before /home/linuxbrew/.linuxbrew/bin
	# Warning: Homebrew's bin was not found in your PATH.
	# Warning: Homebrew's sbin was not found in your PATH but you have installed
	export PATH="$(brew --prefix)/bin:$PATH"
	export PATH="$(brew --prefix)/sbin:$PATH"
	brew doctor
	if [ "$?" != "0" ]; then
		echo "Something going wrong with Homebrew!"
		exit 255
	fi
fi

# install all packages and applications
python brew-tap.py
python install.py brew
python install.py pip3
