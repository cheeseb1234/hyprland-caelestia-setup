#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$ROOT_DIR/scripts/lib.sh"

need_cmd pacman

packages=(
  base-devel
  git
  hyprland
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  hyprpicker
  wl-clipboard
  cliphist
  inotify-tools
  wireplumber
  pipewire
  pipewire-pulse
  pipewire-alsa
  foot
  fish
  fastfetch
  starship
  btop
  jq
  eza
  papirus-icon-theme
  ttf-jetbrains-mono-nerd
  brightnessctl
  ddcutil
  grim
  slurp
  swappy
  networkmanager
  lm_sensors
  qt6-declarative
  qt6-wayland
  trash-cli
)

if [[ "${INSTALL_GREETD:-0}" -eq 1 ]]; then
  packages+=(greetd tuigreet)
fi

log "Installing official repo packages"
if [[ "${NOCONFIRM:-0}" -eq 1 ]]; then
  sudo_cmd pacman -S --needed --noconfirm "${packages[@]}"
else
  sudo_cmd pacman -S --needed "${packages[@]}"
fi

if [[ "${INSTALL_GREETD:-0}" -eq 1 ]]; then
  log "Enabling greetd service"
  sudo_cmd systemctl enable greetd.service
fi
