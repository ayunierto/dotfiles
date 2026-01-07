#!/bin/bash
# Script modular para copiar configuraciones de Hyprland

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/../config"

echo "================================================"
echo "  Configurando Hyprland"
echo "================================================"
echo ""

# Verificar que los archivos de configuración existen
if [ ! -d "$CONFIG_SOURCE" ]; then
    echo "❌ Error: No se encontró el directorio $CONFIG_SOURCE"
    exit 1
fi

# Crear directorio .config si no existe
mkdir -p "$HOME/.config"

# Copiar configuraciones
echo "📁 Copiando configuraciones de Hyprland..."

# Lista de directorios a copiar
CONFIGS=(
    "hypr"
    "waybar"
    "kitty"
    "rofi"
    "swaync"
)

for config in "${CONFIGS[@]}"; do
    if [ -d "$CONFIG_SOURCE/$config" ]; then
        echo "  → Copiando $config..."
        
        # Crear backup si existe
        if [ -d "$HOME/.config/$config" ] && [ ! -L "$HOME/.config/$config" ]; then
            echo "    ℹ️  Creando backup de $config existente"
            mv "$HOME/.config/$config" "$HOME/.config/$config.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        cp -r "$CONFIG_SOURCE/$config" "$HOME/.config/"
    else
        echo "  ⚠️  $config no encontrado en config/"
    fi
done

# Copiar .zshrc si existe
if [ -f "$CONFIG_SOURCE/.zshrc" ]; then
    echo "  → Copiando .zshrc..."
    
    # Crear backup si existe
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        echo "    ℹ️  Creando backup de .zshrc existente"
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    cp "$CONFIG_SOURCE/.zshrc" "$HOME/.zshrc"
fi

echo ""
echo "✅ Configuraciones copiadas correctamente"
echo ""
echo "💡 Reinicia la terminal para aplicar los cambios de zsh"
echo ""
