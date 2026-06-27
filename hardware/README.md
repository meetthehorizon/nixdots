# Hardware Configurations (`hardware/`)

This directory contains system configuration modules tailored to specific hardware architectures and machine targets.

## Directory Structure

- [asus-zephyrus-g14/](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/): Holds configuration profiles for the Asus Zephyrus G14 laptop model.
  - [asus.nix](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/asus.nix): Asus-specific drivers, tools, and daemon integrations (e.g., `supergfxctl`, `asusd`).
  - [nvidia.nix](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/nvidia.nix): Dedicated Nvidia GPU kernel parameters, graphics packages, and Prime offload settings.
  - [default.nix](file:///home/conart/nixdots/hardware/asus-zephyrus-g14/default.nix): Aggregates and imports the hardware modules for the G14.

## Usage

These configurations are imported selectively inside the host profiles in the `hosts/` directory, allowing modular hardware configuration mapping (e.g. mapping the G14 hardware profile to the `horizon` host).
