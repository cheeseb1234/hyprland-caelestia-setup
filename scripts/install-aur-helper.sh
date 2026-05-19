#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$ROOT_DIR/scripts/lib.sh"

helper="$(aur_helper_name)"

if command -v "$helper" >/dev/null 2>&1; then
  log "AUR helper already present: $helper"
  exit 0
fi

need_cmd git
need_cmd makepkg

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

log "Installing AUR helper: $helper"
run git clone "https://aur.archlinux.org/${helper}.git" "$tmp_dir/$helper"
cd "$tmp_dir/$helper"

if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
  printf '[dry-run] cd %s && makepkg -si %s\n' "$tmp_dir/$helper" "$( [[ "${NOCONFIRM:-0}" -eq 1 ]] && printf -- '--noconfirm' )"
  exit 0
fi

if [[ "${NOCONFIRM:-0}" -eq 1 ]]; then
  makepkg -si --noconfirm
else
  makepkg -si
fi
