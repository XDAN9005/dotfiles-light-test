#!/bin/bash

# Script de configuración para i3, picom y herramientas relacionadas
# Solo configuraciones - NO instala paquetes
set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

print_section "Configuración de teclado"

print_status "Configurando layout de teclado la-latin1..."
# Para X11
echo 'Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "latam"
    Option "XkbModel" "pc105"
EndSection' | sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf

# Para consola virtual (TTY)
sudo localectl set-keymap la-latin1
sudo localectl set-x11-keymap latam

print_section "Creando directorios necesarios"

print_section "Script para cambiar wallpaper"


print_section "¡Configuración completada!"

echo "     Si tienes libinput-gestures instalado, ejecuta:"
echo "     libinput-gestures-setup autostart"
echo "     libinput-gestures-setup start"

print_status "¡Listo! Todas las configuraciones han sido aplicadas."