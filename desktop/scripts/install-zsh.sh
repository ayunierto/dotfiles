#!/bin/bash
# Script para configurar zsh con Oh My Zsh, plugins y tema Powerlevel10k

set -e

echo "================================================"
echo "  Configurando ZSH"
echo "================================================"
echo ""

# Verificar que yay esté instalado
if ! command -v yay &> /dev/null; then
    echo "❌ Error: yay no está instalado. Instálalo primero."
    exit 1
fi

# Instalar zsh
echo "📦 Instalando zsh..."
yay -S --needed --noconfirm zsh exa bat

# Verificar si Oh My Zsh ya está instalado
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "⚠️  Oh My Zsh ya está instalado. Saltando instalación..."
else
    echo "📥 Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Instalar plugins
echo ""
echo "🔌 Instalando plugins..."

# zsh-autosuggestions
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "  → zsh-autosuggestions ya está instalado"
else
    echo "  → Instalando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "  → zsh-syntax-highlighting ya está instalado"
else
    echo "  → Instalando zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Instalar Powerlevel10k
echo ""
echo "🎨 Instalando tema Powerlevel10k..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "  → Powerlevel10k ya está instalado"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Copiar .zshrc si existe en dotfiles
echo ""
if [ -f "$HOME/dotfiles/.zshrc" ]; then
    echo "📝 Copiando configuración de .zshrc..."
    cp "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
    echo "✅ .zshrc configurado"
else
    echo "⚠️  No se encontró .zshrc en ~/dotfiles"
    echo "   Configura manualmente los plugins en ~/.zshrc:"
    echo "   plugins=(git zsh-autosuggestions zsh-syntax-highlighting)"
    echo "   ZSH_THEME=\"powerlevel10k/powerlevel10k\""
fi

# Cambiar shell por defecto
echo ""
echo "🐚 Cambiando shell por defecto a zsh..."
if [ "$SHELL" = "$(which zsh)" ]; then
    echo "  → zsh ya es tu shell por defecto"
else
    chsh -s "$(which zsh)"
    echo "✅ Shell cambiado a zsh. Reinicia la sesión para aplicar los cambios."
fi

echo ""
echo "✅ Configuración de ZSH completada"
echo ""
echo "💡 Consejos:"
echo "   - Reinicia la terminal para aplicar los cambios"
echo "   - Ejecuta 'p10k configure' para configurar el tema Powerlevel10k"
echo ""
