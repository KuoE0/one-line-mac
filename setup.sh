#!/usr/bin/env bash
#
# Copyright (C) 2013 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.

if [ "$#" != "1" ]; then
	echo
	echo "usage: ./setup.sh <hostname>"
	echo
	echo "       <hostname>    the new hostname for this machine"
	echo
	exit
fi

# create temporal directory
TMP_DIR=/tmp/$(date +%Y%m%d-%H%M%S)
if [ -d $TMP_DIR ] || [ -f $TMP_DIR ]; then
	rm -r $TMP_DIR
fi
mkdir $TMP_DIR

################################################################################
### System Setup
################################################################################

# change hostname
hostname=$1
sudo scutil --set HostName $hostname

################################################################################
### Dictionaries
################################################################################

DICT_PATH=~/Library/Dictionaries
for DICT_ZIP in $(ls dictionaries); do
	DICT=${DICT%.*}
	echo "Install $DICT..."
	unzip "dictionaries/$DICT_ZIP" -d $TMP_DIR
	if [ -d $DICT_PATH/$DICT ] || [ -f $DICT_PATH/$DICT ]; then
		rm -r $DICT_PATH/$DICT
	fi
	mv $TMP_DIR/$DICT $DICT_PATH
done

############################################################################
### command line tools
############################################################################

osascript CLItools.AppleScript

############################################################################
### Homebrew
############################################################################

bash brew-install.sh

############################################################################
### Shell
############################################################################
# make it as a regular shell
ZSH_REGULAR=$(grep '/usr/local/bin/zsh' /etc/shells)
if [ "${ZSH_REGULAR:-x}" = x ]; then
	sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
fi

# use zsh as my defaut shell
chsh -s /usr/local/bin/zsh $USER

