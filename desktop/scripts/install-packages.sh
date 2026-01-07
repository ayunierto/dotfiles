#!/bin/bash
# Script para instalar paquetes base de Hyprland

set -e

echo "================================================"
echo "  Instalando paquetes base de Hyprland"
echo "================================================"
echo ""

# Verificar que yay esté instalado
if ! command -v yay &> /dev/null; then
    echo "❌ Error: yay no está instalado. Instálalo primero."
    exit 1
fi

# Lista de paquetes
PACKAGES=(
    "hyprland"
    "hyprlock"
    "hypridle"
    "waybar"
    "kitty"
    "hyprpicker"
    "swww"
    "swaync"
    "grim"
    "playerctl"
    "rofi"
    "wl-clipboard"
    "brightnessctl"
    "slurp"
)

echo "📦 Instalando paquetes..."
echo ""

for package in "${PACKAGES[@]}"; do
    echo "  → Instalando $package..."
done

yay -S --needed --noconfirm "${PACKAGES[@]}"

echo ""
echo "✅ Paquetes instalados correctamente"
echo ""
