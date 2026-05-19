#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$ROOT_DIR/scripts/lib.sh"

helper="$(aur_helper_name)"
repo_dir="$HOME/.local/share/caelestia"

need_cmd git
command -v "$helper" >/dev/null 2>&1 || die "AUR helper not found after install step: $helper"

log "Installing Caelestia meta package from AUR"
if [[ "${NOCONFIRM:-0}" -eq 1 ]]; then
  run "$helper" -S --needed --noconfirm caelestia-meta
else
  run "$helper" -S --needed caelestia-meta
fi

run mkdir -p "$(dirname "$repo_dir")"

if [[ -d "$repo_dir/.git" ]]; then
  log "Updating existing Caelestia dots repo"
  run git -C "$repo_dir" pull --ff-only
else
  log "Cloning upstream Caelestia dots repo"
  run git clone https://github.com/caelestia-dots/caelestia.git "$repo_dir"
fi

if [[ ! -x "$repo_dir/install.fish" ]]; then
  die "Expected upstream installer not found at $repo_dir/install.fish"
fi

install_args=()
if [[ "${NOCONFIRM:-0}" -eq 1 ]]; then
  install_args+=(--noconfirm)
fi
install_args+=(--aur-helper "$helper")
install_args+=("$@")

log "Running upstream Caelestia installer"
run fish "$repo_dir/install.fish" "${install_args[@]}"
