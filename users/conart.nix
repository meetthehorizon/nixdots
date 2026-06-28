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
  home = {
    username = "conart";
    homeDirectory = "/home/conart";
    file = {
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Pictures";

      ".face".source = assets.userIcon;
      ".config/fastfetch/logo.png".source = assets.nixosIcon;
    };
  };

  imports = [
    ./modules/commercial.nix
    ./modules/crypt.nix
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
    ./modules/ide/antigravity.nix
    ./modules/ide/code.nix
    ./modules/kitty.nix
    ./modules/nixvim/colorschemes.nix
    ./modules/nixvim/keymaps.nix
    ./modules/nixvim/options.nix
    ./modules/nixvim/plugins.nix
    ./modules/settings.nix
    ./modules/shell-util.nix
    ./modules/starship.nix
    ./modules/syncthing.nix
    ./modules/system.nix
    ./modules/system.nix
    ./modules/theme.nix
    ./modules/zoxide.nix
    inputs.nixvim.homeModules.nixvim
  ];

  secret = {
    githubPat = {
      enable = true;
      file = ./.secrets/conart/github.pat.age;
    };
    gpg = {
      enable = true;
      file = ./.secrets/conart/gpg.age;
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05";
}
