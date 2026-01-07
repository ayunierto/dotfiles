#!/usr/bin/env bash
# Script modular para instalar drivers AMD

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$SCRIPT_DIR/arch.env"

if [[ $EUID -ne 0 ]]; then
  echo "❌ Este script debe ejecutarse como root." >&2
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ No se encontró $ENV_FILE." >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

: "${INSTALL_LIB32:=0}"

echo "================================================"
echo "  Instalando Drivers AMD"
echo "================================================"
echo ""

local pkgs=(mesa vulkan-radeon)

# Detectar si hay GPU AMD
if [[ -f /sys/module/amdgpu ]]; then
  echo "✅ GPU AMD detectada"
  pkgs+=(xf86-video-amdgpu)
else
  echo "ℹ️  No se detectó GPU AMD, instalando drivers genéricos"
fi

# Soporte para librerías 32-bit (gaming)
if [[ "$INSTALL_LIB32" -eq 1 ]]; then
  if ! grep -q "\[multilib\]" /etc/pacman.conf; then
    echo "⚠️  Multilib no está habilitado; omitiendo lib32.*"
    echo ""
    echo "Para habilitar multilib, edita /etc/pacman.conf y descomenta:"
    echo "  [multilib]"
    echo "  Include = /etc/pacman.d/mirrorlist"
    echo ""
  else
    echo "📦 Agregando soporte 32-bit para gaming..."
    pkgs+=(lib32-mesa lib32-vulkan-radeon)
  fi
fi

echo "📦 Instalando paquetes: ${pkgs[*]}"
pacman -S --noconfirm "${pkgs[@]}"

echo ""
echo "✅ Drivers AMD instalados correctamente"
echo ""
