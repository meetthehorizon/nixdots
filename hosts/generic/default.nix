{ ... }: {
  imports = [
    # Shared configurations
    ../common

    # Generic hardware-configuration for this machine
    ./hardware-configuration.nix
  ];

  # Host identification
  networking.hostName = "generic";

  # Standard state version for a new install
  system.stateVersion = "26.05";
}
