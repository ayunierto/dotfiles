#!/usr/bin/env bash
# Script modular para instalación base de Arch Linux

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

# === Configura tus variables (con valores por defecto) ===
: "${EFI_PART:=/dev/nvme0n1p1}"
: "${ROOT_PART:=/dev/nvme0n1p4}"
: "${HOME_PART:=/dev/nvme0n1p6}"
: "${MOUNTPOINT:=/mnt}"
: "${HOSTNAME:=arch}"
: "${USERNAME:=neo}"
: "${TIMEZONE:=America/Lima}"
: "${LOCALE_GENERATE:=en_US.UTF-8 UTF-8}"
: "${LOCALE_LANG:=es_PE.UTF-8}"
: "${BOOTLOADER_ID:=Arch}"
: "${EXTRA_PKGS:=nano}"

read -r -a EXTRA_PKGS_ARR <<< "$EXTRA_PKGS"

echo "================================================"
echo "  Instalación Base de Arch Linux"
echo "================================================"
echo ""
echo "Configuración:"
echo "  EFI:  $EFI_PART"
echo "  ROOT: $ROOT_PART"
echo "  HOME: $HOME_PART"
echo "  Hostname: $HOSTNAME"
echo "  Usuario: $USERNAME"
echo "  Zona horaria: $TIMEZONE"
echo ""

# Verificar que las particiones existen
for part in "$EFI_PART" "$ROOT_PART" "$HOME_PART"; do
	[[ -b "$part" ]] || { echo "❌ No existe dispositivo $part"; exit 1; }
done

echo "⚠️  ADVERTENCIA: Esto BORRARÁ datos en: $ROOT_PART y $HOME_PART"
read -rp "Escribe 'yes' para continuar: " CONFIRM
[[ "$CONFIRM" == "yes" ]] || { echo "Instalación cancelada."; exit 1; }

echo ""
echo "📦 Formateando particiones..."
mkfs.ext4 -F "$ROOT_PART"
mkfs.ext4 -F "$HOME_PART"

echo "📁 Montando particiones..."
mount "$ROOT_PART" "$MOUNTPOINT"
mount --mkdir "$EFI_PART" "$MOUNTPOINT/boot/efi"
mount --mkdir "$HOME_PART" "$MOUNTPOINT/home"

echo "⬇️  Instalando sistema base..."
pacstrap -K "$MOUNTPOINT" base linux linux-firmware networkmanager "${EXTRA_PKGS_ARR[@]}"

echo "📝 Generando fstab..."
genfstab -U "$MOUNTPOINT" >> "$MOUNTPOINT/etc/fstab"

echo "⚙️  Configurando sistema..."
arch-chroot "$MOUNTPOINT" /bin/bash <<CHROOT
set -euo pipefail

echo "  → Configurando zona horaria..."
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

echo "  → Configurando locales..."
echo "$LOCALE_GENERATE" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE_LANG" > /etc/locale.conf

echo "  → Configurando hostname..."
echo "$HOSTNAME" > /etc/hostname

echo "  → Instalando GRUB..."
pacman -S --noconfirm grub efibootmgr os-prober

echo "  → Instalando PipeWire..."
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils

echo "  → Configurando GRUB..."
echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
os-prober

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="$BOOTLOADER_ID"
grub-mkconfig -o /boot/grub/grub.cfg

echo "  → Habilitando NetworkManager..."
systemctl enable NetworkManager

# Enable PipeWire user services when the user exists
if id "$USERNAME" &>/dev/null; then
	runuser -u "$USERNAME" -- systemctl --user enable --now pipewire wireplumber || true
	loginctl enable-linger "$USERNAME" || true
fi
CHROOT

echo ""
echo "🧹 Desmontando particiones..."
umount -R "$MOUNTPOINT"

echo ""
echo "✅ Instalación base completada exitosamente"
echo ""
echo "Próximos pasos:"
echo "  1. Reinicia el sistema: reboot"
echo "  2. Inicia sesión como root"
echo "  3. Ejecuta: ./scripts/install-users.sh"
echo ""
