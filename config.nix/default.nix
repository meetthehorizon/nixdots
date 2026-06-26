{pkgs, ...}: let
  assets = import ../assets.nix {inherit pkgs;};
in {
  uifont = "IBM Plex Sans";
  codefont = "JetBrainsMono Nerd Font";
  wallpaper = assets.homeScreen;
  fastfetch = {
    icon = assets.nixosIcon;
  };
  user = {
    icon = assets.userIcon;
  };
}
