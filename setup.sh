#!/usr/bin/bash

ln -s `pwd`/.emacs $HOME/.emacs
ln -s `pwd`/.zshrc $HOME/.zshrc

read -p "High DPI? (y/N)?" choice
case "$choice" in
	y|Y ) ln -s `pwd`/.Xresources-hidpi $HOME/.Xresources;;
	* ) ln -s `pwd`/.Xresources $HOME/.Xresources;;
esac
