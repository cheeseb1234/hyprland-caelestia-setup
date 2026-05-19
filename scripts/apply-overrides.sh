#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$ROOT_DIR/scripts/lib.sh"

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/caelestia"
caelestia_repo="$HOME/.local/share/caelestia"
hypr_conf="$caelestia_repo/hypr/hyprland.conf"
wall_dir="$HOME/Pictures/Wallpapers"
cursor_theme="breeze_cursors"
cursor_size="24"

ensure_parent() {
  run mkdir -p "$(dirname "$1")"
}

install_override_file() {
  local src="$1"
  local dest="$2"

  ensure_parent "$dest"
  run cp "$src" "$dest"
  log "Installed override: $dest"
}

enable_hypr_user_includes() {
  [[ -f "$hypr_conf" ]] || die "Expected Hyprland config not found at $hypr_conf"

  if grep -q '^#source = \$cConf/hypr-vars\.conf$' "$hypr_conf"; then
    run sed -i 's/^#source = \$cConf\/hypr-vars\.conf$/source = $cConf\/hypr-vars.conf/' "$hypr_conf"
  fi

  if grep -q '^#source = \$cConf/hypr-user\.conf$' "$hypr_conf"; then
    run sed -i 's/^#source = \$cConf\/hypr-user\.conf$/source = $cConf\/hypr-user.conf/' "$hypr_conf"
  fi

  log "Enabled Caelestia Hyprland user override includes"
}

initialise_wallpaper() {
  if [[ ! -d "$wall_dir" ]]; then
    warn "Wallpaper directory not found, skipping wallpaper init: $wall_dir"
    return 0
  fi

  if ! find "$wall_dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) | grep -q .; then
    warn "No wallpapers found in $wall_dir, skipping wallpaper init"
    return 0
  fi

  log "Initializing Caelestia wallpaper from $wall_dir"
  run caelestia wallpaper -r "$wall_dir"
}

install_cursor_fallbacks() {
  local icons_default_dir="$HOME/.icons/default"
  local cursor_index="$icons_default_dir/index.theme"

  run mkdir -p "$icons_default_dir"

  if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
    printf '[dry-run] write %s\n' "$cursor_index"
  else
    cat >"$cursor_index" <<EOF
[Icon Theme]
Inherits=${cursor_theme}
EOF
  fi

  log "Installed XCursor fallback theme: $cursor_theme"
  run gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
  run gsettings set org.gnome.desktop.interface cursor-size "$cursor_size"
}

restart_shell() {
  log "Restarting Caelestia shell"
  if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
    printf '[dry-run] %s\n' "caelestia shell -k"
  else
    caelestia shell -k >/dev/null 2>&1 || true
  fi
  run caelestia shell -d
}

log "Applying project-owned Caelestia overrides"
install_override_file "$ROOT_DIR/overrides/caelestia/shell.json" "$config_dir/shell.json"
install_override_file "$ROOT_DIR/overrides/caelestia/hypr-user.conf" "$config_dir/hypr-user.conf"
install_override_file "$ROOT_DIR/overrides/caelestia/hypr-vars.conf" "$config_dir/hypr-vars.conf"
enable_hypr_user_includes
install_cursor_fallbacks
initialise_wallpaper
restart_shell
