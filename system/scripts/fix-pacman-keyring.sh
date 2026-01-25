#!/usr/bin/env bash
set -euo pipefail

echo "==> Iniciando corrección de keyring pacman (Arch Linux)"

# 1. Sincronizar hora (CRÍTICO)
echo "==> Sincronizando reloj del sistema..."
timedatectl set-ntp true

echo "==> Estado del tiempo:"
timedatectl status | sed -n '1,10p'

# 2. Inicializar keyring
echo "==> Inicializando pacman-key..."
pacman-key --init

# 3. Poblar claves oficiales de Arch
echo "==> Importando claves oficiales de Arch Linux..."
pacman-key --populate archlinux

# 4. Actualizar keyring
echo "==> Actualizando archlinux-keyring..."
pacman -Sy --noconfirm archlinux-keyring

# 5. Limpiar caché de paquetes (por seguridad)
echo "==> Limpiando caché de paquetes..."
rm -rf /var/cache/pacman/pkg/*

echo "==> Keyring reparado correctamente."
echo "==> Ya puedes ejecutar pacstrap o archinstall."
