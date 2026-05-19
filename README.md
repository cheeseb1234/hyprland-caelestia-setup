# hyprland-caelestia-setup

Bootstrap a Hyprland + Caelestia desktop on Arch-based systems, with a focus on Manjaro running on a MacBookPro14,1.

This project does four things:

1. Updates the system.
2. Installs Hyprland and the Arch/Manjaro packages Caelestia expects.
3. Installs an AUR helper if needed, then pulls in the Caelestia meta package and upstream dotfiles.
4. Applies project-owned Caelestia overrides and places a local cheatsheet into `~/Documents`.

## Target

- Distro: Arch Linux, Manjaro, EndeavourOS
- Hardware: tested path intended for Apple MacBook Pro 14,1 running Manjaro
- Session model: Hyprland with Caelestia on Wayland

## What This Installer Does

- Detects whether the system is Arch-based.
- Runs a full system upgrade with `pacman -Syu`.
- Installs official repo packages needed for a working Hyprland session.
- Installs `yay` if no AUR helper is present.
- Installs `caelestia-meta` from the AUR.
- Clones the upstream `caelestia-dots/caelestia` repo into `~/.local/share/caelestia`.
- Runs the upstream `install.fish` so configs are linked the way Caelestia expects.
- Copies project-owned overrides into `~/.config/caelestia`.
- Enables Caelestia's Hyprland user include files so `hypr-user.conf` and `hypr-vars.conf` actually load.
- Initializes wallpaper selection from `~/Pictures/Wallpapers` when wallpapers are present.
- Copies a quick reference cheatsheet into `~/Documents/Caelestia-Hyprland-Cheatsheet.md`.

## What It Does Not Do

- It does not force a display manager install.
- It does not overwrite your existing dotfiles without a backup.
- It does not claim to solve every MacBook-specific quirk automatically.

## Quick Start

```bash
git clone https://github.com/cheeseb1234/hyprland-caelestia-setup.git ~/.local/share/hyprland-caelestia-setup
cd ~/.local/share/hyprland-caelestia-setup
git config core.filemode false
bash install.sh
```

## Options

```bash
bash install.sh --help
bash install.sh --dry-run
bash install.sh --noconfirm
bash install.sh --aur-helper yay
bash install.sh --aur-helper paru
bash install.sh --greetd
bash install.sh --skip-upgrade
bash install.sh --skip-cheatsheet
bash install.sh --spotify --discord --zen --vscode codium
```

## Notes For MacBookPro14,1

- Keep a TTY available in case your first graphical login needs manual cleanup.
- External keyboard shortcuts may differ from Apple legends; Hyprland binds are listed in the cheatsheet.
- If Wi-Fi, suspend, or brightness control need extra tuning, treat those as post-install hardware tasks rather than installer failures.

## Project Layout

```text
.
├── docs/
│   └── cheatsheet.md
├── install.sh
├── overrides/
│   └── caelestia/
│       ├── hypr-user.conf
│       ├── hypr-vars.conf
│       └── shell.json
└── scripts/
    ├── apply-overrides.sh
    ├── install-aur-helper.sh
    ├── install-caelestia.sh
    ├── install-packages.sh
    ├── install-session.sh
    └── lib.sh
```

## Upstream Basis

This bootstrap follows the current upstream split:

- Hyprland from Arch repos / Arch-based packaging
- Caelestia shell and meta packages from AUR
- Caelestia dotfiles from `caelestia-dots/caelestia`

Review upstream projects before running this on a production machine.
