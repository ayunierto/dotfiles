#!/bin/bash
# Instalador de entorno de escritorio
# Script con menú interactivo para instalación modular de Hyprland

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_color() {
    echo -e "${2}${1}${NC}"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear
echo "================================================"
print_color "  Instalador de Entorno de Escritorio" "$BLUE"
echo "================================================"
echo ""

chmod +x scripts/*.sh

# Verificar que yay esté instalado
if ! command -v yay &> /dev/null; then
    print_color "❌ yay no está instalado" "$RED"
    echo ""
    echo "Instala yay primero desde system/:"
    echo "  cd ../system"
    echo "  ./scripts/install-yay.sh"
    exit 1
fi

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_color "❌ Este script requiere permisos de root" "$RED"
        echo "Ejecuta con: sudo ./install.sh"
        exit 1
    fi
}

show_menu() {
    echo ""
    print_color "¿Qué deseas instalar?" "$BLUE"
    echo ""
    echo "  1) 📦 Paquetes base (Hyprland, Waybar, Kitty, etc.)"
    echo "  2) 🖥️  Login manager (seatd + greetd + tuigreet)"
    echo "  3) 🐚 Configuración de ZSH (Oh My Zsh + plugins)"
    echo "  4) 🚀 Configuración de Rofi"
    echo "  5) 📁 Copiar configuraciones a ~/.config"
    echo "  6) 🔗 Crear symlinks (mantener config sincronizada)"
    echo "  7) ✨ Instalación completa (todo lo anterior)"
    echo "  0) ❌ Salir"
    echo ""
    read -p "Selecciona una opción [0-7]: " choice
}

create_symlinks() {
    print_color "🔗 Creando symlinks..." "$YELLOW"
    echo ""
    
    CONFIG_SOURCE="$SCRIPT_DIR/../config"
    
    # Symlink para .zshrc
    if [ -f "$CONFIG_SOURCE/.zshrc" ]; then
        if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
            echo "  → Creando backup de .zshrc"
            mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        ln -sf "$CONFIG_SOURCE/.zshrc" "$HOME/.zshrc"
        echo "  ✓ Symlink: ~/.zshrc → config/.zshrc"
    fi
    
    # Symlinks para .config
    CONFIGS=("hypr" "waybar" "kitty" "rofi" "swaync")
    for config in "${CONFIGS[@]}"; do
        if [ -d "$CONFIG_SOURCE/$config" ]; then
            if [ -d "$HOME/.config/$config" ] && [ ! -L "$HOME/.config/$config" ]; then
                echo "  → Creando backup de .config/$config"
                mv "$HOME/.config/$config" "$HOME/.config/$config.backup.$(date +%Y%m%d_%H%M%S)"
            fi
            ln -sf "$CONFIG_SOURCE/$config" "$HOME/.config/$config"
            echo "  ✓ Symlink: ~/.config/$config → config/$config"
        fi
    done
    
    echo ""
    print_color "✅ Symlinks creados correctamente" "$GREEN"
}

install_all() {
    print_color "🚀 Iniciando instalación completa..." "$BLUE"
    echo ""
    
    check_root
    
    ./scripts/install-packages.sh
    echo ""
    
    ./scripts/install-seatd-greetd.sh
    echo ""
    
    # ZSH debe ejecutarse como usuario
    print_color "⚠️  Cambiando a usuario para instalar ZSH..." "$YELLOW"
    REAL_USER="${SUDO_USER:-$USER}"
    if [ "$REAL_USER" != "root" ]; then
        sudo -u "$REAL_USER" bash scripts/install-zsh.sh
    else
        print_color "⚠️  Ejecuta manualmente como usuario: ./scripts/install-zsh.sh" "$YELLOW"
    fi
    echo ""
    
    ./scripts/install-rofi.sh
    echo ""
    
    # Copiar configs como usuario
    if [ "$REAL_USER" != "root" ]; then
        sudo -u "$REAL_USER" bash scripts/install-configs.sh
    else
        ./scripts/install-configs.sh
    fi
    echo ""
    
    print_color "🎉 ¡Instalación completa finalizada!" "$GREEN"
    echo ""
    echo "Próximos pasos:"
    echo "  1. Reinicia la terminal para aplicar cambios de ZSH"
    echo "  2. Ejecuta 'p10k configure' para configurar Powerlevel10k"
    echo "  3. Reinicia el sistema: sudo reboot"
    echo "  4. Inicia sesión en Hyprland desde el greeter"
}

while true; do
    show_menu
    
    case $choice in
        1) check_root; ./scripts/install-packages.sh; read -p "Presiona Enter...";;
        2) check_root; ./scripts/install-seatd-greetd.sh; read -p "Presiona Enter...";;
        3)
            if [ "$EUID" -eq 0 ]; then
                print_color "❌ No ejecutes ZSH como root" "$RED"
                echo "   Sal y ejecuta: ./scripts/install-zsh.sh"
            else
                ./scripts/install-zsh.sh
            fi
            read -p "Presiona Enter..."
            ;;
        4) check_root; ./scripts/install-rofi.sh; read -p "Presiona Enter...";;
        5) ./scripts/install-configs.sh; read -p "Presiona Enter...";;
        6) create_symlinks; read -p "Presiona Enter...";;
        7) install_all; read -p "Presiona Enter...";;
        0) print_color "👋 ¡Hasta luego!" "$BLUE"; exit 0;;
        *) print_color "❌ Opción inválida" "$RED"; sleep 2;;
    esac
    
    clear
    echo "================================================"
    print_color "  Instalador de Entorno de Escritorio" "$BLUE"
    echo "================================================"
done
