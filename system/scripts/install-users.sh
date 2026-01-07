#!/usr/bin/env bash
# Script modular para configurar usuarios y sudo

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$SCRIPT_DIR/arch.env"

if [[ $EUID -ne 0 ]]; then
  echo "❌ Este script debe ejecutarse como root." >&2
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ No se encontró $ENV_FILE. Crea o ajusta la configuración antes de continuar." >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

: "${USERNAME:?Define USERNAME en arch.env}"

echo "================================================"
echo "  Configuración de Usuarios y Sudo"
echo "================================================"
echo ""

backup_if_exists() {
  local path="$1"
  if [[ -f "$path" ]]; then
    cp "$path" "$path.bak.$(date +%s)"
    echo "  ℹ️  Backup creado: $path.bak"
  fi
}

# Establece contraseña para root
set_root_password() {
  echo "🔑 Establece contraseña de root:"
  passwd
  echo ""
}

# Crear usuario si no existe
ensure_user() {
  if id "$USERNAME" >/dev/null 2>&1; then
    echo "ℹ️  Usuario $USERNAME ya existe; se omite creación."
  else
    echo "👤 Creando usuario $USERNAME..."
    useradd -m -G wheel "$USERNAME"
    echo ""
    echo "🔑 Establece contraseña para $USERNAME:"
    passwd "$USERNAME"
  fi
  echo ""
}

# Habilitar sudo para grupo wheel
enable_wheel_sudo() {
  echo "⚙️  Habilitando sudo para grupo wheel..."
  local sudoers="/etc/sudoers"
  backup_if_exists "$sudoers"
  sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' "$sudoers"
  echo "✅ Sudo habilitado para grupo wheel"
  echo ""
}

set_root_password
ensure_user
enable_wheel_sudo

echo "✅ Usuarios y sudo configurados correctamente"
echo ""
echo "Próximos pasos:"
echo "  1. Ejecuta: ./scripts/install-yay.sh (como usuario normal)"
echo "  2. Luego ejecuta: sudo ./scripts/install-desktop.sh"
echo ""
