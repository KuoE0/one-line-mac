#!/usr/bin/env bash
#
# brew-install.sh
# Copyright (C) 2013 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.

function get-column {
	COLON_CNT=$(echo "$1" | grep ':' | wc -l)
	if [ $(echo "$COLON_CNT + 1" | bc) -ge $2 ]; then
		echo "$1" | cut -d':' -f "$2" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//'
	fi
}

# create temporal directory & log directory
LOG_DIR="./BREW-$(date +%Y%m%d-%H%M%S)"
IFS=$'\n'

if [ -d $LOG_DIR ] || [ -f $LOG_DIR ]; then
	rm -r $TMP_DIR
fi
mkdir -p $LOG_DIR

# brew does not exist
if ! which brew &> /dev/null; then
	# remove homebrew directory /usr/local/Cellar
	if [ -d /usr/local/Cellar ] || [ -f /usr/local/Cellar ]; then
		rm -rf /usr/local/Cellar
	fi

	# remove homebrew directory /usr/local/.git
	if [ -d /usr/local/.git ] || [ -f /usr/local/.git ]; then
		rm -rf /usr/local/.git
	fi

	# install homebrew
	echo "Install Homebrew..."
	# send ENTER keystroke to install automatically
	echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

fi

# homebrew install failed
if ! which brew &> /dev/null; then
	echo "Homebrew install failed!"
	exit 255
fi

# add taps to homebrew
tap_list=(caskroom/cask caskroom/versions caskroom/fonts homebrew/dupes homebrew/science homebrew/versions)

for TAP_NAME in ${tap_list[*]}; do
	echo "Add tap $TAP_NAME to Homebrew..."
	brew tap $TAP_NAME
done


# brew status check
echo "Diagnose Homebrew..."
brew doctor 2>&1 | tee "$LOGDIR/brew-doctor.log"

# install packages and applications
if [ "$?" = "0" ]; then

	# use llvm to build
	brew --env --use-llvm

	# update brew database
	brew update

	# install & upgrade brew-cask
	brew install brew-cask
	brew upgrade brew-cask

	# install applications from homebrew-cask
	# Install from homebrew-cask first, because there are some package need XQuartz
	BREW_CASK_LOG_DIR=$LOG_DIR/BREW_CASK
	mkdir -p $BREW_CASK_LOG_DIR
	while read LINE; do
		echo "Installing $LINE"
		APP="$(get-column "$LINE" 1)"
		FORCE_LOCATION="$(get-column "$LINE" 2)"
		echo "APP:      \"$PKG\""
		echo "LOCATION: \"$FORCE_LOCATIO\""
		brew cask install $APP --appdir=/Applications 2>&1 | tee $BREW_CASK_LOG_DIR/$APP.log
		if [ "$FORCE_LOCATION" != "" ]; then
			LOG_NAME=$BREW_CASK_LOG_DIR/$APP.log
			APP_NAME="$(cat "$LOG_NAME" | tail -n 2 | head -n 1 | grep -oe "'[^\']\+'" | head -n 1 | sed -e "s/'//g")"
			SYM_LINK="$(cat "$LOG_NAME" | tail -n 2 | head -n 1 | grep -oe "'[^\']\+'" | tail -n 1 | sed -e "s/'//g")"
			REAL_LOCATION="$(cat "$LOG_NAME" | tail -n 1 | grep -oe "'.\+'" | sed -e "s/'//g")/$APP_NAME"
			if [ -h "$SYM_LINK" ]; then
				rm "$SYM_LINK"
			fi
			echo "Move $APP_NAME to $FORCE_LOCATION ..."
			mv "$REAL_LOCATION" "$FORCE_LOCATION/$APP_NAME"
		fi
	done < brew-cask.list

	# install packages from homebrew
	BREW_LOG_DIR=$LOG_DIR/BREW
	mkdir -p $BREW_LOG_DIR
	while read LINE; do
		PKG="$(get-column "$LINE" 1)"
		PARAMETER="$(get-column "$LINE" 2)"
		echo "PKG:       \"$PKG\""
		echo "PARAMETER: \"$PARAMETER\""
		brew install $PKG $PARAMETER 2>&1 | tee $BREW_LOG_DIR/$PKG.log
	done < brew.list
fi

