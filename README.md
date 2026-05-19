# hyprland-caelestia-setup

Bootstrap a Hyprland + Caelestia desktop on Arch-based systems, with a focus on Manjaro running on a MacBookPro14,1.

This project does four things:

1. Updates the system.
2. Installs Hyprland and the Arch/Manjaro packages Caelestia expects.
3. Installs an AUR helper if needed, then pulls in the Caelestia meta package and upstream dotfiles.
4. Places a local cheatsheet into `~/Documents`.

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
- Copies a quick reference cheatsheet into `~/Documents/Caelestia-Hyprland-Cheatsheet.md`.

## What It Does Not Do

- It does not force a display manager install.
- It does not overwrite your existing dotfiles without a backup.
- It does not claim to solve every MacBook-specific quirk automatically.

## Quick Start

```bash
git clone <https://github.com/cheeseb1234/hyprland-caelestia-setup> ~/.local/share/hyprland-caelestia-setup
cd ~/.local/share/hyprland-caelestia-setup
chmod +x install.sh scripts/*.sh
./install.sh
```

## Options

```bash
./install.sh --help
./install.sh --dry-run
./install.sh --noconfirm
./install.sh --aur-helper yay
./install.sh --aur-helper paru
./install.sh --greetd
./install.sh --skip-upgrade
./install.sh --skip-cheatsheet
./install.sh --spotify --discord --zen --vscode codium
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
└── scripts/
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
