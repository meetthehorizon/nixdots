{ ... }: {
  imports = [
    # Shared configurations
    ../common

    # Hardware profile for Asus Zephyrus G14
    ../../hardware/asus-zephyrus-g14

    # Generated hardware-configuration for this specific machine
    ./hardware-configuration.nix
  ];

  # Host identification
  networking.hostName = "horizon";

  # The state version when this system was installed. Do not change.
  system.stateVersion = "26.05";
}
