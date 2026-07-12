{
  config,
  pkgs,
  ...
}: let
  simpleicons = pkgs.fetchFromGitHub {
    owner = "simple-icons";
    repo = "simple-icons";
    rev = "14.0.0";
    hash = "sha256-U8IiqIux89K7NagWddz4Rq+OGCjWVhuR33rhjyqY6nM=";
  };

  lucide = pkgs.fetchFromGitHub {
    owner = "lucide-icons";
    repo = "lucide";
    rev = "main";
    hash = "sha256-akN7xhl9xW+LNvDgrH79y5EGCjb55zYCfdb9jNFTUh8="; # Make sure to update hash if it complains
  };

  quickshellIcons = pkgs.runCommand "quickshell-icons" {} ''
    mkdir -p $out/{simpleicons,lucide,custom}

    cp -r ${simpleicons}/icons/* $out/simpleicons/
    find ${lucide} -type f -name "*.svg" -exec cp {} $out/lucide \;
    cp -r ${./quickshell/custom_icons}/* $out/custom/
  '';
in {
  home.file."${config.home.homeDirectory}/nixdots/modules/widgets/quickshell/icons".source = quickshellIcons;
}
