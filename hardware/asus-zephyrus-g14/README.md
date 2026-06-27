# Asus Zephyrus G14 Hardware Profile (`hardware/asus-zephyrus-g14/`)

This directory contains system settings and driver configurations specialized for the Asus Zephyrus G14 laptop.

## Configuration Files

- [default.nix](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/default.nix): The entry point for the G14 profile. It imports `asus.nix` and `nvidia.nix`, and enables required hardware microcode updates.
- [asus.nix](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/asus.nix): Configures Asus specific kernel configurations, daemons, and tools.
  - Enables `services.asusd` for fan control and keyboard backlighting.
  - Enables `services.supergfxctl` for dynamic GPU switching.
- [nvidia.nix](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/nvidia.nix): Nvidia proprietary driver configuration, hardware acceleration setup, and power management options.
  - Enables the Nvidia graphics driver.
  - Configures `hardware.nvidia.prime` for dynamic offloading (AMD/Intel integrated + Nvidia discrete).

## Usage

This hardware profile is imported by host targets running on this specific device, such as the `horizon` host target in [hosts/horizon/default.nix](file:///home/conart/nixdots/hosts/horizon/default.nix).
