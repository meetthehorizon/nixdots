# Gemini Guidelines & Workspace Memory

This file serves as a persistent memory and guidelines file for AI agents working in this repository. It is checked into the NixOS repository so that all context is reproducible across sessions and projects.

## Execution Rules

- **Do NOT run `sudo` commands as a task**: Never execute commands using `sudo` directly. If a command requires root/administrative privileges, prompt the user with the command and ask them to run it manually.

## Workspace Memory & System Configuration

### 1. Environment Details
- **OS**: NixOS
- **Host**: `horizon`
- **Shell**: Fish shell (configured via `modules/shell.nix`)
- **Config Path**: `~/nixdots`
- **Rebuild Commands**:
  - `nate` (switch system config): `sudo nixos-rebuild switch --flake ~/nixdots/#horizon`
  - `nest` (test system config): `sudo nixos-rebuild test --flake ~/nixdots/#horizon`

### 2. Window Manager (Hyprland)
- **Format**: Hyprland Lua configuration (version 0.55+ using `hyprland.lua`).
- **Startup Hook**: Uses `hl.on("hyprland.start", callback)` to launch default apps onto specific workspaces:
  - **Workspace 1**: `antigravity` (silent)
  - **Workspace 2**: `firefox` (silent)
  - **Workspace 3**: `kitty` (silent, focused on startup via `hl.dispatch(hl.dsp.focus({ workspace = "3" }))`)
  - **Workspace 4**: `spotify` (silent)
  - **Workspace 10**: `obsidian` (silent)
- **Keybind for Workspace 10**: Mapped to `Win + 0` (and `Win + SHIFT + 0` to move windows).

### 3. Service Configurations
- **Syncthing**: Enabled as a systemd user service (`syncthing.service`) via `services.syncthing`.
- **Hyprsunset**: Enabled via `services.hyprsunset` but autostart on boot is disabled by setting `systemd.user.services.hyprsunset.Install.WantedBy = lib.mkForce [ ];`. Run on-demand via the `<Win> + <N>` hotkey.

### 4. Firefox Configurations
- **Policy Management**: Configured via global policies (`programs.firefox.policies`) rather than declarative profile settings. This prevents Home Manager from clobbering local profile data, bookmarks, history, and cookies.
- **Workspace Focus**: Preference `widget.disable-workspace-management` set to `true` to ensure Firefox windows open in the active workspace.
- **Extensions Installed via Policy**:
  - Dark Reader (`addon@darkreader.org`)
  - uBlock Origin (`uBlock0@raymondhill.net`)

### 5. Assets & Symlinks
- **Pictures Directory**: `~/Pictures` is mapped as an out-of-store symlink (`mkOutOfStoreSymlink`) to `~/nixdots/assets/Pictures` (containing `Wallpapers` and `Icons`). Any files added to `~/Pictures` will reside directly in the local Git repository directory.
- **System Wallpapers**: System/lockscreen wallpapers (`assets.homeScreen` and `assets.lockScreen` in `assets.nix`) are loaded directly from the Nix store in `modules/hyprland.nix` so that `~/Pictures` remains completely clean of managed fallbacks.
