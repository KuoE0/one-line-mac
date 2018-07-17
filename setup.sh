#!/usr/bin/env bash
#
# setup.sh
# KuoE0 <kuoe0.tw@gmail.com>
# Copyright (C) 2018
#
# Distributed under terms of the MIT license.
#

if [ "$#" != "1" ]; then
	echo -n "Enter the new hostname (leave empty to not set the hostname): "
	read HOSTNAME
fi

OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
	echo "Bootstrapping macOS..."
	bash bootstrap-mac.sh "$HOSTNAME"
else
	echo "Bootstrapping Linux..."
	bash bootstrap-linux.sh "$HOSTNAME"
fi

if [ "$?" != "0" ]; then
	exit
fi

# setup dotfiles
curl https://raw.githubusercontent.com/kuoe0/kuoe0-dotfile/master/setup.sh | /bin/bash -s $HOME/Works
