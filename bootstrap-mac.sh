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
	sudo scutil --set HostName $HOSTNAME
fi

###
### Xcode
###
xcode-select -p > /dev/null 2>&1
if [ "$?" != "0" ]; then
	echo "Installing Xcode Command Line Tools..."
	osascript installCommandLineTools.AppleScript
else
	echo "Xcode already installed."
	# Auto accept Xcode license
	sudo xcodebuild -license accept
fi

###
### Command Line Setup
###

# brew does not exist
if ! which brew &> /dev/null; then
	# install homebrew
	echo "Install Homebrew..."
	# send ENTER keystroke to install automatically
	echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# homebrew install failed
if ! which brew &> /dev/null; then
	echo "Homebrew failed to install!"
	exit 255
else
	brew doctor
	if [ "$?" = "0" ]; then
		# use llvm to build
		brew --env --use-llvm
	else
		echo "Something going wrong with Homebrew!"
		exit 255
	fi
fi

# install command line packages
ruby installPackages.rb


# make zsh as a regular shell
ZSH_PATH="/usr/local/bin/zsh"
if [ -e "$ZSH_PATH" ]; then
	ZSH_REGULAR=$(grep "$ZSH_PATH" /etc/shells)
	if [ "${ZSH_REGULAR:-x}" = x ]; then
		sudo sh -c "echo $ZSH_PATH >> /etc/shells"
	fi
fi

# use zsh as my defaut shell
chsh -s /usr/local/bin/zsh $USER

# setup dotfiles
curl https://raw.githubusercontent.com/kuoe0/kuoe0-dotfile/master/setup.sh | bash -s $HOME/Works

#
# Mac App Store
#
if ! mas account &> /dev/null; then
	# sign in
	echo -n "Enter your Apple ID: "
	read APPLE_ID
	mas signin --dialog $APPLE_ID
fi
ruby installApplications.rb
