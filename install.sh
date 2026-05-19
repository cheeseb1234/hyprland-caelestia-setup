#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib.sh
source "$ROOT_DIR/scripts/lib.sh"

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --dry-run              Print actions without running them
  --noconfirm            Run package installs without interactive confirmation
  --aur-helper NAME      Use a specific AUR helper (yay or paru)
  --greetd               Install greetd + tuigreet session manager
  --skip-upgrade         Skip full system upgrade
  --skip-cheatsheet      Do not copy the cheatsheet into ~/Documents
  --spotify              Pass --spotify to Caelestia's upstream installer
  --discord              Pass --discord to Caelestia's upstream installer
  --zen                  Pass --zen to Caelestia's upstream installer
  --vscode NAME          Pass --vscode <code|codium> to Caelestia's upstream installer
  -h, --help             Show this help
EOF
}

DRY_RUN=0
NOCONFIRM=0
SKIP_UPGRADE=0
SKIP_CHEATSHEET=0
INSTALL_GREETD=0
AUR_HELPER=""
CAELESTIA_INSTALL_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --noconfirm)
      NOCONFIRM=1
      shift
      ;;
    --aur-helper)
      AUR_HELPER="${2:-}"
      [[ -n "$AUR_HELPER" ]] || die "--aur-helper requires a value"
      shift 2
      ;;
    --greetd)
      INSTALL_GREETD=1
      shift
      ;;
    --skip-upgrade)
      SKIP_UPGRADE=1
      shift
      ;;
    --skip-cheatsheet)
      SKIP_CHEATSHEET=1
      shift
      ;;
    --spotify|--discord|--zen)
      CAELESTIA_INSTALL_ARGS+=("$1")
      shift
      ;;
    --vscode)
      [[ -n "${2:-}" ]] || die "--vscode requires code or codium"
      CAELESTIA_INSTALL_ARGS+=("$1" "$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
done

export DRY_RUN NOCONFIRM AUR_HELPER INSTALL_GREETD ROOT_DIR

assert_arch_based
print_plan

if [[ "$NOCONFIRM" -ne 1 ]]; then
  confirm_or_exit "Proceed with Hyprland + Caelestia setup on this machine?"
fi

bash "$ROOT_DIR/scripts/install-session.sh" "$SKIP_UPGRADE"
bash "$ROOT_DIR/scripts/install-packages.sh"
bash "$ROOT_DIR/scripts/install-aur-helper.sh"
bash "$ROOT_DIR/scripts/install-caelestia.sh" "${CAELESTIA_INSTALL_ARGS[@]}"
bash "$ROOT_DIR/scripts/apply-overrides.sh"

if [[ "$SKIP_CHEATSHEET" -ne 1 ]]; then
  install_cheatsheet
fi

print_done
