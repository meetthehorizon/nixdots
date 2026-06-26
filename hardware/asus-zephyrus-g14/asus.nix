{ pkgs, ... }: {
  # Use latest kernel — ASUS ROG drivers are mainlined in 6.10+
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable asusd daemon (battery limits, fan curves, keyboard LEDs, platform profiles)
  services.asusd.enable = true;

  # asusd's systemd service uses ReadWritePaths=/etc/asusd/ with ProtectSystem=strict,
  # which requires the directory to exist. Ensure it's created even with no config set.
  environment.etc."asusd/.keep".text = "";

  # Power profiles daemon — integrates with asusctl for Quiet/Balanced/Performance
  services.power-profiles-daemon.enable = true;

  # rog-control-center GUI (Wayland-native, works with Hyprland)
  environment.systemPackages = with pkgs; [
    asusctl # CLI + GUI: includes asusctl and rog-control-center
    pkgs.mesa-demos # glxinfo, glxgears for GPU diagnostics
  ];
}
