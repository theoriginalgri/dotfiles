#!/usr/bin/env bash

function addShell() {
	RESULT=`egrep $1 /etc/shells`
	
	if [ $RESULT ]; then
		echo "Skipping $1. Already in /etc/shells."
		return
	fi
	
	sudo sh -c "echo \"$1\" >> /etc/shells"
}

# install Command Line Tools
echo "[i] Install XCode"
xcode-select --install

echo "[i] Install Java"
java > /dev/null

echo "[i] Install Cocoapods"
sudo gem install cocoapods

# install homwbrew
echo "[i] Install Homebrew"
brew info > /dev/null

if [ $? -eq 0 ]; then
	echo "Skipped. Homebrew is already installed"
else
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# install brew formula
echo "[i] Install Brew formula"
brew bundle Brewfile

# install certificates
echo "[i] Install CAcert certificates"
./setup-cacert.sh

# add shells
echo "[i] Add brew zsh and bash to shells"
addShell /usr/local/bin/bash
addShell /usr/local/bin/zsh

# install brew cask apps
echo "[i] Install brew cask apps"
./cask

# install oh-my-zsh
echo "[i] Install oh-my-zsh"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# setup zsh as default shell
echo "[i] Set zsh as default shell"
chsh -s /usr/local/bin/zsh

# linking files
echo "[i] Linking dotfiles"
ln -s ~/.dotfiles/bashrc ~/.bashrc
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/wgetrc ~/.wgetrc
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/curlrc ~/.curlrc

# install python packages
echo "[i] Install Python Packages"
/usr/local/bin/pip3install httpie

# Some stuff
echo "[i] Doing some stuff"
mkdir ~/.virtualenvs 

# set osx defaults
echo "[i] Set OS X defaults"
./osx
