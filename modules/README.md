# Configuration Modules (`modules/`)

This directory houses the Home Manager and system-level configuration modules that define user environments, packages, shells, and system services.

## Module Directory

- [default.nix](file:///home/conart/nixdots/modules/default.nix): Groups and imports all active configuration modules.
- [assets.nix](file:///home/conart/nixdots/modules/assets.nix): Loads paths to static images and wallpapers.
- [files.nix](file:///home/conart/nixdots/modules/files.nix): Maps files and folders (e.g., `~/Pictures`) as out-of-store symlinks to the repository.
- [git.nix](file:///home/conart/nixdots/modules/git.nix): Configures global git, aliases, credential parameters, and formatting.
- [hyprland.nix](file:///home/conart/nixdots/modules/hyprland.nix): Sets up Hyprland window manager startup hooks, default app workspaces, and workspace/monitor keybindings.
- [kitty.nix](file:///home/conart/nixdots/modules/kitty.nix): Declares configurations, font, cursor, and rendering settings for the Kitty terminal.
- [nixvim.nix](file:///home/conart/nixdots/modules/nixvim.nix): Integrates Neovim text editor configuration directly inside the Nix expression.
- [packages.nix](file:///home/conart/nixdots/modules/packages.nix): Lists system packages and tools installed in the user's profile.
- [shell.nix](file:///home/conart/nixdots/modules/shell.nix): Configures the Fish shell, theme aliases, custom prompts, and shell environments.
- [syncthing.nix](file:///home/conart/nixdots/modules/syncthing.nix): Configures Syncthing as a systemd user service.
- [theme.nix](file:///home/conart/nixdots/modules/theme.nix): Integrates system-wide styling variables (defined in [config.nix](file:///home/conart/nixdots/config.nix/default.nix)) into window borders, terminals, and shell environments.
