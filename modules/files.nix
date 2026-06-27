{
  config,
  pkgs,
  ...
}: let
  dotfilesDir = "${config.home.homeDirectory}/nixdots";
  assets = import ../assets.nix {inherit pkgs;};
in {
  home.file = {
    "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Pictures";

    ".face".source = assets.userIcon;
    ".config/fastfetch/logo.png".source = assets.nixosIcon;
    ".gemini/GEMINI.md".source = ../GEMINI-global.md;

    ".local/bin/nixdots".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/scripts/nixdots";
  };
}
