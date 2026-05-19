#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$ROOT_DIR/scripts/lib.sh"

SKIP_UPGRADE="${1:-0}"

if [[ "$SKIP_UPGRADE" -eq 0 ]]; then
  log "Running full system upgrade"
  if [[ "${NOCONFIRM:-0}" -eq 1 ]]; then
    sudo_cmd pacman -Syu --noconfirm
  else
    sudo_cmd pacman -Syu
  fi
else
  warn "Skipping full system upgrade"
fi
