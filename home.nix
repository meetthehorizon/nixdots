{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # Replace with your exact username and home directory path
  home.username = "conart";
  home.homeDirectory = "/home/conart";

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05";

  imports = [
    ./modules
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
