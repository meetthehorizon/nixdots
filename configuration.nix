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
    ./system/asus.nix
    ./system/nvidia.nix
  ];

  # Boot Manager
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.initrd.kernelModules = ["amdgpu"];

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
  time.hardwareClockInLocalTime = false;
  services.ntp.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    TZDIR = "/etc/zoneinfo";
  };

  # System Packages
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Users
  security.pam.services.hyprlock = {};
  security.pam.services.ly.enableGnomeKeyring = true;
  users.users.conart = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video"];
    shell = pkgs.fish;
    packages = [];
  };

  # SUID Wrapper
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Services
  services.displayManager.ly.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.openssh.enable = true;

  # Secrets Management
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/home/conart/.config/sops/age/keys.txt"
  ];

  age.secrets.github-ssh-key = {
    file = ./secrets/github-ssh-key.age;
    path = "/home/conart/.ssh/id_ed25519";
    owner = "conart";
    group = "users";
    mode = "0600";
  };

  age.secrets.github-pat = {
    file = ./secrets/github-pat.age;
    path = "/home/conart/.config/gh/github-pat";
    owner = "conart";
    group = "users";
    mode = "0600";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Are you absolutely sure you need to change this variable?
  system.stateVersion = "26.05";
}
