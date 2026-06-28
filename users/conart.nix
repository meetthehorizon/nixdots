{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  dotfilesDir = "${config.home.homeDirectory}/nixdots";
  assets = import ./modules/assets.nix {inherit pkgs;};
in {
  # Replace with your exact username and home directory path
  home = {
    username = "conart";
    homeDirectory = "/home/conart";
    file = {
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Pictures";

      ".face".source = assets.userIcon;
      ".config/fastfetch/logo.png".source = assets.nixosIcon;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./modules/dev.nix
    ./modules/eza.nix
    ./modules/fastfetch.nix
    ./modules/files.nix
    ./modules/firefox.nix
    ./modules/fish.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/nixvim.nix
    ./modules/packages.nix
    ./modules/starship.nix
    ./modules/syncthing.nix
    ./modules/theme.nix
    ./modules/zoxide.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05";
}
