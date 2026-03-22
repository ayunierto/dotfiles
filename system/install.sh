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

# # Asegurar que trabajamos desde el directorio del script para rutas relativas
# cd "$SCRIPT_DIR" || { print_color "❌ No se pudo cambiar a $SCRIPT_DIR" "$RED"; exit 1; }

# clear
# echo "================================================"
# print_color "  Instalador de Arch Linux (Sistema Base)" "$BLUE"
# echo "================================================"
# echo ""

# if [ ! -f "$ENV_FILE" ]; then
#     print_color "❌ Error: No se encontró arch.env" "$RED"
#     echo ""
#     echo "Crea el archivo arch.env con tu configuración"
#     exit 1
# fi

# chmod +x scripts/*.sh

# # Live ISO auto-detection removed per user request

# # --- Flujo interactivo simple al iniciar ---
# # Si el usuario acepta, preguntamos los datos necesarios y ejecutamos
# # `scripts/install-base.sh` con las variables como entorno.
# source "$ENV_FILE"

# initial_interactive() {
#     echo ""
#     print_color "⚙️  Instalación base interactiva" "$BLUE"
#     echo "Esto solicitará los datos necesarios para la instalación base." 
#     read -rp "Iniciar instalación base ahora? (S/n): " START_NOW
#     if [[ "$START_NOW" == "n" || "$START_NOW" == "N" ]]; then
#         return 1
#     fi

#     # Pedir valores, mostrando los valores por defecto leídos desde arch.env
#     read -rp "EFI partition [${EFI_PART:-/dev/nvme0n1p1}]: " EFI_IN
#     read -rp "Root partition [${ROOT_PART:-/dev/nvme0n1p4}]: " ROOT_IN
#     read -rp "Home partition [${HOME_PART:-/dev/nvme0n1p6}]: " HOME_IN
#     read -rp "Mountpoint [${MOUNTPOINT:-/mnt}]: " MOUNT_IN
#     read -rp "Hostname [${HOSTNAME:-arch}]: " HOST_IN
#     read -rp "Username [${USERNAME:-neo}]: " USER_IN
#     read -rp "Timezone [${TIMEZONE:-America/Lima}]: " TZ_IN
#     read -rp "Extra packages (espacio separado) [${EXTRA_PKGS:-nano}]: " PKGS_IN

#     # Construir variables usando entrada o valores por defecto
#     [[ -n "$EFI_IN" ]] && EFI_VAL="$EFI_IN" || EFI_VAL="${EFI_PART:-/dev/nvme0n1p1}"
#     [[ -n "$ROOT_IN" ]] && ROOT_VAL="$ROOT_IN" || ROOT_VAL="${ROOT_PART:-/dev/nvme0n1p4}"
#     [[ -n "$HOME_IN" ]] && HOME_VAL="$HOME_IN" || HOME_VAL="${HOME_PART:-/dev/nvme0n1p6}"
#     [[ -n "$MOUNT_IN" ]] && MOUNT_VAL="$MOUNT_IN" || MOUNT_VAL="${MOUNTPOINT:-/mnt}"
#     [[ -n "$HOST_IN" ]] && HOST_VAL="$HOST_IN" || HOST_VAL="${HOSTNAME:-arch}"
#     [[ -n "$USER_IN" ]] && USER_VAL="$USER_IN" || USER_VAL="${USERNAME:-neo}"
#     [[ -n "$TZ_IN" ]] && TZ_VAL="$TZ_IN" || TZ_VAL="${TIMEZONE:-America/Lima}"
#     [[ -n "$PKGS_IN" ]] && PKGS_VAL="$PKGS_IN" || PKGS_VAL="${EXTRA_PKGS:-nano}"

#     echo ""
#     echo "Resumen de configuración:" 
#     echo "  EFI:  $EFI_VAL"
#     echo "  ROOT: $ROOT_VAL"
#     echo "  HOME: $HOME_VAL"
#     echo "  MOUNT: $MOUNT_VAL"
#     echo "  HOST:  $HOST_VAL"
#     echo "  USER:  $USER_VAL"
#     echo "  TZ:    $TZ_VAL"
#     echo "  PKGS:  $PKGS_VAL"
#     echo ""
#     read -rp "¿Continuar e iniciar instalación? (s/N): " CONF2
#     if [[ "$CONF2" != "s" && "$CONF2" != "S" ]]; then
#         echo "Cancelado por usuario. Volviendo al menú..."
#         return 1
#     fi

