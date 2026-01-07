# Dotfiles & Arch Linux Installer

Repositorio completo para instalación automatizada de Arch Linux y configuración de entorno de escritorio Hyprland.

## Contenido

Este repositorio contiene **dos partes principales**:

1. **`system/`** - Instalador de Arch Linux (sistema base)
2. **`desktop/`** - Entorno de escritorio Hyprland + aplicaciones
3. **`config/`** - Archi vos de configuración

## Inicio Rápido

### 1. Instalar Sistema Base (desde Live ISO)

```bash
cd system && chmod +x install.sh && ./install.sh
```

Instala:

- Sistema base de Arch Linux
- Particiones y bootloader (GRUB)
- Red (NetworkManager)
- Usuarios y sudo
- yay (AUR helper)
- Drivers AMD (opcional)

[Ver guía completa →](system/README.md)

### 2. Instalar Entorno de Escritorio

```bash
cd desktop
./install.sh
```

Instala:

- ✅ Hyprland (compositor Wayland)
- ✅ Login manager (greetd + tuigreet)
- ✅ Waybar, swaync, rofi
- ✅ ZSH con Oh My Zsh
- ✅ Aplicaciones y configuraciones

[Ver guía completa →](desktop/README.md)

## 📁 Estructura del Repositorio

```
.
├── system/                 # Instalación de Arch Linux
│   ├── README.md          # Guía detallada de instalación
│   ├── install.sh         # Instalador interactivo
│   ├── arch.env           # Variables de configuración
│   └── scripts/           # Scripts modulares
│       ├── install-base.sh
│       ├── install-users.sh
│       ├── install-yay.sh
│       └── install-amd-drivers.sh
│
├── desktop/               # Entorno de escritorio
│   ├── README.md         # Guía de escritorio
│   ├── install.sh        # Instalador interactivo
│   └── scripts/          # Scripts modulares
│       ├── install-packages.sh
│       ├── install-seatd-greetd.sh
│       ├── install-zsh.sh
│       ├── install-rofi.sh
│       └── install-configs.sh
│
└── config/               # Configuraciones
    ├── hypr/            # Hyprland
    ├── waybar/          # Barra de estado
    ├── kitty/           # Terminal
    ├── rofi/            # Lanzador
    ├── swaync/          # Notificaciones
    └── .zshrc           # Shell config
```

## 🎯 Características

### Sistema Base

- 💿 Instalación automatizada de Arch Linux
- 🔧 Configuración de particiones y bootloader + (Dual Boot)
- 👥 Gestión de usuarios y permisos
- 📦 yay (AUR helper) preinstalado
- 🎮 Soporte para drivers AMD

### Entorno de Escritorio

- 🪟 Hyprland (compositor Wayland moderno)
- 📊 Waybar (barra de estado personalizable)
- 🔔 Swaync (centro de notificaciones)
- 🚀 Rofi (lanzador de aplicaciones)
- 🐚 ZSH con Oh My Zsh + Temas + Autocompletado + Resaltado de sintaxis
- 🎨 Tema Catppuccin completo

## ⚙️ Requisitos

### Para instalación del sistema:

- USB booteable con Arch Linux
- Conexión a Internet
- Modo UEFI (no BIOS legacy)
- Mínimo 20GB de espacio en disco

### Para entorno de escritorio:

- Arch Linux instalado
- yay instalado
- Usuario normal con sudo

## 📖 Documentación

- **[system/README.md](system/README.md)** - Guía completa de instalación de Arch
  - Preparación de particiones
  - Configuración del sistema
  - Instalación manual paso a paso
- **[desktop/README.md](desktop/README.md)** - Guía del entorno de escritorio
  - Instalación de Hyprland
  - Configuración de aplicaciones
  - Atajos de teclado
  - Personalización

## 🔄 Flujo Completo de Instalación

1. **Arrancar desde USB** con Arch Linux
2. **Ejecutar** `system/install.sh` para instalar el sistema base
3. **Reiniciar** e iniciar sesión
4. **Ejecutar** `desktop/install.sh` para el entorno de escritorio
5. **Reiniciar** y disfrutar de Hyprland

## 🛠️ Instalación Manual

Si prefieres no usar los scripts automáticos, cada README contiene instrucciones completas para instalación manual paso a paso:

- [Instalación manual del sistema](system/README.md#-instalación-manual)
- [Instalación manual del escritorio](desktop/README.md#-instalación-manual)

## ⌨️ Atajos de Teclado Principales

| Tecla         | Acción             |
| ------------- | ------------------ |
| `SUPER + Q`   | Terminal           |
| `SUPER + C`   | Cerrar ventana     |
| `SUPER + E`   | Gestor de archivos |
| `SUPER + R`   | Lanzador (Rofi)    |
| `SUPER + 1-9` | Cambiar workspace  |

[Ver lista completa →](desktop/README.md#-atajos-de-teclado)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si encuentras algún problema o tienes sugerencias:

1. Abre un **issue** describiendo el problema
2. Envía un **pull request** con mejoras

## 📝 Licencia

Este proyecto está disponible libremente para uso personal. Si lo utilizas o te inspiras en él, se agradece una mención.

## 🔗 Enlaces Útiles

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)

---

**Autor**: [@ayunierto](https://github.com/ayunierto)  
**Última actualización**: Enero 2026
