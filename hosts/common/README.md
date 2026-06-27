# Shared Host Configuration (`hosts/common/`)

This directory contains the base system configurations shared across all host installations in this repository.

## Components

- [default.nix](file:///home/conart/nixdots/hosts/common/default.nix): Defines default system options, packages, and settings.

## Configured Features

- **Bootloader**: Custom configuration for the **Limine Boot Manager** including active secure boot setup (`sbctl`) and dual-boot Windows chainloading.
- **Localization**: System timezone set to `Asia/Kolkata` and locale configured to `en_US.UTF-8`.
- **System Shell**: Fish shell is enabled globally.
- **Display Manager**: Ly display manager console frontend.
- **Audio Service**: Pipewire audio subsystem enabled with ALSA, Jack, and PulseAudio emulations.
- **User Account**: Primary user `conart` configured under the wheel, networkmanager, and video groups.
- **Secrets Decryption**: `agenix` setups including references to encrypted SSH keys and GitHub personal access tokens.
