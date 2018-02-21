#!/usr/bin/env bash
#
# setup.sh
# KuoE0 <kuoe0.tw@gmail.com>
# Copyright (C) 2018
#
# Distributed under terms of the MIT license.
#

if [ "$#" != "1" ]; then
	echo
	echo "usage: ./setup.sh <hostname>"
	echo
	echo "       <hostname>    the new hostname for this machine"
	echo
	exit
fi

OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
	echo "Bootstrapping macOS..."
	bash bootstrap-mac.sh "$1"
else
	echo "Bootstrapping Linux..."
	bash bootstrap-linux.sh "$1"
fi
