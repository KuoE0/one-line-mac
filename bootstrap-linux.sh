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

# use zsh as my defaut shell
chsh -s /usr/local/bin/zsh $USER

# setup dotfiles
curl https://raw.githubusercontent.com/kuoe0/kuoe0-dotfile/master/setup.sh | bash -s $HOME/Works
