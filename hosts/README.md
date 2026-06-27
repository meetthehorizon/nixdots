# System Host Profiles (`hosts/`)

This directory houses system configurations and definitions for individual machines (hosts) managed by this flake.

## Directory Structure

- [common/](file:///home/conart/nixdots/hosts/common/): A shared NixOS module imported by all hosts. Sets up base configurations, network managers, locale, packages, and credentials decryption.
- [generic/](file:///home/conart/nixdots/hosts/generic/): A fallback profile for testing or setting up generic configurations on other standard machines.
- [horizon/](file:///home/conart/nixdots/hosts/horizon/): The configuration profile for the main system, `horizon` (an Asus Zephyrus G14 laptop running secure boot).

## Configuration Entry Points

Hosts are exposed in [flake.nix](file:///home/conart/nixdots/flake.nix) under the `nixosConfigurations` attribute. They can be built or switched using the standard `nixos-rebuild` command with the appropriate flake target.
