# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Nix configuration managing a macOS M1 MacBook Pro, Linux VMs (aarch64 and x86-64) in VMware Fusion, and WSL. Uses nix-darwin + home-manager for macOS, NixOS for VMs.

Nixpkgs channel: `nixos-25.11` (stable), with `nixpkgs-unstable` for select packages.

## Common Commands

### macOS (primary machine)
```bash
make switch    # Apply darwin configuration
make test      # Test without applying
```

### Linux VMs (initial bootstrap from host Mac)
```bash
export NIXADDR=<vm-ip>
export NIXNAME=vm-aarch64   # or vm-intel
make vm/bootstrap0           # Partition + initial NixOS install
make vm/bootstrap            # Copy config and finalize
```

### Linux VMs (subsequent updates, run inside VM)
```bash
make vm/switch
```

### WSL
```bash
make wsl    # Build WSL installer tarball
```

## Architecture

### Entry Point: `flake.nix`
Defines 4 system outputs: `macbook-pro-m1`, `vm-aarch64`, `vm-intel`, `wsl`. All are built through the `lib/mkSystem.nix` factory.

### `lib/mkSystem.nix`
Factory function that assembles the correct module list based on platform (Darwin vs NixOS). Injects shared context (system type, hostname, username, `isWSL` flag) into all modules via `specialArgs`.

### Layer structure
1. **`machines/`** — hardware/platform config (bootloader, kernel modules, VM-specific tweaks)
2. **`users/matthiskheimensen/darwin.nix`** / **`nixos.nix`** — OS-level user setup (Homebrew casks on macOS, user accounts and SSH keys on Linux)
3. **`users/matthiskheimensen/home-manager.nix`** — platform-agnostic dotfiles (packages, shell, git, Neovim, Alacritty)

### Key design notes
- `home-manager.nix` is shared across all platforms; platform-specific differences are guarded by `pkgs.stdenv.isDarwin` / `isWSL` checks
- The M1 Mac uses the Determinate Systems Nix installer, so `nix.enable = false` in `machines/macbook-pro-m1.nix`
- `modules/vmware-guest.nix` is a custom module adding aarch64 VMware guest support (upstream lacks it)
- `pkgs/jdtls.nix` is a custom derivation for the Eclipse Java Language Server

### Neovim config
Managed entirely in Nix: plugins declared in `home-manager.nix`, Lua config in `users/matthiskheimensen/vim-init.lua` (loaded via `programs.neovim.extraLuaConfig`).
