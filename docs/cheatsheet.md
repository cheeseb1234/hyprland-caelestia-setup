# Caelestia + Hyprland Cheatsheet

Installed by `hyprland-caelestia-setup`.

## Core Keybinds

- `Super`: open launcher
- `Super + 1..9`: switch workspace
- `Super + Alt + 1..9`: move focused window to workspace
- `Super + T`: open terminal
- `Super + W`: open browser
- `Super + C`: open code editor
- `Super + S`: toggle special workspace
- `Ctrl + Alt + Delete`: open session menu
- `Ctrl + Super + Space`: media play/pause
- `Ctrl + Super + Alt + R`: restart Caelestia shell

## Useful Paths

- Caelestia repo: `~/.local/share/caelestia`
- Hyprland config: `~/.config/hypr`
- Foot config: `~/.config/foot`
- Fish config: `~/.config/fish`
- Starship config: `~/.config/starship.toml`

## Common Commands

```bash
# Update the whole system
sudo pacman -Syu

# Update AUR packages
yay

# Refresh Caelestia dots
git -C ~/.local/share/caelestia pull --ff-only

# Re-run the upstream installer
fish ~/.local/share/caelestia/install.fish --aur-helper yay
```

## First Boot Checklist

1. Log into Hyprland from your display manager, or launch it from a TTY if you are not using one.
2. Confirm `xdg-desktop-portal-hyprland` is running.
3. Test terminal launch with `Super + T`.
4. Test launcher with `Super`.
5. Verify audio, brightness, clipboard, and screenshots.

## MacBookPro14,1 Notes

- Apple keyboard legends do not match `Super` exactly; use the key mapped as the main modifier in your current layout.
- Brightness and media keys may need extra mapping beyond the base install.
- If an external monitor behaves oddly, check Hyprland monitor config and scale settings.

## Recovery

```bash
# If the shell breaks, switch to a TTY and inspect the configs
ls ~/.config/hypr
ls ~/.config/quickshell

# Reinstall core session packages
sudo pacman -S hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

# Re-run bootstrap in dry-run mode
./install.sh --dry-run
```
