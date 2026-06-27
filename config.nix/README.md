# User Configuration & Theme Settings (`config.nix/`)

This directory houses the primary layout, font, and system aesthetic variables.

## Contents

- [default.nix](file:///home/conart/nixdots/config.nix/default.nix): Defines core theme and UI variable configurations.

## Configured Options

The following system-wide parameters are declared here:
- **uifont**: The font family utilized for desktop application interfaces (e.g., `IBM Plex Sans`).
- **codefont**: The monospace Nerd Font utilized for terminals and editors (e.g., `JetBrainsMono Nerd Font`).
- **wallpaper**: The system wallpaper asset path (retrieved from [assets.nix](file:///home/conart/nixdots/assets.nix)).
- **fastfetch**: The system icon displayed in fastfetch outputs.
- **user**: The user profile avatar/icon configuration.

## Usage

This configuration profile is imported and resolved in modules such as [modules/theme.nix](file:///home/conart/nixdots/modules/theme.nix) to guarantee unified styling across terminal settings, lockscreen designs, status bars, and desktop styling.
