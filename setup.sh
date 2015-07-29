#!/usr/bin/env bash
#
# Copyright (C) 2013 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.

if [ "$#" != "1" ]; then
	echo
	echo "usage: sudo ./setup.sh <hostname>"
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
scutil --set HostName $hostname

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
	sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
fi

# use zsh as my defaut shell
chsh -s /usr/local/bin/zsh kuoe0

