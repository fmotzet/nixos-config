# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build / Deploy Commands

- **Rebuild and switch** (current host): `sudo nixos-rebuild switch --flake /home/felix/nixos-config/`
  - Shell alias `rebuild` is available for the user
- **Rebuild specific host**: `sudo nixos-rebuild switch --flake /home/felix/nixos-config/#<hostname>`
- **Dry build** (check without applying): `nixos-rebuild dry-build --flake /home/felix/nixos-config/`
- **Cleanup old generations**: `sudo nix-collect-garbage --delete-older-than 7d && nix-store --optimize`

## Architecture

This is a NixOS flake-based configuration managing multiple physical machines and VMs.

**Nixpkgs channels**: `nixpkgs` tracks `nixos-25.11` (stable), `nixpkgs-unstable` is available via `pkgs-unstable` (passed to home-manager as `extraSpecialArgs`).

### Host hierarchy

Each host configuration in `hosts/<hostname>/configuration.nix` imports:
1. Its own `hardware-configuration.nix` (machine-specific)
2. `system/users.nix` (shared user definitions)
3. A host-specific home file `home/home-<host>.nix` which imports `home/home.nix` (shared home-manager config) and adds host-specific overrides (e.g. monitor settings)

**Hosts**:
- `nixos-fw13` — Framework 13 laptop (current machine)
- `nixos-TP-p15v` — ThinkPad P15v
- `nixos-TP-t14g6` — ThinkPad T14 Gen 6
- `mnextcloud01`, `dawarich01` — VMs (no home-manager, standalone configs)

### Module layout

- `home/home.nix` — shared home-manager config for all physical hosts. Imports per-program modules (`hyprland.nix`, `waybar/waybar.nix`, `kitty.nix`, etc.). This is the central place for user-level programs and dotfiles.
- `home/home-<host>.nix` — thin host-specific wrappers that import `home.nix` and override settings like monitor config
- `system/` — shared system-level modules (users, services)
- `modules/` — extra NixOS modules (e.g. `noctalia.nix` for noctalia-shell, only used on fw13)
- `templates/` — project templates (e.g. Rust dev flake for `nix-dev-init` alias)

### Desktop environment

Hyprland (Wayland compositor) with: waybar (status bar), rofi (launcher), swaync (notifications), hyprlock (lock screen), kitty (terminal), hyprpaper/swww (wallpaper).

### Key patterns

- Per-program home-manager configs are separate `.nix` files in `home/` and imported from `home/home.nix`
- `git-personal.nix` is conditionally imported (only if file exists) to keep personal git config out of version control
- Unstable packages: use `pkgs-unstable` (available in home-manager modules) when a package needs a newer version than stable provides
