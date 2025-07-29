#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles-light"
CONFIGS="bspwm dunst fastfetch gtk-2.0 gtk-3.0 gtk-4.0 kitty picom polybar rofi sxhkd"

for config in $CONFIGS; do
    DEST="$HOME/.config/$config"
    mkdir -p "$DEST"
    cp -r "$DOTFILES_DIR/$config/"* "$DEST"
done