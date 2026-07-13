{pkgs, ...}: {
  # NixOS Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Boot Manager Defaults
  boot.loader = {
    efi.canTouchEfiVariables = true;
    limine = {
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
  };

  # Network Configuration
  networking = {
    hostName = "horizon";
    networkmanager.enable = true;

    # Firewall for Docker
    firewall = {
      enable = true;
      allowedTCPPorts = [80 8000 53 5300];
      allowedUDPPorts = [53 5300];
      extraCommands = ''
        iptables -A PREROUTING -t nat -i eth0 -p TCP --dport 80 -j REDIRECT --to-port 8000
        iptables -A PREROUTING -t nat -i eth0 -p TCP --dport 53 -j REDIRECT --to-port 5300
        iptables -A PREROUTING -t nat -i eth0 -p UDP --dport 53 -j REDIRECT --to-port 5300
      '';
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.wlps3s0.forwarding" = 1;
  };

  # Locale and Time
  time.timeZone = "Asia/Kolkata";
  services.chrony.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # Users
  users.users.conart = {
    isNormalUser = true;
    linger = true;
    extraGroups = ["wheel" "networkmanager" "video" "docker"];
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

  # Virtualization
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        data-root = "~/.local/docker";
        dns = ["1.1.1.1" "8.8.8.8"];
        registry-mirrors = ["https://mirror.gcr.io"];
      };
    };
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
  environment.systemPackages = with pkgs; [vim sbctl home-manager tzdata];

  # The state version when this system was installed. Do not change.
  system.stateVersion = "26.05";
}
