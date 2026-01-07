# 🖥️ Sistema Base - Arch Linux

Instalador automatizado del sistema base de Arch Linux con scripts modulares.

## 🎯 Alcance

Este instalador cubre **únicamente el sistema base**:

✅ Particionado y formateo  
✅ Sistema base de Arch Linux  
✅ Bootloader (GRUB UEFI)  
✅ NetworkManager  
✅ PipeWire (audio)  
✅ Usuarios y sudo  
✅ yay (AUR helper)  
✅ Drivers AMD (opcional)

**❌ NO incluye** (ver [../desktop/](../desktop/)):

- Entorno de escritorio
- Aplicaciones
- Temas e iconos

## ⚙️ Configuración

Edita `arch.env` antes de comenzar:

```bash
nano arch.env
```

### Variables principales:

```bash
# Particiones
EFI_PART="/dev/nvme0n1p1"
ROOT_PART="/dev/nvme0n1p4"
HOME_PART="/dev/nvme0n1p6"

# Sistema
HOSTNAME="arch"
USERNAME="neo"
TIMEZONE="America/New_York"
LOCALE_LANG="es_ES.UTF-8"

# Opciones
ENABLE_AMD_STACK=1      # 1 = instalar drivers AMD
INSTALL_LIB32=1        # 1 = instalar soporte 32-bit
```

## 🚀 Instalación Rápida

### Desde Live ISO (root):

```bash
cd system
chmod +x install.sh
./install.sh
```

El menú interactivo te permite:

1. Instalación base completa
2. Configurar usuarios
3. Instalar yay
4. Instalar drivers AMD

## 📋 Flujo Paso a Paso

### 1. En Live ISO

```bash
# Conectar WiFi
iwctl
station wlan0 connect "NombreRed"
exit

# Ejecutar instalador
cd system
chamod +x install.sh
./install.sh
# Selecciona: Instalación base completa

# Reinicia
reboot
```

### 2. Después del Reinicio

```bash
# Login como root (primera vez)
cd system
chamod +x install.sh
./install.sh
# Selecciona: Configurar usuarios y sudo

# Sal de root
exit

# Login como tu usuario
./scripts/install-yay.sh

# (Opcional) Drivers AMD
chmod +x scripts/install-amd-drivers.sh
sudo ./scripts/install-amd-drivers.sh
```

### 3. Siguiente Paso

```bash
cd ../desktop
./install.sh
```

## 🧩 Scripts Modulares

Ubicados en `scripts/`:

### install-base.sh

Instalación del sistema base desde Live ISO.

**¿Qué hace?**

- Formatea particiones (ROOT y HOME)
- Monta particiones
- Instala sistema base con `pacstrap`
- Genera fstab
- Configura zona horaria y locales
- Instala GRUB
- Configura NetworkManager y PipeWire

**Uso:**

```bash
sudo ./scripts/install-base.sh
```

### install-users.sh

Configuración de usuarios y sudo.

**¿Qué hace?**

- Establece contraseña de root
- Crea usuario normal
- Agrega usuario al grupo wheel
- Habilita sudo para wheel

**Uso:**

```bash
sudo ./scripts/install-users.sh
```

### install-yay.sh

Instala yay (AUR helper).

**¿Qué hace?**

- Clona repositorio de yay
- Compila e instala yay
- Limpia archivos temporales

**Uso (como usuario normal):**

```bash
./scripts/install-yay.sh
```

### install-amd-drivers.sh

Instala drivers AMD (opcional).

**¿Qué hace?**

- Instala mesa y vulkan-radeon
- Detecta GPU AMD
- Instala lib32 si multilib está habilitado

**Uso:**

```bash
sudo ./scripts/install-amd-drivers.sh
```

## 📦 Paquetes Instalados

### Sistema Base

- base, linux, linux-firmware
- grub, efibootmgr, os-prober
- networkmanager

### Audio

- pipewire, pipewire-alsa, pipewire-pulse
- pipewire-jack, wireplumber, alsa-utils

### Herramientas

- nano (o el definido en EXTRA_PKGS)
- yay (AUR helper)

### AMD (opcional)

- mesa, vulkan-radeon
- xf86-video-amdgpu
- lib32-mesa, lib32-vulkan-radeon (si INSTALL_LIB32=1)

## 🛠️ Instalación Manual

Si prefieres no usar scripts:

### 1. Preparar Particiones

```bash
# Formatear
mkfs.ext4 /dev/sdX2  # ROOT
mkfs.ext4 /dev/sdX3  # HOME

# Montar
mount /dev/sdX2 /mnt
mount --mkdir /dev/sdX1 /mnt/boot/efi
mount --mkdir /dev/sdX3 /mnt/home
```

### 2. Instalar Sistema Base

```bash
pacstrap -K /mnt base linux linux-firmware networkmanager nano
genfstab -U /mnt >> /mnt/etc/fstab
```

### 3. Configurar Sistema

```bash
arch-chroot /mnt

# Zona horaria
ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
hwclock --systohc

# Locales
echo "es_PE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=es_PE.UTF-8" > /etc/locale.conf

# Hostname
echo "arch" > /etc/hostname

# Instalar GRUB
pacman -S grub efibootmgr os-prober
echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Habilitar NetworkManager
systemctl enable NetworkManager

exit
```

### 4. Usuarios

```bash
# Contraseña root
passwd

# Crear usuario
useradd -m -G wheel neo
passwd neo

# Habilitar sudo
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
```

### 5. Instalar yay

```bash
# Como usuario normal
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## ⚠️ Notas Importantes

- ⚡ `install-base.sh` **formatea particiones** - confirma antes
- 🔒 Todos los scripts requieren **root** excepto `install-yay.sh`
- 💾 Los scripts crean **backups automáticos**
- 🎯 Los scripts son **idempotentes** - detectan componentes ya instalados
- 📝 Edita `arch.env` para personalizar la instalación

## 🐛 Solución de Problemas

### NetworkManager no funciona

```bash
systemctl status NetworkManager
sudo systemctl enable --now NetworkManager
```

### GRUB no aparece

```bash
# Desde Live ISO
mount /dev/sdX2 /mnt
mount /dev/sdX1 /mnt/boot/efi
arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Audio no funciona

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## 📚 Referencias

- [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
- [GRUB](https://wiki.archlinux.org/title/GRUB)
- [NetworkManager](https://wiki.archlinux.org/title/NetworkManager)
- [PipeWire](https://wiki.archlinux.org/title/PipeWire)

---

**Siguiente paso**: [Instalar entorno de escritorio →](../desktop/README.md)
