{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./packages.nix
    ./theme.nix
    ./files.nix
    ./git.nix
    ./shell.nix
    ./kitty.nix
    ./hyprland.nix
    ./nixvim.nix
    ./syncthing.nix
  ];
}
