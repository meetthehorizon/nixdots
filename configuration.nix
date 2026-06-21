# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot Manager
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 7;

  # Home Package Configuration
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;

  # Networking
  networking.hostName = "horizon";
  networking.networkmanager.enable = true;

  # Experimental Features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # System Packages
  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Users
  security.pam.services.hyprlock = {};
  users.users.conart = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
    packages = [];
  };

  # SUID Wrapper
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Services
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Are you absolutely sure you need to change this variable?
  system.stateVersion = "26.05";
}
