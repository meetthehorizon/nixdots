{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs.bat-extras; [
    pkgs.bat
    batdiff
    batgrep
    batman
    batpipe
    batwatch
    prettybat
  ];

  programs.fish.interactiveShellInit = ''
    set -x LESSOPEN "|batpipe %s"
  '';

  programs.fish.shellAbbrs = {
    diff = "batdiff";
    grep = "batgrep";
    less = "batpipe";
    man = "batman";
    watch = "batwatch";
  };
}
