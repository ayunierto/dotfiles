#!/usr/bin/env bash
# Script básico para crear symlinks de dotfiles
# Edita las listas FILES y CONFIG_DIRS antes de usar

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
CONFIG_SRC="$DOTFILES/config"
BIN_SRC="$DOTFILES/bin"

# Archivos en la raíz del home
FILES=(
  ".zshrc"
)

# Directorios dentro de ~/.config
CONFIG_DIRS=(
  "hypr"
  "kitty"
  "rofi"
  "swaync"
  "waybar"
  "wofi"
)

# Archivos dentro de ~/.local/bin
BIN_FILES=(
  "reload-waybar"
)

backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local ts
    ts=$(date +%Y%m%d_%H%M%S)
    mv "$target" "${target}.backup.${ts}"
    echo "Backup creado: ${target}.backup.${ts}"
  fi
}

link_item() {
  local src="$1" dest="$2"
  if [ ! -e "$src" ]; then
    echo "⚠️  No existe origen: $src" >&2
    return 1
  fi
  mkdir -p "$(dirname "$dest")"
  backup "$dest"
  ln -snf "$src" "$dest"
  echo "✓ $dest -> $src"
}

main() {
  echo "Usando DOTFILES en: $DOTFILES"
  echo "Creando symlinks..."

  # Archivos en $HOME
  for f in "${FILES[@]}"; do
    link_item "$DOTFILES/$f" "$HOME/$f"
  done

  # Directorios en ~/.config
  for d in "${CONFIG_DIRS[@]}"; do
    link_item "$CONFIG_SRC/$d" "$HOME/.config/$d"
  done

  # Scripts en ~/.local/bin
  mkdir -p "$HOME/.local/bin"
  for b in "${BIN_FILES[@]}"; do
    link_item "$BIN_SRC/$b" "$HOME/.local/bin/$b"
  done

  # Copia el archivo de configuración de vscode y lo remplaza si ya existe
  if [ -d "$HOME/.config/Code/User" ]; then
    cp -rf "$CONFIG_SRC/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
    echo "✓ VSCode settings linked."
  else
    echo "⚠️  VSCode no está instalado o no se encontró el directorio de configuración. Saltando enlace de settings.json."
  fi

  echo "Listo. Si cambias las listas FILES/CONFIG_DIRS, vuelve a ejecutar."
}

main "$@"
