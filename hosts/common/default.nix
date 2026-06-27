# Common NixOS configuration shared by all hosts.
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Boot Manager Defaults
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Limine and Secure Boot configuration
  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
    enrollConfig = true;
    panicOnChecksumMismatch = true;
    enableEditor = false; # Best practice for Secure Boot integrity
    extraEntries = ''
      /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  # Home Package Configuration
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  # Networking
  networking.networkmanager.enable = true;

  # Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Locale
  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = false;
  services.ntp.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    TZDIR = "/etc/zoneinfo";
  };

  # System Packages
  programs.fish.enable = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    sbctl
  ];

  # Users
  security.pam.services.hyprlock = {};
  security.pam.services.ly.enableGnomeKeyring = true;
  users.users.conart = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
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
    file = ../../secrets/github-ssh-key.age;
    path = "/home/conart/.ssh/id_ed25519";
    owner = "conart";
    group = "users";
    mode = "0600";
  };

  age.secrets.github-pat = {
    file = ../../secrets/github-pat.age;
    path = "/home/conart/.config/gh/github-pat";
    owner = "conart";
    group = "users";
    mode = "0600";
  };
}
