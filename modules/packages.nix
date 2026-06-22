{
  pkgs,
  inputs,
  ...
}: {
  # User-specific packages you want installed
  home.packages = with pkgs; [
    firefox
    hyprlauncher
    wl-clipboard
    fastfetch
    nerd-fonts.jetbrains-mono
    ibm-plex
    brightnessctl
    awww
    spotify

    gh
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default

    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-no-fhs
    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-cli
  ];
}
