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
    ./modules/settings.nix
    ./modules/direnv.nix
    ./modules/eza.nix
    ./modules/fastfetch.nix
    ./modules/files.nix
    ./modules/firefox.nix
    ./modules/fish.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/hyprland/binds.nix
    ./modules/hyprland/config.nix
    ./modules/hyprland/lock.nix
    ./modules/hyprland/mako.nix
    ./modules/hyprland/sunset.nix
    ./modules/hyprland/wallpaper.nix
    ./modules/kitty.nix
    ./modules/nixvim/options.nix
    ./modules/nixvim/colorschemes.nix
    ./modules/nixvim/keymaps.nix
    ./modules/nixvim/plugins.nix
    ./modules/starship.nix
    ./modules/syncthing.nix
    ./modules/theme.nix
    ./modules/zoxide.nix
    ./modules/shell-util.nix
    ./modules/commercial.nix
    ./modules/system.nix
    ./modules/ide/code.nix
    ./modules/ide/antigravity.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05";
}
