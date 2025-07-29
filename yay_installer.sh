#!/bin/bash

# Function to print status messages
print_status() {
    echo -e "\n\e[32m[INFO]\e[0m $1"
}

print_section() {
    echo -e "\n\e[34m=== $1 ===\e[0m"
}

print_section "Installing AUR Packages"
yay -S --noconfirm \
    polybar \
    picom-git \
    chrome-browser \
    visual-studio-code-bin \
    telegram-desktop \
    bottles \
    ani-cli \
    ani-skip-git \
    wpgtk-git \
    xpadneo-dkms \
    dracula-cursors-git

yay -Sc --noconfirm

echo -e "\n\e[32m[SUCCESS]\e[0m AUR packages installed successfully."