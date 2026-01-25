#!/bin/bash
# Instalador de sistema base Arch Linux
# Script con menú interactivo para instalación modular

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
ENV_FILE="$SCRIPT_DIR/arch.env"

clear
echo "================================================"
print_color "  Instalador de Arch Linux (Sistema Base)" "$BLUE"
echo "================================================"
echo ""

if [ ! -f "$ENV_FILE" ]; then
    print_color "❌ Error: No se encontró arch.env" "$RED"
    echo ""
    echo "Crea el archivo arch.env con tu configuración"
    exit 1
fi

chmod +x scripts/*.sh

# Live ISO auto-detection removed per user request

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_color "❌ Este script requiere permisos de root" "$RED"
        echo "Ejecuta con: sudo ./install.sh"
        exit 1
    fi
}

show_menu_live() {
    echo ""
    print_color "🔴 Detectado: Live ISO de Arch Linux" "$YELLOW"
    echo ""
    print_color "Opciones disponibles:" "$BLUE"
    echo ""
    echo "  1) 💿 Instalación base completa"
    echo "  0) ❌ Salir"
    echo ""
    read -p "Selecciona una opción [0-1]: " choice
}

show_menu_installed() {
    echo ""
    print_color "🟢 Detectado: Sistema Arch instalado" "$GREEN"
    echo ""
    print_color "¿Qué deseas configurar?" "$BLUE"
    echo ""
    echo "  1) 👥 Configurar usuarios y sudo"
    echo "  2) 📦 Instalar yay (AUR helper)"
    echo "  3) 🎮 Instalar drivers AMD"
    echo "  4) ✨ Instalación completa del sistema base"
    echo "  0) ❌ Salir"
    echo ""
    print_color "💡 Para el entorno de escritorio: cd ../desktop && ./install.sh" "$YELLOW"
    echo ""
    read -p "Selecciona una opción [0-4]: " choice
}

install_base() {
    check_root
    print_color "💿 Iniciando instalación base..." "$BLUE"
    echo ""
    ./scripts/install-base.sh
    echo ""
    print_color "🎉 ¡Instalación base completada!" "$GREEN"
    echo ""
    echo "Próximos pasos:"
    echo "  1. Reinicia: reboot"
    echo "  2. Inicia sesión como root"
    echo "  3. Ejecuta: cd system && sudo ./install.sh"
}

install_post_base() {
    check_root
    print_color "🚀 Instalación completa del sistema base..." "$BLUE"
    echo ""
    
    ./scripts/install-users.sh
    echo ""
    
    print_color "⚠️  yay debe instalarse como usuario normal" "$YELLOW"
    echo ""
    read -p "¿Instalar drivers AMD? (s/N): " install_amd
    
    if [[ "$install_amd" == "s" || "$install_amd" == "S" ]]; then
        ./scripts/install-amd-drivers.sh
        echo ""
    fi
    
    echo ""
    print_color "✅ Sistema base completado" "$GREEN"
    echo ""
    print_color "📦 Próximos pasos:" "$BLUE"
    echo "  1. Sal de root y ejecuta como usuario: ./scripts/install-yay.sh"
    echo "  2. Para escritorio: cd ../desktop && ./install.sh"
    echo ""
}

run_live_menu() {
    while true; do
        show_menu_live
        case $choice in
            1) install_base; read -p "Presiona Enter...";;
            0) print_color "👋 ¡Hasta luego!" "$BLUE"; exit 0;;
            *) print_color "❌ Opción inválida" "$RED"; sleep 2;;
        esac
        clear
        echo "================================================"
        print_color "  Instalador de Arch Linux (Sistema Base)" "$BLUE"
        echo "================================================"
    done
}

run_installed_menu() {
    while true; do
        show_menu_installed
        case $choice in
            1) check_root; ./scripts/install-users.sh; read -p "Presiona Enter...";;
            2)
                if [ "$EUID" -eq 0 ]; then
                    print_color "❌ No ejecutes como root" "$RED"
                    echo "   Ejecuta: ./scripts/install-yay.sh"
                else
                    ./scripts/install-yay.sh
                fi
                read -p "Presiona Enter..."
                ;;
            3) check_root; ./scripts/install-amd-drivers.sh; read -p "Presiona Enter...";;
            4) install_post_base; read -p "Presiona Enter...";;
            0) print_color "👋 ¡Hasta luego!" "$BLUE"; exit 0;;
            *) print_color "❌ Opción inválida" "$RED"; sleep 2;;
        esac
        clear
        echo "================================================"
        print_color "  Instalador de Arch Linux (Sistema Base)" "$BLUE"
        echo "================================================"
    done
}

run_installed_menu
