# 🎨 Entorno de Escritorio - Hyprland

Instalador automatizado de Hyprland y aplicaciones con scripts modulares.

## 🎯 Alcance

Este instalador cubre el **entorno de escritorio completo**:

✅ Hyprland (compositor Wayland)  
✅ Login manager (greetd + tuigreet)  
✅ Waybar, swaync, rofi  
✅ ZSH con Oh My Zsh + Powerlevel10k  
✅ Aplicaciones esenciales  
✅ Configuraciones personalizadas

**Prerequisito**: Sistema base de Arch instalado desde [../system/](../system/)

## 📦 Requisitos Previos

- ✅ Arch Linux instalado
- ✅ yay instalado
- ✅ Usuario normal con sudo

```bash
# Verifica que yay está instalado
which yay
# Si no: cd ../system && ./scripts/install-yay.sh
```

## 🚀 Instalación Rápida

```bash
cd desktop
./install.sh
```

El menú interactivo te permite:

1. Instalar paquetes base (Hyprland, Waybar, etc.)
2. Configurar login manager
3. Configurar ZSH
4. Configurar Rofi
5. Copiar configuraciones
6. Crear symlinks
7. Instalación completa

## 📋 Flujo Paso a Paso

### Instalación Completa Automática

```bash
cd desktop
sudo ./install.sh
# Selecciona: 7) Instalación completa
```

### Instalación Modular

```bash
# 1. Paquetes base (requiere root)
sudo ./scripts/install-packages.sh

# 2. Login manager (requiere root)
sudo ./scripts/install-seatd-greetd.sh

# 3. ZSH (como usuario normal)
./scripts/install-zsh.sh

# 4. Rofi (requiere root)
sudo ./scripts/install-rofi.sh

# 5. Copiar configuraciones
./scripts/install-configs.sh

# 6. Reiniciar
sudo reboot
```

## 🧩 Scripts Modulares

### install-packages.sh

Instala Hyprland y componentes del WM.

**¿Qué instala?**

- Hyprland, hyprlock, hypridle, hyprpicker
- Waybar, waybar-updates
- swaync (notificaciones)
- swww (wallpapers)
- wl-clipboard, grim, slurp (screenshots)
- brightnessctl, playerctl

**Uso:**

```bash
sudo ./scripts/install-packages.sh
```

### install-seatd-greetd.sh

Configura el login manager para Wayland.

**¿Qué hace?**

- Instala seatd, greetd, tuigreet
- Habilita seatd.service
- Crea usuario greeter
- Agrega usuario al grupo seat
- Configura greetd para iniciar Hyprland

**Uso:**

```bash
sudo ./scripts/install-seatd-greetd.sh
```

**Configuración manual:**

```bash
# Editar comando de inicio
sudo nano /etc/greetd/config.toml

# Cambiar:
command = "tuigreet --cmd Hyprland"
```

### install-zsh.sh

Configura ZSH completo (ejecutar como usuario).

**¿Qué instala?**

- ZSH, exa, bat
- Oh My Zsh
- Powerlevel10k (tema)
- zsh-autosuggestions
- zsh-syntax-highlighting

**Uso:**

```bash
./scripts/install-zsh.sh

# Después de reiniciar la terminal:
p10k configure
```

**Configuración manual:**

