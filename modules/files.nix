{
  config,
  pkgs,
  ...
}: let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  assets = import ../assets.nix {inherit pkgs;};
in {
  home.file = {
    "Pictures/Icons".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Icons";
    "Pictures/Wallpapers/Private".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Wallpapers";

    ".face".source = assets.userIcon;
    ".config/fastfetch/logo.png".source = assets.nixosIcon;
    "Pictures/Wallpapers/home".source = assets.homeScreen;
    "Pictures/Wallpapers/lock".source = assets.lockScreen;
  };
}
