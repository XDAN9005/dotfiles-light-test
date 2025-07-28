#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

print_section "Updating system packages"
pacman -Syu --noconfirm

print_section "Installing Graphics Drivers"
pacman -S --noconfirm mesa \
                      vulkan-intel

print_section "Installing X11"
pacman -S --noconfirm xorg-server \
                      xorg-xinit \
                      xorg-xsetroot \
                      xorg-xrandr \
                      xorg-xprop \
                      xorg-xwininfo \
                      xorg-xdpyinfo \
                      xorg-xev \
                      xorg-xkill \
                      xorg-xbacklight \
                      xf86-input-libinput

print_section "Instalando Paquetes"
pacman -S --noconfirm bspwm \
                      dunst \
                      fastfetch \
                      picom \
                      kitty \
                      polybar \
                      rofi \
                      sxhkd \
                      flameshot \
                      betterlockscreen \
                      lightdm lightdm-gtk-greeter

print_section "Herramientas para temas dinámicos"
sudo pacman -S --noconfirm python-pywal \
                           imagemagick

print_section "Installing Audio Components"
pacman -S --noconfirm pulseaudio \
                      pulseaudio-alsa \
                      pulseaudio-bluetooth \
                      pulsemixer \
                      pavucontrol \
                      alsa-utils

usermod -a -G audio $USER

print_section "Installing Bluetooth and Connectivity Tools"
pacman -S --noconfirm bluez \
                      bluez-utils \
                      blueman \
                      networkmanager \
                      network-manager-applet \
                      wpa_supplicant

systemctl enable NetworkManager

print_section "Installing File Manager and Utilities"
pacman -S --noconfirm pcmanfm gvfs gvfs-mtp \
                      file-roller \
                      udisks2\
                      ntfs-3g\
                      unzip \
                      unrar \
                      p7zip

print_section "Installing Multimedia Tools"
pacman -S --noconfirm mpv \
                      feh \
                      sxiv \
                      aegisub \
                      ffmpeg \
                      yt-dlp

print_section "Installing GUI Configuration Tools"
pacman -S --noconfirm lxappearance \
                      gtk-engine-murrine \
                      nitrogen \
                      arandr

print_section "Installing System Utilities"
pacman -S --noconfirm htop \
                      tree \
                      ranger \
                      git\
                      lm_sensors \
                      firefox \
                      redshift \
                      scrot maim

print_section "Installing Clipboard and Notification Dependencies"
pacman -S --noconfirm xclip \
                      xsel\
                      libnotify

print_section "Installing Image Viewer and PDF Reader"
pacman -S --noconfirm zathura \
                      zathura-pdf-mupdf

print_section "Installing Fonts"
pacman -S --noconfirm ttf-dejavu \
                      ttf-liberation \
                      noto-fonts-emoji \
                      terminus-font

print_section "Gaming ligero"
# Habilitar multilib para Steam
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    print_status "Habilitando repositorio multilib..."
    sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy
fi

sudo pacman -S --noconfirm steam

print_section "Impresora HP (si la necesitas)"
sudo pacman -S --noconfirm cups hplip system-config-printer
sudo systemctl enable cups
sudo usermod -a -G lp $USER

print_section "Instalando AUR helper (yay - más ligero que paru)"
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
fi

print_section "Node.js y herramientas de desarrollo"
sudo pacman -S --noconfirm nodejs npm

print_section "Soporte para gestos de trackpad"
sudo pacman -S --noconfirm libinput-gestures xdotool
# Agregar usuario al grupo input para gestos
sudo usermod -a -G input $USER

print_section "Enabling Services"
systemctl enable NetworkManager
systemctl enable now lightdm

print_section "Optimizaciones para laptop vieja"
print_status "Configurando swappiness para SSD/HDD..."
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

print_section "Limpieza del sistema"
sudo pacman -Sc --noconfirm

print_section "Reflector"
reflector --country Mexico --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

print_status "Usuario actual: $USER"
print_status "Grupos añadidos: audio, lp, input"

read -p "¿Reiniciar ahora para aplicar cambios? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
