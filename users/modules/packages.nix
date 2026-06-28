{
  pkgs,
  inputs,
  ...
}: {
  # User-specific packages you want installed
  home.packages = with pkgs; [
    brightnessctl
    awww
    spotify
    playerctl
    obsidian

    gh
    seahorse

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

    # TUI
    pkgs.bluetui

    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-no-fhs
    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-cli
  ];
}
