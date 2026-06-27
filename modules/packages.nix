{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        # Dark Reader
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
      Preferences = {
        "widget.disable-workspace-management" = true;
      };
    };
  };

  # User-specific packages you want installed
  home.packages = with pkgs; [
    hyprlauncher
    wl-clipboard
    fastfetch
    nerd-fonts.jetbrains-mono
    ibm-plex
    brightnessctl
    awww
    spotify
    playerctl
    obsidian

    gh
    seahorse
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default
    python3
    python3Packages.rich

    # Archive utilities
    unzip
    zip
    bzip2
    gnutar

    # Document/PDF utilities
    img2pdf
    qpdf

    # Modern CLI / Productivity tools
    ripgrep
    fd
    jq
    bat
    tealdeer

    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-no-fhs
    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-cli
  ];
}
