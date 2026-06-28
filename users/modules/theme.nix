{pkgs, config, ...}: let
  fontPackageMap = {
    "IBM Plex Sans" = pkgs.ibm-plex;
    "IBM Plex Serif" = pkgs.ibm-plex;
    "JetBrainsMono Nerd Font" = pkgs.nerd-fonts.jetbrains-mono;
    "FiraCode Nerd Font" = pkgs.nerd-fonts.fira-code;
    "Hack Nerd Font" = pkgs.nerd-fonts.hack;
    "Iosevka Nerd Font" = pkgs.nerd-fonts.iosevka;
    "Mononoki Nerd Font" = pkgs.nerd-fonts.mononoki;
    "Inter" = pkgs.inter;
    "Roboto" = pkgs.roboto;
    "Comic Mono" = pkgs.comic-mono;
  };

  resolveFont = name: fontPackageMap.${name} or null;

  # Only install packages for the fonts currently in use
  activeFontPkgs = builtins.filter (p: p != null) [
    (resolveFont config.theme.fonts.sans)
    (resolveFont config.theme.fonts.serif)
    (resolveFont config.theme.fonts.mono)
  ];
in {
  home.packages = activeFontPkgs;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [config.theme.fonts.sans];
      serif = [config.theme.fonts.serif];
      monospace = [config.theme.fonts.mono];
    };
  };

  gtk = {
    enable = true;
    font = {
      name = config.theme.fonts.sans;
      size = config.theme.fonts.sizes.gtk;
    };
  };
}