#     # Construir comando de entorno
#     ENV_CMD="EFI_PART=\"$EFI_VAL\" ROOT_PART=\"$ROOT_VAL\" HOME_PART=\"$HOME_VAL\" MOUNTPOINT=\"$MOUNT_VAL\" HOSTNAME=\"$HOST_VAL\" USERNAME=\"$USER_VAL\" TIMEZONE=\"$TZ_VAL\" EXTRA_PKGS=\"$PKGS_VAL\""

#     # Ejecutar con privilegios: si ya es root, ejecutar directamente; si no, usar sudo
#     if [ "$EUID" -eq 0 ]; then
#         eval "$ENV_CMD ./scripts/install-base.sh"
#     else
#         read -rp "No eres root. Ejecutar instalación ahora con sudo? (s/N): " SURE
#         if [[ "$SURE" == "s" || "$SURE" == "S" ]]; then
#             sudo env $ENV_CMD bash -c '"$PWD"/scripts/install-base.sh'
#         else
#             echo "Instalación pospuesta. Vuelve a ejecutar el script como root para continuar." 
#             return 1
#         fi
#     fi

#     # Si llegó aquí, la instalación terminó o falló dentro del script.
#     exit 0
# }

# # Ejecutar el flujo interactivo al inicio; si el usuario cancela, continúa al menú normal
# initial_interactive || true


# check_root() {
#     if [ "$EUID" -ne 0 ]; then
#         print_color "❌ Este script requiere permisos de root" "$RED"
#         echo "Ejecuta con: sudo ./install.sh"
#         exit 1
#     fi
# }

# show_menu_live() {
#     echo ""
#     print_color "🔴 Detectado: Live ISO de Arch Linux" "$YELLOW"
#     echo ""
#     print_color "Opciones disponibles:" "$BLUE"
#     echo ""
#     echo "  1) 💿 Instalación base completa"
#     echo "  0) ❌ Salir"
#     echo ""
#     read -p "Selecciona una opción [0-1]: " choice
# }

# show_menu_installed() {
#     echo ""
#     print_color "🟢 Detectado: Sistema Arch instalado" "$GREEN"
#     echo ""
#     print_color "¿Qué deseas configurar?" "$BLUE"
#     echo ""
#     echo "  1) 👥 Configurar usuarios y sudo"
#     echo "  2) 📦 Instalar yay (AUR helper)"
#     echo "  3) 🎮 Instalar drivers AMD"
#     echo "  4) ✨ Instalación completa del sistema base"
#     echo "  5) 💿 Instalación base (particiones interactivas)"
#     echo "  0) ❌ Salir"
#     echo ""
#     print_color "💡 Para el entorno de escritorio: cd ../desktop && ./install.sh" "$YELLOW"
#     echo ""
#     read -p "Selecciona una opción [0-5]: " choice
# }

# install_base() {
#     check_root
#     print_color "💿 Iniciando instalación base..." "$BLUE"
#     echo ""
#     # Preguntar particiones de forma interactiva
#     ask_partitions() {
#         echo ""
#         print_color "⚙️  Configurar particiones para instalación base" "$BLUE"
#         echo "Deja en blanco para usar los valores por defecto en arch.env"
#         echo ""
#         read -rp "EFI partition: " EFI_PART
#         read -rp "Root partition: " ROOT_PART
#         read -rp "Home partition: " HOME_PART
#         read -rp "Mountpoint [/mnt]: " MOUNTPOINT
#         echo ""
#         echo "Resumen:"
#         if [[ -n "$EFI_PART" ]]; then
#             echo "  EFI:  $EFI_PART"
#         else
#             echo "  EFI:  (usar valor por defecto)"
#         fi
#         if [[ -n "$ROOT_PART" ]]; then
#             echo "  ROOT: $ROOT_PART"
#         else
#             echo "  ROOT: (usar valor por defecto)"
#         fi
#         if [[ -n "$HOME_PART" ]]; then
#             echo "  HOME: $HOME_PART"
#         else
#             echo "  HOME: (usar valor por defecto)"
#         fi
#         if [[ -n "$MOUNTPOINT" ]]; then
#             echo "  MOUNT: $MOUNTPOINT"
#         else
#             echo "  MOUNT: /mnt"
#         fi
#         echo ""
#         read -rp "¿Continuar con estas opciones? (s/N): " CONF
#         if [[ "$CONF" != "s" && "$CONF" != "S" ]]; then
#             echo "Instalación cancelada."
#             return 1
#         fi

