#!/usr/bin/env bash
set -euo pipefail

color() {
  local code="$1"
  shift
  printf '\033[%sm%s\033[0m\n' "$code" "$*"
}

log() {
  color "1;34" "[info] $*"
}

warn() {
  color "1;33" "[warn] $*"
}

die() {
  color "1;31" "[error] $*"
  exit 1
}

run() {
  if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

run_shell() {
  if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  bash -lc "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

assert_arch_based() {
  [[ -r /etc/os-release ]] || die "Cannot detect distro: /etc/os-release missing"
  # shellcheck disable=SC1091
  source /etc/os-release
  local distro="${ID:-unknown}"
  local like="${ID_LIKE:-}"

  if [[ "$distro" != "arch" && "$distro" != "manjaro" && "$like" != *"arch"* ]]; then
    die "This installer currently supports Arch-based systems only. Detected: ${PRETTY_NAME:-unknown}"
  fi
}

is_manjaro() {
  [[ -r /etc/os-release ]] || return 1
  # shellcheck disable=SC1091
  source /etc/os-release
  [[ "${ID:-}" == "manjaro" ]]
}

sudo_cmd() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    run "$@"
  else
    run sudo "$@"
  fi
}

confirm_or_exit() {
  local prompt="$1"
  local reply
  read -r -p "$prompt [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]] || die "Cancelled"
}

pacman_args() {
  if [[ "${NOCONFIRM:-0}" -eq 1 ]]; then
    printf -- "--noconfirm"
  fi
}

aur_helper_name() {
  if [[ -n "${AUR_HELPER:-}" ]]; then
    printf '%s\n' "$AUR_HELPER"
    return 0
  fi
  if command -v yay >/dev/null 2>&1; then
    printf 'yay\n'
    return 0
  fi
  if command -v paru >/dev/null 2>&1; then
    printf 'paru\n'
    return 0
  fi
  printf 'yay\n'
}

print_plan() {
  cat <<EOF
Planned actions:
  - Verify Arch/Manjaro environment
  - Optionally upgrade the full system
  - Install Hyprland session packages from pacman
  - Install an AUR helper if needed
  - Install Caelestia packages and dotfiles
  - Copy cheatsheet to ~/Documents
EOF
}

install_cheatsheet() {
  local docs_dir="$HOME/Documents"
  local target="$docs_dir/Caelestia-Hyprland-Cheatsheet.md"
  run mkdir -p "$docs_dir"
  run cp "$ROOT_DIR/docs/cheatsheet.md" "$target"
  log "Installed cheatsheet to $target"
}

print_done() {
  cat <<'EOF'
Setup complete.

Next steps:
  1. Reboot if the system upgrade touched core graphics/session packages.
  2. Start or select a Hyprland session.
  3. Read ~/Documents/Caelestia-Hyprland-Cheatsheet.md
  4. If something fails, try a TTY and inspect the upstream Caelestia install output.
EOF
}
