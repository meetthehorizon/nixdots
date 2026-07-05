{pkgs, ...}: {
  # NixOS Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Boot Manager Defaults
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
    enrollConfig = true;
    panicOnChecksumMismatch = true;
    enableEditor = false;
    extraEntries = ''
      /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  # Network Configuration
  networking.hostName = "horizon";
  networking.networkmanager.enable = true;

  # Locale and Time
  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = false;
  services.ntp.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # Users
  users.users.conart = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video"];
    shell = pkgs.fish;
    packages = [];
  };

  # Security
  security = {
    rtkit.enable = true;
    pam.services = {
      hyprlock = {};
      login.enableGnomeKeyring = true;
      ly.enableGnomeKeyring = true;
    };
  };

  # XDG portal
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = ["gtk"];
      };
      hyprland = {
        default = ["gtk" "hyprland"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Services
  services = {
    upower.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager.ly.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
  };

  # SUID Wrapper
  programs.mtr.enable = true;

  # Environment Variables
  environment.sessionVariables = {TZDIR = "/etc/zoneinfo";};

  # System Packages
  programs = {
    fish.enable = true;
    hyprland.enable = true;
  };
  environment.systemPackages = with pkgs; [vim sbctl home-manager];

  # The state version when this system was installed. Do not change.
  system.stateVersion = "26.05";
}