#         ENV_CMD=""
#         [[ -n "$EFI_PART" ]] && ENV_CMD+="EFI_PART=\"$EFI_PART\" "
#         [[ -n "$ROOT_PART" ]] && ENV_CMD+="ROOT_PART=\"$ROOT_PART\" "
#         [[ -n "$HOME_PART" ]] && ENV_CMD+="HOME_PART=\"$HOME_PART\" "
#         [[ -n "$MOUNTPOINT" ]] && ENV_CMD+="MOUNTPOINT=\"$MOUNTPOINT\" "
#     }

#     if ask_partitions; then
#         if [[ -n "${ENV_CMD:-}" ]]; then
#             eval "$ENV_CMD ./scripts/install-base.sh"
#         else
#             ./scripts/install-base.sh
#         fi
#     fi

#     echo ""
#     print_color "🎉 ¡Instalación base completada!" "$GREEN"
#     echo ""
#     echo "Próximos pasos:"
#     echo "  1. Reinicia: reboot"
#     echo "  2. Inicia sesión como root"
#     echo "  3. Ejecuta: cd system && sudo ./install.sh"
# }

# install_post_base() {
#     check_root
#     print_color "🚀 Instalación completa del sistema base..." "$BLUE"
#     echo ""
    
#     ./scripts/install-users.sh
#     echo ""
    
#     print_color "⚠️  yay debe instalarse como usuario normal" "$YELLOW"
#     echo ""
#     read -p "¿Instalar drivers AMD? (s/N): " install_amd
    
#     if [[ "$install_amd" == "s" || "$install_amd" == "S" ]]; then
#         ./scripts/install-amd-drivers.sh
#         echo ""
#     fi
    
#     echo ""
#     print_color "✅ Sistema base completado" "$GREEN"
#     echo ""
#     print_color "📦 Próximos pasos:" "$BLUE"
#     echo "  1. Sal de root y ejecuta como usuario: ./scripts/install-yay.sh"
#     echo "  2. Para escritorio: cd ../desktop && ./install.sh"
#     echo ""
# }

# run_live_menu() {
#     while true; do
#         show_menu_live
#         case $choice in
#             1) install_base; read -p "Presiona Enter...";;
#             0) print_color "👋 ¡Hasta luego!" "$BLUE"; exit 0;;
#             *) print_color "❌ Opción inválida" "$RED"; sleep 2;;
#         esac
#         clear
#         echo "================================================"
#         print_color "  Instalador de Arch Linux (Sistema Base)" "$BLUE"
#         echo "================================================"
#     done
# }

# run_installed_menu() {
#     while true; do
#         show_menu_installed
#         case $choice in
#             1) check_root; ./scripts/install-users.sh; read -p "Presiona Enter...";;
#             2)
#                 if [ "$EUID" -eq 0 ]; then
#                     print_color "❌ No ejecutes como root" "$RED"
#                     echo "   Ejecuta: ./scripts/install-yay.sh"
#                 else
#                     ./scripts/install-yay.sh
#                 fi
#                 read -p "Presiona Enter..."
#                 ;;
#             3) check_root; ./scripts/install-amd-drivers.sh; read -p "Presiona Enter...";;
#             4) install_post_base; read -p "Presiona Enter...";;
#             5) check_root; install_base; read -p "Presiona Enter...";;
#             0) print_color "👋 ¡Hasta luego!" "$BLUE"; exit 0;;
#             *) print_color "❌ Opción inválida" "$RED"; sleep 2;;
#         esac
#         clear
#         echo "================================================"
#         print_color "  Instalador de Arch Linux (Sistema Base)" "$BLUE"
#         echo "================================================"
#     done
# }

# run_installed_menu
