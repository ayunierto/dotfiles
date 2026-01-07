#!/usr/bin/env bash
# Script modular para instalar y configurar seatd + greetd + tuigreet

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

: "${USERNAME:?Define USERNAME en arch.env}"
: "${GREETD_USER:=greeter}"
: "${GREETD_CMD:=tuigreet --time --remember --user-menu --cmd 'Hyprland'}"

echo "================================================"
echo "  Instalando seatd + greetd + tuigreet"
echo "================================================"
echo ""

backup_if_exists() {
  local path="$1"
  if [[ -f "$path" ]]; then
    cp "$path" "$path.bak.$(date +%s)"
    echo "  ℹ️  Backup creado: ${path}.bak"
  fi
}

user_in_group() {
  local user="$1" group="$2"
  id -nG "$user" | tr ' ' '\n' | grep -qx "$group"
}

echo "📦 Instalando paquetes..."
pacman -S --noconfirm seatd greetd tuigreet

echo "⚙️  Habilitando seatd.service..."
systemctl enable seatd.service

echo "👤 Creando usuario $GREETD_USER para greetd..."
if ! id "$GREETD_USER" >/dev/null 2>&1; then
  useradd --system --shell /usr/bin/nologin --home /var/lib/greetd "$GREETD_USER"
fi

echo "👥 Agregando $USERNAME al grupo seat..."
if ! user_in_group "$USERNAME" seat; then
  gpasswd --add "$USERNAME" seat
fi

echo "📝 Configurando greetd..."
local cfg="/etc/greetd/config.toml"
backup_if_exists "$cfg"

cat > "$cfg" <<EOF
[terminal]
shell = "/bin/bash"

[default_session]
command = "$GREETD_CMD"
user = "$GREETD_USER"
EOF

echo "⚙️  Habilitando greetd.service..."
systemctl enable greetd.service

echo ""
echo "✅ seatd + greetd + tuigreet configurados correctamente"
echo ""
echo "ℹ️  El sistema iniciará con tuigreet después del próximo reinicio"
echo ""
