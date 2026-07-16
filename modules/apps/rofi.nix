{config, ...}: {
  imports = [./rofi-theme.nix];

  programs.rofi = {
    enable = true;
    font = "${config.font.mono} ${toString config.font.size.base}";
    theme = "${config.xdg.configHome}/rofi/themes/custom.rasi";
  };
}
