#!/usr/bin/env bash
# Script para instalar yay AUR helper (ejecutar como usuario normal)

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "❌ Este script NO debe ejecutarse como root." >&2
  echo "   Ejecuta como usuario normal: ./scripts/install-yay.sh" >&2
  exit 1
fi

echo "================================================"
echo "  Instalando yay (AUR Helper)"
echo "================================================"
echo ""

# Verificar que git y base-devel están instalados
if ! command -v git >/dev/null 2>&1; then
  echo "❌ git no está instalado. Instálalo primero:"
  echo "   sudo pacman -S git base-devel"
  exit 1
fi

# Verificar si yay ya está instalado
if command -v yay >/dev/null 2>&1; then
  echo "✅ yay ya está instalado"
  yay --version
  exit 0
fi

echo "📥 Clonando repositorio de yay..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://aur.archlinux.org/yay.git

echo "🔨 Compilando e instalando yay..."
cd yay
makepkg -si --noconfirm

echo "🧹 Limpiando archivos temporales..."
cd ~
rm -rf "$TEMP_DIR"

echo ""
echo "✅ yay instalado correctamente"
echo ""
yay --version
echo ""
echo "Próximo paso:"
echo "  Ejecuta: sudo ./scripts/install-desktop.sh"
echo ""
