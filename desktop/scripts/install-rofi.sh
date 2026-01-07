#!/bin/bash
# Script para configurar Rofi con temas

set -e

echo "================================================"
echo "  Configurando Rofi"
echo "================================================"
echo ""

# Verificar que yay esté instalado
if ! command -v yay &> /dev/null; then
    echo "❌ Error: yay no está instalado. Instálalo primero."
    exit 1
fi

# Instalar rofi
echo "📦 Instalando Rofi..."
yay -S --needed --noconfirm rofi

# Crear directorio de configuración
mkdir -p "$HOME/.config/rofi"

# Verificar si existe configuración en dotfiles
if [ -d "$HOME/dotfiles/.config/rofi" ]; then
    echo "📁 Copiando configuración de Rofi desde dotfiles..."
    cp -r "$HOME/dotfiles/.config/rofi" "$HOME/.config/"
    echo "✅ Configuración de Rofi copiada"
else
    echo ""
    echo "📥 Descargando temas de adi1090x/rofi..."
    
    # Clonar repositorio de temas
    TEMP_DIR=$(mktemp -d)
    git clone --depth=1 https://github.com/adi1090x/rofi.git "$TEMP_DIR/rofi-themes"
    
    # Copiar archivos relevantes
    if [ -d "$TEMP_DIR/rofi-themes/files" ]; then
        cp -r "$TEMP_DIR/rofi-themes/files/"* "$HOME/.config/rofi/"
        echo "✅ Temas instalados en ~/.config/rofi"
    fi
    
    # Limpiar
    rm -rf "$TEMP_DIR"
fi

echo ""
echo "✅ Configuración de Rofi completada"
echo ""
echo "💡 Prueba Rofi con: rofi -show drun"
echo ""