```bash
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Editar ~/.zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

### install-rofi.sh

Instala y configura Rofi.

**¿Qué hace?**

- Instala rofi
- Copia configuraciones desde ../config/rofi

**Uso:**

```bash
sudo ./scripts/install-rofi.sh
```

**Probar:**

```bash
rofi -show drun
```

### install-configs.sh

Copia configuraciones a ~/.config

**¿Qué copia?**

- hypr/ → ~/.config/hypr
- waybar/ → ~/.config/waybar
- kitty/ → ~/.config/kitty
- rofi/ → ~/.config/rofi
- swaync/ → ~/.config/swaync
- .zshrc → ~/.zshrc

**Uso:**

```bash
./scripts/install-configs.sh
```

## 📦 Paquetes Instalados

### Compositor y WM

```bash
hyprland hyprlock hypridle hyprpicker swww
xdg-desktop-portal-hyprland
```

### Barra y Notificaciones

```bash
waybar waybar-updates swaync
```

### Herramientas Wayland

```bash
wl-clipboard brightnessctl grim slurp playerctl
```

### Login Manager

```bash
seatd greetd tuigreet
```

### Shell y Terminal

```bash
zsh kitty oh-my-zsh powerlevel10k
exa bat
```

### Lanzador

```bash
rofi
```

## ⌨️ Atajos de Teclado

### Ventanas y Aplicaciones

| Combinación | Acción                 |
| ----------- | ---------------------- |
| `SUPER + Q` | Abrir terminal (Kitty) |
| `SUPER + C` | Cerrar ventana activa  |
| `SUPER + M` | Salir de Hyprland      |
| `SUPER + E` | Gestor de archivos     |
| `SUPER + R` | Lanzador (Rofi)        |
| `SUPER + V` | Alternar flotante      |
| `SUPER + F` | Pantalla completa      |

### Navegación

| Combinación            | Acción                    |
| ---------------------- | ------------------------- |
| `SUPER + ←↑↓→`         | Mover foco                |
| `SUPER + 1-9`          | Cambiar workspace         |
| `SUPER + SHIFT + 1-9`  | Mover ventana a workspace |
| `SUPER + Mouse Scroll` | Cambiar workspace         |

### Multimedia

| Tecla                   | Acción          |
| ----------------------- | --------------- |
| `XF86AudioRaiseVolume`  | Subir volumen   |
| `XF86AudioLowerVolume`  | Bajar volumen   |
| `XF86AudioMute`         | Silenciar       |
| `XF86MonBrightnessUp`   | Aumentar brillo |
| `XF86MonBrightnessDown` | Reducir brillo  |

**Ver más**: [../config/hypr/hyprland.conf](../config/hypr/hyprland.conf)

## 🎨 Personalización

### Cambiar Tema de Colores

Edita `~/.config/hypr/hyprland.conf`:

```conf
general {
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
}
```

### Modificar Waybar

```bash
nano ~/.config/waybar/config
nano ~/.config/waybar/style.css
```

### Cambiar Wallpaper

```bash
swww img ~/Imágenes/wallpaper.jpg
```

### Configurar Rofi

```bash
nano ~/.config/rofi/config.rasi
```

## 🔗 Usar Symlinks

Para mantener las configuraciones sincronizadas con el repositorio:

```bash
# Desde el menú interactivo
./install.sh
# Selecciona: 6) Crear symlinks

# O manualmente:
ln -sf ~/dotfiles/config/hypr ~/.config/hypr
ln -sf ~/dotfiles/config/waybar ~/.config/waybar
ln -sf ~/dotfiles/config/.zshrc ~/.zshrc
```

## 🛠️ Instalación Manual Completa

### 1. Instalar Paquetes

```bash
yay -S hyprland hyprlock hypridle waybar kitty \
       hyprpicker swww swaync grim playerctl \
       rofi wl-clipboard brightnessctl slurp
```

### 2. Configurar Login Manager

```bash
sudo pacman -S seatd greetd tuigreet
sudo systemctl enable seatd
sudo systemctl enable greetd

sudo useradd --system --shell /usr/bin/nologin --home /var/lib/greetd greeter
sudo gpasswd --add $USER seat

sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
shell = "/bin/bash"

[default_session]
command = "tuigreet --cmd Hyprland"
user = "greeter"
EOF

sudo systemctl enable greetd.service
```

### 3. Configurar ZSH

```bash
yay -S zsh exa bat
chsh -s $(which zsh)

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ~/.oh-my-zsh/custom/themes/powerlevel10k

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Configurar ~/.zshrc
nano ~/.zshrc
```

### 4. Copiar Configuraciones

```bash
cp -r ../config/hypr ~/.config/
cp -r ../config/waybar ~/.config/
cp -r ../config/kitty ~/.config/
cp -r ../config/rofi ~/.config/
cp -r ../config/swaync ~/.config/
cp ../config/.zshrc ~/
```

### 5. Reiniciar

```bash
sudo reboot
```

## 🐛 Solución de Problemas

### Hyprland no inicia

```bash
# Verificar seatd
systemctl status seatd

# Verificar grupo seat
groups | grep seat

# Si no está:
sudo gpasswd --add $USER seat
sudo reboot
```

### Waybar no aparece

```bash
# Verificar proceso
pgrep waybar

# Reiniciar Waybar
killall waybar
waybar &
```

### ZSH no cambia

```bash
# Verificar shell
echo $SHELL

# Si no es zsh:
chsh -s $(which zsh)
# Cerrar sesión y volver a entrar
```

### Rofi no funciona

```bash
# Probar manualmente
rofi -show drun

# Ver errores
rofi -show drun -no-lazy-grab
```

## 📚 Referencias

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Configuration](https://github.com/Alexays/Waybar/wiki)
- [Rofi User Guide](https://github.com/davatorium/rofi)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

---

**¡Disfruta de Hyprland!** 🎉
