{...}: {
  imports = [
    # Hardware profile for Asus Zephyrus G14
    ../../hardware/asus-zephyrus-g14

    # Generated hardware-configuration for this specific machine
    ./hardware-configuration.nix

    # System Level Configuration boot, networking, etc.
    ./configuration.nix
  ];
}
